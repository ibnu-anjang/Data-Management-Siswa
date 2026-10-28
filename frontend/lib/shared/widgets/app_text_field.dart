import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
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
    this.scrollPadding = const EdgeInsets.only(bottom: 120, top: 20),
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
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          scrollPadding: scrollPadding,
          style: TextStyle(
            fontSize: 14,
            color: labelColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
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
