import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'animated_count.dart';

class MajorStatItem {
  final String code;
  final String fullName;
  final String subtitle;
  final int studentCount;
  final int rombelCount;
  final IconData icon;
  final Color accentColor;
  final Color lightBg;
  final VoidCallback onTap;

  const MajorStatItem({
    required this.code,
    required this.fullName,
    required this.subtitle,
    required this.studentCount,
    required this.rombelCount,
    required this.icon,
    required this.accentColor,
    required this.lightBg,
    required this.onTap,
  });
}

class MajorDistributionSection extends StatelessWidget {
  final List<MajorStatItem> majors;
  final String title;
  final String? subtitle;

  const MajorDistributionSection({
    super.key,
    required this.majors,
    this.title = 'Distribusi Program Keahlian (Jurusan)',
    this.subtitle = 'Ketuk jurusan untuk filter data siswa terkait',
  });

  Widget _buildMajorCard(
    BuildContext context,
    MajorStatItem major,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textMuted, {
    required bool isWide,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isWide ? 0 : 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: major.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Accent Icon Box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? major.accentColor.withValues(alpha: 0.18) : major.lightBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: major.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(major.icon, color: major.accentColor, size: 24),
                ),
                const SizedBox(width: 12),

                // Center Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            major.code,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: major.accentColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              major.fullName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${major.subtitle} • ${major.rombelCount} Rombel',
                        style: TextStyle(fontSize: 11, color: textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Right Student Count
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedCount(
                      count: major.studentCount,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      suffix: 'Siswa',
                      suffixStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: major.accentColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: major.accentColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 780;
            if (isWide) {
              return Row(
                children: majors.map((major) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildMajorCard(context, major, isDark, cardBg, borderColor, textColor, textMuted, isWide: true),
                    ),
                  );
                }).toList(),
              );
            }
            return Column(
              children: majors
                  .map((major) => _buildMajorCard(context, major, isDark, cardBg, borderColor, textColor, textMuted, isWide: false))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
