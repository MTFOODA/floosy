import 'package:flutter/material.dart';
import '../../domain/entities/detected_card_model.dart';

extension CardAppearanceView on CardAppearance {
  /// Resolves the effective gradient colors for this card.
  List<Color> get colors {
    if (colorA != null && colorB != null) {
      return [Color(colorA!), Color(colorB!)];
    }
    return CardPresets.presets[presetIndex.clamp(
      0,
      CardPresets.presets.length - 1,
    )];
  }
}

/// A bank of premium, visually-distinct card gradients/patterns. Each card
/// starts with a different preset so users can tell them apart at a glance
/// (requirement #10 — unique background design for every card).
class CardPresets {
  static const List<List<Color>> presets = [
    // Indigo → Purple
    [Color(0xFF0A3852), Color(0xFF18C7B5)],
    // Teal → Cyan
    [Color(0xFF0EA5E9), Color(0xFF12BFFF)],
    // Rose → Pink
    [Color(0xFF124E78), Color(0xFF38A7D8)],
    // Amber → Orange
    [Color(0xFFFFB84D), Color(0xFFF59E1A)],
    // Emerald → Green
    [Color(0xFF10B981), Color(0xFF34D399)],
    // Violet → Fuchsia
    [Color(0xFF075B5A), Color(0xFF41D9C5)],
    // Blue → Indigo
    [Color(0xFF55AFFF), Color(0xFF4F46E5)],
    // Dark slate → muted
    [Color(0xFF1E293B), Color(0xFF334155)],
    [Color(0xFF005B36), Color(0xFF00945E)],
    [Color(0xFF6F102C), Color(0xFFA32144)],
    [Color(0xFF003B71), Color(0xFF0077B5)],
    [Color(0xFF004D42), Color(0xFF008C72)],
    [Color(0xFFB5121B), Color(0xFFE53535)],
    [Color(0xFF41143D), Color(0xFF782960)],
    [Color(0xFF006A53), Color(0xFF00A878)],
    [Color(0xFF1C3377), Color(0xFF5066AD)],
    [Color(0xFF121212), Color(0xFF424242)],
    [Color(0xFF7A5A17), Color(0xFFB38E35)],
    [Color(0xFF006747), Color(0xFF4E8B29)],
    [Color(0xFF4A1628), Color(0xFF8D2746)],
    [Color(0xFF002D62), Color(0xFF005DAA)],
    [Color(0xFF763F15), Color(0xFFC27825)],
    [Color(0xFF005F73), Color(0xFF0A9396)],
    [Color(0xFF53565A), Color(0xFF8B8F95)],
  ];

  static const palette = <Color>[
    Color(0xFF005B36),
    Color(0xFF00945E),
    Color(0xFF006A53),
    Color(0xFF008C72),
    Color(0xFF006747),
    Color(0xFF4E8B29),
    Color(0xFF10B981),
    Color(0xFF34D399),
    Color(0xFF6F102C),
    Color(0xFFA32144),
    Color(0xFFB5121B),
    Color(0xFFE53535),
    Color(0xFF4A1628),
    Color(0xFF8D2746),
    Color(0xFF41143D),
    Color(0xFF782960),
    Color(0xFF003B71),
    Color(0xFF0077B5),
    Color(0xFF002D62),
    Color(0xFF005DAA),
    Color(0xFF1C3377),
    Color(0xFF5066AD),
    Color(0xFF0EA5E9),
    Color(0xFF55AFFF),
    Color(0xFF005F73),
    Color(0xFF0A9396),
    Color(0xFF0A3852),
    Color(0xFF075B5A),
    Color(0xFF124E78),
    Color(0xFF18C7B5),
    Color(0xFF38A7D8),
    Color(0xFF41D9C5),
    Color(0xFF7A5A17),
    Color(0xFFB38E35),
    Color(0xFF763F15),
    Color(0xFFC27825),
    Color(0xFFFFB84D),
    Color(0xFFF59E1A),
    Color(0xFF121212),
    Color(0xFF1E293B),
    Color(0xFF334155),
    Color(0xFF53565A),
    Color(0xFF8B8F95),
    Color(0xFFFFFFFF),
    Color(0xFFF1F5F9),
    Color(0xFFCBD5E1),
    Color(0xFF64748B),
    Color(0xFF000000),
  ];
}
