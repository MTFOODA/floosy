import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/app_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/auth/auth_brand_header.dart';
import '../../../../core/widgets/auth/auth_text_field.dart';
import '../../../../core/widgets/auth/gradient_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  bool _isEmailNotConfirmed = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final l = AppLocalizations.s(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = l['fillAllFields']);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authRepositoryProvider).signIn(
            email: email,
            password: password,
          );
      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('email not confirmed') ||
            errorStr.contains('email_not_confirmed')) {
          setState(() {
            _errorMessage = l['emailNotConfirmed'];
            _isEmailNotConfirmed = true;
          });
        } else if (errorStr.contains('invalid credentials') ||
            errorStr.contains('invalid login')) {
          setState(() {
            _errorMessage = '${l['loginFailed']}: ${l['invalidCredentials']}';
            _isEmailNotConfirmed = false;
          });
        } else {
          setState(() {
            _errorMessage = '${l['loginFailed']}: ${e.toString()}';
            _isEmailNotConfirmed = false;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendConfirmation() async {
    final l = AppLocalizations.s(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = l['pleaseEnterEmail']);
      return;
    }
    setState(() => _isResending = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .resendConfirmationEmail(email: email);
      if (mounted) {
        setState(() {
          _errorMessage = l['confirmationEmailSent'];
          _isEmailNotConfirmed = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage =
            '${l['resendConfirmationFailed']}: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Scaffold(
      backgroundColor: context.fc.authBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: FloosyDesign.horizontalPadding(context)
              .copyWith(top: 20, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const AuthBrandHeader(),
              const SizedBox(height: 60),
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: context.fc.logoutBg,
                    borderRadius:
                        BorderRadius.circular(FloosyDesign.radiusSmall),
                    border: Border.all(color: context.fc.logoutBorder),
                  ),
                  child: Column(
                    children: [
                      Text(_errorMessage!,
                          style: const TextStyle(
                              color: FloosyDesign.negative, fontSize: 13)),
                      if (_isEmailNotConfirmed)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextButton.icon(
                            onPressed:
                                _isResending ? null : _resendConfirmation,
                            icon: _isResending
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.email_outlined,
                                    size: 18, color: FloosyDesign.brightPurple),
                            label: Text(l['resendConfirmationEmail'],
                                style: const TextStyle(
                                    color: FloosyDesign.brightPurple)),
                          ),
                        ),
                    ],
                  ),
                ),
              AuthTextField(
                controller: _emailController,
                hintText: 'ahmed@example.com',
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _passwordController,
                hintText: l['enterPassword'],
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: context.fc.textMuted,
                    size: 22,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 28),
              GradientButton(
                text: l['login'],
                onPressed: _isLoading ? null : _handleLogin,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.forgotPassword),
                  child: Text(
                    l['forgotPassword'],
                    style: context.fc.bodyText
                        .copyWith(color: FloosyDesign.brightPurple),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l['dontHaveAccount'], style: context.fc.bodyText),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.register),
                      child: Text(
                        l['signup'],
                        style: context.fc.bodyText.copyWith(
                          color: FloosyDesign.brightPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
