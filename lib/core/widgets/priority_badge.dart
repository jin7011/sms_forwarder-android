import 'package:flutter/material.dart';
import '../designsystem/colors.dart';

/// 우선순위 배지 컴포넌트
/// - 주황색 원형 배경에 숫자 표시
/// - 흰색 테두리 옵션 지원
/// - 지도 마커 및 일정 아이템에서 사용
class PriorityBadge extends StatelessWidget {
  /// 지도 마커용 기본 크기 (이 값만 수정하면 전체 적용)
  static const double defaultMapMarkerSize = 22;

  /// 표시할 숫자 (우선순위)
  final int priority;

  /// 배지 크기
  final double size;

  /// 배경 색상
  final Color backgroundColor;

  /// 텍스트 색상
  final Color textColor;

  /// 흰색 테두리 표시 여부
  final bool showBorder;

  /// 테두리 두께
  final double borderWidth;

  /// 테두리 색상
  final Color borderColor;

  /// 폰트 크기 (null이면 자동 계산)
  final double? fontSize;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.size = 28,
    this.backgroundColor = AppColors.primaryOrange,
    this.textColor = AppColors.white,
    this.showBorder = false,
    this.borderWidth = 2,
    this.borderColor = AppColors.white,
    this.fontSize,
  });

  /// 흰색 테두리가 있는 배지 생성
  const PriorityBadge.withBorder({
    super.key,
    required this.priority,
    this.size = 28,
    this.backgroundColor = AppColors.primaryOrange,
    this.textColor = AppColors.white,
    this.borderWidth = 3,
    this.borderColor = AppColors.white,
    this.fontSize,
  }) : showBorder = true;

  /// 지도 마커용 배지 (흰색 테두리)
  /// 크기는 [defaultMapMarkerSize] 상수로 관리
  const PriorityBadge.mapMarker({
    super.key,
    required this.priority,
    this.size = defaultMapMarkerSize,
    this.backgroundColor = AppColors.primaryOrange,
    this.textColor = AppColors.white,
    this.borderWidth = 2,
    this.borderColor = AppColors.white,
    this.fontSize,
  }) : showBorder = true;

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? (size * 0.43);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor,
                width: borderWidth,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$priority',
          style: TextStyle(
            fontSize: effectiveFontSize,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
