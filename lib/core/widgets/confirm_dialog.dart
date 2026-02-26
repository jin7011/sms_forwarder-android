import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 확인 다이얼로그를 표시합니다.
///
/// [title]: 다이얼로그 제목
/// [message]: 다이얼로그 내용
/// [confirmText]: 확인 버튼 텍스트 (기본값: '확인')
/// [cancelText]: 취소 버튼 텍스트 (기본값: '취소')
/// [confirmColor]: 확인 버튼 색상 (기본값: primaryOrange)
/// [isDestructive]: 위험한 작업 여부 (true이면 확인 버튼이 빨간색)
///
/// 반환값: 확인 시 true, 취소 시 false
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = '확인',
  String cancelText = '취소',
  Color? confirmColor,
  bool isDestructive = false,
}) async {
  final effectiveConfirmColor =
      confirmColor ?? (isDestructive ? Colors.red : AppColors.primaryOrange);

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(
            cancelText,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            confirmText,
            style: AppTypography.labelMedium.copyWith(
              color: effectiveConfirmColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}
