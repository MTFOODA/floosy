import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../routing/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final session = context.read<AuthCubit>().state.session;
      if (session != null) {
        context.go(AppRoutes.dashboard);
      } else {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floosy logo — same image used as the official app icon.
            // Centered, original aspect ratio preserved, never stretched.
            SizedBox(
              width: 160,
              height: 160,
              child: Image.asset(
                'assets/logo/floosy.png',
                fit: BoxFit.contain,
                width: 160,
                height: 160,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Floosy',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.s(context)['smartFinance'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
