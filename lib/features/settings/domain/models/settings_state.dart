import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default('') String webhookUrl,
    @Default(false) bool isWebhookValid,
    @Default(false) bool isForwardingEnabled,
    @Default(false) bool hasSmsPermission,
    @Default(false) bool isTestingWebhook,
    @Default('') String deviceName,
    @Default('') String phoneNumber,
    String? testResult,
    String? appVersion,
  }) = _SettingsState;

  const SettingsState._();

  factory SettingsState.initial() => const SettingsState();
}
