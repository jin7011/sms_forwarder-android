import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

enum ServiceStatus { stopped, running, error }

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(false) bool isForwardingEnabled,
    @Default(ServiceStatus.stopped) ServiceStatus serviceStatus,
    @Default(0) int totalForwarded,
    @Default(0) int todayCount,
    @Default(0) int failedCount,
    @Default(false) bool hasSmsPermission,
    @Default(false) bool hasWebhookUrl,
    String? lastSender,
    String? lastBody,
    DateTime? lastMessageTime,
    String? errorMessage,
  }) = _DashboardState;

  const DashboardState._();

  factory DashboardState.initial() => const DashboardState();
}
