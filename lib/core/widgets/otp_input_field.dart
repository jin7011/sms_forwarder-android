import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// OTP/인증번호 입력 컴포넌트
/// - 6자리 숫자 입력
/// - 항상 마지막 위치에서만 편집 가능
/// - 활성화된 칸은 주황색 테두리
class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInputField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _value = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // 숫자만 필터링하고 최대 길이 제한
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final limitedValue = digits.length > widget.length
        ? digits.substring(0, widget.length)
        : digits;

    setState(() {
      _value = limitedValue;
    });

    // 컨트롤러 텍스트 동기화
    if (_controller.text != limitedValue) {
      _controller.text = limitedValue;
      _controller.selection = TextSelection.collapsed(offset: limitedValue.length);
    }

    widget.onChanged?.call(_value);

    if (_value.length == widget.length) {
      widget.onCompleted?.call(_value);
    }
  }

  void _onTap() {
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        children: [
          // 숨겨진 실제 입력 필드
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 1,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: widget.length,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onChanged,
              ),
            ),
          ),
          // 표시용 박스들
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final hasValue = index < _value.length;
              final isCurrentIndex = index == _value.length;
              final isFocused = _focusNode.hasFocus && isCurrentIndex;

              return Flexible(
                child: GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: const BoxConstraints(maxWidth: 56),
                    child: AspectRatio(
                      aspectRatio: 0.85,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hasValue
                                ? AppColors.primaryOrange
                                : isFocused
                                    ? AppColors.primaryOrange
                                    : AppColors.inputBorder,
                            width: isFocused ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: hasValue
                              ? Text(
                                  _value[index],
                                  style: AppTypography.titleLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                )
                              : isFocused
                                  ? _buildCursor()
                                  : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCursor() {
    return SizedBox(
      width: 2,
      height: 24,
      child: const ColoredBox(color: AppColors.primaryOrange),
    );
  }
}
