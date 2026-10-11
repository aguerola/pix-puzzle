import 'package:flutter/material.dart';

/// Paper + ink tokens for Pix-Puzzle (see design-system/pix-puzzle/MASTER.md).
abstract final class PixColors {
  static const app = Color(0xFFF4F1EC);
  static const raised = Color(0xFFFFFCF8);
  static const ink = Color(0xFF1A1A1A);
  static const inkMuted = Color(0xFF5C5A56);
  static const cellEmpty = Color(0xFFFFFFFF);
  static const cellBorder = Color(0xFFB8B4AC);
  static const stamp = Color(0xFF2F6F6A);
  static const onStamp = Color(0xFFFFFFFF);
  static const done = Color(0xFF3D8B6E);
  static const reset = Color(0xFF8B4A3D);
}

ThemeData buildPixTheme() {
  final base = ColorScheme.fromSeed(
    seedColor: PixColors.stamp,
    brightness: Brightness.light,
    primary: PixColors.stamp,
    onPrimary: PixColors.onStamp,
    surface: PixColors.app,
    onSurface: PixColors.ink,
    secondary: PixColors.done,
    onSecondary: PixColors.onStamp,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: base,
    scaffoldBackgroundColor: PixColors.app,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: PixColors.app,
      foregroundColor: PixColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0.5,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE4DFD6),
      space: 1,
      thickness: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: PixColors.ink,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: PixColors.inkMuted,
      textColor: PixColors.ink,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: PixColors.raised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
