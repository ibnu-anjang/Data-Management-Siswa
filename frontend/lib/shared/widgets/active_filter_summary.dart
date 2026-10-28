import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class ActiveFilterSummary extends StatelessWidget {
  final String activeClass;
  final String activeGender;
  final String activeStatus;
  final VoidCallback onClearClass;
  final VoidCallback onClearGender;
  final VoidCallback onClearStatus;
  final VoidCallback onClearAll;

  const ActiveFilterSummary({
    super.key,
    required this.activeClass,
    required this.activeGender,
    required this.activeStatus,
    required this.onClearClass,
    required this.onClearGender,
    required this.onClearStatus,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilters = activeClass != 'all' || activeGender != 'all' || activeStatus != 'all';
    if (!hasFilters) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipBg = isDark ? AppColors.surfaceSubtleDark : AppColors.primaryLight;
    final textColor = isDark ? AppColors.textDark : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          if (activeClass != 'all')
            _FilterChip(
              label: 'Kelas: $activeClass',
              onClear: onClearClass,
              chipBg: chipBg,
              textColor: textColor,
            ),
          if (activeGender != 'all')
            _FilterChip(
              label: 'Gender: $activeGender',
              onClear: onClearGender,
              chipBg: chipBg,
              textColor: textColor,
            ),
          if (activeStatus != 'all')
            _FilterChip(
              label: 'Status: $activeStatus',
              onClear: onClearStatus,
              chipBg: chipBg,
              textColor: textColor,
            ),
          InkWell(
            onTap: onClearAll,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Text(
                'Reset Semua',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;
  final Color chipBg;
  final Color textColor;

  const _FilterChip({
    required this.label,
    required this.onClear,
    required this.chipBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onClear,
            child: Icon(Icons.close, size: 14, color: textColor),
          ),
        ],
      ),
    );
  }
}
