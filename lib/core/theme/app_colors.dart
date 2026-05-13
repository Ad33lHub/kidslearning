import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF4C1D95);
  static const Color secondary = Color(0xFFF43F5E);
  static const Color accent = Color(0xFFF59E0B);

  // Background
  static const Color background = Color(0xFFF5F3FF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1E1B4B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Header gradient
  static const List<Color> headerGradient = [Color(0xFF4C1D95), Color(0xFF7C3AED)];

  // Home mode card gradients
  static const List<Color> gradientLearning = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> gradientVideo = [Color(0xFFF43F5E), Color(0xFFFB7185)];
  static const List<Color> gradientQuiz = [Color(0xFF0EA5E9), Color(0xFF38BDF8)];
  static const List<Color> gradientListen = [Color(0xFF10B981), Color(0xFF34D399)];
  static const List<Color> gradientActivities = [Color(0xFFF97316), Color(0xFFFB923C)];
  static const List<Color> gradientRewards = [Color(0xFFF59E0B), Color(0xFFFCD34D)];

  // Category gradients
  static const List<Color> gradientAlphabet = [Color(0xFF7C3AED), Color(0xFFA78BFA)];
  static const List<Color> gradientNumbers = [Color(0xFF1D4ED8), Color(0xFF60A5FA)];
  static const List<Color> gradientColors = [Color(0xFFB45309), Color(0xFFFBBF24)];
  static const List<Color> gradientShapes = [Color(0xFF0F766E), Color(0xFF2DD4BF)];
  static const List<Color> gradientAnimals = [Color(0xFF15803D), Color(0xFF4ADE80)];
  static const List<Color> gradientBirds = [Color(0xFF0369A1), Color(0xFF38BDF8)];
  static const List<Color> gradientFlowers = [Color(0xFFBE185D), Color(0xFFF472B6)];
  static const List<Color> gradientFruits = [Color(0xFFB91C1C), Color(0xFFF87171)];
  static const List<Color> gradientMonths = [Color(0xFF4338CA), Color(0xFF818CF8)];
  static const List<Color> gradientVegetables = [Color(0xFF3B7A1F), Color(0xFF86EFAC)];

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Bottom Nav
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navSelected = Color(0xFF6D28D9);
  static const Color navUnselected = Color(0xFFB0B8C9);

  // Shadow
  static Color shadowColor = const Color(0xFF6D28D9).withOpacity(0.18);
}
