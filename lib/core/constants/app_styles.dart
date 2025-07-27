import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_editor_app/core/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get h1 => GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static TextStyle get homeTitle =>
      GoogleFonts.lato(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -1);

  static TextStyle get cardTitle =>
      GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static TextStyle get cardSubtitle =>
      GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textSecondary);

  static TextStyle get body =>
      GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary);

  static TextStyle get button =>
      GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
}
