import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 빈 상태를 표시하는 위젯
///
/// 데이터가 없거나 빈 목록일 때 사용합니다.
class EmptyStateWidget extends StatelessWidget {
  /// 표시할 아이콘
  final IconData icon;

  /// 제목 텍스트
  final String title;

  /// 부제목 텍스트
  final String subtitle;

  /// 아이콘 크기 (기본값: 80)
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: AppColors.disabledTextGray,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
