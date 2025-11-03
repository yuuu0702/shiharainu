import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/constants/app_theme.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/services/event_service.dart';
import 'package:shiharainu/shared/services/participant_service.dart';
import 'package:shiharainu/shared/widgets/widgets.dart';

class EventParticipantManagementPage extends ConsumerWidget {
  final String eventId;

  const EventParticipantManagementPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventStreamProvider(eventId));
    final participantsAsync = ref.watch(eventParticipantsStreamProvider(eventId));
    final isOrganizerAsync = ref.watch(isEventOrganizerProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('参加者管理'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: eventAsync.when(
        data: (event) {
          return participantsAsync.when(
            data: (participants) {
              return isOrganizerAsync.when(
                data: (isOrganizer) {
                  return _buildContent(
                    context,
                    ref,
                    event,
                    participants,
                    isOrganizer,
                  );
                },
                loading: () => _buildLoading(),
                error: (error, stack) => _buildError(error),
              );
            },
            loading: () => _buildLoading(),
            error: (error, stack) => _buildError(error),
          );
        },
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(error),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.destructive),
          const SizedBox(height: AppTheme.spacing16),
          Text('データの取得に失敗しました', style: AppTheme.headlineMedium),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            error.toString(),
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    EventModel event,
    List<ParticipantModel> participants,
    bool isOrganizer,
  ) {
    if (participants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppTheme.mutedForeground,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              '参加者がいません',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              '招待コードを共有して参加者を招待しましょう',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
          child: _ParticipantCard(
            participant: participant,
            eventId: eventId,
            isOrganizer: isOrganizer,
          ),
        );
      },
    );
  }
}

class _ParticipantCard extends ConsumerWidget {
  final ParticipantModel participant;
  final String eventId;
  final bool isOrganizer;

  const _ParticipantCard({
    required this.participant,
    required this.eventId,
    required this.isOrganizer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            participant.displayName,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          if (participant.role == ParticipantRole.organizer)
                            AppBadge(
                              text: '主催者',
                              variant: AppBadgeVariant.default_,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        participant.email,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOrganizer)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _showEditDialog(context, ref);
                          break;
                        case 'toggle_role':
                          _handleToggleRole(context, ref);
                          break;
                        case 'remove':
                          _handleRemove(context, ref);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: AppTheme.spacing8),
                            Text('情報を編集'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle_role',
                        child: Row(
                          children: [
                            const Icon(Icons.swap_horiz),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              participant.role == ParticipantRole.organizer
                                  ? '参加者に変更'
                                  : '主催者に変更',
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppTheme.destructive),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              '削除',
                              style: TextStyle(color: AppTheme.destructive),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            const Divider(),
            const SizedBox(height: AppTheme.spacing12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    '年齢',
                    participant.age != null ? '${participant.age}歳' : '未設定',
                    Icons.cake_outlined,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    '性別',
                    _getGenderLabel(participant.gender),
                    Icons.person_outline,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    '役職',
                    participant.position ?? '未設定',
                    Icons.work_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.mutedForeground),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getGenderLabel(ParticipantGender gender) {
    switch (gender) {
      case ParticipantGender.male:
        return '男性';
      case ParticipantGender.female:
        return '女性';
      case ParticipantGender.other:
        return 'その他';
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _EditParticipantDialog(
        participant: participant,
        eventId: eventId,
      ),
    );
  }

  Future<void> _handleToggleRole(BuildContext context, WidgetRef ref) async {
    final newRole = participant.role == ParticipantRole.organizer
        ? ParticipantRole.participant
        : ParticipantRole.organizer;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('役割変更'),
        content: Text(
          '${participant.displayName}を${newRole == ParticipantRole.organizer ? '主催者' : '参加者'}に変更しますか?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          AppButton.primary(
            text: '変更',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final participantService = ref.read(participantServiceProvider);
        await participantService.updateParticipantRole(
          eventId: eventId,
          participantId: participant.id,
          newRole: newRole,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${participant.displayName}の役割を変更しました'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('役割の変更に失敗しました: $e'),
              backgroundColor: AppTheme.destructive,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleRemove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('参加者削除'),
        content: Text(
          '${participant.displayName}を削除しますか?\n\nこの操作は取り消せません。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          AppButton(
            text: '削除',
            variant: AppButtonVariant.primary,
            isDestructive: true,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final participantService = ref.read(participantServiceProvider);
        await participantService.removeParticipant(
          eventId: eventId,
          participantId: participant.id,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${participant.displayName}を削除しました'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('削除に失敗しました: $e'),
              backgroundColor: AppTheme.destructive,
            ),
          );
        }
      }
    }
  }
}

class _EditParticipantDialog extends HookConsumerWidget {
  final ParticipantModel participant;
  final String eventId;

  const _EditParticipantDialog({
    required this.participant,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayNameController = useTextEditingController(
      text: participant.displayName,
    );
    final ageController = useTextEditingController(
      text: participant.age?.toString() ?? '',
    );
    final positionController = useTextEditingController(
      text: participant.position ?? '',
    );
    final selectedGender = useState<ParticipantGender>(participant.gender);
    final isDrinker = useState<bool>(participant.isDrinker);
    final isLoading = useState<bool>(false);

    Future<void> handleSave() async {
      if (isLoading.value) return;

      final displayName = displayNameController.text.trim();
      if (displayName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('表示名を入力してください'),
            backgroundColor: AppTheme.destructive,
          ),
        );
        return;
      }

      int? age;
      final ageText = ageController.text.trim();
      if (ageText.isNotEmpty) {
        age = int.tryParse(ageText);
        if (age == null || age < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('年齢は0以上の数値を入力してください'),
              backgroundColor: AppTheme.destructive,
            ),
          );
          return;
        }
      }

      isLoading.value = true;

      try {
        final participantService = ref.read(participantServiceProvider);
        await participantService.updateParticipant(
          eventId: eventId,
          participantId: participant.id,
          displayName: displayName,
          age: age,
          position: positionController.text.trim().isEmpty
              ? null
              : positionController.text.trim(),
          gender: selectedGender.value,
          isDrinker: isDrinker.value,
        );

        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('参加者情報を更新しました'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('更新に失敗しました: $e'),
              backgroundColor: AppTheme.destructive,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return AlertDialog(
      title: const Text('参加者情報編集'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInput(
              label: '表示名',
              controller: displayNameController,
              isRequired: true,
              placeholder: '表示名を入力',
            ),
            const SizedBox(height: AppTheme.spacing16),
            AppInput(
              label: '年齢',
              controller: ageController,
              placeholder: '年齢を入力',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppTheme.spacing16),
            AppInput(
              label: '役職',
              controller: positionController,
              placeholder: '役職を入力',
            ),
            const SizedBox(height: AppTheme.spacing16),
            AppSelect<ParticipantGender>(
              label: '性別',
              value: selectedGender.value,
              items: [
                DropdownMenuItem(
                  value: ParticipantGender.male,
                  child: const Text('男性'),
                ),
                DropdownMenuItem(
                  value: ParticipantGender.female,
                  child: const Text('女性'),
                ),
                DropdownMenuItem(
                  value: ParticipantGender.other,
                  child: const Text('その他'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  selectedGender.value = value;
                }
              },
            ),
            const SizedBox(height: AppTheme.spacing16),
            Row(
              children: [
                Checkbox(
                  value: isDrinker.value,
                  onChanged: (value) {
                    if (value != null) {
                      isDrinker.value = value;
                    }
                  },
                ),
                const Text('飲酒する'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading.value ? null : () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        AppButton.primary(
          text: '保存',
          onPressed: isLoading.value ? null : handleSave,
          isLoading: isLoading.value,
        ),
      ],
    );
  }
}
