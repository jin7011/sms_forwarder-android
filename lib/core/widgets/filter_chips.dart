import 'package:flutter/material.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 필터 칩 목록 위젯
///
/// 가로 스크롤 가능한 필터 칩들을 표시합니다.
class FilterChips<T> extends StatelessWidget {
  /// 필터 목록
  final List<T> filters;

  /// 현재 선택된 필터
  final T selectedFilter;

  /// 필터 선택 콜백
  final ValueChanged<T> onSelected;

  /// 필터를 문자열로 변환하는 함수 (기본값: toString)
  final String Function(T)? labelBuilder;

  /// 가로 패딩 (기본값: 16)
  final double horizontalPadding;

  /// 세로 패딩 (기본값: 8)
  final double verticalPadding;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    this.labelBuilder,
    this.horizontalPadding = 16,
    this.verticalPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          final label = labelBuilder?.call(filter) ?? filter.toString();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryOrange : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryOrange
                        : AppColors.inputBorder,
                  ),
                ),
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
