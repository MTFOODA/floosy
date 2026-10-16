import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Supported locales in Floosy. The app offers exactly ONE language at a time
/// (no mixed UI) — Arabic or English, persisted in SharedPreferences.
const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];

/// Loads [AppLocalizations] from the ARB files in `assets/translations/`.
class AppLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedValues = {};

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Shortcut accessor.
  static AppLocalizations s(BuildContext context) => of(context);

  Future<void> load() async {
    final jsonString = await rootBundle
        .loadString('assets/translations/app_${locale.languageCode}.arb');
    final Map<String, dynamic> parsed =
        json.decode(jsonString) as Map<String, dynamic>;
    _localizedValues = parsed;
  }

  /// Returns the translated string for [key], or [key] itself if not found.
  /// Supports `{param}` substitution.
  String t(String key, [Map<String, String>? params]) {
    var value = _localizedValues[key]?.toString() ?? key;
    if (params != null) {
      params.forEach((k, v) => value = value.replaceAll('{$k}', v));
    }
    return value;
  }

  /// Convenience operator for bracket-style access.
  String operator [](String key) => t(key);

  /// True when the active locale is Arabic (RTL). Used by widgets that need
  /// to mirror their own layout/alignment logic.
  bool get isArabic => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final loc = AppLocalizations(locale);
    await loc.load();
    return loc;
  }

  @override
  bool shouldReload(covariant _AppLocalizationsDelegate old) => false;
}
