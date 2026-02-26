import '../../core/common/result/result.dart';
import '../../core/util/logger.dart';
import '../../features/history/domain/models/sms_message_model.dart';
import '../../features/history/data/sms_history_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import 'slack_service.dart';

class MmsForwardingService {
  final SlackService _slackService;
  final SmsHistoryRepository _historyRepo;
  final SettingsRepository _settingsRepo;
  final _logger = AppLogger();

  MmsForwardingService({
    required SlackService slackService,
    required SmsHistoryRepository historyRepo,
    required SettingsRepository settingsRepo,
  })  : _slackService = slackService,
        _historyRepo = historyRepo,
        _settingsRepo = settingsRepo;

  /// MMS 수신 처리
  Future<void> handleIncomingMms({
    required String sender,
    required String body,
  }) async {
    _logger.i('[MMS] handleIncomingMms 시작 - 발신자: $sender, 내용길이: ${body.length}자');

    final webhookUrl = await _settingsRepo.getWebhookUrl();
    final isEnabled = await _settingsRepo.isForwardingEnabled();

    _logger.d('[MMS] 설정 확인 - 포워딩활성화: $isEnabled, webhookUrl: ${webhookUrl.isNotEmpty ? "설정됨" : "미설정"}');

    if (!isEnabled || webhookUrl.isEmpty) {
      _logger.w('[MMS] 포워딩 중단 - ${!isEnabled ? "비활성화 상태" : "Webhook URL 미설정"}');
      return;
    }

    final now = DateTime.now();
    final id = 'mms_${now.millisecondsSinceEpoch}';

    // 1. 기록에 pending 상태로 저장
    final model = SmsMessageModel(
      id: id,
      sender: sender,
      body: body,
      receivedAt: now,
      status: ForwardStatus.pending,
    );
    await _historyRepo.save(model);
    _logger.d('[MMS] 히스토리 저장 완료 - id: $id, status: pending');

    // 2. Slack으로 전송 (헤더를 MMS로 표시)
    final deviceName = await _settingsRepo.getDeviceName();
    final phoneNumber = await _settingsRepo.getPhoneNumber();
    _logger.i('[MMS] Slack 전송 시도 - 발신자: $sender, 기기: $deviceName');

    final result = await _slackService.sendMmsMessage(
      webhookUrl: webhookUrl,
      sender: sender,
      body: body,
      timestamp: now,
      deviceName: deviceName,
      phoneNumber: phoneNumber,
    );

    // 3. 결과에 따라 상태 업데이트
    if (result.isSuccess) {
      await _historyRepo.updateStatus(
        id,
        ForwardStatus.success,
        forwardedAt: DateTime.now(),
      );
      _logger.i('[MMS] Slack 전송 성공 - id: $id');
    } else {
      await _historyRepo.updateStatus(
        id,
        ForwardStatus.failed,
        errorMessage: result.errorMessage,
      );
      _logger.e('[MMS] Slack 전송 실패 - id: $id, 에러: ${result.errorMessage}');
    }
  }
}
