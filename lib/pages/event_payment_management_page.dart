import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class EventPaymentManagementPage extends StatefulWidget {
  final String eventId;

  const EventPaymentManagementPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventPaymentManagementPage> createState() => _EventPaymentManagementPageState();
}

class _EventPaymentManagementPageState extends State<EventPaymentManagementPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsivePageScaffold(
      title: '支払い管理',
      navigationItems: const [],
      currentRoute: '/events/${widget.eventId}/payments',
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: AppTheme.mutedForeground,
            ),
            SizedBox(height: AppTheme.spacing16),
            Text(
              'イベント専用支払い管理画面',
              style: AppTheme.headlineMedium,
            ),
            SizedBox(height: AppTheme.spacing8),
            Text(
              '既存のPaymentManagementPageを\nこのイベント専用に再設計予定',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}