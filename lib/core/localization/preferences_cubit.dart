import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/app_preferences_repository.dart';
import '../../domain/entities/detected_card_model.dart';
import '../../domain/services/card_ownership.dart';

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
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._preferences) : super(const Locale('ar')) {
    _load();
  }

  final AppPreferencesRepository _preferences;

  Future<void> _load() async {
    final code = (await _preferences.read(PrefsKeys.languageCode)) ?? 'ar';
    if (!isClosed) emit(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    emit(locale);
    await _preferences.write(PrefsKeys.languageCode, locale.languageCode);
  }

  bool get isArabic => state.languageCode == 'ar';
}

/// Persisted theme mode: strictly light or dark (no system) per product spec.
class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(this._preferences) : super(ThemeMode.dark) {
    _load();
  }

  final AppPreferencesRepository _preferences;

  Future<void> _load() async {
    final stored = await _preferences.read(PrefsKeys.themeMode);
    if (!isClosed) emit(stored == 'light' ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    await _preferences.write(
        PrefsKeys.themeMode, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

/// Bank-qualified selection emits one immutable state even when last4 is unchanged.
class CardSelection {
  final String? last4;
  final String? bankName;
  final bool requiresChoice;
  const CardSelection({this.last4, this.bankName, this.requiresChoice = false});
  @override
  bool operator ==(Object other) =>
      other is CardSelection &&
      other.last4 == last4 &&
      other.bankName == bankName &&
      other.requiresChoice == requiresChoice;
  @override
  int get hashCode => Object.hash(last4, bankName, requiresChoice);
}

class SelectedCardCubit extends Cubit<CardSelection> {
  final AppPreferencesRepository _preferences;
  late final Future<void> ready;
  Future<void> _save = Future.value();
  SelectedCardCubit(this._preferences) : super(const CardSelection()) {
    ready = _load();
  }
  String? get bankName => state.bankName;
  Future<void> _load() async {
    final bank = await _preferences.read(PrefsKeys.selectedCardBankName);
    final last4 = await _preferences.read(PrefsKeys.selectedCardLast4);
    if (!isClosed) emit(CardSelection(last4: last4, bankName: bank));
  }

  Future<void> setSelectedCard(String? last4, {String? bankName}) async {
    await ready;
    if (isClosed) return;
    emit(
        CardSelection(last4: last4, bankName: last4 == null ? null : bankName));
    _save = _save.catchError((Object _) {}).then((_) async {
      if (last4 == null) {
        await _preferences.remove(PrefsKeys.selectedCardLast4);
        await _preferences.remove(PrefsKeys.selectedCardBankName);
      } else {
        await _preferences.write(PrefsKeys.selectedCardLast4, last4);
        if (bankName == null || bankName.isEmpty) {
          await _preferences.remove(PrefsKeys.selectedCardBankName);
        } else {
          await _preferences.write(PrefsKeys.selectedCardBankName, bankName);
        }
      }
    });
    await _save;
  }

  Future<void> setSelectedCardLast4(String? last4) =>
      setSelectedCard(last4, bankName: state.bankName);
  Future<void> clear() => setSelectedCard(null);
  Future<void> reconcile(List<String> last4s) async {
    await ready;
    if (last4s.isEmpty) {
      if (state.last4 != null) await clear();
      return;
    }
    if (!state.requiresChoice &&
        (state.last4 == null || !last4s.contains(state.last4))) {
      await setSelectedCard(last4s.first);
    }
  }

  Future<void> reconcileCards(List<DetectedCard> cards) async {
    await ready;
    if (isClosed) return;
    if (cards.isEmpty) {
      if (state.last4 != null) await clear();
      return;
    }
    if (state.requiresChoice) return;
    final matches = cards.where((card) => card.last4 == state.last4).toList();
    if (matches.isEmpty) {
      await setSelectedCard(cards.first.last4, bankName: cards.first.bankName);
    } else if (matches.length > 1) {
      final bank = normalizeBankIdentity(state.bankName);
      final qualified = matches.where((card) =>
          bank != null && normalizeBankIdentity(card.bankName) == bank);
      if (qualified.length != 1) {
        // Preserve the unresolved legacy identity until the user chooses a bank.
        emit(CardSelection(last4: state.last4, requiresChoice: true));
      }
    }
  }
}
