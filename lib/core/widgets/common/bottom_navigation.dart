import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_design_system.dart';
import '../../localization/app_localizations.dart';
import '../../utils/app_logger.dart';
import '../../../routing/app_routes.dart';

/// Premium bottom navigation shared across all main screens.
/// 5 items: Home, Transactions, AI Agent, Analysis, Settings.
class FloosyBottomNav extends StatefulWidget {
  final Widget child;
  const FloosyBottomNav({super.key, required this.child});

  @override
  State<FloosyBottomNav> createState() => _FloosyBottomNavState();
}

class _FloosyBottomNavState extends State<FloosyBottomNav> {
  int _currentIndex = 0;

  static const _routes = [
    AppRoutes.dashboard,
    AppRoutes.transactions,
    '',
    AppRoutes.analytics,
    AppRoutes.settings,
  ];

  static const _aiRoute = AppRoutes.aiChat;

  void _onTap(int index) {
    if (index == 2) {
      context.go(_aiRoute);
      return;
    }
    final route = _routes[index];
    if (route.isNotEmpty && index != _currentIndex) {
      setState(() => _currentIndex = index);
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == AppRoutes.dashboard) {
      _currentIndex = 0;
    } else if (location == AppRoutes.transactions) {
      _currentIndex = 1;
    } else if (location == AppRoutes.aiChat) {
      _currentIndex = 2;
    } else if (location == AppRoutes.analytics) {
      _currentIndex = 3;
    } else if (location == AppRoutes.settings) {
      _currentIndex = 4;
    }

    // GLOBAL BACK NAVIGATION GUARD (requirement #1).
    //
    // All five bottom-tab screens are siblings on the ROOT navigator inside
    // the ShellRoute, so a system back press on any tab has no route below
    // it — GoRouter's default would terminate the whole app. This guard is
    // the single architectural fix for every tab screen:
    //   * When a child/detail screen is pushed ABOVE the shell (Add
    //     Transaction, Profile, Items, Pocket Cash, ...), GoRouter CAN pop —
    //     this PopScope allows the normal pop and the Android back
    //     button/gesture/system-back return exactly ONE navigation step.
    //   * When a bottom-tab screen is on top, nothing can pop — the back
    //     press is swallowed instead of exiting the app. Tab switches are
    //     done with the bottom navigation, never with back.
    // Pushed screens keep their own default back behavior (they are NOT
    // inside this guard), and dialogs/sheets are popped by the navigator
    // before this route is ever consulted.
    final canPop = GoRouter.of(context).canPop();

    final l = AppLocalizations.s(context);
    final labels = [
      l['navHome'],
      l['navTransactions'],
      l['navAI'],
      l['navAnalysis'],
      l['navSettings'],
    ];
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !canPop) {
          // Bottom-tab screen on top — never exit the app on back.
          logInfo('BACK_SWALLOWED root tab (location=$location)');
        }
      },
      child: Scaffold(
        body: widget.child,
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: context.fc.navBackground.withValues(alpha: 0.94),
            border: Border(
              top: BorderSide(color: context.fc.borderLight, width: 1),
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPad),
                child: SizedBox(
                  height: 72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(
                        icon: Icons.home_rounded,
                        label: labels[0],
                        isActive: _currentIndex == 0,
                        onTap: () => _onTap(0),
                      ),
                      _NavItem(
                        icon: Icons.receipt_long_rounded,
                        label: labels[1],
                        isActive: _currentIndex == 1,
                        onTap: () => _onTap(1),
                      ),
                      _AIAgentButton(
                        label: labels[2],
                        isActive: _currentIndex == 2,
                        onTap: () => _onTap(2),
                      ),
                      _NavItem(
                        icon: Icons.analytics_rounded,
                        label: labels[3],
                        isActive: _currentIndex == 3,
                        onTap: () => _onTap(3),
                      ),
                      _NavItem(
                        icon: Icons.settings_rounded,
                        label: labels[4],
                        isActive: _currentIndex == 4,
                        onTap: () => _onTap(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
                duration: FloosyDesign.normal,
                width: 40,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isActive
                        ? FloosyDesign.primaryPurple.withValues(alpha: .15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon,
                    size: 22,
                    color: isActive
                        ? FloosyDesign.primaryPurple
                        : context.fc.textMuted)),
            const SizedBox(height: 4),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    isActive ? context.fc.navLabelActive : context.fc.navLabel),
          ],
        ),
      ),
    );
  }
}

class _AIAgentButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _AIAgentButton(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 50px button + 3px gap + 11px label fits comfortably inside the
            // 72px bar — fixes the "Bottom overflowed by 6px" on all devices.
            AnimatedContainer(
              duration: FloosyDesign.normal,
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: FloosyDesign.purpleGradient,
                borderRadius: BorderRadius.circular(15),
                border: isActive
                    ? null
                    : Border.all(color: context.fc.borderSubtle),
                boxShadow: isActive
                    ? glowShadow(FloosyDesign.primaryPurple,
                        radius: 14, opacity: 0.3)
                    : null,
              ),
              child: const Icon(Icons.desktop_windows_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(height: 3),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    isActive ? context.fc.navLabelActive : context.fc.navLabel),
          ],
        ),
      ),
    );
  }
}
