import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/util/logger.dart';
import '../../../core/common/providers.dart';

class MainViewModel extends StateNotifier<MainState> {
  final AppLogger _logger;

  MainViewModel(this._logger) : super(const MainState.initial());

  void initialize() {
    _logger.d('MainViewModel: initialized');
  }
}

final mainViewModelProvider =
    StateNotifierProvider<MainViewModel, MainState>((ref) {
  final logger = ref.read(loggerProvider);
  final vm = MainViewModel(logger);
  vm.initialize();
  return vm;
});

abstract class MainState {
  const MainState();

  const factory MainState.initial() = _InitialState;
}

class _InitialState extends MainState {
  const _InitialState();
}
