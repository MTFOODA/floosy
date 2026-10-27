import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/presentation_dependencies.dart';
import 'app/app_runtime.dart';
import 'app/composition_root.dart';
import 'app/app_scope.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';
import 'config/supabase_config.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/sms_permission_service.dart';
import 'core/widgets/auth/biometric_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with centralized configuration
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  final dependencies = AppDependencies();
  final runtime = AppRuntime(dependencies.repositories());
  dependencies.currentUserId = () => runtime.auth.state.userId;
  dependencies.onDataChanged = runtime.refresh.refresh;
  runApp(AppScope(
      runtime: runtime,
      ownsRuntime: true,
      disposeDependencies: dependencies.close,
      child: const FloosyApp()));
}

class FloosyApp extends StatefulWidget {
  const FloosyApp({super.key});

  @override
  State<FloosyApp> createState() => _FloosyAppState();
}

class _FloosyAppState extends State<FloosyApp> {
  /// ONE 5-second bank-SMS polling loop for the whole app (requirement #2).
  /// Started exactly once with the root widget — never per screen, never in
  /// build. The poller itself is lifecycle-safe (pauses in background) and
  /// no-ops when no user is signed in.
  bool _smsPermissionRequested = false;
  late final AppRouterController _router;
  late final SmsCubit _sms;

  @override
  void initState() {
    super.initState();
    _router = AppRouterController(
        context.read<AuthCubit>(), context.read<AppLockCubit>());
    _sms = context.read<SmsCubit>();
    _sms.start();
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
    _sms.stop();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = _router.router;
    final locale = context.watch<LocaleCubit>().state;
    final themeMode = context.watch<ThemeModeCubit>().state;

    return MaterialApp.router(
      title: 'Floosy',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: (context, child) =>
          BiometricGate(child: child ?? const SizedBox.shrink()),
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
