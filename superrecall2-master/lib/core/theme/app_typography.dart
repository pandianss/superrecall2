import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // Primary Action / Topic (Research: Display/topic 22px 500)
  static const TextStyle displayTopic = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Card Prompts (Research: 18px 500)
  static const TextStyle cardPrompt = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Card Answers (Research: 16px line-height 1.7)
  static const TextStyle cardAnswer = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.7,
  );

  // Labels & Badges (Research: 11px 500 UPPERCASE)
  static const TextStyle labelBadge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
  );

  // Progress Meta (Research: 13px)
  static const TextStyle progressMeta = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextTheme textTheme(Color color) => TextTheme(
    displaySmall: displayTopic.copyWith(color: color),
    headlineSmall: displayTopic.copyWith(color: color),
    titleLarge: titleLarge.copyWith(color: color),
    titleMedium: cardPrompt.copyWith(color: color),
    bodyLarge: cardAnswer.copyWith(color: color),
    bodyMedium: bodyMedium.copyWith(color: color),
    bodySmall: bodySmall.copyWith(color: color),
    labelSmall: labelBadge.copyWith(color: color),
  );
}
