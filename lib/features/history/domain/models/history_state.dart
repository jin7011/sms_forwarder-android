import 'package:freezed_annotation/freezed_annotation.dart';
import 'sms_message_model.dart';

part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default([]) List<SmsMessageModel> messages,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _HistoryState;

  const HistoryState._();

  factory HistoryState.initial() => const HistoryState();
}
