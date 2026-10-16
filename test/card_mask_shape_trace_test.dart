import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/data/local/datasources/detected_card_local_datasource.dart';
import 'package:floosy/data/local/datasources/money_local_datasource.dart';
import 'package:floosy/data/local/datasources/processed_sms_local_datasource.dart';
import 'package:floosy/data/local/datasources/sms_message_local_datasource.dart';
import 'package:floosy/data/local/datasources/transaction_local_datasource.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/data/remote/datasources/money_remote_datasource.dart';
import 'package:floosy/data/remote/datasources/transaction_remote_datasource.dart';
import 'package:floosy/data/repositories/cash_wallet_repository.dart';
import 'package:floosy/data/repositories/detected_card_repository.dart';
import 'package:floosy/data/repositories/expense_repository.dart';
import 'package:floosy/data/repositories/money_repository.dart';
import 'package:floosy/data/repositories/transaction_repository.dart';
import 'package:floosy/data/services/sms_parser_service.dart';
import 'package:floosy/data/services/sms_transaction_processor.dart';
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


/// TRACE: the REAL device card-purchase SMS, captured from
/// `/data/data/com.example.floosy/app_flutter/floosy.db` on the connected
/// device (sender=FAISAL BANK, 162 such messages on that device).
///
/// The card is rendered `2307**`: the visible four digits are the card's LAST
/// four, and the trailing asterisks are an alignment artifact. The digits are
/// preserved so the mask SHAPE stays authentic.
void main() {
  const user = 'user';

  // Verbatim structure from the device sms_messages row.
  const realDevicePurchase =
      'تمت عملية بمبلغ1.00 EGPببطاقة2307** في14/04/26-12:38 عند VODAFONE EGYPT '
      'Smart Village EG  للإستفسار 19851';

  // Control message in the LEAD-mask layout, which genuinely exposes the LAST
  // four digits - the form the parser is actually correct about.
  const leadMaskPurchase =
      'عميلنا العزيز, تم خصم EGP 1,200.00 من البطاقة رقم  **2325 من merchant '
      'في 30.08.2026 04:21 PM. المتاح الان EGP 7,608.40';

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

  Future<void> trace(String label, String body, {String? sender}) async {
    final s = sender ?? 'FAISAL BANK';
    final parsed = await SMSParser.parse(
        smsContent: body, sender: s, knownBanks: const []);
    final before = await txnLocal.getTransactionsByUserId(user);
    await processor.process(userId: user, sender: s, smsContent: body);
    final after = await txnLocal.getTransactionsByUserId(user);
    // ignore: avoid_print
    print('''
════ $label ════
RAW SMS            : $body
Parser.bank        : ${parsed.bankName}
Parser.type        : ${parsed.type}
Parser.cardLast4   : ${parsed.cardLast4}
Parser.accountLast4: ${parsed.accountLast4}
''');
    if (after.length == before.length) {
      // ignore: avoid_print
      print('Drift             : (no new row created)');
      return;
    }
    final row = after.firstWhere((r) => !before.any((b) => b.id == r.id));
    // ignore: avoid_print
    print('''
Processor          : passes parsed.cardLast4 through unchanged
Repository         : cardLast4 = ${parsed.cardLast4}
Drift.card_last4   : ${row.cardLast4}
Drift.card_id      : ${row.cardId}
''');
  }

  test('TRACE real device TRAIL-mask SMS (mask shape 2307**)', () async {
    await trace('REAL DEVICE - FAISAL BANK - 2307**', realDevicePurchase);
  });

  test('TRACE LEAD-mask SMS (mask shape **2325)', () async {
    await trace('LEAD-MASK CONTROL - ALEXBANK - **2325', leadMaskPurchase,
        sender: 'ALEXBANK');
  });

  test('FINDING: the trail-mask form carries the card Last 4 too', () async {
    // `2307**` and `**2325` are both the card's last four. The trailing `**` is
    // a formatting/alignment artifact of this bank's card rendering, NOT a rule
    // that the visible digits are the card's first four. Discarding this value
    // would throw away the only card identity the message carries.
    final parsed = await SMSParser.parse(
        smsContent: realDevicePurchase,
        sender: 'FAISAL BANK',
        knownBanks: const []);
    expect(parsed.cardLast4, '2307',
        reason: 'a card label introduces the last four in either mask layout');
    expect(parsed.accountLast4, isNull,
        reason: 'account last4 must never be confused with the card last4');
  });

  test('a genuine last 4 in the LEAD-mask layout is still extracted', () async {
    final parsed = await SMSParser.parse(
        smsContent: leadMaskPurchase,
        sender: 'ALEXBANK',
        knownBanks: const []);
    expect(parsed.cardLast4, '2325',
        reason: 'the digits AFTER a mask really are the last four');
  });
}
