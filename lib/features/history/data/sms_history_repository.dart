import 'package:hive_flutter/hive_flutter.dart';
import '../domain/models/sms_message_model.dart';
import '../../../core/util/logger.dart';

class SmsHistoryRepository {
  static const String _boxName = 'sms_history';
  final _logger = AppLogger();

  Future<Box<SmsMessageModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<SmsMessageModel>(_boxName);
    }
    return Hive.box<SmsMessageModel>(_boxName);
  }

  /// 메시지 저장
  Future<void> save(SmsMessageModel message) async {
    final box = await _getBox();
    await box.put(message.id, message);
    _logger.d('SmsHistoryRepository: 메시지 저장 완료 - ${message.id}');
  }

  /// 모든 메시지 가져오기 (최신순)
  Future<List<SmsMessageModel>> getAll() async {
    final box = await _getBox();
    final messages = box.values.toList();
    messages.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    return messages;
  }

  /// 오늘 전송 건수
  Future<int> getTodayCount() async {
    final box = await _getBox();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return box.values
        .where((m) =>
            m.receivedAt.isAfter(today) && m.status == ForwardStatus.success)
        .length;
  }

  /// 실패 건수
  Future<int> getFailedCount() async {
    final box = await _getBox();
    return box.values.where((m) => m.status == ForwardStatus.failed).length;
  }

  /// 전체 성공 건수
  Future<int> getTotalSuccessCount() async {
    final box = await _getBox();
    return box.values.where((m) => m.status == ForwardStatus.success).length;
  }

  /// 메시지 상태 업데이트
  Future<void> updateStatus(
    String id,
    ForwardStatus status, {
    DateTime? forwardedAt,
    String? errorMessage,
  }) async {
    final box = await _getBox();
    final message = box.get(id);
    if (message != null) {
      message.status = status;
      message.forwardedAt = forwardedAt;
      message.errorMessage = errorMessage;
      await message.save();
    }
  }

  /// 단일 메시지 삭제
  Future<void> delete(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  /// 전체 삭제
  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
    _logger.i('SmsHistoryRepository: 전체 기록 삭제 완료');
  }

  /// 마지막 메시지 가져오기
  Future<SmsMessageModel?> getLastMessage() async {
    final messages = await getAll();
    return messages.isNotEmpty ? messages.first : null;
  }
}
