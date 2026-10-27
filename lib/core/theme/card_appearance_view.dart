import 'package:flutter/material.dart';
import '../../domain/entities/detected_card_model.dart';

extension CardAppearanceView on CardAppearance {
  /// Resolves the effective gradient colors for this card.
  List<Color> get colors {
    if (colorA != null && colorB != null) {
      return [Color(colorA!), Color(colorB!)];
    }
    return CardPresets
        .presets[presetIndex.clamp(0, CardPresets.presets.length - 1)];
  }
}

/// A bank of premium, visually-distinct card gradients/patterns. Each card
/// starts with a different preset so users can tell them apart at a glance
/// (requirement #10 — unique background design for every card).
class CardPresets {
  static const List<List<Color>> presets = [
    // Indigo → Purple
    [Color(0xFF6F5BD3), Color(0xFF8A78E8)],
    // Teal → Cyan
    [Color(0xFF0EA5E9), Color(0xFF12BFFF)],
    // Rose → Pink
    [Color(0xFFF05B9A), Color(0xFFFFB3BA)],
    // Amber → Orange
    [Color(0xFFFFB84D), Color(0xFFF59E1A)],
    // Emerald → Green
    [Color(0xFF10B981), Color(0xFF34D399)],
    // Violet → Fuchsia
    [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    // Blue → Indigo
    [Color(0xFF55AFFF), Color(0xFF4F46E5)],
    // Dark slate → muted
    [Color(0xFF1E293B), Color(0xFF334155)],
  ];
}
