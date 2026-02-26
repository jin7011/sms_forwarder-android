import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/util/logger.dart';

class SettingsRepository {
  static const String _webhookUrlKey = 'webhook_url';
  static const String _forwardingEnabledKey = 'forwarding_enabled';
  static const String _deviceNameKey = 'device_name';
  static const String _phoneNumberKey = 'phone_number';

  final _logger = AppLogger();

  Future<String> getWebhookUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_webhookUrlKey) ?? '';
  }

  Future<void> setWebhookUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_webhookUrlKey, url);
    _logger.i('SettingsRepository: Webhook URL 저장 완료');
  }

  Future<bool> isForwardingEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_forwardingEnabledKey) ?? false;
  }

  Future<void> setForwardingEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_forwardingEnabledKey, enabled);
    _logger.i('SettingsRepository: 포워딩 ${enabled ? "활성화" : "비활성화"}');
  }

  Future<String> getDeviceName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceNameKey) ?? '';
  }

  Future<void> setDeviceName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceNameKey, name);
    _logger.i('SettingsRepository: 기기 이름 저장 - $name');
  }

  Future<String> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey) ?? '';
  }

  Future<void> setPhoneNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, number);
    _logger.i('SettingsRepository: 전화번호 저장');
  }

  /// Webhook URL 유효성 검사
  bool isValidWebhookUrl(String url) {
    return url.startsWith('https://hooks.slack.com/services/');
  }
}
