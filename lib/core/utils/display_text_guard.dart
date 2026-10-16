/// Conservative presentation guard for dynamic, user/SMS-derived text.
///
/// It only filters text that is clearly encoding corruption and never mutates
/// legitimate Arabic, English, digits, currency symbols, or punctuation.
class DisplayTextGuard {
  DisplayTextGuard._();

  // These are code points, written as ASCII escapes so this file itself stays
  // valid UTF-8 and does not contain the corruption it detects.
  static const List<String> _commonSequences = <String>[
    '\u00f6\u00c7\u0393', // repeated box-drawing corruption
    '\u00e2\u20ac\u2122', // curly apostrophe corruption
    '\u00e2\u20ac\u201c', // left quote corruption
    '\u00e2\u20ac\u201d', // right quote corruption
    '\u00e2\u20ac\u2026', // ellipsis corruption
    '\u00e2\u0080', // leading UTF-8 continuation residue
    '\u00c2', // Latin-1 interpretation of a UTF-8 lead byte
    '\u00c3', // Latin-1 interpretation of a UTF-8 lead byte
  ];

  static final RegExp _boxRun = RegExp(r'[\u2500-\u257f]{3,}');

  /// Returns true only when [text] is clearly corrupted.
  static bool looksCorrupted(String? text) {
    if (text == null || text.isEmpty) return false;
    if (text.contains('\ufffd')) return true;

    for (final rune in text.runes) {
      if (rune < 0x20 && rune != 0x09 && rune != 0x0A && rune != 0x0D) {
        return true;
      }
    }
    if (_boxRun.hasMatch(text)) return true;
    return _commonSequences.any(text.contains);
  }

  /// Preserves legitimate content and replaces only clearly corrupted labels.
  static String label(String? text, {String fallback = 'Bank'}) {
    if (text == null || text.trim().isEmpty) return fallback;
    if (looksCorrupted(text)) return fallback;
    return text;
  }
}
