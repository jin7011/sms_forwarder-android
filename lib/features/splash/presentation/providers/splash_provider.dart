import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/splash_state.dart';
import '../notifiers/splash_notifier.dart';

final splashProvider =
    StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier();
});
