import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../../app/app_runtime.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../domain/repositories/backup_repository.dart';

class BackupActions extends StatefulWidget {
  const BackupActions({super.key});
  @override
  State<BackupActions> createState() => _BackupActionsState();
}

class _BackupActionsState extends State<BackupActions> {
  bool _busy = false;
  String _text(String ar, String en) =>
      AppLocalizations.s(context).isArabic ? ar : en;
  void _message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _run(bool restore) async {
    final runtime = context.read<AppRuntime>();
    final repository = runtime.repositories.backup;
    final user = runtime.auth.state.userId;
    if (_busy || repository == null || user == null) return;
    setState(() => _busy = true);
    try {
      if (restore) {
        // Only ciphertext is read/cached by the OS picker. No decrypted temp file.
        final file = await FilePicker.pickFile();
        if (file == null || !mounted) return;
        if ((file.lengthSync() ?? 0) > 64 * 1024 * 1024) {
          throw const BackupFailure('tooLarge');
        }
        final buffer = BytesBuilder(copy: false);
        await for (final chunk in file.readAsByteStream()) {
          if (buffer.length + chunk.length > 64 * 1024 * 1024) {
            throw const BackupFailure('tooLarge');
          }
          buffer.add(chunk);
        }
        final bytes = buffer.takeBytes();
        if (!mounted) return;
        final password = await showDialog<String>(
          context: context,
          builder: (_) => const BackupPasswordDialog(creating: false),
        );
        if (password == null || !mounted) return;
        final summary = await repository.inspect(user, bytes, password);
        if (!mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialog) => AlertDialog(
            title: Text(_text('استعادة النسخة الاحتياطية', 'Restore backup')),
            content: Text(
              _text(
                'نسخة بتاريخ ${DateFormat('yyyy/MM/dd HH:mm').format(summary.createdAt.toLocal())}، تحتوي على ${summary.transactions} معاملة.\nستستبدل البيانات المالية الحالية لهذا الحساب على الجهاز. الحسابات الأخرى وتسجيل الدخول لن يتغيروا.',
                'Backup from ${DateFormat('yyyy/MM/dd HH:mm').format(summary.createdAt.toLocal())}, with ${summary.transactions} transactions.\nThis replaces this account’s current financial data on this device. Other accounts and sign-in stay unchanged.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: Text(_text('إلغاء', 'Cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: Text(_text('استعادة واستبدال', 'Restore and replace')),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        await runtime.withSmsSuspended(
          () => repository.restore(user, bytes, password),
        );
        _message(
          _text(
            'تمت استعادة النسخة والتحقق من بياناتها.',
            'Backup restored and verified.',
          ),
        );
      } else {
        final password = await showDialog<String>(
          context: context,
          builder: (_) => const BackupPasswordDialog(creating: true),
        );
        if (password == null) return;
        final bytes = await repository.create(user, password);
        if (!mounted) return;
        final destination = await FilePicker.saveFile(
          fileName:
              'Floosy-${DateFormat('yyyy-MM-dd-HHmm').format(DateTime.now())}.floosybackup',
          bytes: bytes,
          mimeType: 'application/octet-stream',
        );
        if (destination != null) {
          _message(
            _text(
              'تم حفظ النسخة الاحتياطية المشفّرة.',
              'Encrypted backup saved.',
            ),
          );
        }
      }
    } catch (error) {
      final code = error is BackupFailure ? error.code : 'unavailable';
      _message(switch (code) {
        'passwordOrDamage' => _text(
          'كلمة المرور غير صحيحة أو الملف تالف. بياناتك لم تتغير.',
          'Incorrect password or damaged file. Your data is unchanged.',
        ),
        'account' => _text(
          'النسخة تخص حسابًا آخر. سجّل بنفس الحساب الذي أنشأها.',
          'This backup belongs to another account. Sign in with the account that created it.',
        ),
        'tooLarge' => _text(
          'حجم النسخة أكبر من الحد المدعوم.',
          'This backup exceeds the supported size.',
        ),
        'invalid' => _text(
          'هذا الملف ليس نسخة Floosy مدعومة أو أنه تالف.',
          'This is not a supported Floosy backup, or the file is damaged.',
        ),
        _ => _text(
          'تعذّر إتمام العملية. جرّب مرة أخرى.',
          'Could not complete this operation. Try again.',
        ),
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.backup_outlined),
        title: Text(_text('نسخ احتياطي', 'Create backup')),
        subtitle: Text(
          _text(
            'ملف مشفّر بكلمة مرور تختارها',
            'An encrypted file with your own password',
          ),
        ),
        onTap: _busy ? null : () => _run(false),
      ),
      ListTile(
        leading: const Icon(Icons.restore_outlined),
        title: Text(_text('استعادة نسخة احتياطية', 'Restore backup')),
        subtitle: Text(
          _text(
            'اختر الملف وأدخل كلمة مرور النسخة',
            'Choose a file and enter its backup password',
          ),
        ),
        onTap: _busy ? null : () => _run(true),
      ),
      if (_busy)
        const Padding(
          padding: EdgeInsets.all(12),
          child: LinearProgressIndicator(),
        ),
    ],
  );
}

class BackupPasswordDialog extends StatefulWidget {
  final bool creating;
  const BackupPasswordDialog({super.key, required this.creating});
  @override
  State<BackupPasswordDialog> createState() => _BackupPasswordDialogState();
}

class _BackupPasswordDialogState extends State<BackupPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _hidden = true;
  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = AppLocalizations.s(context).isArabic;
    return AlertDialog(
      title: Text(ar ? 'كلمة مرور النسخة' : 'Backup password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.creating)
              Text(
                ar
                    ? 'اختر كلمة مرور من ١٠ أحرف على الأقل واحفظها. لا نحتفظ بها، ولا يمكن استعادة النسخة بدونها.'
                    : 'Use at least 10 characters and keep this password safe. We do not store it; the backup cannot be recovered without it.',
              ),
            TextField(
              controller: _password,
              obscureText: _hidden,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: ar ? 'كلمة مرور النسخة' : 'Backup password',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _hidden = !_hidden),
                  icon: Icon(
                    _hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            if (widget.creating)
              TextField(
                controller: _confirm,
                obscureText: _hidden,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: ar ? 'تأكيد كلمة المرور' : 'Confirm password',
                ),
              ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(ar ? 'إلغاء' : 'Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (widget.creating && _password.text.runes.length < 10) {
              setState(
                () => _error = ar
                    ? 'استخدم ١٠ أحرف على الأقل.'
                    : 'Use at least 10 characters.',
              );
              return;
            }
            if (widget.creating && _password.text != _confirm.text) {
              setState(
                () => _error = ar
                    ? 'كلمتا المرور غير متطابقتين.'
                    : 'Passwords do not match.',
              );
              return;
            }
            if (_password.text.isEmpty) return;
            Navigator.pop(context, _password.text);
          },
          child: Text(ar ? 'متابعة' : 'Continue'),
        ),
      ],
    );
  }
}
