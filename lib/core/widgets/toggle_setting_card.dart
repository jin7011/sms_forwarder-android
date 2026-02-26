import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';
import 'setting_card_container.dart';

/// 토글 스위치가 있는 설정 카드 컴포넌트
///
/// ON 상태일 때 오렌지 배경과 테두리로 강조 표시됩니다.
class ToggleSettingCard extends StatelessWidget {
  /// 카드 제목
  final String title;

  /// 카드 부제목 (설명)
  final String subtitle;

  /// 왼쪽 아이콘
  final IconData icon;

  /// 토글 값
  final bool value;

  /// 토글 변경 콜백 (null이면 비활성화)
  final ValueChanged<bool>? onChanged;

  const ToggleSettingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 활성화 상태: 값이 true이고 onChanged가 null이 아닐 때
    final isEnabled = value && onChanged != null;

    return SettingCardContainer(
      isHighlighted: isEnabled,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryOrange,
            activeTrackColor: AppColors.primaryOrange.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.textTertiary,
            inactiveTrackColor: AppColors.inputBorder,
          ),
        ],
      ),
    );
  }
}
