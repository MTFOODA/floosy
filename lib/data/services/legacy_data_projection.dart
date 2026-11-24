import 'dart:convert';
import 'package:drift/drift.dart';
import '../local/datasources/private_record_store.dart';
import '../local/datasources/sms_message_local_datasource.dart';
import '../local/datasources/processed_sms_local_datasource.dart';
import '../../domain/entities/transaction_model.dart';
import '../../domain/services/card_ownership.dart';
import '../../domain/services/card_balance_calculator.dart';

/// Maps the audited server schema onto the existing local ledger. All local
/// edits win over older server rows; aliases preserve child references when
/// a transaction was already present under its fingerprint.
class LegacyDataProjection {
  final PrivateRecordStore store;
  LegacyDataProjection(this.store);
  Map<String, dynamic> _preciseTimes(Map<String, dynamic> row) => {
    for (final entry in row.entries)
      if (entry.value is String &&
          (entry.key.endsWith('_at') || entry.key.endsWith('_date')) &&
          (DateTime.tryParse(entry.value as String)?.microsecondsSinceEpoch ??
                      0) %
                  1000000 !=
              0)
        entry.key: entry.value,
  };
  static const coreTables = {
    'transactions': 'transactions',
    'items': 'items',
    'expenses': 'expenses',
    'expense_items': 'expense_items',
    'cash_wallets': 'cash_wallets',
    'cash_movements': 'cash_movements',
    'monthly_incomes': 'monthly_incomes',
    'user_bank_accounts': 'bank_accounts',
    'user_bank_movements': 'bank_movements',
    'item_usage': 'item_usages',
  };
  String _id(String value) => '"${value.replaceAll('"', '""')}"';
  Future<String> alias(String table, String id) async =>
      (await store.get('migration_aliases', '$table:$id'))?['local_id']
          as String? ??
      id;
  Future<void> _alias(String table, String remote, String local) async {
    await store.put('migration_aliases', {
      'id': '$table:$remote',
      'local_id': local,
    });
  }

  Future<void> project(String table, Map<String, dynamic> original) async {
    final row = Map<String, dynamic>.from(original);
    final id = row['id'] as String;
    final owner = store.owner;
    if (row['user_id'] != null && row['user_id'] != owner) {
      throw StateError('Foreign owner in legacy import');
    }
    for (final link in const {
      'transaction_id': 'transactions',
      'reference_id': 'transactions',
      'wallet_id': 'cash_wallets',
      'card_id': 'detected_cards',
    }.entries) {
      final value = row[link.key];
      if (value is String &&
          (link.key != 'reference_id' ||
              row['reference_type'] == 'transaction')) {
        row[link.key] = await alias(link.value, value);
      }
    }
    if ((table == 'cash_movements' || table == 'user_bank_movements') &&
        row['reference_type'] == 'transaction' &&
        original['reference_id'] is String &&
        await store.get(
              'legacy_conflicts:transactions',
              original['reference_id'] as String,
            ) !=
            null) {
      final raw = await store.database
          .customSelect(
            'SELECT * FROM transactions WHERE user_id=? AND id=?',
            variables: [
              Variable(owner),
              Variable(row['reference_id'] as String),
            ],
          )
          .getSingleOrNull();
      if (raw == null) throw StateError('Conflicting transaction unavailable');
      final status = raw.read<String>('status');
      final type = TransactionType.values.byName(
        raw.read<String>('type').split('.').last,
      );
      await store.put('legacy_conflicts:$table', original, onlyIfMissing: true);
      if (status != TransactionStatus.confirmed.toString()) return;
      if (table == 'cash_movements') {
        if (type != TransactionType.atm_withdrawal &&
            type != TransactionType.cash_expense) {
          return;
        }
        row['type'] = type.name;
        row['amount_minor'] = raw.read<int>('amount_minor');
      } else {
        final transaction = Transaction(
          id: raw.read<String>('id'),
          userId: owner,
          type: type,
          source: TransactionSource.sms,
          amountMinor: raw.read<int>('amount_minor'),
          transactionDate: DateTime.now(),
          fingerprint: '',
        );
        final delta = CardBalance.balanceDelta(transaction);
        if (delta == 0) return;
        row['type'] = delta > 0 ? 'in' : 'out';
        row['amount_minor'] = delta.abs();
      }
      row['movement_date'] = DateTime.fromMillisecondsSinceEpoch(
        raw.read<int>('transaction_date') * 1000,
        isUtc: true,
      ).toIso8601String();
    }
    if (table == 'detected_cards') {
      // Keep local appearance, limits and learned identity if already present.
      final matches = (await store.list(table))
          .where(
            (c) =>
                c['last4'] == row['last4'] &&
                normalizeBankIdentity(c['bank_name'] as String?) ==
                    normalizeBankIdentity(row['bank_name'] as String?),
          )
          .toList();
      if (matches.length == 1) {
        await _alias(table, id, matches.single['id'] as String);
        await store.put(
          'legacy_conflicts:$table',
          original,
          onlyIfMissing: true,
        );
        return;
      }
      await store.put(table, row, onlyIfMissing: true);
      return;
    }
    if (table == 'sms_messages') {
      final timestamps = _preciseTimes(original);
      if (timestamps.isNotEmpty) {
        await store.put('legacy_extras:$table', {
          'id': id,
          'source_timestamps': timestamps,
        }, onlyIfMissing: true);
      }
      final exists = await store.database
          .customSelect(
            'SELECT id FROM sms_messages WHERE user_id=? AND message_hash=?',
            variables: [
              Variable(owner),
              Variable(row['message_hash'] as String),
            ],
          )
          .getSingleOrNull();
      if (exists == null) {
        await SmsMessageLocalDataSource(
          store.database,
        ).upsert(SMSMessage.fromJson(row));
      }
      final transactionId = row['transaction_id'] as String?;
      if (transactionId != null) {
        final transaction = await store.database
            .customSelect(
              'SELECT id FROM transactions WHERE user_id=? AND id=?',
              variables: [Variable(owner), Variable(transactionId)],
            )
            .getSingleOrNull();
        if (transaction != null) {
          await ProcessedSmsLocalDataSource(store.database).markProcessed(
            ProcessedSmsRecord(
              id: 'import:$id',
              userId: owner,
              sender: row['sender'] as String?,
              messageHash: row['message_hash'] as String,
              receivedAt: DateTime.parse(row['received_at'] as String),
              transactionId: transactionId,
              processedAt: DateTime.now(),
            ),
          );
        }
      }
      return;
    }
    final localTable = coreTables[table];
    if (localTable == null) {
      await store.put(table, row, onlyIfMissing: true);
      return;
    }
    final db = store.database;
    String? existingId;
    if (table == 'transactions' &&
        (row['fingerprint'] as String? ?? '').isNotEmpty) {
      final same = await db
          .customSelect(
            'SELECT id FROM transactions WHERE user_id=? AND fingerprint=?',
            variables: [
              Variable(owner),
              Variable(row['fingerprint'] as String),
            ],
          )
          .getSingleOrNull();
      existingId = same?.read<String>('id');
    } else if (table == 'cash_wallets') {
      final same = await db
          .customSelect(
            'SELECT id FROM cash_wallets WHERE user_id=? AND currency=? LIMIT 1',
            variables: [Variable(owner), Variable(row['currency'] as String)],
          )
          .getSingleOrNull();
      existingId = same?.read<String>('id');
    } else if ((table == 'cash_movements' || table == 'user_bank_movements') &&
        row['reference_type'] == 'transaction' &&
        row['reference_id'] != null) {
      final target = table == 'cash_movements' ? 'wallet_id' : 'account_id';
      final same = await db
          .customSelect(
            'SELECT id FROM $localTable WHERE user_id=? AND reference_type=? AND reference_id=? AND $target=? LIMIT 1',
            variables: [
              Variable(owner),
              const Variable('transaction'),
              Variable(row['reference_id'] as String),
              Variable(row[target] as String),
            ],
          )
          .getSingleOrNull();
      existingId = same?.read<String>('id');
    }
    if (existingId != null) {
      await _alias(table, id, existingId);
      // Conflicting server values are retained encrypted for explicit review.
      await store.put('legacy_conflicts:$table', original, onlyIfMissing: true);
      return;
    }
    final columns =
        (await db.customSelect('PRAGMA table_info(${_id(localTable)})').get())
            .map((r) => r.read<String>('name'))
            .toSet();
    final timestamps = _preciseTimes(original);
    final extras = <String, dynamic>{
      if (timestamps.isNotEmpty) 'source_timestamps': timestamps,
    };
    final values = <String, dynamic>{};
    for (final entry in row.entries) {
      if (!columns.contains(entry.key)) {
        extras[entry.key] = entry.value;
        continue;
      }
      var value = entry.value;
      if (value is bool) value = value ? 1 : 0;
      if (value is String &&
          (entry.key.endsWith('_at') ||
              entry.key.endsWith('_date') ||
              const ['effective_from', 'effective_to'].contains(entry.key))) {
        value = DateTime.parse(value).millisecondsSinceEpoch ~/ 1000;
      }
      if (table == 'transactions' && value is String) {
        if (entry.key == 'type') value = 'TransactionType.$value';
        if (entry.key == 'source') value = 'TransactionSource.$value';
        if (entry.key == 'status') value = 'TransactionStatus.$value';
      }
      if (value is Map || value is List) value = jsonEncode(value);
      values[entry.key] = value;
    }
    final keys = values.keys.toList();
    final previous = await db
        .customSelect(
          'SELECT * FROM ${_id(localTable)} WHERE id=?',
          variables: [Variable(id)],
        )
        .getSingleOrNull();
    if (previous != null) {
      if (columns.contains('user_id') && previous.data['user_id'] != owner) {
        throw StateError('Conflicting record owner');
      }
      // Local edits win, but the complete older values remain available for
      // recovery instead of silently discarding them during INSERT OR IGNORE.
      if (values.entries.any((e) => previous.data[e.key] != e.value)) {
        await store.put(
          'legacy_conflicts:$table',
          original,
          onlyIfMissing: true,
        );
      }
      return;
    }
    await db.customStatement(
      'INSERT OR IGNORE INTO ${_id(localTable)} (${keys.map(_id).join(',')}) VALUES (${List.filled(keys.length, '?').join(',')})',
      values.values.toList(),
    );
    final saved = await db
        .customSelect(
          'SELECT * FROM ${_id(localTable)} WHERE id=?',
          variables: [Variable(id)],
        )
        .getSingleOrNull();
    if (saved == null ||
        values.entries.any((e) => saved.data[e.key] != e.value)) {
      throw StateError('Legacy row was not persisted exactly');
    }
    if (extras.isNotEmpty) {
      await store.put('legacy_extras:$table', {
        'id': id,
        ...extras,
      }, onlyIfMissing: true);
    }
  }
}
