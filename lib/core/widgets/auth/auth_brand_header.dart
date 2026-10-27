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
        Container(
          width: 68,
          height: 68,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset('assets/logo/floosy_symbol.png',
              fit: BoxFit.contain, excludeFromSemantics: true),
        ),
        const SizedBox(height: 8),
        Text(l['appTitle'],
            style: context.fc.logo.copyWith(fontSize: 40, height: 1.15)),
        const SizedBox(height: 4),
        Text(
          l['smartFinance'],
          style: const TextStyle(
            fontSize: 14,
            color: FloosyDesign.brightPurple,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
