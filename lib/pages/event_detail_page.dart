import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  // TODO: 実際のデータはRiverpodプロバイダーから取得
  late EventDetailData _eventData;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  void _loadEventData() {
    // TODO: 実際のデータ取得処理
    _eventData = EventDetailData(
      id: widget.eventId,
      title: '新年会2024',
      description: '会社の新年会です。皆さんでお疲れ様でした。今年も一年間ありがとうございました。',
      date: DateTime.now().add(const Duration(days: 7)),
      location: '銀座の居酒屋「○○」',
      budget: 4000,
      participantCount: 15,
      maxParticipants: 20,
      role: ParticipantRole.organizer,
      status: EventStatus.active,
      organizer: ParticipantData(
        id: 'organizer1',
        name: '田中太郎',
        email: 'tanaka@example.com',
        paymentStatus: PaymentStatus.paid,
      ),
      participants: [
        ParticipantData(
          id: 'p1',
          name: '佐藤花子',
          email: 'sato@example.com',
          paymentStatus: PaymentStatus.paid,
        ),
        ParticipantData(
          id: 'p2',
          name: '鈴木一郎',
          email: 'suzuki@example.com',
          paymentStatus: PaymentStatus.pending,
        ),
        ParticipantData(
          id: 'p3',
          name: '高橋美咲',
          email: 'takahashi@example.com',
          paymentStatus: PaymentStatus.unpaid,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_eventData.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: _eventData.role == ParticipantRole.organizer
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton.outline(
                    text: '設定',
                    icon: const Icon(Icons.settings_outlined, size: 18),
                    onPressed: () =>
                        context.go('/events/${widget.eventId}/settings'),
                  ),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventHeader(),
            const SizedBox(height: AppTheme.spacing24),
            _buildActionCards(),
            const SizedBox(height: AppTheme.spacing32),
            _buildEventInfo(),
            const SizedBox(height: AppTheme.spacing32),
            _buildParticipantsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(_eventData.title, style: AppTheme.headlineLarge),
              ),
              _buildStatusBadge(_eventData.status),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(_eventData.description, style: AppTheme.bodyLarge),
          const SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                _formatFullDate(_eventData.date),
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                _eventData.location,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 20,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                '¥${_eventData.budget.toStringAsFixed(0)}',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return ResponsiveGrid(
      mobileColumns: 2,
      tabletColumns: 3,
      desktopColumns: 4,
      spacing: AppTheme.spacing16,
      children: _eventData.role == ParticipantRole.organizer
          ? _buildOrganizerActions()
          : _buildParticipantActions(),
    );
  }

  List<Widget> _buildOrganizerActions() {
    return [
      _buildActionCard(
        '支払い管理',
        Icons.payment_outlined,
        AppTheme.successColor,
        '支払い状況を確認',
        () => context.go('/events/${widget.eventId}/payments'),
      ),
      _buildActionCard(
        '参加者管理',
        Icons.people_outlined,
        AppTheme.primaryColor,
        '参加者を管理',
        () {
          // TODO: 参加者管理画面へ
        },
      ),
      _buildActionCard(
        '招待リンク',
        Icons.share_outlined,
        const Color(0xFF8B5CF6),
        'リンクをシェア',
        () {
          // TODO: 招待リンクシェア機能
        },
      ),
      _buildActionCard(
        'イベント編集',
        Icons.edit_outlined,
        AppTheme.warningColor,
        'イベント情報編集',
        () => context.go('/events/${widget.eventId}/settings'),
      ),
    ];
  }

  List<Widget> _buildParticipantActions() {
    return [
      _buildActionCard(
        '支払い確認',
        Icons.payment_outlined,
        AppTheme.successColor,
        '自分の支払い状況',
        () => context.go('/events/${widget.eventId}/payments'),
      ),
      _buildActionCard(
        'イベント詳細',
        Icons.info_outlined,
        AppTheme.primaryColor,
        '詳細情報を確認',
        () {
          // TODO: イベント詳細情報
        },
      ),
    ];
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return AppCard.interactive(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            title,
            style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            description,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.mutedForeground),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('イベント情報', style: AppTheme.headlineMedium),
        const SizedBox(height: AppTheme.spacing16),
        AppCard(
          child: Column(
            children: [
              _buildInfoRow(
                '参加人数',
                '${_eventData.participantCount}/${_eventData.maxParticipants}人',
              ),
              const Divider(),
              _buildInfoRow('予算', '¥${_eventData.budget.toStringAsFixed(0)}'),
              const Divider(),
              _buildInfoRow('幹事', _eventData.organizer.name),
              const Divider(),
              _buildInfoRow(
                '作成日',
                _formatFullDate(
                  _eventData.date.subtract(const Duration(days: 30)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
      child: Row(
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection() {
    final paidCount =
        _eventData.participants
            .where((p) => p.paymentStatus == PaymentStatus.paid)
            .length +
        1; // +1 for organizer
    final unpaidCount = _eventData.participants.length + 1 - paidCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('参加者', style: AppTheme.headlineMedium),
            const Spacer(),
            AppBadge(text: '支払済 $paidCount', variant: AppBadgeVariant.default_),
            const SizedBox(width: AppTheme.spacing8),
            AppBadge(
              text: '未払 $unpaidCount',
              variant: AppBadgeVariant.destructive,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing16),
        AppCard(
          child: Column(
            children: [
              // 幹事を最初に表示
              AppProfileCard.standard(
                name: _eventData.organizer.name,
                subtitle: '幹事 - 支払済',
                initials: _getInitials(_eventData.organizer.name),
                trailing: AppBadge(
                  text: '幹事',
                  variant: AppBadgeVariant.default_,
                ),
              ),
              if (_eventData.participants.isNotEmpty) const Divider(),
              // 参加者リスト
              ..._eventData.participants.asMap().entries.map((entry) {
                final index = entry.key;
                final participant = entry.value;
                return Column(
                  children: [
                    AppProfileCard.standard(
                      name: participant.name,
                      subtitle: _getPaymentStatusText(
                        participant.paymentStatus,
                      ),
                      initials: _getInitials(participant.name),
                      trailing: _buildPaymentStatusBadge(
                        participant.paymentStatus,
                      ),
                    ),
                    if (index < _eventData.participants.length - 1)
                      const Divider(),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(EventStatus status) {
    switch (status) {
      case EventStatus.planning:
        return AppBadge(text: '企画中', variant: AppBadgeVariant.secondary);
      case EventStatus.active:
        return AppBadge(text: '募集中', variant: AppBadgeVariant.default_);
      case EventStatus.completed:
        return AppBadge(text: '完了', variant: AppBadgeVariant.secondary);
    }
  }

  Widget _buildPaymentStatusBadge(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return AppBadge(text: '支払済', variant: AppBadgeVariant.default_);
      case PaymentStatus.pending:
        return AppBadge(text: '確認中', variant: AppBadgeVariant.warning);
      case PaymentStatus.unpaid:
        return AppBadge(text: '未払', variant: AppBadgeVariant.destructive);
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return '支払い完了';
      case PaymentStatus.pending:
        return '支払い確認中';
      case PaymentStatus.unpaid:
        return '支払い待ち';
    }
  }

  String _getInitials(String name) {
    if (name.length <= 2) return name;
    return name.substring(0, 2);
  }

  String _formatFullDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}

// TODO: 実際のデータモデルはshared/modelsに移動
class EventDetailData {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double budget;
  final int participantCount;
  final int maxParticipants;
  final ParticipantRole role;
  final EventStatus status;
  final ParticipantData organizer;
  final List<ParticipantData> participants;

  const EventDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.budget,
    required this.participantCount,
    required this.maxParticipants,
    required this.role,
    required this.status,
    required this.organizer,
    required this.participants,
  });
}

class ParticipantData {
  final String id;
  final String name;
  final String email;
  final PaymentStatus paymentStatus;

  const ParticipantData({
    required this.id,
    required this.name,
    required this.email,
    required this.paymentStatus,
  });
}

enum PaymentStatus { paid, pending, unpaid }
