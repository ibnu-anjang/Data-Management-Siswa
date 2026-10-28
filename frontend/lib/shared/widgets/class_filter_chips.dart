import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ClassFilterChips extends StatelessWidget {
  final List<String> rombelList;
  final String activeClass;
  final ValueChanged<String> onSelectClass;
  final int Function(String className) getCount;

  const ClassFilterChips({
    super.key,
    required this.rombelList,
    required this.activeClass,
    required this.onSelectClass,
    required this.getCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allClasses = ['all', ...rombelList];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: allClasses.map((cls) {
          final isSelected = activeClass == cls;
          final count = getCount(cls);
          final label = cls == 'all' ? 'Semua Kelas' : cls;

          final bgColor = isSelected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);

          final textColor = isSelected
              ? Colors.white
              : (isDark ? AppColors.textDark : AppColors.textLight);

          final badgeBg = isSelected
              ? Colors.white.withValues(alpha: 0.25)
              : (isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight);

          final badgeTextColor = isSelected
              ? Colors.white
              : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

          final borderColor = isSelected
              ? AppColors.primary
              : (isDark ? AppColors.borderDark : AppColors.borderLight);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => onSelectClass(cls),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
