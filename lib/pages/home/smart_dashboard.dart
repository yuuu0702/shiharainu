import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/pages/home/smart_dashboard_logic.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class SmartDashboard extends StatelessWidget {
  final SmartAction action;

  const SmartDashboard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(action.type);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.mutedColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(action.type),
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _getLabel(action.type),
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // Optional: Priority Badge or Date could go here
                if (action.eventDate != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.mutedColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatDate(action.eventDate!),
                      style: const TextStyle(
                        color: AppTheme.mutedForeground,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Content Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title ?? 'No Action',
                  style: const TextStyle(
                    color: AppTheme.foregroundColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    height: 1.3,
                  ),
                ),
                if (action.subTitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    action.subTitle!,
                    style: const TextStyle(
                      color: AppTheme.mutedForeground,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Button Section (Full width at bottom)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.mutedColor, width: 0.5),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleAction(context, action),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_getButtonText(action.type)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, SmartAction action) {
    switch (action.type) {
      case SmartActionType.pay:
        if (action.eventId != null) {
          context.go('/events/${action.eventId}');
        }
        break;
      case SmartActionType.checkStatus:
        if (action.eventId != null) {
          context.go('/events/${action.eventId}');
        }
        break;
      case SmartActionType.create:
        context.go('/events/create');
        break;
      case SmartActionType.join:
        // context.go('/events');
        showDialog(
          context: context,
          builder: (context) => const JoinEventDialog(),
        );
        break;
      case SmartActionType.wait:
        if (action.eventId != null) {
          context.go('/events/${action.eventId}');
        }
        break;
    }
  }

  // --- Helpers for Styles ---

  Color _getAccentColor(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return const Color(0xFFE11D48); // Rose 600 (Slightly darker for text)
      case SmartActionType.checkStatus:
        return const Color(0xFF7C3AED); // Violet 600
      case SmartActionType.create:
      case SmartActionType.join:
        return const Color(0xFF2563EB); // Blue 600
      case SmartActionType.wait:
        return const Color(0xFF059669); // Emerald 600
    }
  }

  IconData _getIcon(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return Icons.payment_outlined;
      case SmartActionType.checkStatus:
        return Icons.assignment_turned_in_outlined;
      case SmartActionType.create:
        return Icons.add_circle_outline;
      case SmartActionType.join:
        return Icons.login;
      case SmartActionType.wait:
        return Icons.calendar_today_outlined;
    }
  }

  String _getLabel(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return '支払いをお忘れですか？';
      case SmartActionType.checkStatus:
        return 'もうすぐ開催';
      case SmartActionType.create:
        return '新しいイベント';
      case SmartActionType.join:
        return 'イベントに参加';
      case SmartActionType.wait:
        return '次の予定';
    }
  }

  String _getButtonText(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return '支払い画面へ進む';
      case SmartActionType.checkStatus:
        return '状況を確認する';
      case SmartActionType.create:
        return 'イベントを作成する';
      case SmartActionType.join:
        return '参加コードを入力';
      case SmartActionType.wait:
        return 'イベント詳細を見る';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
