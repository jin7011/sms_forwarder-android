import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  // Light Theme (equivalent to Android LightColorScheme)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.purple40,
      secondary: AppColors.purpleGrey40,
      tertiary: AppColors.pink40,
      background: AppColors.background,
      surface: AppColors.surface,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onTertiary: AppColors.onTertiary,
      onBackground: AppColors.onBackground,
      onSurface: AppColors.onSurface,
    ),
    textTheme: AppTypography.textTheme,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple40,
        foregroundColor: AppColors.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.purple40.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.textTheme.labelSmall?.copyWith(
            color: AppColors.purple40,
          );
        }
        return AppTypography.textTheme.labelSmall?.copyWith(
          color: AppColors.onSurface.withOpacity(0.6),
        );
      }),
    ),
  );

  // Dark Theme (equivalent to Android DarkColorScheme)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.purple80,
      secondary: AppColors.purpleGrey80,
      tertiary: AppColors.pink80,
      background: Color(0xFF1C1B1F),
      surface: Color(0xFF1C1B1F),
      onPrimary: Color(0xFF381E72),
      onSecondary: Color(0xFF4A4458),
      onTertiary: Color(0xFF633B48),
      onBackground: Color(0xFFE6E1E5),
      onSurface: Color(0xFFE6E1E5),
    ),
    textTheme: AppTypography.textTheme.apply(
      bodyColor: const Color(0xFFE6E1E5),
      displayColor: const Color(0xFFE6E1E5),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xFF1C1B1F),
      foregroundColor: Color(0xFFE6E1E5),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple80,
        foregroundColor: const Color(0xFF381E72),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1C1B1F),
      indicatorColor: AppColors.purple80.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.textTheme.labelSmall?.copyWith(
            color: AppColors.purple80,
          );
        }
        return AppTypography.textTheme.labelSmall?.copyWith(
          color: const Color(0xFFE6E1E5).withOpacity(0.6),
        );
      }),
    ),
  );

  // Get theme based on system brightness (equivalent to Android's isSystemInDarkTheme)
  static ThemeData getTheme(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }
}