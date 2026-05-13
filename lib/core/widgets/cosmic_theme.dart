import 'package:flutter/material.dart';

/// Cosmic Discovery palette — single source of truth for all learning screens.
/// Mirrors DESIGN.md.
class CosmicPalette {
  CosmicPalette._();

  static const Color bg = Color(0xFF0E0E10);
  static const Color bgMid = Color(0xFF1C1B1D);
  static const Color surface = Color(0xFF201F21);
  static const Color surfaceHigh = Color(0xFF2A2A2C);
  static const Color outline = Color(0x33FFFFFF);
  static const Color outlineStrong = Color(0x55FFFFFF);

  static const Color primary = Color(0xFFC1C5E3);
  static const Color secondary = Color(0xFFEBB2FF);
  static const Color secondaryDeep = Color(0xFFB600F8);
  static const Color tertiary = Color(0xFFC9CE00);
  static const Color teal = Color(0xFF7FE7D4);
  static const Color tealDeep = Color(0xFF1FB6A4);

  static const Color textPrimary = Color(0xFFE5E1E4);
  static const Color textMuted = Color(0xFFC7C5CE);

  static const Color correct = Color(0xFF6DB072);
  static const Color wrong = Color(0xFFFF6B7D);

  /// Per-category accent (used for gallery cards and glow).
  static const Map<String, _Accent> categoryAccents = {
    'alphabet': _Accent(Color(0xFFEBB2FF), Color(0xFFB600F8), '🔤'),
    'numbers': _Accent(Color(0xFF9BB4FF), Color(0xFF3C5BD9), '🔢'),
    'colors': _Accent(Color(0xFFFFC58A), Color(0xFFE0853A), '🎨'),
    'shapes': _Accent(Color(0xFF7FE7D4), Color(0xFF1FB6A4), '🔷'),
    'animals': _Accent(Color(0xFFA8E89A), Color(0xFF3B7A1F), '🦁'),
    'birds': _Accent(Color(0xFFB7DEFF), Color(0xFF0369A1), '🦜'),
    'flowers': _Accent(Color(0xFFFFB7D5), Color(0xFFBE185D), '🌸'),
    'fruits': _Accent(Color(0xFFFF9F8F), Color(0xFFB91C1C), '🍎'),
    'months': _Accent(Color(0xFFBAB8FF), Color(0xFF4338CA), '📅'),
    'vegetables': _Accent(Color(0xFFBEEAA8), Color(0xFF3B7A1F), '🥦'),
  };
}

class _Accent {
  final Color light;
  final Color deep;
  final String emoji;
  const _Accent(this.light, this.deep, this.emoji);
}

/// Convenience getters per category — fall back to default cosmic accents.
class CosmicAccent {
  CosmicAccent._();

  static Color light(String category) =>
      CosmicPalette.categoryAccents[category]?.light ??
      CosmicPalette.secondary;

  static Color deep(String category) =>
      CosmicPalette.categoryAccents[category]?.deep ??
      CosmicPalette.secondaryDeep;

  static String emoji(String category) =>
      CosmicPalette.categoryAccents[category]?.emoji ?? '✨';
}

/// Cosmic text style helpers — always use these on user-facing text.
class CosmicText {
  CosmicText._();

  static const TextStyle title = TextStyle(
    fontFamily: 'arlrdbd',
    fontSize: 20,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: 'arlrdbd',
    fontSize: 24,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'arlrdbd',
    fontSize: 15,
    color: Colors.white,
    height: 1.3,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'arlrdbd',
    fontSize: 13,
    color: CosmicPalette.textMuted,
    height: 1.3,
  );

  static const TextStyle cardLabel = TextStyle(
    fontFamily: 'arlrdbd',
    fontSize: 15,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle pronunciation = TextStyle(
    fontFamily: 'arlrdbd',
    fontSize: 22,
    color: Colors.white,
    height: 1.2,
  );
}
