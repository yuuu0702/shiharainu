import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/pages/home/smart_dashboard_logic.dart';

class SmartDashboard extends StatelessWidget {
  final SmartAction action;

  const SmartDashboard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getBackgroundColor(action.type),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(action.type),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(action.type),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Label
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(action.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getLabel(action.type),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Title
          Text(
            action.title ?? 'No Action',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          if (action.subTitle != null)
            Text(
              action.subTitle!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleAction(context, action),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _getPrimaryColor(action.type),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              child: Text(_getButtonText(action.type)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, SmartAction action) {
    switch (action.type) {
      case SmartActionType.pay:
        // 支払いQR画面へ直接遷移 (まだページがない場合はイベント詳細へ)
        // 今回はイベント詳細へ遷移し、そこで支払いフローを促す形にする
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
        // Join Dialog logic would be here, but for now we might route or show dialog
        // Since we are in a widget, better to route to home and show dialog or just open dialog
        // For simplicity: go to create event for now or maybe home with query
        // But cleaner is to show the invite dialog.
        // Let's assume we implement a route or callback.
        // For now, let's open the create page or similar.
        context.go('/events'); // Or create? "新しいイベントを企画" implies create.
        break;
      case SmartActionType.wait:
        if (action.eventId != null) {
          context.go('/events/${action.eventId}');
        }
        break;
    }
  }

  // --- Helpers for Styles ---

  Color _getBackgroundColor(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return const Color(0xFFF43F5E); // Rose 500
      case SmartActionType.checkStatus:
        return const Color(0xFF8B5CF6); // Violet 500
      case SmartActionType.create:
      case SmartActionType.join:
        return const Color(0xFF3B82F6); // Blue 500
      case SmartActionType.wait:
        return const Color(0xFF10B981); // Emerald 500
    }
  }

  Color _getShadowColor(SmartActionType type) {
    return _getBackgroundColor(type).withValues(alpha: 0.4);
  }

  List<Color> _getGradientColors(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return [const Color(0xFFF43F5E), const Color(0xFFE11D48)];
      case SmartActionType.checkStatus:
        return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
      case SmartActionType.create:
      case SmartActionType.join:
        return [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
      case SmartActionType.wait:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
    }
  }

  Color _getPrimaryColor(SmartActionType type) {
    return _getBackgroundColor(type);
  }

  IconData _getIcon(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return Icons.payment;
      case SmartActionType.checkStatus:
        return Icons.assignment_turned_in;
      case SmartActionType.create:
        return Icons.add_circle_outline;
      case SmartActionType.join:
        return Icons.login;
      case SmartActionType.wait:
        return Icons.calendar_today;
    }
  }

  String _getLabel(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return 'Action Required';
      case SmartActionType.checkStatus:
        return 'Upcoming Event';
      case SmartActionType.create:
        return 'Start New';
      case SmartActionType.join:
        return 'Join Event';
      case SmartActionType.wait:
        return 'Next Up';
    }
  }

  String _getButtonText(SmartActionType type) {
    switch (type) {
      case SmartActionType.pay:
        return '今すぐ支払う';
      case SmartActionType.checkStatus:
        return '状況を確認';
      case SmartActionType.create:
        return 'イベントを作成';
      case SmartActionType.join:
        return '参加コードを入力';
      case SmartActionType.wait:
        return '詳細を見る';
    }
  }
}
