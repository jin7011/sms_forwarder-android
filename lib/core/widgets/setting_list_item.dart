import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 클릭 가능한 설정 리스트 아이템 컴포넌트
///
/// 아이콘, 제목, 부제목, 그리고 선택적으로 chevron 화살표를 표시합니다.
/// 다른 화면으로 이동하는 설정 항목에 사용됩니다.
class SettingListItem extends StatelessWidget {
  /// 아이템 제목
  final String title;

  /// 아이템 부제목 (설명, 빈 문자열이면 표시 안함)
  final String subtitle;

  /// 왼쪽 아이콘
  final IconData icon;

  /// 탭 콜백 (null이면 chevron 미표시)
  final VoidCallback? onTap;

  /// chevron 표시 여부 (기본값: onTap이 있으면 true)
  final bool? showChevron;

  const SettingListItem({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.icon,
    this.onTap,
    this.showChevron,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShowChevron = showChevron ?? (onTap != null);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (shouldShowChevron)
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
