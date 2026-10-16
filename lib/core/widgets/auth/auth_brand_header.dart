import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';
import '../../theme/app_design_system.dart';

/// Premium Floosy branding header used on Login and Register screens.
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Floosy', style: context.fc.logo),
        const SizedBox(height: 4),
        Text(
          'Floosy | فلوسي',
          style: TextStyle(
            fontSize: 14,
            color: context.fc.textMuted,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l['smartFinance'],
          style: const TextStyle(
            fontSize: 18,
            color: FloosyDesign.brightPurple,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
