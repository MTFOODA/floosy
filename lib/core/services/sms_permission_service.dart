import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/app_logger.dart';

/// Runtime SMS permissions (Android).
///
/// The manifest declares RECEIVE_SMS / READ_SMS, but on Android 6+ they are
/// dangerous permissions and MUST be requested at runtime. Without this the
/// OS never shows the dialog and SMS transaction tracking silently fails.
class SmsPermissionService {
  SmsPermissionService._();

  /// Requests the SMS permission if not already granted.
  ///
  /// Returns true when the permission is granted. Shows a rationale dialog
  /// and offers to open app settings when permanently denied.
  static Future<bool> ensureSmsPermission(BuildContext context) async {
    try {
      var status = await Permission.sms.status;

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        if (!context.mounted) return false;
        final openSettings = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('إذن الرسائل مطلوب'),
            content: const Text(
              'يحتاج فلوسي إلى إذن قراءة الرسائل لتتبع مشترياتك وسحوبات '
              'المصرفية تلقائيًا. يمكنك تمكين الإذن من إعدادات التطبيق.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('لاحقًا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('فتح الإعدادات'),
              ),
            ],
          ),
        );
        if (openSettings == true) {
          await openAppSettings();
        }
        return false;
      }

      status = await Permission.sms.request();
      logInfo('SMS permission request result: $status');
      return status.isGranted;
    } catch (e) {
      logError('Failed to request SMS permission', e);
      return false;
    }
  }

  /// One-time silent startup request (requirement #17).
  ///
  /// The Settings "فحص رسائل البنك" manual-scan button was removed, so the
  /// automatic 5-second polling pipeline is the ONLY scan path. READ_SMS
  /// must therefore be requested once when the app starts — otherwise the
  /// pipeline runs with no permission and silently reads an empty inbox.
  ///
  /// Shows only the standard OS permission dialog; no in-app dialogs (the
  /// root widget context has no Navigator). Never throws.
  static Future<bool> requestAtStartup() async {
    try {
      final status = await Permission.sms.request();
      logInfo('SMS_PERMISSION startup request result: $status');
      return status.isGranted;
    } catch (e) {
      logError('SMS_PERMISSION startup request failed', e);
      return false;
    }
  }
}
