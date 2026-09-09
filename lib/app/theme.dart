/// Material 3 themes, light and dark, from one seed colour.
///
/// Both are defined rather than only one: `NFR-16` requires the application to
/// render legibly under either, and a dark theme derived by accident from a
/// light one usually does not.
library;

import 'package:flutter/material.dart';

abstract final class FortunaTheme {
  /// The single seed both schemes are derived from.
  static const seed = Color(0xFF1B6B4C);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      // Monetary figures are tabular by nature: a column of amounts that does
      // not align on the decimal separator is a column that is hard to read.
      textTheme: const TextTheme().apply(
        fontFamilyFallback: const ['monospace'],
      ),
    );
  }
}
