import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/state/app_state.dart';

class AppBottomNavBar extends StatelessWidget {
  final AppRole role;
  final String activeScreen;
  final ValueChanged<String> onSelectTab;

  const AppBottomNavBar({
    super.key,
    required this.role,
    required this.activeScreen,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    List<_NavItemData> items = [];
    if (role == AppRole.admin) {
      items = [
        _NavItemData(screen: 's04', label: 'Dashboard', icon: Icons.grid_view_rounded),
        _NavItemData(screen: 's05', label: 'Kelola Siswa', icon: Icons.people_alt_rounded),
        _NavItemData(screen: 's09', label: 'Profil', icon: Icons.person_rounded),
      ];
    } else {
      items = [
        _NavItemData(screen: 's02', label: 'Beranda', icon: Icons.home_rounded),
        _NavItemData(screen: 's03', label: 'Data Siswa', icon: Icons.people_alt_rounded),
        _NavItemData(screen: 's09', label: 'Profil', icon: Icons.person_rounded),
      ];
    }

    return Container(
      height: 64,
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: navBg,
        border: Border(
          top: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((item) {
                final isSelected = activeScreen == item.screen;
                final color = isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

                return Expanded(
                  child: InkWell(
                    onTap: () => onSelectTab(item.screen),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: color, size: 20),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Mobile Home Indicator Line 1:1 with styles.css .phone-home-indicator
          Center(
            child: Container(
              width: 120,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.textMutedDark.withValues(alpha: 0.3) : AppColors.textMutedLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  final String screen;
  final String label;
  final IconData icon;

  _NavItemData({
    required this.screen,
    required this.label,
    required this.icon,
  });
}
