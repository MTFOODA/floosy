import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/core/localization/app_localizations.dart';
import 'package:floosy/domain/entities/transaction_model.dart';
import 'package:floosy/domain/entities/transaction_edit_policy.dart';
import 'package:floosy/domain/entities/item_model.dart' as items;
import 'package:floosy/domain/usecases/save_transaction_edit.dart';
import 'package:floosy/features/transactions/presentation/widgets/transaction_edit_dialog.dart';
import 'package:floosy/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:floosy/features/dashboard/presentation/widgets/salary_setup_dialog.dart';
import 'package:floosy/features/dashboard/presentation/widgets/small_detected_card.dart';
import 'package:floosy/domain/entities/detected_card_model.dart';

final _locales = <String, AppLocalizations>{};

class _Delegate extends LocalizationsDelegate<AppLocalizations> {
  const _Delegate();
  @override
  bool isSupported(Locale locale) => _locales.containsKey(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(_locales[locale.languageCode]!);
  @override
  bool shouldReload(_Delegate old) => false;
}

Widget _app(Widget child, {String language = 'ar'}) => MaterialApp(
  locale: Locale(language),
  supportedLocales: supportedLocales,
  localizationsDelegates: const [
    _Delegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: const TextScaler.linear(1.4)),
    child: child!,
  ),
  home: Scaffold(body: child),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final language in ['ar', 'en']) {
      final l = AppLocalizations(Locale(language));
      await l.load();
      _locales[language] = l;
    }
  });
  testWidgets('balance-only save closes a focused salary form cleanly', (
    tester,
  ) async {
    int? savedBalance;
    int? savedSalary;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showSalarySetupDialog(
              context,
              currentBalanceMinor: 0,
              onSave: (balance, salary, day, detect) async {
                savedBalance = balance;
                savedSalary = salary;
              },
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(DropdownButtonFormField<int>), findsNothing);
    await tester.enterText(find.byType(TextFormField).first, '69.287.04');
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();
    expect(savedBalance, 6928704);
    expect(savedSalary, isNull);
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('minimum-width card fits at large Arabic text size', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: SizedBox(
            width: 156,
            child: SmallDetectedCard(
              card: DetectedCard(
                id: 'c',
                userId: 'u',
                last4: '2307',
                bankName: 'Faisal Bank',
              ),
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('•••• 2307'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'completed fields stay disabled and shaded; missing merchant/category/card and an added note save without touching facts',
    (tester) async {
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final tx = Transaction(
        id: 't',
        userId: 'u',
        type: TransactionType.purchase,
        source: TransactionSource.sms,
        amountMinor: 12550,
        currency: 'EGP',
        transactionDate: DateTime(2026, 11, 21, 10, 30),
        fingerprint: 'f',
        merchantName: 'CIB',
      );
      TransactionEditDraft? saved;
      final policy = TransactionEditPolicy(
        tx,
        const TransactionEditEvidence(
          bankName: 'CIB',
          typeIdentified: true,
          amountIdentified: true,
          currencyIdentified: true,
        ),
      );
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              child: const Text('open'),
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (_) => TransactionEditDialog(
                  policy: policy,
                  categories: const [
                    items.Category(id: 'food', name: 'Food', nameAr: 'الطعام'),
                  ],
                  onSave: (draft) async {
                    saved = draft;
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('tx_amount')))
            .enabled,
        isFalse,
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('tx_amount')))
            .readOnly,
        isTrue,
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('tx_date')))
            .enabled,
        isFalse,
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('tx_bank')))
            .enabled,
        isFalse,
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('tx_last4')))
            .enabled,
        isTrue,
      );
      expect(find.text('Amount'), findsNothing);
      expect(find.text('Transaction date'), findsNothing);
      await tester.ensureVisible(find.byKey(const ValueKey('tx_last4')));
      await tester.enterText(find.byKey(const ValueKey('tx_last4')), '١٢٣٤');
      await tester.ensureVisible(find.byKey(const ValueKey('tx_merchant')));
      await tester.enterText(
        find.byKey(const ValueKey('tx_merchant')),
        'متجر الاختبار',
      );
      await tester.ensureVisible(find.byKey(const ValueKey('tx_note')));
      await tester.enterText(
        find.byKey(const ValueKey('tx_note')),
        'معلومة إضافية',
      );
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();
      expect(saved, isNotNull);
      expect(saved!.amountMinor, 12550);
      expect(saved!.type, tx.type);
      expect(saved!.currency, tx.currency);
      expect(saved!.transactionDate, tx.transactionDate);
      expect(saved!.last4Text, '1234');
      expect(saved!.merchantName, 'متجر الاختبار');
      expect(saved!.additionalNote, 'معلومة إضافية');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'onboarding headings and currency choices follow Arabic then English at narrow width',
    (tester) async {
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(_app(const OnboardingScreen()));
      await tester.pumpAndSettle();
      expect(find.text('أهلًا بيك في فلوسي'), findsOneWidget);
      expect(find.text('Welcome to Floosy'), findsNothing);
      await tester.tap(find.text('التالي'));
      await tester.pumpAndSettle();
      expect(find.text('اختر العملة الأساسية'), findsOneWidget);
      expect(find.text('الجنيه المصري'), findsOneWidget);
      expect(find.text('Egyptian Pound'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_app(const OnboardingScreen(), language: 'en'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Floosy'), findsOneWidget);
      expect(find.text('أهلًا بيك في فلوسي'), findsNothing);
    },
  );

  test(
    'translation keys and placeholders stay aligned; Arabic interface values contain no English labels',
    () {
      final ar =
          jsonDecode(File('assets/translations/app_ar.arb').readAsStringSync())
              as Map;
      final en =
          jsonDecode(File('assets/translations/app_en.arb').readAsStringSync())
              as Map;
      expect(ar.keys.toSet(), en.keys.toSet());
      for (final key in ar.keys.where((k) => !k.toString().startsWith('@'))) {
        final arabic = ar[key].toString(), english = en[key].toString();
        final variables = RegExp(r'\{[^}]+\}');
        expect(
          variables.allMatches(arabic).map((m) => m[0]).toSet(),
          variables.allMatches(english).map((m) => m[0]).toSet(),
          reason: '$key placeholders',
        );
        expect(
          RegExp('[A-Za-z]{2,}').hasMatch(arabic.replaceAll(variables, '')),
          isFalse,
          reason: '$key: $arabic',
        );
      }
    },
  );
}
