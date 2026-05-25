import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.accentPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_rounded,
                size: 40,
                color: colors.surfaceElevated,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'SuperRecall',
              style: textTheme.displaySmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: colors.accentPrimary,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
