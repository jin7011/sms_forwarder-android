import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'core/designsystem/theme.dart';
import 'core/common/providers.dart';
import 'features/history/domain/models/sms_message_model.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 전역 에러 핸들링
    FlutterError.onError = (FlutterErrorDetails details) {
      // ignore: avoid_print
      print("Main: FlutterError - ${details.exceptionAsString()}");
    };
    ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      // ignore: avoid_print
      print("Main: Uncaught error - $error");
      return true;
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // ignore: avoid_print
      print("Main: ErrorWidget - ${details.exceptionAsString()}");
      return const SizedBox.shrink();
    };

    // Hive 초기화 및 어댑터 등록
    await Hive.initFlutter();
    Hive.registerAdapter(SmsMessageModelAdapter());
    Hive.registerAdapter(ForwardStatusAdapter());

    // 기기 정보 자동 감지 (device_info_plus)
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingName = prefs.getString('device_name') ?? '';
      if (existingName.isEmpty) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final autoName = '${androidInfo.brand} ${androidInfo.model}';
        await prefs.setString('device_name', autoName);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Main: 기기 정보 감지 실패 - $e');
    }

    // Edge-to-edge 디스플레이
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    runApp(
      const ProviderScope(child: SmsForwarderApp()),
    );
  }, (error, stack) {
    // ignore: avoid_print
    print('Main: runZonedGuarded uncaught: $error');
  });
}

class SmsForwarderApp extends ConsumerStatefulWidget {
  const SmsForwarderApp({super.key});

  @override
  ConsumerState<SmsForwarderApp> createState() => _SmsForwarderAppState();
}

class _SmsForwarderAppState extends ConsumerState<SmsForwarderApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'SMS Forwarder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: router.router,
    );
  }
}
