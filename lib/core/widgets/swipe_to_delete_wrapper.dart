import 'package:flutter/material.dart';
import '../designsystem/colors.dart';

/// 스와이프 삭제 래퍼 위젯
///
/// HomeScreen, ScheduleScreen 등에서 공통으로 사용
/// 오른쪽에서 왼쪽으로 스와이프하여 삭제
class SwipeToDeleteWrapper extends StatelessWidget {
  /// 고유 키 (Dismissible용)
  final String itemId;

  /// 래핑할 자식 위젯
  final Widget child;

  /// 삭제 확인 콜백 - true 반환 시 삭제 진행
  final Future<bool> Function() onConfirmDismiss;

  /// 삭제 실행 콜백
  final VoidCallback onDismissed;

  /// 삭제 배경색 (기본: primaryOrange)
  final Color? backgroundColor;

  /// 삭제 아이콘 (기본: delete_outline)
  final IconData? icon;

  /// 삭제 임계값 (0.0 ~ 1.0, 기본: 0.3)
  final double dismissThreshold;

  const SwipeToDeleteWrapper({
    super.key,
    required this.itemId,
    required this.child,
    required this.onConfirmDismiss,
    required this.onDismissed,
    this.backgroundColor,
    this.icon,
    this.dismissThreshold = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(itemId),
      direction: DismissDirection.endToStart,
      movementDuration: const Duration(milliseconds: 50),
      dismissThresholds: {
        DismissDirection.endToStart: dismissThreshold,
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon ?? Icons.delete_outline,
          color: AppColors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) => onConfirmDismiss(),
      onDismissed: (direction) => onDismissed(),
      child: child,
    );
  }
}
