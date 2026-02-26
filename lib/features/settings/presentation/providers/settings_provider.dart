import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/providers.dart';
import '../../domain/models/settings_state.dart';
import '../notifiers/settings_notifier.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final slackService = ref.watch(slackServiceProvider);
  final smsListener = ref.watch(smsListenerServiceProvider);

  return SettingsNotifier(
    settingsRepo: settingsRepo,
    slackService: slackService,
    smsListener: smsListener,
  );
});
