import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/app_routes.dart';
import '../../../../core/localization/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool get _isLoading => context.read<AuthCubit>().state.working;
  String? _errorMessage;
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    final l = AppLocalizations.s(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = l['pleaseEnterEmail']);
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      await context.read<AuthCubit>().resetPassword(email: email);
      if (mounted) {
        setState(() => _isEmailSent = true);
      }
    } catch (e) {
      if (mounted) {
        setState(
            () => _errorMessage = '${l['resetEmailFailed']}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthCubit>();
    final l = AppLocalizations.s(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                l['resetPassword'],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _isEmailSent ? l['checkEmail'] : l['resetInstructions'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 40),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_isEmailSent) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l['emailSent'],
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.t('resetLinkSent', {'email': _emailController.text}),
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: Text(l['backToLogin']),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l['email'],
                    hintText: 'your@email.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleForgotPassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(l['sendResetLink']),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
