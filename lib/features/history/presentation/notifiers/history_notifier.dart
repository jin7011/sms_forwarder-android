import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/util/logger.dart';
import '../../data/sms_history_repository.dart';
import '../../domain/models/history_state.dart';

class HistoryNotifier extends StateNotifier<HistoryState> {
  final SmsHistoryRepository _historyRepo;
  final _logger = AppLogger();

  HistoryNotifier(this._historyRepo) : super(HistoryState.initial());

  /// 메시지 목록 로드
  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true);
    try {
      final messages = await _historyRepo.getAll();
      state = state.copyWith(
        messages: messages,
        isLoading: false,
      );
      _logger.d('HistoryNotifier: ${messages.length}개 메시지 로드');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '메시지 로드 실패: $e',
      );
    }
  }

  /// 단일 메시지 삭제
  Future<void> deleteMessage(String id) async {
    await _historyRepo.delete(id);
    await loadMessages();
    _logger.d('HistoryNotifier: 메시지 삭제 - $id');
  }

  /// 전체 기록 삭제
  Future<void> clearAll() async {
    await _historyRepo.clearAll();
    state = state.copyWith(messages: []);
    _logger.i('HistoryNotifier: 전체 기록 삭제');
  }
}
