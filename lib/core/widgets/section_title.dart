import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 섹션 제목 스타일
enum SectionTitleStyle {
  /// 큰 섹션 제목 (titleSmall, w600)
  large,

  /// 작은 섹션 제목 / 폼 라벨 (bodySmall, w500)
  small,
}

/// 섹션 제목 위젯
///
/// 리스트나 폼에서 섹션을 구분하는 제목을 표시합니다.
class SectionTitle extends StatelessWidget {
  /// 제목 텍스트
  final String title;

  /// 제목 스타일 (기본값: large)
  final SectionTitleStyle style;

  /// 텍스트 색상 (기본값: textPrimary)
  final Color? color;

  const SectionTitle({
    super.key,
    required this.title,
    this.style = SectionTitleStyle.large,
    this.color,
  });

  /// 폼 라벨용 팩토리 생성자
  const SectionTitle.label({
    super.key,
    required this.title,
    this.color,
  }) : style = SectionTitleStyle.small;

  @override
  Widget build(BuildContext context) {
    final textStyle = switch (style) {
      SectionTitleStyle.large => AppTypography.titleSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        ),
      SectionTitleStyle.small => AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textPrimary,
        ),
    };

    return Text(title, style: textStyle);
  }
}
