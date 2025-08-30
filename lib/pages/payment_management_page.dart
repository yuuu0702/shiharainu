import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';

class PaymentManagementPage extends StatefulWidget {
  const PaymentManagementPage({super.key});

  @override
  State<PaymentManagementPage> createState() => _PaymentManagementPageState();
}

class _PaymentManagementPageState extends State<PaymentManagementPage> {
  // モックデータ（将来的にはRiverpod Providerで管理）
  final List<ParticipantPayment> participants = [
    ParticipantPayment(
      id: '1',
      name: '田中太郎',
      amount: 5000,
      isPaid: true,
      role: '部長',
      age: 45,
      drinkingStatus: true,
    ),
    ParticipantPayment(
      id: '2',
      name: '佐藤花子',
      amount: 4000,
      isPaid: false,
      role: '主任',
      age: 35,
      drinkingStatus: true,
    ),
    ParticipantPayment(
      id: '3',
      name: '山田次郎',
      amount: 3000,
      isPaid: true,
      role: '一般',
      age: 25,
      drinkingStatus: false,
    ),
    ParticipantPayment(
      id: '4',
      name: '鈴木美穂',
      amount: 3000,
      isPaid: false,
      role: '一般',
      age: 28,
      drinkingStatus: true,
    ),
  ];

  int get totalParticipants => participants.length;
  int get paidCount => participants.where((p) => p.isPaid).length;
  int get unpaidCount => totalParticipants - paidCount;
  int get totalAmount => participants.fold(0, (sum, p) => sum + p.amount);
  int get paidAmount => participants.where((p) => p.isPaid).fold(0, (sum, p) => sum + p.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支払い管理'),
        leading: AppButton.icon(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          AppButton.icon(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _refreshPaymentStatus,
          ),
        ],
      ),
      body: ResponsivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 支払い状況サマリー
            _buildPaymentSummary(),
            const SizedBox(height: 24),

            // フィルターとソート
            _buildFilterControls(),
            const SizedBox(height: 16),

            // 参加者リスト
            const Text(
              '参加者一覧',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: ResponsiveLayout(
                mobile: _buildMobileList(),
                tablet: _buildTabletGrid(),
                desktop: _buildDesktopGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return ResponsiveLayout(
      mobile: Column(
        children: [
          _buildSummaryCard('支払い完了', '$paidCount人', AppTheme.successColor, Icons.check_circle),
          const SizedBox(height: 12),
          _buildSummaryCard('未支払い', '$unpaidCount人', AppTheme.destructiveColor, Icons.pending),
        ],
      ),
      tablet: Row(
        children: [
          Expanded(child: _buildSummaryCard('支払い完了', '$paidCount人', AppTheme.successColor, Icons.check_circle)),
          const SizedBox(width: 16),
          Expanded(child: _buildSummaryCard('未支払い', '$unpaidCount人', AppTheme.destructiveColor, Icons.pending)),
          const SizedBox(width: 16),
          Expanded(child: _buildSummaryCard('合計金額', '¥${totalAmount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}', AppTheme.primaryColor, Icons.currency_yen)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedForeground,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls() {
    return Row(
      children: [
        AppButton.outline(
          text: 'すべて',
          size: AppButtonSize.small,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        AppButton.outline(
          text: '未支払いのみ',
          size: AppButtonSize.small,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        AppButton.outline(
          text: '支払い済みのみ',
          size: AppButtonSize.small,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      itemCount: participants.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final participant = participants[index];
        return _buildParticipantCard(participant);
      },
    );
  }

  Widget _buildTabletGrid() {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      spacing: 16,
      children: participants.map(_buildParticipantCard).toList(),
    );
  }

  Widget _buildDesktopGrid() {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      spacing: 16,
      children: participants.map(_buildParticipantCard).toList(),
    );
  }

  Widget _buildParticipantCard(ParticipantPayment participant) {
    return AppCard.interactive(
      onTap: () => _togglePaymentStatus(participant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: participant.isPaid 
                  ? AppTheme.successColor 
                  : AppTheme.mutedColor,
                child: Icon(
                  participant.isPaid ? Icons.check : Icons.person,
                  color: participant.isPaid ? Colors.white : AppTheme.mutedForeground,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      participant.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${participant.role} • ${participant.age}歳',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              AppBadge(
                text: participant.isPaid ? '支払い済み' : '未支払い',
                variant: participant.isPaid 
                  ? AppBadgeVariant.success 
                  : AppBadgeVariant.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '¥${participant.amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Row(
                children: [
                  if (participant.drinkingStatus)
                    const Icon(Icons.local_bar, size: 16, color: AppTheme.warningColor),
                  const SizedBox(width: 4),
                  Icon(
                    participant.isPaid ? Icons.check_circle : Icons.schedule,
                    size: 16,
                    color: participant.isPaid ? AppTheme.successColor : AppTheme.mutedForeground,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _togglePaymentStatus(ParticipantPayment participant) {
    setState(() {
      final index = participants.indexWhere((p) => p.id == participant.id);
      if (index != -1) {
        participants[index] = participant.copyWith(isPaid: !participant.isPaid);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${participant.name}の支払い状況を${participant.isPaid ? '未支払い' : '支払い済み'}に更新しました',
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _refreshPaymentStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('支払い状況を更新しました'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }
}

// データモデル（将来的にはlib/shared/models/に移動）
class ParticipantPayment {
  final String id;
  final String name;
  final int amount;
  final bool isPaid;
  final String role;
  final int age;
  final bool drinkingStatus;

  const ParticipantPayment({
    required this.id,
    required this.name,
    required this.amount,
    required this.isPaid,
    required this.role,
    required this.age,
    required this.drinkingStatus,
  });

  ParticipantPayment copyWith({
    String? id,
    String? name,
    int? amount,
    bool? isPaid,
    String? role,
    int? age,
    bool? drinkingStatus,
  }) {
    return ParticipantPayment(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      role: role ?? this.role,
      age: age ?? this.age,
      drinkingStatus: drinkingStatus ?? this.drinkingStatus,
    );
  }
}