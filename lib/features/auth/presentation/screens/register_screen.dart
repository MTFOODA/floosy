import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/app_routes.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/auth/auth_brand_header.dart';
import '../../../../core/widgets/auth/auth_mode_switch.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  bool get _isLoading => context.read<AuthCubit>().state.working;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final l = AppLocalizations.s(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      setState(() => _errorMessage = l['fillAllFields']);
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = l['passwordMinLength']);
      return;
    }
    setState(() {
      _errorMessage = null;
    });
    try {
      await context
          .read<AuthCubit>()
          .signUp(email: email, password: password, fullName: name);
      // full_name is already sent in signup metadata. Without a confirmed
      // session, RLS cannot permit a profile update; the signup trigger owns
      // initial profile creation.
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
        await _showEmailConfirmationDialog(email);
      }
    } catch (e) {
      if (mounted) {
        setState(() =>
            _errorMessage = '${l['registrationFailed']}: ${e.toString()}');
      }
    }
  }

  Future<void> _showEmailConfirmationDialog(String email) async {
    final l = AppLocalizations.s(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.fc.primarySurface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium)),
        title: Text(l['emailConfirmationRequired'],
            style: TextStyle(color: context.fc.textPrimary)),
        content: Text(
            l['emailConfirmationMessage'].replaceAll('{email}', email),
            style: TextStyle(color: context.fc.textSecondary)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.go(AppRoutes.login);
              },
              child: Text(l['backToLogin'],
                  style: const TextStyle(color: FloosyDesign.brightPurple))),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(color: context.fc.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.fc.textMuted, fontSize: 15),
        prefixIcon: Icon(icon, color: context.fc.textMuted, size: 22),
        filled: true,
        fillColor: context.fc.inputBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
            borderSide: BorderSide(color: context.fc.inputBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
            borderSide: BorderSide(color: context.fc.inputBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
            borderSide: const BorderSide(
                color: FloosyDesign.primaryPurple, width: 1.5)),
      ),
    );
  }

  Widget _buildPasswordField() {
    final l = AppLocalizations.s(context);
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: context.fc.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: l['passwordHint'],
        hintStyle: TextStyle(color: context.fc.textMuted, fontSize: 15),
        prefixIcon: Icon(Icons.lock_outline_rounded,
            color: context.fc.textMuted, size: 22),
        suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: context.fc.textMuted,
                size: 22),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword)),
        filled: true,
        fillColor: context.fc.inputBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
            borderSide: BorderSide(color: context.fc.inputBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
            borderSide: BorderSide(color: context.fc.inputBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FloosyDesign.radiusInput),
            borderSide: const BorderSide(
                color: FloosyDesign.primaryPurple, width: 1.5)),
      ),
    );
  }

  Widget _buildButton(AppLocalizations l) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleRegister,
      child: AnimatedScale(
        scale: _isLoading ? 0.97 : 1.0,
        duration: FloosyDesign.fast,
        child: Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _isLoading
                ? LinearGradient(colors: [
                    context.fc.elevatedSurface,
                    context.fc.elevatedSurface
                  ])
                : FloosyDesign.purpleGradient,
            borderRadius: BorderRadius.circular(FloosyDesign.radiusButton),
          ),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation(context.fc.textPrimary)))
                : Text(l['signup'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: context.fc.textPrimary)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthCubit>();
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
              const SizedBox(height: 32),
              const AuthModeSwitch(register: true),
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
                  child: Text(_errorMessage!,
                      style: const TextStyle(
                          color: FloosyDesign.negative, fontSize: 13)),
                ),
              _buildField(
                  _nameController, l['fullName'], Icons.person_outline_rounded),
              const SizedBox(height: 16),
              _buildField(
                  _emailController, 'ahmed@example.com', Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 28),
              _buildButton(l),
              const SizedBox(height: 40),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Text(l['alreadyHaveAccount'], style: context.fc.bodyText),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.login),
                      child: Text(l['login'],
                          style: context.fc.bodyText.copyWith(
                              color: FloosyDesign.brightPurple,
                              fontWeight: FontWeight.bold)),
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
