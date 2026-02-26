import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_telephony/telephony.dart';

import '../../core/util/logger.dart';
import '../../features/history/domain/models/sms_message_model.dart';

/// 백그라운드 SMS 핸들러 (최상위 함수 - 별도 isolate에서 실행)
@pragma('vm:entry-point')
Future<void> backgroundSmsHandler(SmsMessage message) async {
  // 백그라운드 isolate에서는 Riverpod 사용 불가
  // 직접 SharedPreferences + Hive + Dio 사용

  try {
    final prefs = await SharedPreferences.getInstance();
    final webhookUrl = prefs.getString('webhook_url') ?? '';
    final isEnabled = prefs.getBool('forwarding_enabled') ?? false;
    final deviceName = prefs.getString('device_name') ?? '';
    final phoneNumber = prefs.getString('phone_number') ?? '';

    if (!isEnabled || webhookUrl.isEmpty) return;

    final sender = message.address ?? '알 수 없음';
    final body = message.body ?? '';
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();

    // Hive 초기화 (백그라운드 isolate에서 필요)
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ForwardStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SmsMessageModelAdapter());
    }

    final box = await Hive.openBox<SmsMessageModel>('sms_history');

    // 기록 저장
    final model = SmsMessageModel(
      id: id,
      sender: sender,
      body: body,
      receivedAt: now,
      status: ForwardStatus.pending,
    );
    await box.put(id, model);

    // Slack 전송
    final dio = Dio();
    final formattedTime =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    // 기기 라벨 생성
    final deviceParts = <String>[];
    if (deviceName.isNotEmpty) deviceParts.add(deviceName);
    if (phoneNumber.isNotEmpty) deviceParts.add(phoneNumber);
    final deviceLabel = deviceParts.isEmpty ? '미설정' : deviceParts.join(' | ');

    try {
      await dio.post(
        webhookUrl,
        data: {
          'blocks': [
            {
              'type': 'header',
              'text': {
                'type': 'plain_text',
                'text': 'SMS 수신',
                'emoji': true,
              },
            },
            {
              'type': 'context',
              'elements': [
                {'type': 'mrkdwn', 'text': ':iphone: *수신 기기:* $deviceLabel'},
              ],
            },
            {
              'type': 'section',
              'fields': [
                {'type': 'mrkdwn', 'text': '*발신자:*\n$sender'},
                {'type': 'mrkdwn', 'text': '*시간:*\n$formattedTime'},
              ],
            },
            {
              'type': 'section',
              'text': {'type': 'mrkdwn', 'text': '*내용:*\n$body'},
            },
            {'type': 'divider'},
          ],
        },
      );

      model.status = ForwardStatus.success;
      model.forwardedAt = DateTime.now();
      await model.save();
    } catch (e) {
      model.status = ForwardStatus.failed;
      model.errorMessage = e.toString();
      await model.save();
    }
  } catch (e) {
    // 백그라운드에서의 에러는 조용히 무시 (로그 불가)
  }
}

class SmsListenerService {
  final Telephony _telephony = Telephony.instance;
  final _logger = AppLogger();

  /// SMS 권한 요청
  Future<bool> requestPermission() async {
    final result = await _telephony.requestSmsPermissions;
    _logger.i('SmsListenerService: SMS 권한 결과 - $result');
    return result ?? false;
  }

  /// SMS 권한 확인
  Future<bool> hasPermission() async {
    final result = await _telephony.requestSmsPermissions;
    return result ?? false;
  }

  /// 포그라운드 SMS 리스닝 시작
  void startListening({
    required void Function(SmsMessage) onMessage,
  }) {
    _telephony.listenIncomingSms(
      onNewMessage: onMessage,
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
    _logger.i('SmsListenerService: SMS 리스닝 시작');
  }
}
