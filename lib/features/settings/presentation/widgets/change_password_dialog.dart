import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../domain/entities/auth_session.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});
  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _form = GlobalKey<FormState>();
  final _old = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _hidden = [true, true, true];
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _old.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final l = AppLocalizations.s(context);
    try {
      await context.read<AuthCubit>().changePassword(
        currentPassword: _old.text,
        newPassword: _password.text,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      final code = error is AuthenticationFailure ? error.code : null;
      setState(() {
        _saving = false;
        _error = switch (code) {
          'invalid_credentials' ||
          'invalid_password' => l['oldPasswordIncorrect'],
          'weak_password' => l['passwordTooWeak'],
          'same_password' => l['passwordMustDiffer'],
          'over_request_rate_limit' ||
          'over_email_send_rate_limit' => l['passwordTryLater'],
          'reauthentication_needed' ||
          'reauthentication_not_valid' ||
          'session_not_found' => l['passwordSignInAgain'],
          'password_login_required' => l['passwordLoginRequired'],
          _ => l['passwordChangeFailed'],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text(l['changePassword']),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: TextFormField(
                        controller: [_old, _password, _confirm][i],
                        enabled: !_saving,
                        obscureText: _hidden[i],
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: [
                          i == 0
                              ? AutofillHints.password
                              : AutofillHints.newPassword,
                        ],
                        textInputAction: i == 2
                            ? TextInputAction.done
                            : TextInputAction.next,
                        onFieldSubmitted: i == 2 ? (_) => _save() : null,
                        decoration: InputDecoration(
                          labelText:
                              l[[
                                'currentPassword',
                                'newPassword',
                                'confirmNewPassword',
                              ][i]],
                          suffixIcon: IconButton(
                            tooltip:
                                l[_hidden[i] ? 'showPassword' : 'hidePassword'],
                            onPressed: _saving
                                ? null
                                : () =>
                                      setState(() => _hidden[i] = !_hidden[i]),
                            icon: Icon(
                              _hidden[i]
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l['fillAllFields'];
                          }
                          if (i == 1 && value.length < 6) {
                            return l['passwordMinLength'];
                          }
                          if (i == 1 && value == _old.text) {
                            return l['passwordMustDiffer'];
                          }
                          if (i == 2 && value != _password.text) {
                            return l['passwordsDoNotMatch'];
                          }
                          return null;
                        },
                      ),
                    ),
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: Text(l['cancel']),
          ),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l['saveChanges']),
          ),
        ],
      ),
    );
  }
}
