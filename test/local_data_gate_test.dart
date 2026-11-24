import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/app/app_runtime.dart';
import 'package:floosy/app/data_preparation_cubit.dart';
import 'package:floosy/app/local_data_gate.dart';

class _Runtime extends Fake implements AppRuntime {
  int retries = 0;
  @override
  Future<void> retryPreparation() async {
    retries++;
  }
}

void main() {
  testWidgets(
    'Arabic preparation gate hides the ledger, fits large text and offers retry without deleting data',
    (tester) async {
      tester.view.reset();
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final state = DataPreparationCubit()..loading('u');
      addTearDown(state.close);
      final runtime = _Runtime();
      await tester.pumpWidget(
        RepositoryProvider<AppRuntime>.value(
          value: runtime,
          child: BlocProvider.value(
            value: state,
            child: const MaterialApp(
              locale: Locale('ar'),
              supportedLocales: [Locale('ar'), Locale('en')],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: MediaQuery(
                data: MediaQueryData(
                  size: Size(320, 480),
                  textScaler: TextScaler.linear(2),
                ),
                child: LocalDataGate(child: Text('الدفتر')),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('الدفتر'), findsNothing);
      expect(tester.takeException(), isNull);
      state.failed('u');
      await tester.pump();
      expect(find.text('الدفتر'), findsNothing);
      await tester.ensureVisible(find.text('إعادة المحاولة'));
      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pump();
      expect(runtime.retries, 1);
      expect(tester.takeException(), isNull);
      state.ready('u');
      await tester.pump();
      expect(find.text('الدفتر'), findsOneWidget);
    },
  );
}
