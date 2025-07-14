import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/providers/auth_provider.dart';
import 'package:shiharainu/shared/constants/debug_config.dart';
import 'package:shiharainu/shared/models/user_model.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isOrganizer = ref.watch(isOrganizerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ダッシュボード'),
        actions: [
          if (isOrganizer)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.go('/event-creation');
              },
            ),
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'logout') {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('ログアウト'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ユーザー情報カード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _getRoleColor(currentUser?.role),
                          child: Icon(
                            _getRoleIcon(currentUser?.role),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser?.name ?? 'ユーザー',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getRoleText(currentUser?.role),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              if (currentUser?.position != null)
                                Text(
                                  '${currentUser?.position} ${currentUser?.branch ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (DebugConfig.isDebugMode)
                          Chip(
                            label: const Text('DEBUG'),
                            backgroundColor: Colors.orange,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 機能別セクション
            if (isOrganizer) ...[
              const Text(
                '幹事機能',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'イベント作成',
                    Icons.add_circle,
                    Colors.blue,
                    () => context.go('/event-creation'),
                  ),
                  _buildFeatureCard(
                    context,
                    '支払い管理',
                    Icons.payment,
                    Colors.green,
                    () => context.go('/dashboard'),
                  ),
                  _buildFeatureCard(
                    context,
                    'ランキング',
                    Icons.leaderboard,
                    Colors.orange,
                    () => context.go('/gamification'),
                  ),
                  _buildFeatureCard(
                    context,
                    '二次会管理',
                    Icons.event,
                    Colors.purple,
                    () => context.go('/secondary-event/test'),
                  ),
                ],
              ),
            ] else ...[
              const Text(
                '参加者機能',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    '支払い',
                    Icons.payment,
                    Colors.green,
                    () => context.go('/payment/test'),
                  ),
                  _buildFeatureCard(
                    context,
                    'ランキング',
                    Icons.leaderboard,
                    Colors.orange,
                    () => context.go('/gamification'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(role) {
    switch (role) {
      case UserRole.organizer:
        return Colors.blue;
      case UserRole.participant:
        return Colors.green;
      case UserRole.guest:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(role) {
    switch (role) {
      case UserRole.organizer:
        return Icons.admin_panel_settings;
      case UserRole.participant:
        return Icons.person;
      case UserRole.guest:
        return Icons.person_outline;
      default:
        return Icons.person;
    }
  }

  String _getRoleText(role) {
    switch (role) {
      case UserRole.organizer:
        return '幹事';
      case UserRole.participant:
        return '参加者';
      case UserRole.guest:
        return 'ゲスト';
      default:
        return 'ユーザー';
    }
  }
}