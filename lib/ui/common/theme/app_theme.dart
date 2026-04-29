import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFBFE4DB);
  static const Color secondaryColor = Color(0xFFEFDDB7);

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.black,
    ),
    // other theme settings
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.black,
    ),
    // other theme settings
  );
}
