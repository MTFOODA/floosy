import 'package:flutter/material.dart';

Future<void> showLocalPrivacyDialog(BuildContext context) {
  final ar = Localizations.localeOf(context).languageCode == 'ar';
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(ar ? 'بياناتك على جهازك' : 'Your data stays on your device'),
      content: SingleChildScrollView(
        child: Text(
          ar
              ? 'رسائل البنوك والمعاملات والكروت والـItems والصور والأرصدة محفوظة محليًا بتشفير ومفتاح خاص بهذا الجهاز.\n\n'
                    'تسجيل الدخول والملف الشخصي يظلان متصلين بخدمة الحساب. البيانات المالية القديمة على السيرفر محفوظة لحين التحقق من النقل وموافقتك على حذفها.\n\n'
                    'تسجيل الدخول بنفس حساب Google على هاتف جديد لا ينقل بياناتك المحلية تلقائيًا. حذف التطبيق أو فقدان الهاتف قد يفقدك الوصول إليها.\n\n'
                    'النسخ الاحتياطي المشفر بكلمة مرور والاستعادة على جهاز آخر لم يتوفرا بعد.'
              : 'Bank messages, transactions, cards, items, images and balances are stored locally with encryption and a key belonging to this device.\n\n'
                    'Sign-in and your profile still use the account service. Historical financial data on the server is retained until migration is verified and you approve its deletion.\n\n'
                    'Signing into the same Google account on a new phone does not automatically transfer local data. Uninstalling the app or losing the phone may lose access to it.\n\n'
                    'Password-encrypted backup and restore to another device are not available yet.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(ar ? 'تمام' : 'OK'),
        ),
      ],
    ),
  );
}
