import '../widgets/change_password_dialog.dart';
import '../widgets/local_privacy_dialog.dart';
import '../widgets/bank_mappings_sheet.dart';
import '../widgets/backup_actions.dart';
import '../../../dashboard/presentation/widgets/salary_setup_dialog.dart';
import '../../../dashboard/presentation/cubit/finance_cubit.dart';
import '../../../dashboard/presentation/cubit/salary_plan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'ios_bank_messages_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/bank_mappings_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/profile_cubit.dart';
import 'package:floosy/core/localization/preferences_cubit.dart';
import 'package:floosy/core/services/app_lock_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../routing/app_routes.dart';
import '../widgets/logout_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final themeMode = context.watch<ThemeModeCubit>().state;
    final profileAsync = context.watch<ProfileCubit>().state;
    final authUser = context.watch<AuthCubit>().state.user;
    final authEmail = authUser?.email ?? '';
    final userName = profileAsync.value?.fullName ?? '';
    final email = authEmail;
    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: FloosyDesign.horizontalPadding(
            context,
          ).copyWith(top: 16, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l['settings'], style: context.fc.pageTitle),
              const SizedBox(height: 20),
              _buildProfileCard(context, userName, email),
              const SizedBox(height: 28),
              _buildSectionLabel(context, l['sectionCustomize']),
              const SizedBox(height: 10),
              _buildCustomizeCard(context, themeMode, l),
              const SizedBox(height: 28),
              _buildSectionLabel(context, l['sectionAccount']),
              const SizedBox(height: 10),
              _buildAccountCard(context, l),
              if (!kIsWeb) ...[
                const SizedBox(height: 20),
                const BackupActions(),
              ],
              if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ...[
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.sms_outlined),
                  title: Text(l['iosSmsTitle']),
                  subtitle: Text(l['iosSmsSettingsHint']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const IosBankMessagesScreen(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              _buildLogoutButton(context, l),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '${l['appBrand']} | 1.0.5',
                  style: TextStyle(fontSize: 12, color: context.fc.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    String userName,
    String email,
  ) {
    return GestureDetector(
      onTap: () {
        logInfo('NAV_TARGET_ROUTE ${AppRoutes.profile}');
        GoRouter.of(context).push(AppRoutes.profile);
      },
      child: Container(
        height: 122,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: FloosyDesign.profileGradient,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: context.fc.textMuted,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildCustomizeCard(
    BuildContext context,
    ThemeMode themeMode,
    AppLocalizations l,
  ) {
    final isDark = themeMode == ThemeMode.dark;
    return Container(
      decoration: BoxDecoration(
        color: context.fc.primarySurface,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        border: Border.all(color: context.fc.borderSubtle),
      ),
      child: Column(
        children: [
          if (context.watch<AuthCubit>().state.userId case final String userId)
            SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: Text(l['biometricLock']),
              value: context.watch<AppLockCubit>().state.enabled.value ?? false,
              onChanged: (enabled) async {
                final ok = await context.read<AppLockCubit>().setEnabled(
                  userId,
                  enabled,
                  l['biometricReason'],
                );
                if (!context.mounted) return;
                if (ok) {
                  context.read<AppLockCubit>().markVerified(userId);
                }
                context.read<AppLockCubit>().reloadEnabled();
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l['biometricUnavailable'])),
                  );
                }
              },
            ),
          _SettingsRow(
            icon: Icons.receipt_long_outlined,
            label: l['manageItems'],
            onTap: () => GoRouter.of(context).push(AppRoutes.items),
          ),
          Divider(height: 1, color: context.fc.borderSubtle),
          _SettingsRow(
            icon: Icons.dark_mode_outlined,
            label: l['theme'],
            trailing: Switch(
              value: isDark,
              onChanged: (dark) => context.read<ThemeModeCubit>().setThemeMode(
                dark ? ThemeMode.dark : ThemeMode.light,
              ),
              activeThumbColor: FloosyDesign.primaryPurple,
            ),
          ),
          Divider(height: 1, color: context.fc.borderSubtle),
          _SettingsRow(
            icon: Icons.language_rounded,
            label: l['language'],
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: context.fc.elevatedSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.isArabic ? 'العربية' : 'English',
                style: TextStyle(fontSize: 13, color: context.fc.textSecondary),
              ),
            ),
            onTap: () => showLanguageDialog(context, l),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AppLocalizations l) {
    final finance = context.watch<FinanceCubit>().state.value;
    final canConfigureSalary = finance?.card?.isCreditCard != true;
    return Container(
      decoration: BoxDecoration(
        color: context.fc.primarySurface,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        border: Border.all(color: context.fc.borderSubtle),
      ),
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.account_balance_outlined,
            label: l['bankMappings'],
            onTap: () => _showBankMappingsSheet(context, l),
          ),
          Divider(height: 1, color: context.fc.borderSubtle),
          if (canConfigureSalary) ...[
            _SettingsRow(
              icon: Icons.payments_outlined,
              label: l['salaryCycle'],
              onTap: () => showSalarySetupDialog(
                context,
                currentBalanceMinor: finance?.summary.myBalanceMinor ?? 0,
                existing: context.read<SalaryPlanCubit>().state.value?.plan,
              ),
            ),
            Divider(height: 1, color: context.fc.borderSubtle),
          ],
          _SettingsRow(
            icon: Icons.lock_outline_rounded,
            label: l['changePassword'],
            onTap: () async {
              final changed = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const ChangePasswordDialog(),
              );
              if (changed == true && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l['passwordChanged'])));
              }
            },
          ),
          Divider(height: 1, color: context.fc.borderSubtle),
          _SettingsRow(
            icon: Icons.notifications_outlined,
            label: l['notifications'],
            onTap: () {},
          ),
          Divider(height: 1, color: context.fc.borderSubtle),
          _SettingsRow(
            icon: Icons.shield_outlined,
            label: l['privacySecurity'],
            onTap: () => showLocalPrivacyDialog(context),
          ),
          Divider(height: 1, color: context.fc.borderSubtle),
          _SettingsRow(
            icon: Icons.credit_card_rounded,
            label: l['detectedCards'],
            onTap: () {
              logInfo('NAV_TARGET_ROUTE ${AppRoutes.detectedCards}');
              GoRouter.of(context).push(AppRoutes.detectedCards);
            },
          ),
        ],
      ),
    );
  }

  /// Unknown-bank management (requirement 2A): lists senders whose bank
  /// could not be identified and lets the user assign a bank name. The
  /// mapping persists per-user and future SMS from that sender are
  /// attributed automatically — classification is never affected.
  Future<void> _showBankMappingsSheet(
    BuildContext context,
    AppLocalizations l,
  ) async {
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;
    final store = context.read<BankMappingsCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BankMappingsSheet(userId: userId, store: store),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l) {
    return GestureDetector(
      onTap: () => confirmLogout(context, l),
      child: Container(
        height: 66,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.fc.logoutBg,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          border: Border.all(color: context.fc.logoutBorder),
        ),
        child: Center(
          child: Text(
            l['logout'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: FloosyDesign.negative,
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.fc.elevatedSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 21, color: context.fc.textSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: context.fc.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: context.fc.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
