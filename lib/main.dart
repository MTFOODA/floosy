import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';
import 'config/supabase_config.dart';
import 'core/providers.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/sms_permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with centralized configuration
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(
    const ProviderScope(
      child: FloosyApp(),
    ),
  );
}

class FloosyApp extends ConsumerStatefulWidget {
  const FloosyApp({super.key});

  @override
  ConsumerState<FloosyApp> createState() => _FloosyAppState();
}

class _FloosyAppState extends ConsumerState<FloosyApp> {
  /// ONE 5-second bank-SMS polling loop for the whole app (requirement #2).
  /// Started exactly once with the root widget — never per screen, never in
  /// build. The poller itself is lifecycle-safe (pauses in background) and
  /// no-ops when no user is signed in.
  bool _smsPermissionRequested = false;

  @override
  void initState() {
    super.initState();
    ref.read(smsPollingServiceProvider).start();
    // Requirement #17: the manual "فحص رسائل البنك" button was removed, so
    // READ_SMS must be requested automatically once per app session —
    // otherwise the polling pipeline runs with no permission and silently
    // reads an empty inbox (this was why SMS transactions stopped appearing).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestSmsPermissionOnce();
    });
  }

  Future<void> _requestSmsPermissionOnce() async {
    if (_smsPermissionRequested) return;
    _smsPermissionRequested = true;
    if (kIsWeb || !Platform.isAndroid) return;
    await SmsPermissionService.requestAtStartup();
  }

  @override
  void dispose() {
    ref.read(smsPollingServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp.router(
      title: 'Floosy',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
