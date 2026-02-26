import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/providers.dart';
import '../../domain/models/dashboard_state.dart';
import '../notifiers/dashboard_notifier.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final forwardingService = ref.watch(smsForwardingServiceProvider);
  final smsListener = ref.watch(smsListenerServiceProvider);
  final mmsListener = ref.watch(mmsListenerServiceProvider);
  final mmsForwardingService = ref.watch(mmsForwardingServiceProvider);
  final historyRepo = ref.watch(smsHistoryRepositoryProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);

  return DashboardNotifier(
    forwardingService: forwardingService,
    smsListener: smsListener,
    mmsListener: mmsListener,
    mmsForwardingService: mmsForwardingService,
    historyRepo: historyRepo,
    settingsRepo: settingsRepo,
  );
});
