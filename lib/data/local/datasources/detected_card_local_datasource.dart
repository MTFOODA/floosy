import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/detected_card_model.dart';
import 'private_record_store.dart';

/// Local (SharedPreferences) storage for [DetectedCard].
///
/// Cards are stored as a JSON-encoded list under a per-user key so they
/// persist across restarts (requirement #5). SharedPreferences is already
/// used elsewhere in Floosy for user preferences, keeping one lightweight
/// persistence path for UI state.
class DetectedCardLocalDataSource {
  final PrivateRecordStore? records;
  DetectedCardLocalDataSource({this.records});
  static const _kKeyPrefix = 'floosy_detected_cards_';

  /// Load all detected cards for [userId], or an empty list.
  Future<List<DetectedCard>> getCards(String userId) async {
    final secure = records;
    if (secure != null) {
      final prefs = await SharedPreferences.getInstance();
      final legacy = prefs.getString(_key(userId));
      if (legacy != null) {
        final old = (jsonDecode(legacy) as List)
            .map((r) => DetectedCard.fromJson(Map<String, dynamic>.from(r)))
            .toList();
        await secure.database.transaction(() async {
          for (final card in old) {
            await secure.put(
              'detected_cards',
              card.toJson(),
              userId: userId,
              onlyIfMissing: true,
            );
          }
        });
        final saved = (await secure.list(
          'detected_cards',
          userId: userId,
        )).map((r) => r['id']).toSet();
        if (old.any((c) => !saved.contains(c.id))) {
          throw StateError('Card migration incomplete');
        }
        await prefs.remove(_key(userId));
      }
      return (await secure.list(
        'detected_cards',
        userId: userId,
      )).map(DetectedCard.fromJson).toList();
    }
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
    final secure = records;
    if (secure != null) {
      await secure.database.transaction(() async {
        final keep = cards.map((c) => c.id).toSet();
        for (final old in await secure.list('detected_cards', userId: userId)) {
          if (!keep.contains(old['id'])) {
            await secure.delete('detected_cards', old['id'] as String);
          }
        }
        for (final card in cards) {
          await secure.put('detected_cards', card.toJson(), userId: userId);
        }
      });
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(cards.map((c) => c.toJson()).toList());
    await prefs.setString(_key(userId), encoded);
  }

  String _key(String userId) => '$_kKeyPrefix$userId';
}
