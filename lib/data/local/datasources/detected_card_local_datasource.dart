import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../models/detected_card_model.dart';

/// Local (SharedPreferences) storage for [DetectedCard].
///
/// Cards are stored as a JSON-encoded list under a per-user key so they
/// persist across restarts (requirement #5). SharedPreferences is already
/// used elsewhere in Floosy for user preferences, keeping one lightweight
/// persistence path for UI state.
class DetectedCardLocalDataSource {
  static const _kKeyPrefix = 'floosy_detected_cards_';

  /// Load all detected cards for [userId], or an empty list.
  Future<List<DetectedCard>> getCards(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(userId));
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .map((e) => DetectedCard.fromJson(Map<String, dynamic>.from(e)))
          .whereType<DetectedCard>()
          .toList();
    } catch (_) {
      // Corrupted payload — fail safe, do not crash (requirement #14).
      return [];
    }
  }

  /// Save the full list of cards (used after create/update/delete).
  Future<void> saveCards(String userId, List<DetectedCard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(cards.map((c) => c.toJson()).toList());
    await prefs.setString(_key(userId), encoded);
  }

  String _key(String userId) => '$_kKeyPrefix$userId';
}
