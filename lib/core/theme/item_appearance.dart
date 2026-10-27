import 'dart:convert';
import 'package:flutter/material.dart';

/// Stored in the existing optional item icon field, together with its colour.
class ItemAppearance {
  const ItemAppearance(
      {this.symbol = '🛍️', this.color = const Color(0xFF75B8FF)});
  final String symbol;
  final Color color;

  static const symbols = [
    '🍽️',
    '☕',
    '🚗',
    '🛍️',
    '🎬',
    '💊',
    '💡',
    '🏠',
    '📱',
    '🍹',
    '✈️',
    '💪',
    '🎮',
    '🎵',
    '📚',
    '🍕',
    '🧴',
    '👗',
    '🧳'
  ];
  static const colors = [
    Color(0xFFFF6B72),
    Color(0xFFFFCB67),
    Color(0xFF75B8FF),
    Color(0xFFA393FF),
    Color(0xFFF37AAF),
    Color(0xFF00B99C),
    Color(0xFF52DEB6),
    Color(0xFFEA805D)
  ];
  static const colorLabels = [
    'itemColorRed',
    'itemColorGold',
    'itemColorBlue',
    'itemColorPurple',
    'itemColorPink',
    'itemColorTeal',
    'itemColorGreen',
    'itemColorOrange'
  ];

  factory ItemAppearance.decode(String? value) {
    if (symbols.contains(value)) return ItemAppearance(symbol: value!);
    try {
      final data = jsonDecode(value ?? '') as Map<String, dynamic>;
      final symbol = data['symbol'];
      final color = data['color'];
      if (symbols.contains(symbol) &&
          color is int &&
          colors.any((c) => c.toARGB32() == color)) {
        return ItemAppearance(symbol: symbol as String, color: Color(color));
      }
    } catch (_) {/* Legacy items use the default appearance. */}
    return const ItemAppearance();
  }

  String encode() => jsonEncode({'symbol': symbol, 'color': color.toARGB32()});
}
