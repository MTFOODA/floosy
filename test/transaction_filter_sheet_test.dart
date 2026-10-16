import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floosy/core/localization/app_localizations.dart';
import 'package:floosy/features/transactions/presentation/state/transaction_display_filter.dart';
import 'package:floosy/features/transactions/presentation/widgets/transaction_filter_sheet.dart';

Widget _app({
  required Widget home,
  ProviderContainer? container,
}) {
  final app = MaterialApp(
    locale: const Locale('en'),
    supportedLocales: supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: home,
  );
  return container == null
      ? app
      : UncontrolledProviderScope(container: container, child: app);
}

class _FilterLauncher extends StatelessWidget {
  const _FilterLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          key: const Key('open_filter'),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const TransactionFilterSheet(),
          ),
          child: const Text('Open filter'),
        ),
      ),
    );
  }
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  testWidgets(
      'filter sheet applies, cancels, clears, and keeps actions accessible',
      (tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(_app(
      container: container,
      home: const _FilterLauncher(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open_filter')));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const Key('transaction_filter_start_date')), findsOneWidget);
    expect(
        find.byKey(const Key('transaction_filter_start_time')), findsOneWidget);
    expect(
        find.byKey(const Key('transaction_filter_end_date')), findsOneWidget);
    expect(
        find.byKey(const Key('transaction_filter_end_time')), findsOneWidget);
    expect(find.byKey(const Key('transaction_filter_apply')), findsOneWidget);
    final applyBottom = tester
        .getBottomLeft(find.byKey(const Key('transaction_filter_apply')))
        .dy;
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(applyBottom, lessThanOrEqualTo(screenHeight));

    await tester.tap(find.byKey(const Key('transaction_filter_start_date')));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction_filter_start_time')));
    await tester.pumpAndSettle();
    expect(find.text('Select time'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('transaction_filter_end_date')));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction_filter_end_time')));
    await tester.pumpAndSettle();
    expect(find.text('Select time'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('transaction_filter_apply')));
    await tester.pumpAndSettle();
    final applied = container.read(transactionDisplayFilterProvider);
    expect(applied.isActive, isTrue);

    await tester.tap(find.byKey(const Key('open_filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction_filter_cancel')));
    await tester.pumpAndSettle();
    expect(container.read(transactionDisplayFilterProvider), applied);

    await tester.tap(find.byKey(const Key('open_filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction_filter_clear')));
    await tester.pumpAndSettle();
    expect(container.read(transactionDisplayFilterProvider).isActive, isFalse);
  });
}
