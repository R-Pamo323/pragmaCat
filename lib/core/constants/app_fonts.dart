import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppFonts {
  const AppFonts._internal();

  static const String fontFamily = 'roboto';

  static const double headlineSize = 24;
  static const double titleSize = 20;
  static const double subtitleSize = 16;
  static const double bodySize = 14;
  static const double captionSize = 12;

  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: headlineSize,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: titleSize,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: subtitleSize,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: bodySize,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontFamily: fontFamily,
    fontSize: bodySize,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: captionSize,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
