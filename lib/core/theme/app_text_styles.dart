import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'arlrdbd';

  static const TextStyle display = TextStyle(
    fontFamily: _font,
    fontSize: 30,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle cardLabel = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    color: AppColors.textWhite,
    height: 1.3,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    color: AppColors.textWhite,
    height: 1.2,
  );

  static const TextStyle greetingName = TextStyle(
    fontFamily: _font,
    fontSize: 26,
    color: AppColors.textWhite,
    height: 1.2,
  );

  static const TextStyle greetingSub = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    color: Color(0xCCFFFFFF),
    height: 1.4,
  );
}
