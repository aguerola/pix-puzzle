import 'package:flutter/material.dart';

abstract final class PixColors {
  static const app = Color(0xFFFAF7F0);
  static const raised = Color(0xFFFFFCF7);
  static const ink = Color(0xFF20252B);
  static const inkMuted = Color(0xFF575D64);
  static const cellEmpty = Color(0xFFFFFCF7);
  static const cellBorder = Color(0xFF73736F);
  static const stamp = Color(0xFFB84433);
  static const focus = Color(0xFFEF7D68);
  static const onStamp = Colors.white;
  static const done = Color(0xFF30654E);
  static const reset = Color(0xFF9B4033);
}

ThemeData buildPixTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: PixColors.stamp,
    brightness: Brightness.light,
    primary: PixColors.stamp,
    onPrimary: PixColors.onStamp,
    surface: PixColors.app,
    onSurface: PixColors.ink,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: PixColors.app,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 40,
        height: 1.05,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.6,
        color: PixColors.ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: PixColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: PixColors.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.5,
        color: PixColors.inkMuted,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: PixColors.app,
      foregroundColor: PixColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE1DDD4),
      thickness: 1,
      space: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 52),
        foregroundColor: PixColors.ink,
        side: const BorderSide(color: PixColors.ink),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: PixColors.ink,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: PixColors.ink,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: PixColors.raised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
