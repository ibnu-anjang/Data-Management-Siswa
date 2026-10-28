import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final EdgeInsets scrollPadding;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.errorText,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.scrollPadding = const EdgeInsets.only(bottom: 220, top: 40),
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _internalFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _internalFocusNode = true;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (_internalFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _internalFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _internalFocusNode = true;
      }
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_internalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _scrollToCenter() {
    // Stage 1: Quick scroll for immediate feedback / physical keyboards
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted && _focusNode.hasFocus) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.15,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      }
    });

    // Stage 2: Second scroll to lock position once mobile soft keyboard finishes opening
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted && _focusNode.hasFocus) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.15,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollToCenter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          onTap: () {
            widget.onTap?.call();
            _scrollToCenter();
          },
          autofocus: widget.autofocus,
          scrollPadding: widget.scrollPadding,
          style: TextStyle(
            fontSize: 14,
            color: labelColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            errorText: widget.errorText,
          ),
        ),
      ],
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? errorText;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          isExpanded: true,
          initialValue: value,
          items: items.map((item) {
            if (item.child is Text) {
              final textWidget = item.child as Text;
              return DropdownMenuItem<T>(
                key: item.key,
                value: item.value,
                enabled: item.enabled,
                alignment: item.alignment,
                child: Text(
                  textWidget.data ?? '',
                  style: textWidget.style,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }
            return item;
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 14,
            color: labelColor,
          ),
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
      ],
    );
  }
}
