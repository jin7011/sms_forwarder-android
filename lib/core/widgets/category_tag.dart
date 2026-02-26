import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 카테고리 태그 컴포넌트
/// 선택 가능한 원형 태그 UI
class CategoryTag extends StatelessWidget {
  /// 태그 텍스트
  final String label;

  /// 선택 여부
  final bool isSelected;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 선택된 상태 배경색
  final Color selectedBackgroundColor;

  /// 선택된 상태 테두리색
  final Color selectedBorderColor;

  /// 선택된 상태 텍스트색
  final Color selectedTextColor;

  /// 미선택 상태 배경색
  final Color unselectedBackgroundColor;

  /// 미선택 상태 테두리색
  final Color unselectedBorderColor;

  /// 미선택 상태 텍스트색
  final Color unselectedTextColor;

  const CategoryTag({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedBackgroundColor = const Color(0xFFFFEDD4),
    this.selectedBorderColor = const Color(0xFFFFB86A),
    this.selectedTextColor = const Color(0xFFCA3500),
    this.unselectedBackgroundColor = AppColors.backgroundGray,
    this.unselectedBorderColor = AppColors.inputBorder,
    this.unselectedTextColor = AppColors.textSecondary,
  });

  /// 오렌지 테마 태그 (기본)
  const CategoryTag.orange({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  })  : selectedBackgroundColor = const Color(0xFFFFEDD4),
        selectedBorderColor = const Color(0xFFFFB86A),
        selectedTextColor = const Color(0xFFCA3500),
        unselectedBackgroundColor = AppColors.backgroundGray,
        unselectedBorderColor = AppColors.inputBorder,
        unselectedTextColor = AppColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSelected ? selectedBackgroundColor : unselectedBackgroundColor;
    final borderColor =
        isSelected ? selectedBorderColor : unselectedBorderColor;
    final textColor = isSelected ? selectedTextColor : unselectedTextColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// 카테고리 태그 그룹
/// 여러 태그를 Wrap으로 표시하고 선택 상태 관리
class CategoryTagGroup extends StatelessWidget {
  /// 카테고리 목록
  final List<String> categories;

  /// 선택된 카테고리
  final String? selectedCategory;

  /// 선택 변경 콜백
  final ValueChanged<String>? onSelected;

  /// 다중 선택 모드
  final bool multiSelect;

  /// 다중 선택된 카테고리 목록 (multiSelect가 true일 때 사용)
  final List<String> selectedCategories;

  /// 다중 선택 변경 콜백
  final ValueChanged<List<String>>? onMultiSelected;

  const CategoryTagGroup({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onSelected,
    this.multiSelect = false,
    this.selectedCategories = const [],
    this.onMultiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = multiSelect
            ? selectedCategories.contains(category)
            : selectedCategory == category;

        return CategoryTag.orange(
          label: category,
          isSelected: isSelected,
          onTap: () {
            if (multiSelect) {
              final newSelection = List<String>.from(selectedCategories);
              if (isSelected) {
                newSelection.remove(category);
              } else {
                newSelection.add(category);
              }
              onMultiSelected?.call(newSelection);
            } else {
              onSelected?.call(category);
            }
          },
        );
      }).toList(),
    );
  }
}
