import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../routing/app_router.dart';

/// Language picker — strictly one language (Arabic or English), persisted.
void showLanguageDialog(
    BuildContext context, WidgetRef ref, AppLocalizations l) {
  final current = ref.read(localeNotifierProvider);
  showDialog(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(l['selectLanguage']),
      children: [
        RadioGroup<String>(
          groupValue: current.languageCode,
          onChanged: (code) {
            ref
                .read(localeNotifierProvider.notifier)
                .setLocale(Locale(code ?? 'en'));
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
Future<void> confirmLogout(
    BuildContext context, WidgetRef ref, AppLocalizations l) async {
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

  await ref.read(authRepositoryProvider).signOut();
  if (context.mounted) {
    context.go(AppRoutes.login);
  }
}
