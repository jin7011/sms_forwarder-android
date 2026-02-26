import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:another_telephony/telephony.dart';
import '../../../../core/util/logger.dart';
import '../../../../features/history/data/sms_history_repository.dart';
import '../../../../features/settings/data/settings_repository.dart';
import '../../../../shared/services/sms_forwarding_service.dart';
import '../../../../shared/services/sms_listener_service.dart';
import '../../../../shared/services/mms_listener_service.dart';
import '../../../../shared/services/mms_forwarding_service.dart';
import '../../domain/models/dashboard_state.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  final SmsForwardingService _forwardingService;
  final SmsListenerService _smsListener;
  final MmsListenerService _mmsListener;
  final MmsForwardingService _mmsForwardingService;
  final SmsHistoryRepository _historyRepo;
  final SettingsRepository _settingsRepo;
  final _logger = AppLogger();

  DashboardNotifier({
    required SmsForwardingService forwardingService,
    required SmsListenerService smsListener,
    required MmsListenerService mmsListener,
    required MmsForwardingService mmsForwardingService,
    required SmsHistoryRepository historyRepo,
    required SettingsRepository settingsRepo,
  })  : _forwardingService = forwardingService,
        _smsListener = smsListener,
        _mmsListener = mmsListener,
        _mmsForwardingService = mmsForwardingService,
        _historyRepo = historyRepo,
        _settingsRepo = settingsRepo,
        super(DashboardState.initial());

  /// 대시보드 초기화
  Future<void> initialize() async {
    _logger.d('DashboardNotifier: 초기화 시작');

    // 설정 로드
    final isEnabled = await _settingsRepo.isForwardingEnabled();
    final webhookUrl = await _settingsRepo.getWebhookUrl();
    final hasPermission = await _smsListener.hasPermission();

    // 통계 로드
    await _loadStats();

    state = state.copyWith(
      isForwardingEnabled: isEnabled,
      hasWebhookUrl: webhookUrl.isNotEmpty,
      hasSmsPermission: hasPermission,
      serviceStatus:
          isEnabled && hasPermission && webhookUrl.isNotEmpty
              ? ServiceStatus.running
              : ServiceStatus.stopped,
    );

    // 포워딩이 활성화되어 있으면 리스닝 시작
    if (isEnabled && hasPermission && webhookUrl.isNotEmpty) {
      _startListening();
      _startMmsListening();
    }
  }

  /// 포워딩 토글
  Future<void> toggleForwarding(bool enabled) async {
    final webhookUrl = await _settingsRepo.getWebhookUrl();
    if (enabled && webhookUrl.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Slack Webhook URL을 먼저 설정해주세요.',
      );
      return;
    }

    if (enabled && !state.hasSmsPermission) {
      final granted = await _smsListener.requestPermission();
      if (!granted) {
        state = state.copyWith(
          errorMessage: 'SMS 권한이 필요합니다.',
          hasSmsPermission: false,
        );
        return;
      }
      state = state.copyWith(hasSmsPermission: true);
    }

    await _settingsRepo.setForwardingEnabled(enabled);

    if (enabled) {
      _startListening();
      _startMmsListening();
      state = state.copyWith(
        isForwardingEnabled: true,
        serviceStatus: ServiceStatus.running,
        errorMessage: null,
      );
      _logger.i('DashboardNotifier: 포워딩 시작 (SMS + MMS)');
    } else {
      _stopMmsListening();
      state = state.copyWith(
        isForwardingEnabled: false,
        serviceStatus: ServiceStatus.stopped,
        errorMessage: null,
      );
      _logger.i('DashboardNotifier: 포워딩 중지');
    }
  }

  /// SMS 리스닝 시작
  void _startListening() {
    _smsListener.startListening(
      onMessage: (SmsMessage message) {
        _onSmsReceived(message);
      },
    );
  }

  /// SMS 수신 처리
  Future<void> _onSmsReceived(SmsMessage message) async {
    _logger.i('DashboardNotifier: SMS 수신 - ${message.address}');

    await _forwardingService.handleIncomingSms(message);

    // 통계 갱신
    await _loadStats();

    // 마지막 메시지 정보 업데이트
    state = state.copyWith(
      lastSender: message.address ?? '알 수 없음',
      lastBody: message.body ?? '',
      lastMessageTime: DateTime.now(),
    );
  }

  /// MMS 리스닝 시작 (Foreground Service + EventChannel)
  Future<void> _startMmsListening() async {
    _logger.i('[MMS] DashboardNotifier: MMS 리스닝 초기화 시작');

    await _mmsListener.startService();

    // 백그라운드에서 쌓인 pending MMS 처리
    _logger.d('[MMS] DashboardNotifier: Pending MMS 확인 중...');
    final pendingList = await _mmsListener.getPendingMms();
    if (pendingList.isNotEmpty) {
      _logger.i('[MMS] DashboardNotifier: Pending MMS ${pendingList.length}건 처리 시작');
    }
    for (final pending in pendingList) {
      final sender = pending['sender'] ?? '알 수 없음';
      final body = pending['body'] ?? '';
      if (body.isNotEmpty) {
        _logger.i('[MMS] DashboardNotifier: Pending MMS 처리 - 발신자: $sender');
        await _onMmsReceived(sender, body);
      }
    }

    _mmsListener.startListening(
      onMmsReceived: (sender, body) {
        _onMmsReceived(sender, body);
      },
    );
    _logger.i('[MMS] DashboardNotifier: MMS 리스닝 활성화 완료 (Foreground Service + EventChannel)');
  }

  /// MMS 리스닝 중지
  Future<void> _stopMmsListening() async {
    _logger.i('[MMS] DashboardNotifier: MMS 리스닝 중지 시작');
    _mmsListener.stopListening();
    await _mmsListener.stopService();
    _logger.i('[MMS] DashboardNotifier: MMS 리스닝 완전 중지');
  }

  /// MMS 수신 처리
  Future<void> _onMmsReceived(String sender, String body) async {
    _logger.i('[MMS] DashboardNotifier: MMS 수신 처리 시작 - 발신자: $sender, 내용길이: ${body.length}자');

    await _mmsForwardingService.handleIncomingMms(
      sender: sender,
      body: body,
    );

    // 통계 갱신
    await _loadStats();
    _logger.d('[MMS] DashboardNotifier: 통계 갱신 완료');

    // 마지막 메시지 정보 업데이트
    state = state.copyWith(
      lastSender: sender,
      lastBody: body,
      lastMessageTime: DateTime.now(),
    );
    _logger.i('[MMS] DashboardNotifier: MMS 처리 완료 - 발신자: $sender');
  }

  /// 통계 로드
  Future<void> _loadStats() async {
    final totalForwarded = await _historyRepo.getTotalSuccessCount();
    final todayCount = await _historyRepo.getTodayCount();
    final failedCount = await _historyRepo.getFailedCount();
    final lastMessage = await _historyRepo.getLastMessage();

    state = state.copyWith(
      totalForwarded: totalForwarded,
      todayCount: todayCount,
      failedCount: failedCount,
      lastSender: lastMessage?.sender,
      lastBody: lastMessage?.body,
      lastMessageTime: lastMessage?.receivedAt,
    );
  }

  /// 통계 새로고침
  Future<void> refreshStats() async {
    await _loadStats();
  }

  /// 에러 메시지 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
