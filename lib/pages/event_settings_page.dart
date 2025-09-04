import 'package:flutter/material.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class EventSettingsPage extends StatefulWidget {
  final String eventId;

  const EventSettingsPage({super.key, required this.eventId});

  @override
  State<EventSettingsPage> createState() => _EventSettingsPageState();
}

class _EventSettingsPageState extends State<EventSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント設定'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 64,
              color: AppTheme.mutedForeground,
            ),
            SizedBox(height: AppTheme.spacing16),
            Text('イベント設定画面', style: AppTheme.headlineMedium),
            SizedBox(height: AppTheme.spacing8),
            Text(
              'イベント情報の編集、\n参加者管理、削除等の機能を実装予定',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }
}
