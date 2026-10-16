import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/processed_sms_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/models/user_model.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
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


/// DIAGNOSTIC: where is the Last4 lost?
///
/// This runs the REAL pipeline (real SMSParser -> real SMSTransactionProcessor
/// -> real MoneyRepository -> real Drift) against the REAL Arabic InstaPay
/// bodies that produced the captured `cardLast4: null` rows in the audit logs,
/// and prints the actual database rows before and after the Edit -> Save flow.
///
/// The synthetic fixtures in the other suites pre-seeded `card_last4`, which is
/// exactly why they could not catch this.
void main() {
  const user = 'user';

  // The REAL body captured in the failing run. It contains the account number
  // and the transaction reference, but NO masked or labelled card number.
  const realInstaPayBody =
      'تم تحويل IPN من حسابكم رقم 7505 بمبلغ10.00 جم رقم مرجعي 7351';

  late db.AppDatabase database;
  late TransactionLocalDataSource txnLocal;
  late SmsMessageLocalDataSource smsLocal;
  late DetectedCardRepository cardRepo;
  late MoneyRepository moneyRepo;
  late _LocalOnlyTransactionRepository txnRepo;
  late SMSTransactionProcessor processor;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    database = db.AppDatabase(NativeDatabase.memory());
    txnLocal = TransactionLocalDataSource(database);
    smsLocal = SmsMessageLocalDataSource(database);
    cardRepo = DetectedCardRepository(local: DetectedCardLocalDataSource());
    txnRepo = _LocalOnlyTransactionRepository(txnLocal);
    moneyRepo = MoneyRepository(
      remote: _Remote(),
      local: MoneyLocalDataSource(database),
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

  /// Prints the actual stored rows: transaction + its detection record.
  Future<void> dump(String label) async {
    final rows = await txnLocal.getTransactionsByUserId(user);
    final smsRows = await database.select(database.smsMessages).get();
    for (final r in rows) {
      final sms = smsRows.where((s) => s.transactionId == r.id).firstOrNull;
      // ignore: avoid_print
      print('''
┌─ $label ─────────────────────────────────────────
│ id            = ${r.id}
│ user_id       = ${r.userId}
│ bank_id       = ${r.bankId}
│ type          = ${r.type}
│ amount_minor  = ${r.amountMinor}
│ merchant_name = ${r.merchantName}
│ card_last4    = ${r.cardLast4}
│ card_id       = ${r.cardId}
│ raw_ref       = ${r.rawReference}
│ sms_id        = ${sms?.id}
│ sms.sender    = ${sms?.sender}
│ sms.bank_ident= ${sms?.bankIdentified}
│ sms.det_bank  = ${sms?.detectedBankName}
│ sms.last4_ok  = ${sms?.cardLast4Identified}
│ sms.det_last4 = ${sms?.detectedCardLast4}
└───────────────────────────────────────────────────''');
    }
  }

  test('DIAGNOSTIC: real Arabic InstaPay SMS body carries no card Last4',
      () async {
    await processor.process(
      userId: user,
      sender: 'IPN',
      smsContent: realInstaPayBody,
    );
    await processor.process(
      userId: user,
      sender: 'IPN',
      smsContent: realInstaPayBody.replaceAll('7351', '7352'),
    );
    await processor.process(
      userId: user,
      sender: 'IPN',
      smsContent: realInstaPayBody.replaceAll('7351', '7353'),
    );

    final rows = await txnLocal.getTransactionsByUserId(user);
    // ignore: avoid_print
    print('\n[DIAG] parsed rows: ${rows.length}');

    // Every real row stores NO last4 and NO card_id - the detection record is
    // the only place the parser's answer lives, and it is null too.
    expect(rows.every((r) => r.cardLast4 == null), isTrue,
        reason: 'the real body has no masked/labelled card number');
    expect(rows.every((r) => r.cardId == null), isTrue);

    await dump('AFTER REAL INGESTION, BEFORE SAVE');

    // Now the Edit -> Save flow: the user supplies 1234 for the first row.
    // NOTE: the row's detected bank is "InstaPay" (from sender IPN), NOT CIB.
    // The learned identity is therefore InstaPay + 1234, and a pre-seeded
    // CIB + 1234 card would be a DIFFERENT card. We let the flow create the
    // identity and read back the card it actually resolved.
    final t1 = rows.first;
    final controller = TransactionEditController(
      userId: user,
      transactionRepository: txnRepo,
      moneyRepository: moneyRepo,
      cardRepository: cardRepo,
      bankCatalogLoader: () async => <Bank>[],
    );
    final learned = await controller.save(TransactionEditDraft(
      transaction: t1,
      type: t1.type,
      amountMinor: t1.amountMinor,
      currency: t1.currency,
      bankText: t1.merchantName ?? '',
      last4Text: '1234',
      categoryId: t1.categoryId,
      merchantName: t1.merchantName,
      transactionDate: t1.transactionDate,
    ));

    await dump('AFTER EDIT -> 1234 -> SAVE');

    // The edited row IS persisted (the fix from the previous round).
    final after = await txnLocal.getTransactionsByUserId(user);
    final edited = after.firstWhere((r) => r.id == t1.id);
    final cardA = learned!.resolution.cardId;
    expect(edited.cardLast4, '1234');
    expect(edited.cardId, isNotNull);
    expect(edited.cardId, cardA);

    // The siblings ARE now propagated: they are the same user, the same detected
    // bank (InstaPay), and their card_last4 is NULL — exactly the population the
    // product rule targets. Previously the old `card_last4 = confirmed` query
    // matched nothing here, so only the edited row ever changed.
    final siblings = after.where((r) => r.id != t1.id).toList();
    for (final s in siblings) {
      expect(s.cardLast4, '1234',
          reason: 'sibling ${s.id}: same user+bank+NULL last4 must be filled');
      expect(s.cardId, cardA,
          reason: 'sibling ${s.id} had no card, so it gains the confirmed one');
    }
  });
}
