import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../localization/app_localizations.dart';
import '../../theme/app_design_system.dart';
import '../../../routing/app_routes.dart';

class AuthModeSwitch extends StatelessWidget {
  const AuthModeSwitch({super.key, this.register = false});
  final bool register;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: context.fc.toggleBackground,
          borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        for (final mode in [false, true])
          Expanded(
            child: Semantics(
              selected: register == mode,
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: register == mode
                    ? null
                    : () =>
                        context.go(mode ? AppRoutes.register : AppRoutes.login),
                child: AnimatedContainer(
                  duration: FloosyDesign.normal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: register == mode
                          ? FloosyDesign.primaryPurple
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: register == mode
                          ? glowShadow(FloosyDesign.primaryPurple)
                          : []),
                  child: Text(l[mode ? 'register' : 'login'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: register == mode
                              ? Colors.white
                              : context.fc.textSecondary)),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
