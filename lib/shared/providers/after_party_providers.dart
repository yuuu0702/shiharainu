import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/services/after_party_service.dart';

/// AfterPartyServiceのプロバイダー
final afterPartyServiceProvider = Provider<AfterPartyService>((ref) {
  return AfterPartyService();
});

/// 二次会一覧を取得するプロバイダー
final afterPartiesProvider = FutureProvider.family<List<EventModel>, String>((
  ref,
  parentEventId,
) async {
  final afterPartyService = ref.watch(afterPartyServiceProvider);
  return afterPartyService.getAfterParties(parentEventId);
});
