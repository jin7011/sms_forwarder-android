import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/common/result/result.dart';
import '../../../../core/util/logger.dart';
import '../../../../shared/services/slack_service.dart';
import '../../../../shared/services/sms_listener_service.dart';
import '../../data/settings_repository.dart';
import '../../domain/models/settings_state.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsRepository _settingsRepo;
  final SlackService _slackService;
  final SmsListenerService _smsListener;
  final _logger = AppLogger();

  SettingsNotifier({
    required SettingsRepository settingsRepo,
    required SlackService slackService,
    required SmsListenerService smsListener,
  })  : _settingsRepo = settingsRepo,
        _slackService = slackService,
        _smsListener = smsListener,
        super(SettingsState.initial());

  /// 설정 로드
  Future<void> loadSettings() async {
    final webhookUrl = await _settingsRepo.getWebhookUrl();
    final isEnabled = await _settingsRepo.isForwardingEnabled();
    final hasPermission = await _smsListener.hasPermission();
    var deviceName = await _settingsRepo.getDeviceName();
    final phoneNumber = await _settingsRepo.getPhoneNumber();

    // 기기 이름이 비어있으면 자동 감지
    if (deviceName.isEmpty) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
        await _settingsRepo.setDeviceName(deviceName);
        _logger.i('SettingsNotifier: 기기 이름 자동 감지 - $deviceName');
      } catch (e) {
        _logger.e('SettingsNotifier: 기기 정보 자동 감지 실패', e);
      }
    }

    String? version;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version = '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (_) {
      version = '1.0.0';
    }

    state = state.copyWith(
      webhookUrl: webhookUrl,
      isWebhookValid: _settingsRepo.isValidWebhookUrl(webhookUrl),
      isForwardingEnabled: isEnabled,
      hasSmsPermission: hasPermission,
      deviceName: deviceName,
      phoneNumber: phoneNumber,
      appVersion: version,
    );
  }

  /// 테스트 메시지 전송
  Future<void> testWebhook() async {
    if (!state.isWebhookValid) {
      state = state.copyWith(testResult: 'Webhook URL이 유효하지 않습니다.');
      return;
    }

    state = state.copyWith(isTestingWebhook: true, testResult: null);

    final result = await _slackService.sendTestMessage(
      webhookUrl: state.webhookUrl,
      deviceName: state.deviceName,
      phoneNumber: state.phoneNumber,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isTestingWebhook: false,
        testResult: '테스트 메시지 전송 성공!',
      );
    } else {
      state = state.copyWith(
        isTestingWebhook: false,
        testResult: '전송 실패: ${result.errorMessage}',
      );
    }
  }

  /// Webhook URL 저장
  Future<void> saveWebhookUrl(String url) async {
    await _settingsRepo.setWebhookUrl(url);
    state = state.copyWith(
      webhookUrl: url,
      isWebhookValid: _settingsRepo.isValidWebhookUrl(url),
      testResult: null,
    );
  }

  /// 기기 이름 저장
  Future<void> saveDeviceName(String name) async {
    await _settingsRepo.setDeviceName(name);
    state = state.copyWith(deviceName: name);
  }

  /// 전화번호 저장
  Future<void> savePhoneNumber(String number) async {
    await _settingsRepo.setPhoneNumber(number);
    state = state.copyWith(phoneNumber: number);
  }

  /// SMS 권한 요청
  Future<void> requestSmsPermission() async {
    final granted = await _smsListener.requestPermission();
    state = state.copyWith(hasSmsPermission: granted);
  }
}
