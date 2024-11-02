import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const Color burntOrange = Color(0xFFCC5500);
  static const Color darkBurntOrange = Color(0xFF993D00);
  static const Color lightBurntOrange = Color(0xFFFFA07A);
  static const Color whiteSmoke = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFFA9A9A9);
  static const Color dimGray = Color(0xFF696969);
  static const Color black = Color(0xFF000000);
}

final String? fontFamily = GoogleFonts.poppins().fontFamily;

ThemeData get dark {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.burntOrange,
      onPrimary: Colors.white,
      secondary: AppColors.lightBurntOrange,
      onSecondary: Colors.white,
      tertiary: AppColors.darkBurntOrange,
      onTertiary: AppColors.darkBurntOrange,
      error: AppColors.darkGray,
      onError: Colors.white,
      surface: AppColors.darkBurntOrange,
      onSurface: AppColors.whiteSmoke,
    ),
    fontFamily: fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBurntOrange,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        fontSize: 20,
        color: AppColors.whiteSmoke,
      ),
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.whiteSmoke),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.darkBurntOrange,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    scaffoldBackgroundColor: AppColors.black,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBurntOrange,
      selectedItemColor: AppColors.burntOrange,
      unselectedItemColor: AppColors.dimGray.withOpacity(0.6),
    ),
    cardTheme: CardTheme(
      color: AppColors.darkBurntOrange,
      shadowColor: AppColors.dimGray.withOpacity(0.25),
    ),
    textTheme: TextTheme(
      displayLarge:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      displayMedium:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      displaySmall:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      headlineLarge:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      headlineMedium:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      headlineSmall:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      titleLarge: TextStyle(
        color: AppColors.whiteSmoke,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      titleMedium:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      titleSmall:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      bodyLarge: TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      bodyMedium: TextStyle(
          color: AppColors.whiteSmoke.withOpacity(0.7), fontFamily: fontFamily),
      bodySmall: TextStyle(
          color: AppColors.whiteSmoke.withOpacity(0.7), fontFamily: fontFamily),
      labelLarge:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      labelMedium:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
      labelSmall:
          TextStyle(color: AppColors.whiteSmoke, fontFamily: fontFamily),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.dimGray),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.dimGray),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.burntOrange),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkGray),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkGray),
        borderRadius: BorderRadius.circular(8.0),
      ),
      floatingLabelStyle: const TextStyle(color: AppColors.whiteSmoke),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.burntOrange),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.lightBurntOrange),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.darkBurntOrange,
      contentTextStyle: const TextStyle(color: AppColors.whiteSmoke),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dimGray,
      thickness: 1,
    ),
  );
}
