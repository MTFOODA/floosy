import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/services/card_ownership.dart';

/// VERIFICATION AGAINST THE REAL DEVICE DATABASE.
///
/// `test/fixtures/device_floosy.db` is a copy of the live app database pulled
/// from the connected phone (`com.example.floosy`: 453 transactions, 540 SMS).
/// It is opened with the REAL production schema and driven through the REAL
/// [MoneyLocalDataSource] statements, so the counts below come from the same
/// code the app runs — not from a synthetic fixture.
///
/// The file is a COPY; the device's own data is never modified.
void main() {
  late db.AppDatabase database;
  late MoneyLocalDataSource local;
  const user = 'beed90e6-d8e8-480d-9508-542ab5b9823c';
  const fdir = 'test/fixtures';

  /// Extra SQL parameters for [count], set by the helpers below.
  final extra = <String>[];

  Future<int> count(String sql) async {
    final row = await database.customSelect(sql, variables: [
      const Variable<String>(user),
      for (final v in extra) Variable<String>(v),
    ]).getSingle();
    return row.read<int>('c');
  }

  Future<int> nullLast4For(String bank) {
    extra
      ..clear()
      ..add(bank);
    return count('''SELECT COUNT(*) AS c FROM transactions t
        JOIN sms_messages s ON s.transaction_id = t.id
        WHERE t.user_id = ? AND t.card_last4 IS NULL
          AND s.bank_identified = 1 AND s.detected_bank_name = ?''');
  }

  /// The same-bank NULL-Last 4 rows whose canonical type is exactly [type].
  /// This is the subgroup a confirmation for that type may reach.
  Future<int> nullLast4OfTypeFor(String bank, String type) {
    extra
      ..clear()
      ..add(type)
      ..add(bank);
    return count('''SELECT COUNT(*) AS c FROM transactions t
        JOIN sms_messages s ON s.transaction_id = t.id
        WHERE t.user_id = ? AND t.card_last4 IS NULL AND t.type = ?
          AND s.bank_identified = 1 AND s.detected_bank_name = ?''');
  }

  Future<int> last4For(String bank, String last4) {
    extra
      ..clear()
      ..add(last4)
      ..add(bank);
    return count('''SELECT COUNT(*) AS c FROM transactions t
        JOIN sms_messages s ON s.transaction_id = t.id
        WHERE t.user_id = ? AND t.card_last4 = ?
          AND s.bank_identified = 1 AND s.detected_bank_name = ?''');
  }

  Future<int> smsNullFor(String bank) {
    extra
      ..clear()
      ..add(bank);
    return count('''SELECT COUNT(*) AS c FROM sms_messages s
        JOIN transactions t ON t.id = s.transaction_id
        WHERE t.user_id = ? AND s.detected_card_last4 IS NULL
          AND s.bank_identified = 1 AND s.detected_bank_name = ?''');
  }

  /// The same-bank SMS rows with a NULL detected Last 4 whose linked
  /// transaction has canonical type exactly [type].
  Future<int> smsNullOfTypeFor(String bank, String type) {
    extra
      ..clear()
      ..add(type)
      ..add(bank);
    return count('''SELECT COUNT(*) AS c FROM sms_messages s
        JOIN transactions t ON t.id = s.transaction_id
        WHERE t.user_id = ? AND t.type = ? AND s.detected_card_last4 IS NULL
          AND s.bank_identified = 1 AND s.detected_bank_name = ?''');
  }

  Future<int> smsWithFor(String bank, String last4) {
    extra
      ..clear()
      ..add(last4)
      ..add(bank);
    return count('''SELECT COUNT(*) AS c FROM sms_messages s
        JOIN transactions t ON t.id = s.transaction_id
        WHERE t.user_id = ? AND s.detected_card_last4 = ?
          AND s.bank_identified = 1 AND s.detected_bank_name = ?''');
  }

  setUp(() {
    final tmp = Directory.systemTemp.createTempSync('floosy_device');
    for (final f in [
      'device_floosy.db',
      'device_floosy.db-wal',
      'device_floosy.db-shm',
    ]) {
      final src = File('$fdir/$f');
      if (src.existsSync()) {
        src.copySync('${tmp.path}${Platform.pathSeparator}$f');
      }
    }
    database = db.AppDatabase(NativeDatabase(
        File('${tmp.path}${Platform.pathSeparator}device_floosy.db')));
    local = MoneyLocalDataSource(database);
  });
  tearDown(() => database.close());


  test('REAL DEVICE: confirming a Last 4 fills every same-bank NULL row',
      () async {
    const bank = 'Faisal Bank';
    const confirmed = '9876';

    // The user edits ONE Faisal Bank transaction that has no Last 4. Its own
    // canonical type is the propagation group: the confirmation reaches that
    // group only, never the other types of the same bank/card.
    final target = await database
        .customSelect(
          '''SELECT t.id, t.type FROM transactions t
             JOIN sms_messages s ON s.transaction_id = t.id
             WHERE t.user_id = ? AND t.card_last4 IS NULL
               AND s.bank_identified = 1 AND s.detected_bank_name = ?
             LIMIT 1''',
          variables: [const Variable<String>(user), const Variable<String>(bank)],
        )
        .getSingle();
    final targetId = target.read<String>('id');
    final targetType = target.read<String>('type');

    // ---- BEFORE ----
    final bNull = await nullLast4For(bank);
    final bSmsNull = await smsNullFor(bank);
    final otherNullBefore = await nullLast4For('AlexBank');
    // The subgroup this confirmation is allowed to touch.
    final bNullOfType = await nullLast4OfTypeFor(bank, targetType);
    final bSmsNullOfType = await smsNullOfTypeFor(bank, targetType);
    // ignore: avoid_print
    print('''
════ BEFORE (real device DB) ════
Edited transaction       : $targetId
Confirmed Last 4         : $confirmed
Propagation group type   : $targetType
$bank + card_last4 NULL  : $bNull
  of which type=$targetType : $bNullOfType
$bank SMS det_last4 NULL : $bSmsNull
AlexBank + NULL          : $otherNullBefore''');

    // ---- the real production statements ----
    final names = await local.distinctDetectedBankNames(user);
    final matching = names
        .where((n) => normalizeBankIdentity(n) == normalizeBankIdentity(bank))
        .toList();
    final siblings = await local.findNullLast4IdsForDetectedBankNames(
        userId: user, bankNames: matching, type: targetType);
    final linkMissing = await local.findMissingCardIdIdsForIdentity(
        userId: user,
        bankNames: matching,
        last4: confirmed,
        type: targetType);
    // ignore: avoid_print
    print('same-bank NULL rows selected : ${siblings.length}');
    // ignore: avoid_print
    print('same-bank link-only rows     : ${linkMissing.length}');

    final result = await local.applyBankScopedConfirmedIdentity(
      transactionId: targetId,
      cardId: 'card-for-$confirmed',
      last4: confirmed,
      siblingTransactionIds:
          siblings.where((id) => id != targetId).toList(),
    );

    // ---- AFTER ----
    final aNull = await nullLast4For(bank);
    final aWith = await last4For(bank, confirmed);
    final aSmsWith = await smsWithFor(bank, confirmed);
    final otherNullAfter = await nullLast4For('AlexBank');
    // ignore: avoid_print
    print('''
════ AFTER (real device DB) ════
rows written : edited=${result.editedRows} siblingLast4=${result.siblingLast4Rows} siblingCard=${result.siblingCardRows} sms=${result.smsRows}
$bank + card_last4 NULL  : $aNull
$bank + card_last4 $confirmed  : $aWith
$bank SMS det_last4=$confirmed : $aSmsWith
AlexBank + NULL          : $otherNullAfter  (was $otherNullBefore)
''');

    expect(aNull, bNull - bNullOfType,
        reason: 'every same-bank NULL row OF THE CONFIRMED TYPE is filled, and '
            'rows of other transaction types are deliberately left for their own '
            'confirmation');
    expect(aWith, bNullOfType, reason: 'they all carry the confirmed value');
    // Exactly one SMS row per AFFECTED transaction is filled. A few NULL SMS
    // rows of the same type belong to transactions that ALREADY carried a
    // card_last4, so they are not siblings and are deliberately left alone —
    // which is why this is compared to the affected count, not the raw NULL SMS
    // count.
    expect(aSmsWith, bNullOfType,
        reason: 'one linked SMS record per affected transaction is filled');
    expect(aSmsWith, lessThanOrEqualTo(bSmsNullOfType),
        reason: 'no SMS row outside the NULL population is ever written');
    // SMS rows belonging to OTHER transaction types of the same bank keep their
    // own NULL Last 4: propagation follows the transaction group, not the bank.
    expect(aSmsWith, lessThan(bSmsNull),
        reason: 'unrelated detection records are not modified');
    expect(result.smsRows, bNullOfType, reason: 'one SMS row per affected txn');
    expect(result.siblingLast4Rows, bNullOfType - 1,
        reason: 'all but the edited row came from the sibling query');
    expect(otherNullAfter, otherNullBefore,
        reason: 'another bank must never be touched');

    final row = await (database.select(database.transactions)
          ..where((t) => t.id.equals(targetId)))
        .getSingle();
    expect(row.cardLast4, confirmed);
    expect(row.cardId, 'card-for-$confirmed');
  });

  test('REAL DEVICE: rows already holding a Last 4 are never rewritten',
      () async {
    const bank = 'Faisal Bank';
    final names = await local.distinctDetectedBankNames(user);
    final matching = names
        .where((n) => normalizeBankIdentity(n) == normalizeBankIdentity(bank))
        .toList();
    final all = await database.select(database.transactions).get();
    final known =
        all.where((t) => t.cardLast4 != null).toList(growable: false);
    // A known Last 4 is authoritative whatever its type, so the query is run
    // once per distinct type present in the data and no known row may appear.
    final types = all.map((t) => t.type).toSet();
    for (final type in types) {
      final siblings = await local.findNullLast4IdsForDetectedBankNames(
          userId: user, bankNames: matching, type: type);
      // ignore: avoid_print
      print('''
════ KNOWN-LAST4 SCAN (type=$type) ════
rows holding a known card_last4      : ${known.length}
rows this type's query would select  : ${siblings.length}''');
      for (final row in known) {
        expect(siblings.contains(row.id), isFalse,
            reason: 'a row that already has a last4 is never a NULL sibling');
      }
    }
  });
}
