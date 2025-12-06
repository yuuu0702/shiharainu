import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

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
    return AppCard(
      child: Row(
        children: [
          // シンプルなアバター
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(dogEmoji, style: AppTheme.displayMedium),
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),

          // ウェルカムメッセージ（シンプルに）
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'おかえりなさい',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mutedForegroundAccessible,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  userName,
                  style: AppTheme.headlineLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
