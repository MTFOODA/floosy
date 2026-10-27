import 'app_routes.dart';
export 'app_routes.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../core/services/app_lock_cubit.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/common/bottom_navigation.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/settings/presentation/screens/profile_screen.dart';
import '../features/settings/presentation/screens/detected_cards_screen.dart';
import '../features/transactions/presentation/screens/transactions_screen.dart';
import '../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../features/pocket_cash/presentation/screens/pocket_cash_screen.dart';
import '../features/items/presentation/screens/items_screen.dart';
import '../features/budgets/presentation/screens/budgets_screen.dart';
import '../features/analytics/presentation/screens/analytics_screen.dart';
import '../features/ai/presentation/screens/ai_chat_screen.dart';

const Set<String> _publicRoutes = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

String? redirectForAppSession({
  required bool hasSession,
  required bool locked,
  required String location,
}) {
  final isPublic = _publicRoutes.contains(location);
  if (!hasSession) {
    return isPublic || location == AppRoutes.splash ? null : AppRoutes.login;
  }
  if (locked) return isPublic ? null : AppRoutes.login;
  return isPublic || location == AppRoutes.splash ? AppRoutes.dashboard : null;
}

class AppRouterController {
  final AuthCubit auth;
  final AppLockCubit lock;
  final _refresh = ValueNotifier<int>(0);
  late final GoRouter router;
  late final StreamSubscription<AuthenticationState> _authSubscription;
  late final StreamSubscription<AppLockState> _lockSubscription;
  AppRouterController(this.auth, this.lock) {
    _authSubscription = auth.stream.listen((_) => _refresh.value++);
    _lockSubscription = lock.stream.listen((_) => _refresh.value++);
    router = _create();
  }
  void dispose() {
    _authSubscription.cancel();
    _lockSubscription.cancel();
    router.dispose();
    _refresh.dispose();
  }

  GoRouter _create() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _refresh,
      redirect: (context, state) {
        return redirectForAppSession(
          hasSession: auth.state.session != null,
          locked: lock.state.required,
          location: state.matchedLocation,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => FloosyBottomNav(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: AppRoutes.transactions,
              builder: (context, state) => const TransactionsScreen(),
            ),
            GoRoute(
              path: AppRoutes.analytics,
              builder: (context, state) => const AnalyticsScreen(),
            ),
            GoRoute(
              path: AppRoutes.aiChat,
              builder: (context, state) => const AIChatScreen(),
            ),
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.detectedCards,
          builder: (context, state) => const DetectedCardsScreen(),
        ),
        GoRoute(
          path: AppRoutes.pocketCash,
          builder: (context, state) => const PocketCashScreen(),
        ),
        GoRoute(
          path: AppRoutes.items,
          builder: (context, state) => const ItemsScreen(),
        ),
        GoRoute(
          path: AppRoutes.budgets,
          builder: (context, state) => const BudgetsScreen(),
        ),
        GoRoute(
          path: AppRoutes.addTransaction,
          builder: (context, state) => const AddTransactionScreen(),
        ),
      ],
    );
  }
}
