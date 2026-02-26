import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/splash_state.dart';

class SplashNotifier extends StateNotifier<SplashState> {

  bool _isInitializing = false;
  bool _isInitialized = false;

  SplashNotifier() : super(SplashState.initial());

  Future<void> initializeApp() async {
    if (_isInitializing || _isInitialized) return;

    _isInitializing = true;

    try {
      // ignore: avoid_print
      print('SplashNotifier: 앱 초기화 시작...');

      await Future.delayed(const Duration(milliseconds: 800));

      state = SplashState.completed();
      _isInitialized = true;
      // ignore: avoid_print
      print('SplashNotifier: 초기화 완료');
    } catch (e) {
      // ignore: avoid_print
      print('SplashNotifier: 초기화 실패 - $e');
      state = SplashState.error(e.toString());

      await Future.delayed(const Duration(seconds: 2));
      _isInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }
}
