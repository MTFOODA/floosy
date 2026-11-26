import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:floosy/app/composition_root.dart';
import 'package:floosy/data/local/database/app_database.dart' as db;
import 'package:floosy/domain/entities/transaction_model.dart';
import 'package:floosy/domain/entities/transaction_edit_policy.dart';
import 'package:floosy/domain/entities/user_model.dart';
import 'package:floosy/domain/usecases/save_transaction_edit.dart';
import 'package:floosy/domain/usecases/create_manual_transaction.dart';
import 'package:floosy/domain/usecases/remove_empty_duplicate_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDependencies deps;
  late SupabaseClient client;
  late SaveTransactionEdit editor;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    client = SupabaseClient(
      'https://floosy.supabase.co',
      'key',
      httpClient: MockClient((_) async => throw StateError('No network')),
    );
    deps = AppDependencies(
      client: client,
      database: db.AppDatabase(NativeDatabase.memory()),
    );
    deps.currentUserId = () => 'u';
    await deps.prepareUser('u');
    editor = SaveTransactionEdit(
      userId: 'u',
      transactionRepository: deps.transactionRepository,
      moneyRepository: deps.moneyRepository,
      cardRepository: deps.detectedCardRepository,
      bankCatalogLoader: () async => const [
        Bank(id: 'cib-id', name: 'Commercial International Bank', code: 'CIB'),
      ],
    );
  });
  tearDown(() async {
    await deps.close();
    await client.dispose();
  });
  Future<Transaction> seed({
    bool incomplete = false,
    bool zeroHold = false,
  }) async {
    final tx = Transaction(
      id: 'tx',
      userId: 'u',
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: incomplete || zeroHold ? 0 : 12550,
      currency: 'EGP',
      transactionDate: DateTime(2026, 11, 13, 4, 29),
      fingerprint: 'tx',
      bankId: incomplete ? null : 'cib-id',
      merchantName: incomplete ? null : 'MY STORE',
      cardLast4: incomplete ? null : '1234',
      notes: 'Existing note',
    );
    await deps.transactionRepository.insertLocally(tx);
    await deps.smsMessageLocalDataSource.upsert(
      SMSMessage(
        id: 'sms',
        userId: 'u',
        messageHash: 'sms',
        receivedAt: tx.transactionDate,
        transactionId: tx.id,
        detectedBankName: incomplete ? null : 'CIB',
        typeIdentified: !incomplete,
        amountIdentified: !incomplete,
        currencyIdentified: true,
        bankIdentified: !incomplete,
        messageBody: 'Private source',
      ),
    );
    return tx;
  }

  TransactionEditDraft draft(
    Transaction t, {
    int? amount,
    TransactionType? type,
    String? currency,
    DateTime? date,
    String? last4,
    String? merchant,
    String? bank,
    String? category,
    String? note,
    String? selectedCardId,
  }) => TransactionEditDraft(
    transaction: t,
    type: type ?? t.type,
    amountMinor: amount ?? t.amountMinor,
    currency: currency ?? t.currency,
    bankText: bank ?? 'CIB',
    last4Text: last4 ?? t.cardLast4 ?? '',
    categoryId: category ?? t.categoryId,
    merchantName: merchant ?? t.merchantName,
    transactionDate: date ?? t.transactionDate,
    additionalNote: note,
    selectedCardId: selectedCardId,
  );

  test(
    'manual purchases use the selected card ID and support no card',
    () async {
      final card = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '2307',
        bankName: 'Faisal Bank',
      );
      final other = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '2307',
        bankName: 'CIB',
      );
      var id = 0;
      final create = CreateManualTransaction(
        deps.transactionRepository,
        cards: deps.detectedCardRepository,
        money: deps.moneyRepository,
        createId: () => 'manual-${id++}',
        now: () => DateTime(2026, 11, 26, 16, 5),
      );
      final linked = await create(
        userId: 'u',
        type: TransactionType.purchase,
        amountMinor: 20000,
        currency: 'EGP',
        cardId: card.id,
      );
      final unlinked = await create(
        userId: 'u',
        type: TransactionType.purchase,
        amountMinor: 10000,
        currency: 'EGP',
      );
      expect(linked.cardId, card.id);
      expect(linked.cardLast4, card.last4);
      expect(unlinked.cardId, isNull);
      final selectedBalance = await deps.moneyRepository.getCardBalance(
        'u',
        card.last4,
        bankName: card.bankName,
      );
      final otherBalance = await deps.moneyRepository.getCardBalance(
        'u',
        other.last4,
        bankName: other.bankName,
      );
      expect(selectedBalance.myBalanceMinor, -20000);
      expect(otherBalance.myBalanceMinor, 0);
      await editor.save(
        draft(unlinked, bank: 'Faisal Islamic Bank of Egypt', last4: '2307'),
      );
      expect(await deps.detectedCardRepository.getCards('u'), hasLength(2));
      expect(
        (await deps.moneyRepository.getTransactionsForCard(
          'u',
          card.last4,
          bankName: card.bankName,
        )).map((tx) => tx.id),
        unorderedEquals([linked.id, unlinked.id]),
      );
    },
  );

  test(
    'legacy duplicate can be corrected without applying the purchase twice',
    () async {
      final card = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '2307',
        bankName: 'Faisal Bank',
      );
      final alias = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '2307',
        bankName: 'Faisal Islamic Bank of',
      );
      expect(alias.id, card.id);
      final duplicate = card.copyWith(
        id: 'legacy',
        bankName: 'faisal islamic bank of',
        createdAt: card.createdAt.add(const Duration(minutes: 1)),
      );
      await deps.detectedCardLocalDataSource.saveCards('u', [card, duplicate]);
      final tx = Transaction(
        id: 'legacy-purchase',
        userId: 'u',
        type: TransactionType.purchase,
        source: TransactionSource.manual,
        amountMinor: 20000,
        fingerprint: 'legacy-purchase',
        cardId: duplicate.id,
        cardLast4: duplicate.last4,
        transactionDate: DateTime(2026, 11, 26),
      );
      await deps.transactionRepository.createTransaction(transaction: tx);
      final remove = RemoveEmptyDuplicateCard(
        deps.detectedCardRepository,
        deps.transactionRepository,
        deps.salaryRepository,
      );
      expect(await remove('u', card.id), isFalse);
      expect(await remove('u', duplicate.id), isFalse);
      final policy = await editor.policy(tx);
      expect(
        policy.cardOptions.map((c) => c.id),
        unorderedEquals([card.id, duplicate.id]),
      );
      await editor.save(
        draft(tx, bank: duplicate.bankName, selectedCardId: card.id),
      );
      final rows = await deps.transactionRepository.getTransactions(
        userId: 'u',
      );
      expect(rows.single.cardId, card.id);
      expect(rows.single.amountMinor, tx.amountMinor);
      expect(
        (await deps.moneyRepository.getCardBalance(
          'u',
          card.last4,
          bankName: card.bankName,
        )).myBalanceMinor,
        -20000,
      );
      expect(
        (await deps.moneyRepository.getCardBalance(
          'u',
          duplicate.last4,
          bankName: duplicate.bankName,
        )).myBalanceMinor,
        0,
      );
      expect(await remove('u', duplicate.id), isTrue);
      expect(
        (await deps.detectedCardRepository.getCards('u')).single.id,
        card.id,
      );
      expect(
        (await deps.transactionRepository.getTransactions(
          userId: 'u',
        )).single.cardId,
        card.id,
      );
    },
  );

  test(
    'captured amount, type, currency, date, card and merchant cannot be edited, including direct save calls',
    () async {
      final tx = await seed();
      for (final attempt in [
        draft(tx, amount: 1),
        draft(tx, type: TransactionType.income),
        draft(tx, currency: 'USD'),
        draft(tx, date: DateTime(2026, 11, 14)),
        draft(tx, last4: '9999'),
        draft(tx, merchant: 'CHANGED'),
        draft(tx, bank: 'ALEXBANK'),
      ]) {
        await expectLater(
          editor.save(attempt),
          throwsA(isA<TransactionEditFailure>()),
        );
      }
      final saved = (await deps.transactionRepository.getTransactions(
        userId: 'u',
      )).single;
      expect(saved.amountMinor, 12550);
      expect(saved.type, TransactionType.purchase);
      expect(saved.bankId, 'cib-id');
      expect(saved.cardLast4, '1234');
      expect(saved.notes, 'Existing note');
    },
  );

  test(
    'missing values complete once, optional notes append and bank metadata survives offline',
    () async {
      final tx = await seed(incomplete: true);
      final before = await editor.policy(tx);
      expect(
        before.amount &&
            before.type &&
            before.bank &&
            before.last4 &&
            before.merchant,
        isTrue,
      );
      await editor.save(
        draft(
          tx,
          amount: 2500,
          type: TransactionType.purchase,
          bank: 'CIB',
          last4: '5678',
          merchant: 'متجر اختباري',
          category: 'category-1',
          note: 'معلومة إضافية',
        ),
      );
      final saved = (await deps.transactionRepository.getTransactions(
        userId: 'u',
      )).single;
      expect(saved.amountMinor, 2500);
      expect(saved.bankId, 'cib-id');
      expect(saved.cardLast4, '5678');
      expect(saved.merchantName, 'متجر اختباري');
      expect(saved.categoryId, 'category-1');
      expect(saved.notes, 'Existing note\nمعلومة إضافية');
      final after = await editor.policy(saved);
      expect(
        after.amount ||
            after.type ||
            after.bank ||
            after.last4 ||
            after.merchant ||
            after.category,
        isFalse,
      );
      await expectLater(
        editor.save(draft(saved, amount: 999)),
        throwsA(isA<TransactionEditFailure>()),
      );
      await expectLater(
        editor.save(draft(saved, category: 'different')),
        throwsA(isA<TransactionEditFailure>()),
      );
      expect(
        (await deps.transactionRepository.bankNamesForTransactions(
          'u',
        ))[saved.id],
        'Commercial International Bank',
      );
    },
  );

  test(
    'optional completion preserves captured zero holds and original pending state',
    () async {
      final tx = await seed(zeroHold: true);
      expect((await editor.policy(tx)).amount, isFalse);
      await editor.save(draft(tx, note: 'Added note'));
      final saved = (await deps.transactionRepository.getTransactions(
        userId: 'u',
      )).single;
      expect(saved.amountMinor, 0);
      expect(saved.transactionDate, tx.transactionDate);
      expect(saved.status, tx.status);
      expect(saved.bankId, 'cib-id');
    },
  );

  test('a stale editor cannot overwrite details completed elsewhere', () async {
    final stale = await seed(incomplete: true);
    await deps.transactionRepository.updateTransaction(
      transaction: stale.copyWith(merchantName: 'Recorded elsewhere'),
    );
    await expectLater(
      editor.save(draft(stale, amount: 1000, merchant: 'Stale replacement')),
      throwsA(isA<TransactionEditFailure>()),
    );
    final current = (await deps.transactionRepository.getTransactions(
      userId: 'u',
    )).single;
    expect(current.merchantName, 'Recorded elsewhere');
    expect(current.amountMinor, 0);
  });

  test(
    'optional information retains an existing card assignment and its balance',
    () async {
      final card = await deps.detectedCardRepository.upsertCard(
        userId: 'u',
        last4: '1234',
        bankName: 'CIB',
      );
      final tx = (await seed()).copyWith(cardId: card.id);
      await deps.transactionRepository.updateTransaction(transaction: tx);
      final before = await deps.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      await editor.save(draft(tx, note: 'اختبار الملاحظة'));
      final saved = (await deps.transactionRepository.getTransactions(
        userId: 'u',
      )).single;
      expect(saved.cardId, card.id);
      expect(saved.cardLast4, '1234');
      expect(saved.notes, 'Existing note\nاختبار الملاحظة');
      final after = await deps.moneyRepository.getCardBalance(
        'u',
        '1234',
        bankName: 'CIB',
      );
      expect(after.myBalanceMinor, before.myBalanceMinor);
      expect(after.deductedMinor, before.deductedMinor);
      expect(after.pocketCashMinor, before.pocketCashMinor);
    },
  );
}
