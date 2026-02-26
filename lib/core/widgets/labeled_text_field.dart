import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../designsystem/colors.dart';
import '../designsystem/typography.dart';

/// 라벨이 있는 텍스트 필드 컴포넌트
/// - 포커스 시 라벨이 상단에 표시됨
/// - 입력 값이 있으면 라벨 유지
class LabeledTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;
  final FocusNode? focusNode;

  const LabeledTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  bool get _hasValue => widget.controller?.text.isNotEmpty ?? false;
  bool get _showFloatingLabel => _isFocused || _hasValue;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      inputFormatters: widget.inputFormatters,
      onChanged: (value) {
        setState(() {});
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: _isFocused ? AppColors.primaryOrange : AppColors.textSecondary,
        ),
        floatingLabelStyle: AppTypography.labelSmall.copyWith(
          color: _isFocused ? AppColors.primaryOrange : AppColors.textSecondary,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: _showFloatingLabel ? widget.hintText : null,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.disabledTextGray,
        ),
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryOrange),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.disabledGray),
        ),
      ),
    );
  }
}

/// 전화번호 전용 텍스트 필드 컴포넌트
class PhoneTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const PhoneTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  bool get _hasValue => widget.controller?.text.isNotEmpty ?? false;
  bool get _showFloatingLabel => _isFocused || _hasValue;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.phone,
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _PhoneNumberFormatter(),
      ],
      onChanged: (value) {
        setState(() {});
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        labelText: '전화번호',
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: _showFloatingLabel ? '010-0000-0000' : null,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.disabledTextGray,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
      ),
    );
  }
}

/// 전화번호 포맷터 (010-1234-5678 형식)
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    // 숫자만 추출
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');

    // 최대 11자리로 제한
    final limitedDigits = digits.length > 11 ? digits.substring(0, 11) : digits;

    // 포맷팅
    String formatted;
    if (limitedDigits.length <= 3) {
      formatted = limitedDigits;
    } else if (limitedDigits.length <= 7) {
      formatted = '${limitedDigits.substring(0, 3)}-${limitedDigits.substring(3)}';
    } else {
      formatted = '${limitedDigits.substring(0, 3)}-${limitedDigits.substring(3, 7)}-${limitedDigits.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
