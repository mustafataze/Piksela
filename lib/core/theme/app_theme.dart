import 'package:flutter/material.dart';
import 'package:photo_editor_app/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(primary: AppColors.primary, surface: AppColors.surface),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.surface, elevation: 0, centerTitle: true),
    useMaterial3: true,
  );
}
