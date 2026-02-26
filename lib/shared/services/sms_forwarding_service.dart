import 'package:another_telephony/telephony.dart';
import '../../core/common/result/result.dart';
import '../../core/util/logger.dart';
import '../../features/history/domain/models/sms_message_model.dart';
import '../../features/history/data/sms_history_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import 'slack_service.dart';

class SmsForwardingService {
  final SlackService _slackService;
  final SmsHistoryRepository _historyRepo;
  final SettingsRepository _settingsRepo;
  final _logger = AppLogger();

  SmsForwardingService({
    required SlackService slackService,
    required SmsHistoryRepository historyRepo,
    required SettingsRepository settingsRepo,
  })  : _slackService = slackService,
        _historyRepo = historyRepo,
        _settingsRepo = settingsRepo;

  /// SMS 수신 처리 (포그라운드)
  Future<void> handleIncomingSms(SmsMessage message) async {
    final webhookUrl = await _settingsRepo.getWebhookUrl();
    final isEnabled = await _settingsRepo.isForwardingEnabled();

    if (!isEnabled || webhookUrl.isEmpty) {
      _logger.d('SmsForwardingService: 포워딩 비활성화 또는 URL 미설정');
      return;
    }

    final sender = message.address ?? '알 수 없음';
    final body = message.body ?? '';
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();

    _logger.i('SmsForwardingService: SMS 수신 - 발신자: $sender');

    // 1. 기록에 pending 상태로 저장
    final model = SmsMessageModel(
      id: id,
      sender: sender,
      body: body,
      receivedAt: now,
      status: ForwardStatus.pending,
    );
    await _historyRepo.save(model);

    // 2. Slack으로 전송 (기기 정보 포함)
    final deviceName = await _settingsRepo.getDeviceName();
    final phoneNumber = await _settingsRepo.getPhoneNumber();
    final result = await _slackService.sendMessage(
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
      _logger.i('SmsForwardingService: Slack 전송 성공');
    } else {
      await _historyRepo.updateStatus(
        id,
        ForwardStatus.failed,
        errorMessage: result.errorMessage,
      );
      _logger.e('SmsForwardingService: Slack 전송 실패 - ${result.errorMessage}');
    }
  }
}
