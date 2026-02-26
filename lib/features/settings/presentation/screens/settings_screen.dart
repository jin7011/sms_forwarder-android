import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/designsystem/typography.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _webhookUrlController = TextEditingController();
  final _deviceNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(settingsProvider.notifier).loadSettings();
      final s = ref.read(settingsProvider);
      _webhookUrlController.text = s.webhookUrl;
      _deviceNameController.text = s.deviceName;
      _phoneNumberController.text = s.phoneNumber;
    });
  }

  @override
  void dispose() {
    _webhookUrlController.dispose();
    _deviceNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          '설정',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          // 기기 정보
          _buildSectionTitle('기기 정보', theme),
          const SizedBox(height: 8),
          _buildDeviceInfoCard(context, state, theme),
          const SizedBox(height: 24),

          // Slack 연동
          _buildSectionTitle('Slack 연동', theme),
          const SizedBox(height: 8),
          _buildWebhookUrlCard(context, state, theme),
          const SizedBox(height: 12),
          _buildSlackTestCard(context, state, theme),
          const SizedBox(height: 24),

          // SMS 권한
          _buildSectionTitle('권한', theme),
          const SizedBox(height: 8),
          _buildPermissionCard(context, state, theme),
          const SizedBox(height: 24),

          // 앱 정보
          _buildSectionTitle('앱 정보', theme),
          const SizedBox(height: 8),
          _buildInfoCard(context, state, theme),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: AppTypography.labelLarge.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDeviceInfoCard(
      BuildContext context, dynamic state, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slack 메시지에 표시될 기기 정보입니다.',
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                labelText: '기기 이름',
                hintText: '예: 성진 Galaxy A24',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                prefixIcon: const Icon(Icons.phone_android, size: 20),
              ),
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: '전화번호',
                hintText: '예: 010-1234-5678',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                prefixIcon: const Icon(Icons.call, size: 20),
              ),
              style: AppTypography.bodyMedium,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final notifier = ref.read(settingsProvider.notifier);
                  notifier.saveDeviceName(
                      _deviceNameController.text.trim());
                  notifier.savePhoneNumber(
                      _phoneNumberController.text.trim());
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('기기 정보가 저장되었습니다.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('기기 정보 저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebhookUrlCard(
      BuildContext context, dynamic state, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slack Incoming Webhook URL을 입력해주세요.',
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _webhookUrlController,
              decoration: InputDecoration(
                labelText: 'Webhook URL',
                hintText: 'https://hooks.slack.com/services/...',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                prefixIcon: const Icon(Icons.link, size: 20),
              ),
              style: AppTypography.bodyMedium,
              keyboardType: TextInputType.url,
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final url = _webhookUrlController.text.trim();
                  ref.read(settingsProvider.notifier).saveWebhookUrl(url);
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        url.startsWith('https://hooks.slack.com/services/')
                            ? 'Webhook URL이 저장되었습니다.'
                            : 'URL 형식이 올바르지 않습니다. https://hooks.slack.com/services/ 로 시작해야 합니다.',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Webhook URL 저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlackTestCard(
      BuildContext context, dynamic state, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  state.isWebhookValid
                      ? Icons.check_circle
                      : Icons.error_outline,
                  color: state.isWebhookValid ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  state.isWebhookValid
                      ? 'Webhook URL 설정됨'
                      : 'Webhook URL 미설정',
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: state.isWebhookValid && !state.isTestingWebhook
                    ? () {
                        ref.read(settingsProvider.notifier).testWebhook();
                      }
                    : null,
                child: state.isTestingWebhook
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('테스트 메시지 전송'),
              ),
            ),
            if (state.testResult != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: state.testResult!.contains('성공')
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.testResult!,
                  style: AppTypography.bodySmall.copyWith(
                    color: state.testResult!.contains('성공')
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard(
      BuildContext context, dynamic state, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              state.hasSmsPermission
                  ? Icons.check_circle
                  : Icons.warning_amber_rounded,
              color: state.hasSmsPermission ? Colors.green : Colors.orange,
            ),
            title: const Text('SMS 수신 권한'),
            subtitle: Text(
              state.hasSmsPermission ? '허용됨' : '권한이 필요합니다',
              style: AppTypography.bodySmall,
            ),
            trailing: state.hasSmsPermission
                ? null
                : FilledButton(
                    onPressed: () {
                      ref
                          .read(settingsProvider.notifier)
                          .requestSmsPermission();
                    },
                    child: const Text('권한 요청'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, dynamic state, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
            title: const Text('앱 버전'),
            subtitle: Text(state.appVersion ?? '1.0.0'),
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                Icon(Icons.description_outlined, color: theme.colorScheme.primary),
            title: const Text('사용법'),
            subtitle: Text(
              '1. Webhook URL 입력 → 2. SMS 권한 허용 → 3. 대시보드에서 포워딩 ON',
              style: AppTypography.bodySmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
