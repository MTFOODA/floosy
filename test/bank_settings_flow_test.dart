import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floosy/core/localization/app_localizations.dart';
import 'package:floosy/core/theme/card_appearance_view.dart';
import 'package:floosy/core/widgets/common/bank_logo.dart';
import 'package:floosy/data/services/bank_sender_mapping_store.dart';
import 'package:floosy/domain/entities/auth_session.dart';
import 'package:floosy/domain/entities/detected_card_model.dart';
import 'package:floosy/domain/repositories/auth_repository.dart';
import 'package:floosy/domain/repositories/detected_card_repository.dart';
import 'package:floosy/domain/repositories/money_repository.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/bank_mappings_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/cards_cubit.dart';
import 'package:floosy/features/settings/presentation/widgets/bank_mappings_sheet.dart';
import 'package:floosy/features/settings/presentation/widgets/card_customization_sheet.dart';
import 'package:floosy/features/settings/presentation/widgets/change_password_dialog.dart';
import 'package:floosy/features/settings/presentation/widgets/detected_bank_card.dart';
import 'package:floosy/features/dashboard/presentation/widgets/small_detected_card.dart';
import 'package:floosy/features/transactions/presentation/widgets/transaction_widgets.dart';
import 'package:floosy/domain/entities/transaction_model.dart';

class _Account implements AccountRepository {
  int updates = 0;
  bool fail = false;
  @override
  AccountSession? get session => null;
  @override
  Stream<AccountUpdate> get changes => const Stream.empty();
  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    updates++;
    if (fail) {
      throw const AuthenticationFailure(
        'Incorrect',
        code: 'invalid_credentials',
      );
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Cards implements DetectedCardRepository {
  CardAppearance? saved;
  @override
  Future<void> updateAppearance(
    String userId,
    String cardId,
    CardAppearance appearance,
  ) async {
    saved = appearance;
  }

  @override
  Future<List<DetectedCard>> getCards(String userId) async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Money implements MoneyRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Appearance must not change money');
}

final _loaded = <String, AppLocalizations>{};

class _Localizations extends LocalizationsDelegate<AppLocalizations> {
  const _Localizations();
  @override
  bool isSupported(Locale locale) => _loaded.containsKey(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(_loaded[locale.languageCode]!);
  @override
  bool shouldReload(_Localizations old) => false;
}

Widget _app(Widget child, {String language = 'en'}) => MaterialApp(
  locale: Locale(language),
  supportedLocales: supportedLocales,
  localizationsDelegates: const [
    _Localizations(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(body: child),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final language in ['en', 'ar']) {
      final localizations = AppLocalizations(Locale(language));
      await localizations.load();
      _loaded[language] = localizations;
    }
  });
  testWidgets(
    'bank logos fit narrow Arabic dashboard cards and transaction rows',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final auth = AuthCubit(_Account());
      addTearDown(auth.close);
      final cards = [
        DetectedCard(
          id: 'cib',
          userId: 'user',
          last4: '1234',
          bankName: 'Commercial International Bank',
        ),
        DetectedCard(
          id: 'nbe',
          userId: 'user',
          last4: '5678',
          bankName: 'National Bank of Egypt',
        ),
        DetectedCard(
          id: 'misr',
          userId: 'user',
          last4: '9012',
          bankName: 'Banque Misr',
        ),
      ];
      await tester.pumpWidget(
        BlocProvider.value(
          value: auth,
          child: _app(
            SingleChildScrollView(
              child: Column(
                children: [
                  DetectedBankCard(card: cards.first),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        for (final card in cards)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: SmallDetectedCard(
                                card: card,
                                isSelected: false,
                                onTap: () {},
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TransactionCard(
                    transaction: Transaction(
                      id: 'tx',
                      userId: 'user',
                      type: TransactionType.purchase,
                      source: TransactionSource.sms,
                      amountMinor: 12550,
                      transactionDate: DateTime(2026, 11, 20, 10, 30),
                      fingerprint: 'demo',
                      merchantName: 'TEST SHOP',
                      cardLast4: '1234',
                    ),
                    bankName: 'Commercial International Bank',
                    isCredit: false,
                    icon: Icons.shopping_bag,
                  ),
                ],
              ),
            ),
            language: 'ar',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BankLogo), findsNWidgets(5));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'mapping rejects immediately, stays hidden after reload and can be restored in Arabic',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = BankSenderMappingStore();
      await store.markUnknown('user', 'UNKNOWN-SENDER');
      final cubit = BankMappingsCubit(store);
      addTearDown(cubit.close);
      await tester.pumpWidget(
        _app(
          BankMappingsSheet(userId: 'user', store: cubit),
          language: 'ar',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('UNKNOWN-SENDER'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(await store.isRejected('user', 'UNKNOWN-SENDER'), isTrue);
      expect(find.text('UNKNOWN-SENDER'), findsNothing);
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('استرجاع'));
      await tester.pumpAndSettle();
      expect(await store.isRejected('user', 'UNKNOWN-SENDER'), isFalse);
      await tester.enterText(find.byType(TextField), 'CIB');
      await tester.pumpAndSettle();
      expect(find.byType(BankLogo), findsWidgets);
      await tester.tap(find.text('البنك التجاري الدولي'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();
      expect(
        await store.getBankForSender('user', 'UNKNOWN-SENDER'),
        'Commercial International Bank',
      );
      expect(await store.getUnknownSenders('user'), isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'password dialog validates, shows incorrect old password and closes only after success',
    (tester) async {
      final account = _Account();
      final cubit = AuthCubit(account);
      addTearDown(cubit.close);
      await tester.pumpWidget(
        BlocProvider.value(
          value: cubit,
          child: _app(
            Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<bool>(
                  context: context,
                  builder: (_) => const ChangePasswordDialog(),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'old-password');
      await tester.enterText(fields.at(1), 'new-password');
      await tester.enterText(fields.at(2), 'different');
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(account.updates, 0);
      expect(find.text('Passwords do not match.'), findsOneWidget);
      await tester.enterText(fields.at(2), 'new-password');
      account.fail = true;
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(find.text('The current password is incorrect.'), findsOneWidget);
      account.fail = false;
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(account.updates, 2);
      expect(find.byType(ChangePasswordDialog), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'choosing first color preserves second color and persists appearance without touching money',
    (tester) async {
      final account = AuthCubit(_Account());
      final repository = _Cards();
      final cards = CardsCubit(repository, _Money(), () => 'user', () {});
      addTearDown(account.close);
      addTearDown(cards.close);
      final card = DetectedCard(
        id: 'card',
        userId: 'user',
        last4: '1234',
        bankName: 'CIB',
      );
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: account),
            BlocProvider.value(value: cards),
          ],
          child: _app(CardCustomizationSheet(card: card, repository: cards)),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('First color'),
        findsOneWidget,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data)
            .join(' | '),
      );
      await tester.tap(find.text('First color'));
      await tester.pumpAndSettle();
      expect(CardPresets.palette.length, 48);
      final color = CardPresets.palette.first;
      await tester.tap(find.bySemanticsLabel('#005B36'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();
      expect(repository.saved?.colorA, color.toARGB32());
      expect(repository.saved?.colorB, card.appearance.colors.last.toARGB32());
      expect(tester.takeException(), isNull);
    },
  );
}
