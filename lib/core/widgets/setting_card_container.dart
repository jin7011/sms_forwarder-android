import 'package:flutter/material.dart';
import '../designsystem/colors.dart';

/// 설정 화면에서 사용되는 공통 카드 컨테이너
///
/// 일관된 BoxDecoration 스타일을 제공합니다.
class SettingCardContainer extends StatelessWidget {
  /// 카드 내부 위젯
  final Widget child;

  /// 배경색 (기본값: 흰색)
  final Color? backgroundColor;

  /// 테두리 색상 (기본값: inputBorder)
  final Color? borderColor;

  /// 테두리 radius (기본값: 12)
  final double borderRadius;

  /// 내부 패딩 (기본값: 없음)
  final EdgeInsetsGeometry? padding;

  /// 강조 상태 여부 (true일 때 오렌지 배경/테두리)
  final bool isHighlighted;

  const SettingCardContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12,
    this.padding,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isHighlighted
        ? AppColors.primaryOrange.withValues(alpha: 0.1)
        : (backgroundColor ?? AppColors.white);

    final effectiveBorderColor = isHighlighted
        ? AppColors.primaryOrange
        : (borderColor ?? AppColors.inputBorder);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor),
      ),
      padding: padding,
      child: child,
    );
  }
}
