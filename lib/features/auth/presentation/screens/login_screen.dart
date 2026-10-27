import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/core/services/app_lock_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/auth_session.dart';
import '../../../../routing/app_routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/preferences_cubit.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/auth/auth_brand_header.dart';
import '../../../../core/widgets/auth/auth_mode_switch.dart';
import '../../../../core/widgets/auth/auth_text_field.dart';
import '../../../../core/widgets/auth/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool get _isLoading => context.read<AuthCubit>().state.working;
  bool get _isGooglePending => context.read<AuthCubit>().state.googlePending;
  bool get _isResending => context.read<AuthCubit>().state.resending;
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
      _errorMessage = null;
    });

    try {
      await context.read<AuthCubit>().signIn(
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
    }
  }

  Future<void> _resendConfirmation() async {
    final l = AppLocalizations.s(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = l['pleaseEnterEmail']);
      return;
    }
    try {
      await context.read<AuthCubit>().resendConfirmationEmail(email: email);
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
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (_isGooglePending || _isLoading) return;
    setState(() {
      _errorMessage = null;
      _isEmailNotConfirmed = false;
    });
    try {
      final launched = await context.read<AuthCubit>().signInWithGoogle();
      if (!launched) throw StateError('Could not open Google sign-in');
      // Supabase's auth event refreshes the router after the callback.
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.s(context)['googleSignInFailed'];
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() => _errorMessage = null);
    final ok = await context
        .read<AppLockCubit>()
        .unlockWithBiometrics(AppLocalizations.s(context)['biometricReason']);
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.dashboard);
    } else {
      setState(() =>
          _errorMessage = AppLocalizations.s(context)['biometricLoginFailed']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    context.watch<AuthCubit>();

    final biometricAvailable =
        context.watch<AppLockCubit>().state.biometricAvailable;
    final biometricBusy = context.watch<AppLockCubit>().state.authenticating;
    final busy = _isLoading || _isGooglePending || biometricBusy;
    return BlocListener<AuthCubit, AuthenticationState>(
        listenWhen: (previous, next) =>
            previous.googlePending &&
            (next.error != null || next.event == AccountEvent.signedIn),
        listener: (context, next) {
          if (next.error != null) {
            final error = next.error;
            final profileFailure = error is AuthenticationFailure &&
                error.message
                    .toLowerCase()
                    .contains('database error saving new user');
            setState(() {
              _errorMessage = l[profileFailure
                  ? 'googleAccountSetupFailed'
                  : 'googleSignInFailed'];
            });
          }
        },
        child: Scaffold(
          backgroundColor: context.fc.authBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: FloosyDesign.horizontalPadding(context)
                  .copyWith(top: 20, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Tooltip(
                      message: l['selectLanguage'],
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'ar', label: Text('العربية')),
                          ButtonSegment(value: 'en', label: Text('English')),
                        ],
                        selected: {l.locale.languageCode},
                        style: SegmentedButton.styleFrom(
                          backgroundColor: context.fc.toggleBackground,
                          foregroundColor: context.fc.textSecondary,
                          selectedBackgroundColor: FloosyDesign.primaryPurple,
                          selectedForegroundColor: Colors.white,
                          side: BorderSide(color: context.fc.borderSubtle),
                        ),
                        onSelectionChanged: (selection) {
                          setState(() {
                            _errorMessage = null;
                            _isEmailNotConfirmed = false;
                          });
                          context
                              .read<LocaleCubit>()
                              .setLocale(Locale(selection.single));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AuthBrandHeader(),
                  const SizedBox(height: 32),
                  const AuthModeSwitch(),
                  const SizedBox(height: 28),
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
                                        size: 18,
                                        color: FloosyDesign.brightPurple),
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
                    onPressed: busy ? null : _handleLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                  if (biometricAvailable) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: busy ? null : _handleBiometricLogin,
                        icon: biometricBusy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.fingerprint_rounded),
                        label: Text(l['loginWithBiometrics']),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  OutlinedButton.icon(
                    onPressed: busy ? null : _handleGoogleLogin,
                    icon: _isGooglePending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.account_circle_outlined),
                    label: Text(l[_isGooglePending
                        ? 'googleSignInPending'
                        : 'continueWithGoogle']),
                  ),
                  if (_isGooglePending)
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.read<AuthCubit>().cancelGoogle(),
                      child: Text(l['cancel']),
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
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
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
        ));
  }
}
