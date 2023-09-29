import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: AppColors.alertDefault,
  secondary: AppColors.secondaryDefault,
  background: AppColors.backgroundDark,
  onBackground: AppColors.backgroundDark,
  surface: AppColors.black,
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.background,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
  ),
);
