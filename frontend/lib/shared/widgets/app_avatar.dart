import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Centralized, high-contrast avatar widget with seamless initial-fallback.
/// When [photoUrl] is empty or fails to load, gracefully displays the capitalized initial letter.
class AppAvatar extends StatelessWidget {
  final String name;
  final String photoUrl;
  final double size;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const AppAvatar({
    super.key,
    required this.name,
    this.photoUrl = '',
    this.size = 40,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  String get _initial {
    final clean = name.trim();
    if (clean.isEmpty) return 'S';
    for (int i = 0; i < clean.length; i++) {
      final char = clean[i];
      if (RegExp(r'[a-zA-Z0-9]').hasMatch(char)) {
        return char.toUpperCase();
      }
    }
    return clean[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? (size / 2);
    final bg = backgroundColor ?? (isDark ? AppColors.surfaceSubtleDark : AppColors.primaryLight);
    final textCol = textColor ?? AppColors.primary;
    final fSize = fontSize ?? (size * 0.42);
    final cleanPhoto = photoUrl.trim();

    final avatarShape = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder
              ? Border.all(
                  color: borderColor ?? AppColors.primary.withValues(alpha: 0.3),
                  width: borderWidth,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: cleanPhoto.isNotEmpty
            ? Image.network(
                cleanPhoto,
                width: size,
                height: size,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: bg,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size * 0.35,
                      height: size * 0.35,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textCol),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => _buildInitial(fSize, textCol),
              )
            : _buildInitial(fSize, textCol),
      ),
    );

    return avatarShape;
  }

  Widget _buildInitial(double fSize, Color textCol) {
    return Center(
      child: Text(
        _initial,
        style: TextStyle(
          fontSize: fSize,
          fontWeight: FontWeight.w700,
          color: textCol,
          height: 1.0,
        ),
      ),
    );
  }
}
