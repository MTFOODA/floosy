import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/core/localization/preferences_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../routing/app_routes.dart';

/// Language picker — strictly one language (Arabic or English), persisted.
void showLanguageDialog(BuildContext context, AppLocalizations l) {
  final current = context.read<LocaleCubit>().state;
  showDialog(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(l['selectLanguage']),
      children: [
        RadioGroup<String>(
          groupValue: current.languageCode,
          onChanged: (code) {
            context.read<LocaleCubit>().setLocale(Locale(code ?? 'en'));
            Navigator.pop(dialogContext);
          },
          child: const Column(
            children: [
              RadioListTile<String>(
                value: 'ar',
                title: Text('العربية'),
              ),
              RadioListTile<String>(
                value: 'en',
                title: Text('English'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Logout confirmation that actually calls supabase.auth.signOut().
/// The router redirect returns the user to Login when the session clears.
Future<void> confirmLogout(BuildContext context, AppLocalizations l) async {
  final auth = context.read<AuthCubit>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l['logout']),
      content: Text(l['logoutConfirm']),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l['cancel']),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(l['yesLogout']),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  await auth.signOut();
  if (context.mounted) {
    context.go(AppRoutes.login);
  }
}
