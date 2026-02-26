import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

enum SplashStep {
  initial,
  requestingPermission,
  completed,
  error,
}

@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    @Default(SplashStep.initial) SplashStep step,
    @Default('앱을 시작하는 중...') String statusText,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _SplashState;

  const SplashState._();

  factory SplashState.initial() => const SplashState();

  factory SplashState.requestingPermission() => const SplashState(
        step: SplashStep.requestingPermission,
        statusText: 'SMS 권한 확인 중...',
        isLoading: true,
      );

  factory SplashState.completed() => const SplashState(
        step: SplashStep.completed,
        statusText: '완료!',
        isLoading: false,
      );

  factory SplashState.error(String message) => SplashState(
        step: SplashStep.error,
        statusText: '초기화 오류 발생',
        isLoading: false,
        errorMessage: message,
      );
}
