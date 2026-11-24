import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_runtime.dart';
import 'data_preparation_cubit.dart';

/// No ledger screens or imports are exposed while the initial snapshot is
/// incomplete. Failures offer retry without resetting or deleting any data.
class LocalDataGate extends StatelessWidget {
  final Widget child;
  const LocalDataGate({super.key, required this.child});
  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<DataPreparationCubit, DataPreparationState>(
    builder: (context, state) {
      if (!state.loading && !state.failed) return child;
      final ar = Localizations.localeOf(context).languageCode == 'ar';
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/logo/floosy_symbol.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.loading) const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      kIsWeb
                          ? (ar
                                ? 'استخدم تطبيق Floosy على جهازك'
                                : 'Use the Floosy app on your device')
                          : state.failed
                          ? (ar
                                ? 'تعذر تجهيز بياناتك بأمان'
                                : 'Could not prepare your data safely')
                          : (ar
                                ? 'جارٍ فتح بياناتك على هذا الجهاز'
                                : 'Opening your local data'),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      kIsWeb
                          ? (ar
                                ? 'التخزين المالي المشفر متاح حاليًا في التطبيق الأصلي. افتح Floosy على الموبايل أو الكمبيوتر للوصول إلى بيانات هذا الجهاز.'
                                : 'Encrypted financial storage currently requires the native app. Open Floosy on your phone or computer to access that device’s data.')
                          : state.failed
                          ? (ar
                                ? (state.timedOut
                                      ? 'فتح التخزين استغرق وقتًا أطول من المتوقع. أعد المحاولة أو أغلق التطبيق وافتحه من جديد.'
                                      : 'تعذر فتح التخزين الآمن على الجهاز. أعد المحاولة أو افتح التطبيق من جديد.')
                                : (state.timedOut
                                      ? 'Opening storage took too long. Try again or close and reopen Floosy.'
                                      : 'Could not open secure storage on this device. Try again or reopen Floosy.'))
                          : (ar
                                ? 'بياناتك الجديدة محفوظة بأمان على هذا الجهاز.'
                                : 'Your new data stays securely on this device.'),
                      textAlign: TextAlign.center,
                    ),
                    if (state.failed) ...[
                      const SizedBox(height: 20),
                      if (!kIsWeb)
                        FilledButton(
                          onPressed: context
                              .read<AppRuntime>()
                              .retryPreparation,
                          child: Text(ar ? 'إعادة المحاولة' : 'Try again'),
                        ),
                      TextButton(
                        onPressed: () =>
                            context.read<AppRuntime>().auth.signOut(),
                        child: Text(ar ? 'تسجيل الخروج' : 'Sign out'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
