import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/detected_card_model.dart';

/// Keys used in SharedPreferences.
///
/// NOTE: the old `floosy_detection_range` key is deliberately gone. The SMS
/// Detection Range was an *ingestion* scope that was also driving the
/// Transactions view; it has been split into two independent concepts
/// (see `TransactionDisplayFilter` for the display side and
/// `SmsSyncStateStore` for the ingestion side).
class PrefsKeys {
  static const languageCode = 'floosy_language_code';
  static const themeMode = 'floosy_theme_mode';
  static const selectedCardLast4 = 'floosy_selected_card_last4';
  static const selectedCardBankName = 'floosy_selected_card_bank_name';
}

/// Persisted app language. Defaults to Arabic (the app's original audience)
/// and survives restarts.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(PrefsKeys.languageCode) ?? 'ar';
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefsKeys.languageCode, locale.languageCode);
  }

  bool get isArabic => state.languageCode == 'ar';
}

/// Persisted theme mode: strictly light or dark (no system) per product spec.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(PrefsKeys.themeMode);
    state = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        PrefsKeys.themeMode, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

/// Persisted selected detected card. The original `card_last4` key remains the
/// compatibility key; bank is stored separately so same-last4 cards from two
/// banks remain independently selectable.
class SelectedCardNotifier extends StateNotifier<String?> {
  SelectedCardNotifier() : super(null) {
    _loaded = _load();
  }

  late final Future<void> _loaded;
  String? _bankName;

  Future<void> get ready => _loaded;
  String? get bankName => _bankName;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(PrefsKeys.selectedCardLast4);
    _bankName = prefs.getString(PrefsKeys.selectedCardBankName);
  }

  Future<void> setSelectedCard(String? last4, {String? bankName}) async {
    // Force listeners to observe a same-last4/different-bank switch while
    // retaining the legacy last4 persistence key.
    if (state == last4) state = null;
    state = last4;
    _bankName = bankName;
    final prefs = await SharedPreferences.getInstance();
    if (last4 == null) {
      await prefs.remove(PrefsKeys.selectedCardLast4);
      await prefs.remove(PrefsKeys.selectedCardBankName);
      return;
    }
    await prefs.setString(PrefsKeys.selectedCardLast4, last4);
    if (bankName == null || bankName.isEmpty) {
      await prefs.remove(PrefsKeys.selectedCardBankName);
    } else {
      await prefs.setString(PrefsKeys.selectedCardBankName, bankName);
    }
  }

  /// Compatibility wrapper for existing callers that only have a last4.
  Future<void> setSelectedCardLast4(String? last4) =>
      setSelectedCard(last4, bankName: _bankName);

  Future<void> clear() => setSelectedCard(null);

  /// Reconciles the persisted selection against currently detected cards.
  /// Existing last4-only selections remain valid when unambiguous. When the
  /// same last4 belongs to multiple banks, the saved bank qualifier is used;
  /// an old unqualified selection is deliberately not resolved to an arbitrary
  /// bank.
  Future<void> reconcile(List<String> detectedLast4) async {
    await ready;
    if (detectedLast4.isEmpty) {
      if (state != null) await clear();
      return;
    }
    if (state == null || !detectedLast4.contains(state)) {
      await setSelectedCard(detectedLast4.first);
    }
  }

  Future<void> reconcileCards(List<DetectedCard> cards) async {
    await ready;
    if (cards.isEmpty) {
      if (state != null) await clear();
      return;
    }
    final selected = state;
    final matches = cards.where((card) => card.last4 == selected).toList();
    if (matches.isEmpty) {
      await setSelectedCard(cards.first.last4, bankName: cards.first.bankName);
    } else if (matches.length > 1) {
      final qualified = matches.where((card) => card.bankName == _bankName);
      if (qualified.isEmpty) {
        // Legacy selection has no bank identity; do not guess a bank.
        await clear();
      }
    }
  }
}
