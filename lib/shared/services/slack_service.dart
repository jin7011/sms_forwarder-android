import 'package:dio/dio.dart';
import '../../core/common/result/result.dart';
import '../../core/util/logger.dart';

class SlackService {
  final Dio _dio;
  final _logger = AppLogger();

  SlackService(this._dio);

  /// Slack Webhook으로 SMS 메시지 전송
  Future<Result<bool>> sendMessage({
    required String webhookUrl,
    required String sender,
    required String body,
    required DateTime timestamp,
    String? deviceName,
    String? phoneNumber,
  }) async {
    try {
      final formattedTime =
          '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';

      // 기기 정보 텍스트 생성
      final deviceLabel = _buildDeviceLabel(deviceName, phoneNumber);

      final response = await _dio.post(
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
            {
              'type': 'divider',
            },
          ],
        },
      );

      if (response.statusCode == 200) {
        _logger.i('SlackService: 메시지 전송 성공');
        return const Success(true);
      } else {
        _logger.e('SlackService: 전송 실패 - ${response.statusCode}');
        return Error('HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('SlackService: 네트워크 에러 - ${e.message}', e);
      return Error('전송 실패: ${e.message}');
    } catch (e) {
      _logger.e('SlackService: 예상치 못한 에러 - $e');
      return Error('전송 실패: $e');
    }
  }

  /// 기기 정보 라벨 생성
  String _buildDeviceLabel(String? deviceName, String? phoneNumber) {
    final parts = <String>[];
    if (deviceName != null && deviceName.isNotEmpty) {
      parts.add(deviceName);
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      parts.add(phoneNumber);
    }
    if (parts.isEmpty) return '미설정';
    return parts.join(' | ');
  }

  /// Slack Webhook으로 MMS 메시지 전송
  Future<Result<bool>> sendMmsMessage({
    required String webhookUrl,
    required String sender,
    required String body,
    required DateTime timestamp,
    String? deviceName,
    String? phoneNumber,
  }) async {
    try {
      final formattedTime =
          '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
          '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';

      final deviceLabel = _buildDeviceLabel(deviceName, phoneNumber);

      final response = await _dio.post(
        webhookUrl,
        data: {
          'blocks': [
            {
              'type': 'header',
              'text': {
                'type': 'plain_text',
                'text': 'MMS 수신',
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
            {
              'type': 'divider',
            },
          ],
        },
      );

      if (response.statusCode == 200) {
        _logger.i('SlackService: MMS 메시지 전송 성공');
        return const Success(true);
      } else {
        _logger.e('SlackService: MMS 전송 실패 - ${response.statusCode}');
        return Error('HTTP ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('SlackService: 네트워크 에러 - ${e.message}', e);
      return Error('전송 실패: ${e.message}');
    } catch (e) {
      _logger.e('SlackService: 예상치 못한 에러 - $e');
      return Error('전송 실패: $e');
    }
  }

  /// 테스트 메시지 전송
  Future<Result<bool>> sendTestMessage({
    required String webhookUrl,
    String? deviceName,
    String? phoneNumber,
  }) async {
    return sendMessage(
      webhookUrl: webhookUrl,
      sender: '테스트',
      body: 'SMS Forwarder 테스트 메시지입니다. 정상 연결되었습니다!',
      timestamp: DateTime.now(),
      deviceName: deviceName,
      phoneNumber: phoneNumber,
    );
  }
}
