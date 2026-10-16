/// Focused verification of the four required behaviours, using the REAL
/// parser, REAL local datasources and the REAL Drift schema (in memory).
///
///  1. A card Last 4 is detected in BOTH mask layouts (`2307**` and `**2325`).
///  2. Currency + amount are detected and stored in their original units.
///  3. A user-confirmed Last 4 propagates to same-user/same-bank NULL rows and
///     to the linked `sms_messages`, atomically, without touching `card_id`.
library;

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/local/datasources/processed_sms_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/user_model.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/data/services/sms_transaction_processor.dart';
import 'package:floosy/features/transactions/presentation/state/transaction_edit_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient _dummyClient() =>
    SupabaseClient('https://example.supabase.co', 'public-anon-key');

class _LocalOnlyTransactionRepository extends TransactionRepository {
  final TransactionLocalDataSource local;
  _LocalOnlyTransactionRepository(this.local)
      : super(TransactionRemoteDataSource(_dummyClient()), local);

  @override
  Future<Transaction> createTransaction(
      {required Transaction transaction}) async {
    await local.insertTransaction(transaction);
    return transaction;
  }

  @override
  Future<bool> isDuplicateTransaction(
          {required String userId, required String fingerprint}) async =>
      await local.getTransactionByFingerprint(userId, fingerprint) != null;

  @override
  Future<List<Transaction>> getTransactions(
          {required String userId,
          bool syncWithRemote = true,
          int limit = 100}) async =>
      local.getTransactionsByUserId(userId);
}

class _Remote implements MoneyRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Cash implements CashWalletRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Expenses implements ExpenseRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const user = 'user';
  const other = 'other-user';
  const alex = 'AlexBank';

  late db.AppDatabase database;
  late MoneyLocalDataSource moneyLocal;
  late TransactionLocalDataSource txnLocal;
  late SmsMessageLocalDataSource smsLocal;
  late DetectedCardRepository cardRepo;
  late MoneyRepository moneyRepo;
  late _LocalOnlyTransactionRepository txnRepo;
  late SMSTransactionProcessor processor;
  var changedCalls = 0;
  var seq = 0;

  setUp(() {
    changedCalls = 0;
    SharedPreferences.setMockInitialValues({});
    database = db.AppDatabase(NativeDatabase.memory());
    moneyLocal = MoneyLocalDataSource(database);
    txnLocal = TransactionLocalDataSource(database);
    smsLocal = SmsMessageLocalDataSource(database);
    cardRepo = DetectedCardRepository(local: DetectedCardLocalDataSource());
    txnRepo = _LocalOnlyTransactionRepository(txnLocal);
    moneyRepo = MoneyRepository(
      remote: _Remote(),
      local: moneyLocal,
      transactionRepository: txnRepo,
      cashWalletRepository: _Cash(),
      expenseRepository: _Expenses(),
      detectedCardRepository: cardRepo,
      smsMessageLocalDataSource: smsLocal,
    );
    processor = SMSTransactionProcessor(
      moneyRepository: moneyRepo,
      detectedCardRepository: cardRepo,
      smsMessageLocalDataSource: smsLocal,
      processedSmsLocalDataSource: ProcessedSmsLocalDataSource(database),
    );
  });
  tearDown(() => database.close());

  /// A transaction + its linked detection record (the persisted relationship
  /// the propagation joins on).
  Future<Transaction> insert({
    required int amount,
    required String bank,
    String userId = user,
    String? last4,
    String? cardId,
    String? smsLast4,
    String? rawRef,
    String? smsHash,
    TransactionType type = TransactionType.purchase,
  }) async {
    final id = 't${seq++}';
    final row = Transaction(
      id: id,
      userId: userId,
      type: type,
      source: TransactionSource.sms,
      amountMinor: amount,
      cardLast4: last4,
      cardId: cardId,
      transactionDate: DateTime.now(),
      rawReference: rawRef,
      fingerprint: 'fp-$id',
    );
    await txnLocal.insertTransaction(row);
    await smsLocal.upsert(SMSMessage(
      id: 's$id',
      userId: userId,
      sender: bank,
      // `message_hash` is UNIQUE per user, so it is kept distinct from
      // `raw_reference`: two transactions may legitimately share one
      // `raw_reference` while their detection records stay separate rows.
      messageHash: smsHash ?? 'h-$id',
      receivedAt: DateTime.now(),
      bankIdentified: true,
      detectedBankName: bank,
      detectedCardLast4: smsLast4,
      cardLast4Identified: smsLast4 != null,
      transactionId: id,
    ));
    return row;
  }

  TransactionEditController controller() => TransactionEditController(
        userId: user,
        transactionRepository: txnRepo,
        moneyRepository: moneyRepo,
        cardRepository: cardRepo,
        bankCatalogLoader: () async => <Bank>[],
        onChanged: () => changedCalls++,
      );

  TransactionEditDraft draft(Transaction t, String last4Text) =>
      TransactionEditDraft(
        transaction: t,
        type: t.type,
        amountMinor: t.amountMinor,
        currency: t.currency,
        bankText: t.merchantName ?? '',
        last4Text: last4Text,
        categoryId: t.categoryId,
        merchantName: t.merchantName,
        transactionDate: t.transactionDate,
      );

  Future<Transaction> txn(String id) async =>
      (await txnLocal.getTransactionsByUserId(user)).firstWhere((r) => r.id == id);

  Future<int> countLast4(String value, {String userId = user}) async {
    final rows = await txnLocal.getTransactionsByUserId(userId);
    return rows.where((r) => r.cardLast4 == value).length;
  }

  Future<int> countNullLast4({String userId = user}) async {
    final rows = await txnLocal.getTransactionsByUserId(userId);
    return rows.where((r) => r.cardLast4 == null).length;
  }

  Future<db.SmsMessage> smsFor(String txnId) async => (await database
          .select(database.smsMessages)
          .get())
      .firstWhere((s) => s.transactionId == txnId);

  Future<db.SmsMessage?> smsById(String id) async {
    final all = await database.select(database.smsMessages).get();
    for (final s in all) {
      if (s.id == id) return s;
    }
    return null;
  }


  // ── PART 1: card Last 4 detection ──────────────────────────────────────────

  group('card Last 4 detection', () {
    // TEST A — ATM trailing mask
    test('Format A: a trailing mask (بطاقة2307**) IS the Last 4', () async {
      const sms = 'تمت عملية سحب بمبلغ8000.00 EGPببطاقة2307** في24/09/26-09:36';
      final parsed = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(parsed.cardLast4, '2307',
          reason: 'the trailing ** is an alignment artifact, not a prefix marker');
      expect(parsed.amountMinor, 800000);
      expect(parsed.currency, 'EGP');
      expect(parsed.type, TransactionType.atm_withdrawal);
    });

    // TEST B — Purchase leading mask
    test('Format B: a leading mask (البطاقة رقم **2325) IS the Last 4', () async {
      const sms = 'عميلنا العزيز,\nتم خصم USD 0.00 من البطاقة رقم **2325 من '
          'MICROSOFT STORE في 19.09.2026 05:04 PM';
      final parsed = await SMSParser.parse(smsContent: sms, sender: 'CIB');
      expect(parsed.cardLast4, '2325');
      expect(parsed.currency, 'USD');
      expect(parsed.amountMinor, 0);
    });

    test('other NNNN** trailing-mask forms resolve the same way', () async {
      for (final digits in ['1234', '9999', '0000']) {
        final parsed = await SMSParser.parse(
          smsContent: 'تمت عملية بمبلغ1200.00 EGPببطاقة$digits** ',
          sender: 'CIB',
        );
        expect(parsed.cardLast4, digits, reason: '$digits** is the last four');
      }
    });

    test('a full 16-digit PAN is never mistaken for a Last 4', () async {
      // The `(?!\d)` lookahead must refuse to match inside a longer digit run,
      // so a complete card number cannot be truncated into a "last four".
      final parsed = await SMSParser.parse(
        smsContent: 'CIB: purchase EGP 50.00 on card 4111111111111111',
        sender: 'CIB',
      );
      expect(parsed.cardLast4, isNull,
          reason: 'a full PAN is not a last four');
    });

    test('an account/reference number is never taken as the card Last 4',
        () async {
      final parsed = await SMSParser.parse(
        smsContent: 'FAISAL BANK: تم تحويل IPN من حسابكم رقم 7505 '
            'بمبلغ10.00 جم رقم مرجعي 7351',
        sender: 'FAISAL BANK',
      );
      expect(parsed.cardLast4, isNull,
          reason: 'account and reference numbers are not card last fours');
    });

    test('the supported leading-mask forms still resolve', () async {
      final cases = <String, String>{
        'CIB: purchase EGP 50.00 on card ****1234': '1234',
        'CIB: purchase EGP 50.00 on card **9876': '9876',
        'CIB: purchase EGP 50.00 on card XX4321': '4321',
        'تم عملية بمبلغ 50.00 جم ببطاقة **7777': '7777',
      };
      for (final entry in cases.entries) {
        final parsed =
            await SMSParser.parse(smsContent: entry.key, sender: 'CIB');
        expect(parsed.cardLast4, entry.value, reason: entry.key);
      }
    });
  });

  // ── PART 2: currency + amount storage ──────────────────────────────────────

  group('currency and amount', () {
    // TEST 3
    test('USD 100 stores amount 100 in USD, not as EGP', () async {
      final parsed = await SMSParser.parse(
        smsContent: 'CIB: purchase USD 100.00 at MICROSOFT STORE card **2325',
        sender: 'CIB',
      );
      expect(parsed.amountMinor, 10000);
      expect(parsed.currency, 'USD',
          reason: 'the original currency must survive parsing');
    });

    test('a genuine 0.00 authorisation hold is a real amount, not "no amount"',
        () async {
      // Rejecting this as "no amount" sent the message to needs_review and lost
      // the Last 4 and currency that had already been detected.
      expect(SMSParser.extractAmount('CIB: USD 0.00 at STORE'), 0);
      expect(SMSParser.extractAmount('CIB: EGP 0.00 at STORE'), 0);
      expect(SMSParser.detectCurrency('CIB: USD 0.00 at STORE'), 'USD');
    });

    test('a zero-amount SMS keeps its detected Last 4 and currency', () async {
      final parsed = await SMSParser.parse(
        smsContent: 'CIB: purchase USD 0.00 at STORE card **2325',
        sender: 'CIB',
      );
      expect(parsed.amountMinor, 0);
      expect(parsed.currency, 'USD');
      expect(parsed.cardLast4, '2325');
    });

    test('a real amount is never collapsed to zero by the bound-zero rule',
        () async {
      expect(SMSParser.extractAmount('CIB: USD 0.50 at STORE'), 50);
      expect(SMSParser.extractAmount('CIB: USD 100.00 at STORE'), 10000);
      expect(SMSParser.extractAmount('CIB: USD 0.01 at STORE'), 1);
    });
  });

  // ── PART 3: no silent conversion to EGP ────────────────────────────────────

  group('foreign currency is not silently converted', () {
    test('the parser never rewrites a foreign amount into EGP minor units',
        () async {
      final parsed = await SMSParser.parse(
        smsContent: 'CIB: purchase USD 100.00 at STORE',
        sender: 'CIB',
      );
      expect(parsed.amountMinor, 10000,
          reason: 'no exchange rate is applied at parse time');
      expect(parsed.currency, 'USD');
    });

    test('the original amount and currency are persisted unchanged', () async {
      final row = await insert(amount: 10000, bank: alex);
      final stored = await txn(row.id);
      expect(stored.amountMinor, 10000,
          reason: 'the DB keeps the ORIGINAL minor units');
      expect(stored.currency, 'EGP');
    });
  });

  // ── PART 4/5/6/7: manual confirmation propagation ───────────────────────────

  group('manual Last 4 confirmation', () {
    // TEST 4
    test('101 same-bank rows get the confirmed value, 20 other-bank do not',
        () async {
      // 1 edited AlexBank row + 100 more AlexBank NULL rows.
      final alexRows = <Transaction>[];
      for (var i = 0; i < 101; i++) {
        alexRows.add(await insert(amount: 1000 + i, bank: alex));
      }
      // 20 other-bank NULL rows.
      for (var i = 0; i < 20; i++) {
        await insert(amount: 5000 + i, bank: 'Faisal Bank');
      }

      await controller().save(draft(alexRows.first, '5143'));

      expect(await countLast4('5143'), 101,
          reason: 'the edited row + 100 same-bank NULL siblings');
      expect((await txn(alexRows.first.id)).cardLast4, '5143');
      expect(await countNullLast4(), 20,
          reason: 'the 20 other-bank rows are untouched');
    });

    test('propagation happens when the user edits only ONE transaction',
        () async {
      final t1 = await insert(amount: 1000, bank: alex);
      await insert(amount: 2000, bank: alex);
      await insert(amount: 3000, bank: alex);
      await insert(amount: 4000, bank: 'Faisal Bank');

      await controller().save(draft(t1, '5143'));

      expect(await countLast4('5143'), 3,
          reason: 'siblings change even though only T1 was edited');
      expect(await countNullLast4(), 1);
    });

    // TEST 5
    test('an existing card_id is preserved while card_last4 is filled', () async {
      final otherCard =
          await cardRepo.upsertCard(userId: user, last4: '1111', bankName: 'CIB');
      final owned =
          await insert(amount: 1000, bank: alex, cardId: otherCard.id);
      final t1 = await insert(amount: 2000, bank: alex);

      await controller().save(draft(t1, '5143'));

      final after = await txn(owned.id);
      expect(after.cardLast4, '5143',
          reason: 'the missing number is filled');
      expect(after.cardId, otherCard.id,
          reason: 'explicit card ownership is NEVER overwritten');
    });

    // TEST 6
    test('same-bank SMS rows with a NULL detected Last 4 receive it', () async {
      final t1 = await insert(amount: 1000, bank: alex);
      final t2 = await insert(amount: 2000, bank: alex);
      expect((await smsFor(t1.id)).detectedCardLast4, isNull);

      await controller().save(draft(t1, '5143'));

      expect((await smsFor(t1.id)).detectedCardLast4, '5143');
      expect((await smsFor(t2.id)).detectedCardLast4, '5143');
      expect((await smsFor(t1.id)).cardLast4Identified, isTrue,
          reason: 'the identification flag must match the stored value');
    });

    // TEST 7
    test('SMS rows that already carry a Last 4 are never rewritten', () async {
      final t1 = await insert(amount: 1000, bank: alex);
      final keep = await insert(
          amount: 2000, bank: alex, last4: '7777', smsLast4: '7777');
      expect((await smsFor(keep.id)).detectedCardLast4, '7777');

      await controller().save(draft(t1, '5143'));

      expect((await smsFor(keep.id)).detectedCardLast4, '7777',
          reason: 'a genuine parsed value is preserved');
      expect((await txn(keep.id)).cardLast4, '7777',
          reason: 'a row that already had a last4 is not rewritten');
    });

    // TEST 8
    test("different-bank SMS rows remain unchanged", () async {
      final t1 = await insert(amount: 1000, bank: alex);
      final otherBank = await insert(amount: 2000, bank: 'Faisal Bank');

      await controller().save(draft(t1, '5143'));

      expect((await smsFor(otherBank.id)).detectedCardLast4, isNull,
          reason: "another bank's detection is not modified");
    });

    // TEST 9
    test('a needs_review SMS with no transaction is never touched', () async {
      await smsLocal.upsert(SMSMessage(
        id: 'orphan',
        userId: user,
        sender: alex,
        messageHash: 'h-orphan',
        receivedAt: DateTime.now(),
        processingStatus: 'needs_review',
        bankIdentified: true,
        detectedBankName: alex,
      ));

      final t1 = await insert(amount: 1000, bank: alex);
      await controller().save(draft(t1, '5143'));

      final after = await smsById('orphan');
      expect(after, isNotNull);
      expect(after!.detectedCardLast4, isNull,
          reason: 'an unlinked needs_review message is left alone');
    });

    test("another user's rows are never reached", () async {
      final mine = await insert(amount: 1000, bank: alex);
      await insert(amount: 2000, bank: alex, userId: other);

      await controller().save(draft(mine, '5143'));

      expect((await txnLocal.getTransactionsByUserId(other)).single.cardLast4,
          isNull);
    });

    // TEST 10
    test('a duplicate raw_reference does not cause a wrong card assignment',
        () async {
      // Two transactions share one raw_reference, so the hash is AMBIGUOUS: a
      // hash-based join would reach the wrong row. Propagation must follow the
      // persisted `sms_messages.transaction_id` relationship instead.
      final a = await insert(amount: 1000, bank: alex, rawRef: 'shared-hash');
      final b = await insert(amount: 2000, bank: alex, rawRef: 'shared-hash');
      expect(a.rawReference, b.rawReference);

      // An unlinked sms row that is a legitimate needs_review orphan.
      await smsLocal.upsert(SMSMessage(
        id: 'ambiguous',
        userId: user,
        sender: alex,
        messageHash: 'ambiguous-hash',
        receivedAt: DateTime.now(),
        processingStatus: 'needs_review',
        bankIdentified: true,
        detectedBankName: alex,
      ));

      await controller().save(draft(a, '5143'));

      // The edited row and its OWN linked detection record change.
      expect((await txn(a.id)).cardLast4, '5143');
      expect((await smsFor(a.id)).detectedCardLast4, '5143');

      // Each row kept its own identity: nothing was crossed over.
      expect((await smsFor(a.id)).transactionId, a.id);
      expect((await smsFor(b.id)).transactionId, b.id);

      // The unlinked row is never assigned through an ambiguous relationship.
      expect((await smsById('ambiguous'))!.detectedCardLast4, isNull);
    });

    // PART 7
    test('the write is atomic: the edited row and its siblings commit together',
        () async {
      final t1 = await insert(amount: 1000, bank: alex);
      await insert(amount: 2000, bank: alex);
      await insert(amount: 3000, bank: alex);

      final all = (await txnLocal.getTransactionsByUserId(user))
          .map((r) => r.id)
          .where((id) => id != t1.id)
          .toList();

      final result = await moneyLocal.applyBankScopedConfirmedIdentity(
        transactionId: t1.id,
        cardId: 'card-1',
        last4: '5143',
        siblingTransactionIds: all,
      );

      expect(result.editedRows, 1);
      expect(result.siblingLast4Rows, 2);
      expect(await countLast4('5143'), 3,
          reason: 'a single commit covers the row and its siblings');
    });

    test('the UI is notified only after the local commit', () async {
      final t1 = await insert(amount: 1000, bank: alex);
      await controller().save(draft(t1, '5143'));
      expect(changedCalls, 1);
      // The database is the source of truth, not an in-memory value.
      expect((await txn(t1.id)).cardLast4, '5143');
    });

    // TEST C — same bank, two distinct cards
    test('TEST C: two cards in the SAME bank stay separate identities', () async {
      final a = await insert(amount: 1000, bank: alex, last4: '2307');
      final b = await insert(amount: 2000, bank: alex, last4: '5143');

      // Learn both identities.
      await controller().save(draft(a, '2307'));
      await controller().save(draft(b, '5143'));

      expect((await txn(a.id)).cardLast4, '2307');
      expect((await txn(b.id)).cardLast4, '5143');

      final card2307 =
          await cardRepo.upsertCard(userId: user, last4: '2307', bankName: alex);
      final card5143 =
          await cardRepo.upsertCard(userId: user, last4: '5143', bankName: alex);
      expect(card2307.id, isNot(card5143.id),
          reason: 'one Last 4 makes exactly one card identity');
      expect((await txn(a.id)).cardId, card2307.id);
      expect((await txn(b.id)).cardId, card5143.id);
    });

    // TEST D — same Last 4, different banks
    test('TEST D: the same Last 4 in two banks stays two identities', () async {
      final a = await insert(amount: 1000, bank: alex, last4: '2325');
      final b = await insert(amount: 2000, bank: 'Faisal Bank', last4: '2325');

      final cardA =
          await cardRepo.upsertCard(userId: user, last4: '2325', bankName: alex);
      final cardB = await cardRepo.upsertCard(
          userId: user, last4: '2325', bankName: 'Faisal Bank');

      expect(cardA.id, isNot(cardB.id),
          reason: 'bank is part of the identity, so these never merge');
      expect((await txn(a.id)).cardLast4, '2325');
      expect((await txn(b.id)).cardLast4, '2325');
    });

    // TEST E — propagation never overwrites a known Last 4
    test('TEST E: only NULL rows take the confirmed value', () async {
      // Bank A: two NULL, one 2307, one 5143. Bank B: one NULL.
      final aNull1 = await insert(amount: 1000, bank: alex);
      final aNull2 = await insert(amount: 2000, bank: alex);
      final a2307 = await insert(amount: 3000, bank: alex, last4: '2307');
      final a5143 = await insert(amount: 4000, bank: alex, last4: '5143');
      final bNull = await insert(amount: 5000, bank: 'Faisal Bank');

      await controller().save(draft(aNull1, '5143'));

      expect((await txn(aNull1.id)).cardLast4, '5143');
      expect((await txn(aNull2.id)).cardLast4, '5143');
      expect((await txn(a2307.id)).cardLast4, '2307',
          reason: 'a known Last 4 is authoritative and never overwritten');
      expect((await txn(a5143.id)).cardLast4, '5143');
      expect((await txn(bNull.id)).cardLast4, isNull,
          reason: 'no cross-bank propagation');
    });
  });

  // ── TEST I: transaction completeness ──────────────────────────────────────

  group('transaction completeness', () {
    test('TEST I: the ATM SMS is stored complete', () async {
      const body = 'تمت عملية سحب بمبلغ8000.00 EGPببطاقة2307** في24/09/26-09:36';
      final before = await txnLocal.getTransactionsByUserId(user);
      await processor.process(userId: user, sender: 'CIB', smsContent: body);
      final row = (await txnLocal.getTransactionsByUserId(user))
          .firstWhere((r) => !before.any((b) => b.id == r.id));

      // Every field the SMS carries must survive into the row. A missing
      // merchant must never cost us the card identity.
      expect(row.type, TransactionType.atm_withdrawal);
      expect(row.amountMinor, 800000);
      expect(row.currency, 'EGP');
      expect(row.cardLast4, '2307');
      expect(row.rawReference, isNotNull, reason: 'the message hash is kept');
    });

    test('the detection record and the transaction agree on every field',
        () async {
      const body = 'تمت عملية سحب بمبلغ8000.00 EGPببطاقة2307** في24/09/26-09:36';
      final before = await txnLocal.getTransactionsByUserId(user);
      await processor.process(userId: user, sender: 'CIB', smsContent: body);
      final row = (await txnLocal.getTransactionsByUserId(user))
          .firstWhere((r) => !before.any((b) => b.id == r.id));

      final sms = (await database.select(database.smsMessages).get())
          .firstWhere((s) => s.transactionId == row.id);

      // Parser, transaction and detection record must never disagree.
      expect(sms.detectedCardLast4, row.cardLast4);
      expect(sms.detectedCardLast4, '2307');
      expect(sms.cardLast4Identified, isTrue);
      expect(sms.detectedCurrency, 'EGP');
      expect(sms.detectedAmountMinor, 800000);
      expect(sms.bankIdentified, isTrue);
      expect(sms.typeIdentified, isTrue);
      expect(sms.amountIdentified, isTrue);
    });
  });

  // ── TYPE-SCOPED propagation identity ──────────────────────────────────────
  //
  //   physical card identity        : user + bank + last4
  //   transaction propagation group : user + bank + last4 + type

  group('type-scoped propagation identity', () {
    // Test 1
    test('Test 1: same bank + same card + same type propagates', () async {
      final a = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final b = await insert(
          amount: 2000, bank: alex, type: TransactionType.purchase);

      await controller().save(draft(a, '5143'));

      expect((await txn(a.id)).cardLast4, '5143');
      expect((await txn(b.id)).cardLast4, '5143',
          reason: 'the same type is the same propagation group');
    });

    // Test 2
    test('Test 2: a purchase confirmation never reaches an ATM sibling',
        () async {
      final purchase = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final atm = await insert(
          amount: 2000, bank: alex, type: TransactionType.atm_withdrawal);

      await controller().save(draft(purchase, '5143'));

      expect((await txn(purchase.id)).cardLast4, '5143');
      expect((await txn(atm.id)).cardLast4, isNull,
          reason: 'a different type on the same card is a different group');
    });

    // Test 3
    test('Test 3: only the matching type group is propagated', () async {
      final p1 = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final p2 = await insert(
          amount: 2000, bank: alex, type: TransactionType.purchase);
      final atm = await insert(
          amount: 3000, bank: alex, type: TransactionType.atm_withdrawal);
      final transfer = await insert(
          amount: 4000, bank: alex, type: TransactionType.transfer_out);

      await controller().save(draft(p1, '5143'));

      expect((await txn(p1.id)).cardLast4, '5143');
      expect((await txn(p2.id)).cardLast4, '5143');
      expect((await txn(atm.id)).cardLast4, isNull);
      expect((await txn(transfer.id)).cardLast4, isNull);
    });

    // Test 4
    test('Test 4: the same Last 4 in two banks stays isolated', () async {
      final cib = await insert(
          amount: 1000, bank: 'Commercial International Bank',
          type: TransactionType.purchase);
      final other = await insert(
          amount: 2000, bank: alex, type: TransactionType.purchase);

      await controller().save(draft(cib, '5143'));

      expect((await txn(cib.id)).cardLast4, '5143');
      expect((await txn(other.id)).cardLast4, isNull,
          reason: 'bank is still part of the identity');
    });

    // Test 5
    test('Test 5: only the matching Last 4 group is affected', () async {
      final target = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final otherCard = await insert(
          amount: 2000, bank: alex, last4: '1111',
          type: TransactionType.purchase);

      await controller().save(draft(target, '5143'));

      expect((await txn(target.id)).cardLast4, '5143');
      expect((await txn(otherCard.id)).cardLast4, '1111',
          reason: 'a known Last 4 is authoritative');
    });

    // Test 6
    test('Test 6: only NULL rows take the confirmed value', () async {
      final target = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final known2307 = await insert(
          amount: 2000, bank: alex, last4: '2307',
          type: TransactionType.purchase);
      final known5143 = await insert(
          amount: 3000, bank: alex, last4: '5143',
          type: TransactionType.purchase);
      final nullRow = await insert(
          amount: 4000, bank: alex, type: TransactionType.purchase);

      await controller().save(draft(target, '5143'));

      expect((await txn(known2307.id)).cardLast4, '2307');
      expect((await txn(known5143.id)).cardLast4, '5143');
      expect((await txn(nullRow.id)).cardLast4, '5143');
      expect((await txn(target.id)).cardLast4, '5143');
    });

    // Test 7
    test('Test 7: an existing card_id survives the confirmation', () async {
      final existing =
          await cardRepo.upsertCard(userId: user, last4: '9999', bankName: alex);
      final owned = await insert(
          amount: 1000, bank: alex, cardId: existing.id,
          type: TransactionType.purchase);
      final target = await insert(
          amount: 2000, bank: alex, type: TransactionType.purchase);

      await controller().save(draft(target, '5143'));

      final after = await txn(owned.id);
      expect(after.cardLast4, '5143');
      expect(after.cardId, existing.id,
          reason: 'explicit ownership is never replaced');
    });

    // Test 8
    test('Test 8: SMS propagation follows the same transaction group',
        () async {
      final purchase = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final atm = await insert(
          amount: 2000, bank: alex, type: TransactionType.atm_withdrawal);
      final transfer = await insert(
          amount: 3000, bank: alex, type: TransactionType.transfer_out);
      final income = await insert(
          amount: 4000, bank: alex, type: TransactionType.income);

      await controller().save(draft(purchase, '5143'));

      expect((await smsFor(purchase.id)).detectedCardLast4, '5143');
      for (final other in [atm, transfer, income]) {
        expect((await smsFor(other.id)).detectedCardLast4, isNull,
            reason: "only the purchase group's SMS rows are filled");
      }
    });

    // Test 9
    test('Test 9: an unresolved type joins no propagation group', () async {
      final purchase = await insert(
          amount: 1000, bank: alex, type: TransactionType.purchase);
      final odd = await insert(
          amount: 2000, bank: alex, type: TransactionType.purchase);
      // A row whose stored type is NOT a canonical TransactionType value. The
      // app's reader maps it back to `purchase`, but on disk it is a distinct
      // value, so it must not be pulled into the `TransactionType.purchase`
      // propagation group.
      await (database.update(database.transactions)
            ..where((t) => t.id.equals(odd.id)))
          .write(const db.TransactionsCompanion(
              type: Value('TransactionType.unresolved')));

      await controller().save(draft(purchase, '5143'));

      expect((await txn(purchase.id)).cardLast4, '5143');
      final oddRow =
          (await database.select(database.transactions).get())
              .firstWhere((t) => t.id == odd.id);
      expect(oddRow.cardLast4, isNull,
          reason: 'an unresolved type must not match a known type');
    });
  });
}

