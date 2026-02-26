import 'dart:async';
import 'package:flutter/services.dart';
import '../../core/util/logger.dart';

class MmsListenerService {
  static const _eventChannel =
      EventChannel('com.jaden.sms_forwarder/mms_events');
  static const _methodChannel =
      MethodChannel('com.jaden.sms_forwarder/mms_service');

  final _logger = AppLogger();
  StreamSubscription? _subscription;

  /// MMS Foreground Service 시작
  Future<void> startService() async {
    try {
      _logger.i('[MMS] Foreground Service 시작 요청...');
      await _methodChannel.invokeMethod('startService');
      _logger.i('[MMS] Foreground Service 시작 완료');
    } catch (e) {
      _logger.e('[MMS] Foreground Service 시작 실패: $e', e);
    }
  }

  /// MMS Foreground Service 중지
  Future<void> stopService() async {
    try {
      _logger.i('[MMS] Foreground Service 중지 요청...');
      await _methodChannel.invokeMethod('stopService');
      _logger.i('[MMS] Foreground Service 중지 완료');
    } catch (e) {
      _logger.e('[MMS] Foreground Service 중지 실패: $e', e);
    }
  }

  /// MMS 이벤트 리스닝 시작
  void startListening({
    required void Function(String sender, String body) onMmsReceived,
  }) {
    _subscription?.cancel();
    _logger.i('[MMS] EventChannel 리스닝 시작...');

    _subscription = _eventChannel.receiveBroadcastStream().listen(
      (event) {
        _logger.d('[MMS] EventChannel 이벤트 수신: ${event.runtimeType}');

        if (event is Map) {
          final sender = event['sender'] as String? ?? '알 수 없음';
          final body = event['body'] as String? ?? '';
          _logger.i('[MMS] 이벤트 파싱 - 발신자: $sender, 내용 길이: ${body.length}자');

          if (body.isNotEmpty) {
            _logger.i('[MMS] 콜백 호출 - 발신자: $sender, 미리보기: "${body.length > 50 ? '${body.substring(0, 50)}...' : body}"');
            onMmsReceived(sender, body);
          } else {
            _logger.w('[MMS] 빈 body - 무시됨 (발신자: $sender)');
          }
        } else {
          _logger.w('[MMS] 예상하지 않은 이벤트 타입: ${event.runtimeType}');
        }
      },
      onError: (error) {
        _logger.e('[MMS] EventChannel 에러: $error', error);
      },
      onDone: () {
        _logger.w('[MMS] EventChannel 스트림 종료됨');
      },
    );
    _logger.i('[MMS] EventChannel 리스닝 등록 완료');
  }

  /// 리스닝 중지
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _logger.i('[MMS] EventChannel 리스닝 중지');
  }

  /// 백그라운드에서 쌓인 pending MMS 가져오기
  Future<List<Map<String, String>>> getPendingMms() async {
    try {
      _logger.d('[MMS] Pending MMS 조회 요청...');
      final result = await _methodChannel.invokeMethod('getPendingMms');

      if (result is List) {
        final parsed = result.map((item) {
          if (item is Map) {
            return item.map((k, v) => MapEntry(k.toString(), v.toString()));
          }
          return <String, String>{};
        }).where((m) => m.isNotEmpty).toList();

        _logger.i('[MMS] Pending MMS ${parsed.length}건 가져옴');
        for (var i = 0; i < parsed.length; i++) {
          _logger.d('[MMS] Pending[$i]: 발신자=${parsed[i]['sender']}, 내용길이=${parsed[i]['body']?.length ?? 0}자');
        }
        return parsed;
      }

      _logger.d('[MMS] Pending MMS 없음 (result 타입: ${result.runtimeType})');
    } catch (e) {
      _logger.e('[MMS] Pending MMS 가져오기 실패: $e', e);
    }
    return [];
  }
}
