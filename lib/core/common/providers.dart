import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../router/app_router.dart';
import '../util/logger.dart';
import '../../shared/services/slack_service.dart';
import '../../shared/services/sms_listener_service.dart';
import '../../shared/services/sms_forwarding_service.dart';
import '../../shared/services/mms_listener_service.dart';
import '../../shared/services/mms_forwarding_service.dart';
import '../../features/history/data/sms_history_repository.dart';
import '../../features/settings/data/settings_repository.dart';

// Core providers
final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());
final loggerProvider = Provider<AppLogger>((ref) => AppLogger());

final dioProvider = Provider<Dio>((ref) {
  final logger = ref.read(loggerProvider);
  final dio = Dio();

  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => logger.d(object.toString()),
    ),
  );

  return dio;
});

// Repository providers
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final smsHistoryRepositoryProvider = Provider<SmsHistoryRepository>((ref) {
  return SmsHistoryRepository();
});

// Service providers
final slackServiceProvider = Provider<SlackService>((ref) {
  final dio = ref.read(dioProvider);
  return SlackService(dio);
});

final smsListenerServiceProvider = Provider<SmsListenerService>((ref) {
  return SmsListenerService();
});

final smsForwardingServiceProvider = Provider<SmsForwardingService>((ref) {
  final slackService = ref.read(slackServiceProvider);
  final historyRepo = ref.read(smsHistoryRepositoryProvider);
  final settingsRepo = ref.read(settingsRepositoryProvider);

  return SmsForwardingService(
    slackService: slackService,
    historyRepo: historyRepo,
    settingsRepo: settingsRepo,
  );
});

// MMS providers
final mmsListenerServiceProvider = Provider<MmsListenerService>((ref) {
  return MmsListenerService();
});

final mmsForwardingServiceProvider = Provider<MmsForwardingService>((ref) {
  final slackService = ref.read(slackServiceProvider);
  final historyRepo = ref.read(smsHistoryRepositoryProvider);
  final settingsRepo = ref.read(settingsRepositoryProvider);

  return MmsForwardingService(
    slackService: slackService,
    historyRepo: historyRepo,
    settingsRepo: settingsRepo,
  );
});
