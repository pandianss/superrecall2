import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color surfaceBase;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color surfaceCallout;
  final Color surfaceLearning;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentPrimary;
  final Color accentSuccess;
  final Color accentWarning;
  final Color accentDanger;
  final Color borderSubtle;

  const AppColors({
    required this.surfaceBase,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.surfaceCallout,
    required this.surfaceLearning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentPrimary,
    required this.accentSuccess,
    required this.accentWarning,
    required this.accentDanger,
    required this.borderSubtle,
  });

  @override
  AppColors copyWith({
    Color? surfaceBase,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? surfaceCallout,
    Color? surfaceLearning,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accentPrimary,
    Color? accentSuccess,
    Color? accentWarning,
    Color? accentDanger,
    Color? borderSubtle,
  }) {
    return AppColors(
      surfaceBase: surfaceBase ?? this.surfaceBase,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceCallout: surfaceCallout ?? this.surfaceCallout,
      surfaceLearning: surfaceLearning ?? this.surfaceLearning,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSuccess: accentSuccess ?? this.accentSuccess,
      accentWarning: accentWarning ?? this.accentWarning,
      accentDanger: accentDanger ?? this.accentDanger,
      borderSubtle: borderSubtle ?? this.borderSubtle,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      surfaceBase: Color.lerp(surfaceBase, other.surfaceBase, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceCallout: Color.lerp(surfaceCallout, other.surfaceCallout, t)!,
      surfaceLearning: Color.lerp(surfaceLearning, other.surfaceLearning, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSuccess: Color.lerp(accentSuccess, other.accentSuccess, t)!,
      accentWarning: Color.lerp(accentWarning, other.accentWarning, t)!,
      accentDanger: Color.lerp(accentDanger, other.accentDanger, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
    );
  }

  // Light Mode Defaults
  static const light = AppColors(
    surfaceBase: Color(0xFFF7F1E8),
    surfaceCard: Color(0xFFFFFBF5),
    surfaceElevated: Color(0xFFFFFFFF),
    surfaceCallout: Color(0xFFE8F3F1),
    surfaceLearning: Color(0xFFFDF8F0),
    textPrimary: Color(0xFF1F2A37),
    textSecondary: Color(0xFF4B5563),
    textMuted: Color(0xFF9CA3AF),
    accentPrimary: Color(0xFF534AB7),
    accentSuccess: Color(0xFF1D9E75),
    accentWarning: Color(0xFFEF9F27),
    accentDanger: Color(0xFFE24B4A),
    borderSubtle: Color(0x121F2A37),
  );

  // Dark Mode Optimized
  static const dark = AppColors(
    surfaceBase: Color(0xFF0D0D0F),
    surfaceCard: Color(0xFF1E1E24),
    surfaceElevated: Color(0xFF26262D),
    surfaceCallout: Color(0xFF1A2E2C),
    surfaceLearning: Color(0xFF221F1B),
    textPrimary: Color(0xFFF0EFF8),
    textSecondary: Color(0xFFC8C6D8),
    textMuted: Color(0xFF8A8899),
    accentPrimary: Color(0xFF7F77DD),
    accentSuccess: Color(0xFF1D9E75),
    accentWarning: Color(0xFFEF9F27),
    accentDanger: Color(0xFFE24B4A),
    borderSubtle: Color(0x12F0EFF8),
  );
}

// Global accessor helper
extension AppColorsTheme on ThemeData {
  AppColors get appColors => extension<AppColors>() ?? AppColors.light;
}

extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  AppColors get appColors => theme.appColors;
  TextTheme get textTheme => theme.textTheme;
}
