import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/profile_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../domain/entities/user_model.dart';
import '../../../../routing/app_routes.dart';

/// Profile screen — the user can edit name/phone; the email is ALWAYS
/// read-only because it is owned by Supabase Auth (auth.users).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool get _isLoading => context.read<ProfileCubit>().state.isLoading;
  bool _initialized = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initFromProfile(UserProfile? profile) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = profile?.fullName ?? '';
    _phoneController.text = profile?.phone ?? '';
  }

  Future<void> _save() async {
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;
    final l = AppLocalizations.s(context);

    final cubit = context.read<ProfileCubit>();
    try {
      await cubit.save(
          userId: userId,
          name: _nameController.text,
          phone: _phoneController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l['profileUpdated'])),
        );
        context.go(AppRoutes.settings);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l['profileSaveFailed']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final profileAsync = context.watch<ProfileCubit>().state;
    final authEmail = context.watch<AuthCubit>().state.user?.email ?? '';

    if (profileAsync.hasValue && !profileAsync.isLoading) {
      _initFromProfile(profileAsync.value);
    }
    if (_emailController.text != authEmail) {
      _emailController.text = authEmail;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l['editProfile']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            logInfo('NAV_BACK profile → previous route');
            context.canPop() ? context.pop() : context.go(AppRoutes.settings);
          },
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l['failedToLoad'])),
        data: (_) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Email — read-only, from the authenticated session.
            TextField(
              enabled: false,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l['emailReadOnly'],
                prefixIcon: const Icon(Icons.alternate_email),
                suffixIcon: const Icon(Icons.lock_outline, size: 18),
                helperText: l['emailReadOnly'],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l['name'],
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l['phone'],
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(l['saveProfile']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
