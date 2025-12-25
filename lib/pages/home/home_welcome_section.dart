import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

/// ホームページのウェルカムセクション
class HomeWelcomeSection extends StatelessWidget {
  final String userName;
  final String dogEmoji;

  const HomeWelcomeSection({
    super.key,
    required this.userName,
    required this.dogEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.spacing16,
        horizontal: AppTheme.spacing4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'おかえりなさい、',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.mutedForegroundAccessible,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$userNameさん',
                  style: AppTheme.displaySmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.foregroundColor,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.2),
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(
                    0x33EA9062,
                  ), // Primary with ~0.2 alpha but constant for const
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(dogEmoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
        ],
      ),
    );
  }
}
