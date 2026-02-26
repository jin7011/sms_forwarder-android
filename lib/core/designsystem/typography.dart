import 'package:flutter/material.dart';

class AppTypography {
  // Static getters for individual text styles
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 57.0,
        height: 1.12,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 45.0,
        height: 1.16,
        letterSpacing: 0.0,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 36.0,
        height: 1.22,
        letterSpacing: 0.0,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 32.0,
        height: 1.25,
        letterSpacing: 0.0,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 28.0,
        height: 1.29,
        letterSpacing: 0.0,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
        height: 1.33,
        letterSpacing: 0.0,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 22.0,
        height: 1.27,
        letterSpacing: 0.0,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        height: 1.50,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        height: 1.5,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        height: 1.33,
        letterSpacing: 0.4,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
        height: 1.33,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 11.0,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // TextTheme for theme configuration
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 57.0,
      height: 1.12,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 45.0,
      height: 1.16,
      letterSpacing: 0.0,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 36.0,
      height: 1.22,
      letterSpacing: 0.0,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 32.0,
      height: 1.25,
      letterSpacing: 0.0,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 28.0,
      height: 1.29,
      letterSpacing: 0.0,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 24.0,
      height: 1.33,
      letterSpacing: 0.0,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 22.0,
      height: 1.27,
      letterSpacing: 0.0,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
      height: 1.50,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
      height: 1.5,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
      height: 1.33,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      height: 1.43,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 12.0,
      height: 1.33,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
      height: 1.45,
      letterSpacing: 0.5,
    ),
  );
}