import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/core/localization/app_localizations.dart';
import 'package:floosy/core/widgets/common/bank_logo.dart';
import 'package:floosy/domain/entities/transaction_model.dart';
import 'package:floosy/features/transactions/presentation/widgets/transaction_widgets.dart';
import 'package:floosy/features/settings/presentation/widgets/backup_actions.dart';

late AppLocalizations _loaded;

class _Translations extends LocalizationsDelegate<AppLocalizations> {
  const _Translations();
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';
  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(_loaded);
  @override
  bool shouldReload(_Translations old) => false;
}

Widget app(Widget child, {String language = 'ar'}) => MaterialApp(
  locale: Locale(language),
  supportedLocales: supportedLocales,
  localizationsDelegates: const [
    _Translations(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(
    body: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.4)),
        child: child,
      ),
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    _loaded = AppLocalizations(const Locale('ar'));
    await _loaded.load();
  });
  testWidgets(
    'Arabic transaction uses large bank logo on right, type below bank, one currency and no daily net',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final transaction = Transaction(
        id: 'tx',
        userId: 'u',
        type: TransactionType.purchase,
        source: TransactionSource.sms,
        amountMinor: 1000,
        transactionDate: DateTime(2026, 11, 13),
        fingerprint: 'f',
        merchantName: 'Vodafone Top Up APP',
      );
      await tester.pumpWidget(
        app(
          SingleChildScrollView(
            child: TransactionGroup(
              dateStr: '13/11/2026',
              transactions: [transaction],
              isCredit: (_) => false,
              typeIcon: (_) => Icons.shopping_bag,
              bankNameOf: (_) => 'FAISAL BANK',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final bank = find.text('بنك فيصل الإسلامي المصري');
      final type = find.text('شراء');
      expect(bank, findsOneWidget);
      expect(type, findsOneWidget);
      expect(find.text('التاجر: Vodafone Top Up APP'), findsOneWidget);
      expect(
        find.text('-10 ج.م.'),
        findsOneWidget,
      ); // No second amount in the date header.
      expect(
        tester.getCenter(find.byType(BankLogo)).dx,
        greaterThan(tester.getCenter(bank).dx),
      );
      expect(tester.getCenter(type).dy, greaterThan(tester.getCenter(bank).dy));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'backup password requires confirmation and does not accept a short passphrase',
    (tester) async {
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (_) => const BackupPasswordDialog(creating: true),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'short');
      await tester.tap(find.text('متابعة'));
      await tester.pump();
      expect(find.text('استخدم ١٠ أحرف على الأقل.'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField).first,
        'a-long-test-password',
      );
      await tester.enterText(find.byType(TextField).last, 'different-password');
      await tester.tap(find.text('متابعة'));
      await tester.pump();
      expect(find.text('كلمتا المرور غير متطابقتين.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
