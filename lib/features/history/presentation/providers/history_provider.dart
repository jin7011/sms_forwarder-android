import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/providers.dart';
import '../../domain/models/history_state.dart';
import '../notifiers/history_notifier.dart';

final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final historyRepo = ref.watch(smsHistoryRepositoryProvider);
  return HistoryNotifier(historyRepo);
});
