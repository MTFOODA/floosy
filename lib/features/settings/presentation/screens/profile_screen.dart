import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../data/models/user_model.dart';
import '../../../../routing/app_router.dart';

/// Profile screen — the user can edit name/phone; the email is ALWAYS
/// read-only because it is owned by Supabase Auth (auth.users).
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _initialized = false;

  @override
  void dispose() {
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
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final l = AppLocalizations.s(context);

    setState(() => _isLoading = true);
    try {
      final current =
          await ref.read(profileRepositoryProvider).getProfile(userId);
      final updated = (current ?? UserProfile(id: userId)).copyWith(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      await ref.read(profileRepositoryProvider).updateProfile(updated);
      ref.invalidate(userProfileProvider);
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
            content: Text(l['error']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final profileAsync = ref.watch(userProfileProvider);
    final authEmail = ref.watch(currentUserProvider)?.email ?? '';

    _initFromProfile(profileAsync.value);

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
              controller: TextEditingController(text: authEmail),
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
