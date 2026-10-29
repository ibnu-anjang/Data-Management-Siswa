import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../core/state/app_state.dart';
import '../core/utils/app_date_utils.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_avatar.dart';
import '../shared/widgets/animated_count.dart';
import '../shared/widgets/dashboard_spotlight_search.dart';
import '../shared/widgets/major_distribution_card.dart';
import '../shared/widgets/recent_students_feed.dart';
import '../shared/modals/student_form_modal.dart';
import '../shared/modals/print_dialog.dart';
import '../shared/modals/school_profile_modal.dart';
import '../shared/modals/rombel_form_modal.dart';

class S04AdminDashboardScreen extends StatelessWidget {
  final AppState appState;

  const S04AdminDashboardScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final totalSiswa = appState.studentsData.length;
    final totalRombel = appState.rombelList.length;
    final school = appState.schoolProfile;

    final countL = appState.studentsData.where((s) => s.gender == 'Laki-laki').length;
    final countP = appState.studentsData.where((s) => s.gender == 'Perempuan').length;
    final countAktif = appState.studentsData.where((s) => s.status == 'Aktif').length;

    final percentL = totalSiswa > 0 ? ((countL / totalSiswa) * 100).round() : 0;
    final percentP = totalSiswa > 0 ? ((countP / totalSiswa) * 100).round() : 0;

    // Major statistics
    final countPPLG = appState.getStudentCountByMajor('PPLG');
    final rombelPPLG = appState.getRombelListByMajor('PPLG').length;

    final countFarmasi = appState.getStudentCountByMajor('Farmasi');
    final rombelFarmasi = appState.getRombelListByMajor('Farmasi').length;

    final countKimia = appState.getStudentCountByMajor('Analis Kimia');
    final rombelKimia = appState.getRombelListByMajor('Analis Kimia').length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Branded
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SekolahKu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Dashboard Admin Utama',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ADM Avatar Button linking to S09 Profile
                  InkWell(
                    onTap: () => appState.navTo('s09'),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'ADM',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Body
            Expanded(
              child: RefreshIndicator(
                onRefresh: appState.refreshData,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Dynamic Time Greeting & School Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppAvatar(
                            name: appState.userName.isNotEmpty ? appState.userName : 'Administrator',
                            photoUrl: appState.userPhotoUrl,
                            size: 42,
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            fontSize: 18,
                            showBorder: true,
                            borderColor: AppColors.primary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppDateUtils.getTimeGreeting()}, Admin',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '${AppDateUtils.getFormattedToday()} • ${school.semester}',
                                  style: TextStyle(fontSize: 11, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                SchoolProfileModal.show(
                                  context: context,
                                  initialProfile: school,
                                  onSubmit: (updated) => appState.updateSchoolProfile(updated),
                                );
                              },
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        school.name,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.edit_outlined, size: 10, color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Spotlight Quick Search
                      DashboardSpotlightSearch(
                        appState: appState,
                        hintText: 'Cari cepat siswa (Nama, NISN, atau Kelas)...',
                        onSeeAll: () => appState.navTo('s05'),
                      ),
                      const SizedBox(height: 14),

                      // Hero Main KPI Card (with AnimatedCount & Click-to-filter)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            appState.resetAdminFilters();
                            appState.navTo('s05');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Total Siswa Terdaftar',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: textMuted,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(Icons.touch_app_outlined, size: 12, color: textMuted),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          AnimatedCount(
                                            count: totalSiswa,
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              color: textColor,
                                            ),
                                            suffix: 'Siswa',
                                            suffixStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.people_alt_outlined,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        appState.setAdminFilters(className: 'all');
                                        appState.navTo('s05');
                                      },
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '$totalRombel Rombel',
                                              style: const TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            const Icon(Icons.arrow_forward_rounded, size: 10, color: AppColors.primary),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        appState.setAdminFilters(status: 'Aktif');
                                        appState.navTo('s05');
                                      },
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.successBg,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '$countAktif Siswa Aktif (${totalSiswa > 0 ? ((countAktif / totalSiswa) * 100).round() : 0}%)',
                                              style: const TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.successText,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            const Icon(Icons.filter_list_rounded, size: 10, color: AppColors.successText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Quick Actions Toolbar Row
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _QuickActionItem(
                              icon: Icons.person_add_alt_1_rounded,
                              label: 'Tambah',
                              color: AppColors.primary,
                              onTap: () {
                                StudentFormModal.show(
                                  context: context,
                                  rombelList: appState.rombelList,
                                  onSubmit: (student) {
                                    appState.addStudent(student);
                                    appState.navTo('s05');
                                  },
                                );
                              },
                            ),
                            _QuickActionItem(
                              icon: Icons.picture_as_pdf_rounded,
                              label: 'Cetak PDF',
                              color: const Color(0xFF0284C7),
                              onTap: () {
                                PrintDialogModal.show(
                                  context: context,
                                  schoolProfile: appState.schoolProfile,
                                  students: appState.studentsData,
                                );
                              },
                            ),
                            _QuickActionItem(
                              icon: Icons.class_outlined,
                              label: 'Rombel',
                              color: const Color(0xFF059669),
                              onTap: () {
                                RombelFormModal.show(
                                  context: context,
                                  onSubmit: (newClass) => appState.addRombel(newClass),
                                );
                              },
                            ),
                            _QuickActionItem(
                              icon: Icons.account_balance_outlined,
                              label: 'Sekolah',
                              color: const Color(0xFFD97706),
                              onTap: () {
                                SchoolProfileModal.show(
                                  context: context,
                                  initialProfile: school,
                                  onSubmit: (updated) => appState.updateSchoolProfile(updated),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2x2 Key Metric Cards Grid with Click-To-Filter
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.45,
                        children: [
                          _MetricCardSquare(
                            title: 'Rombel / Kelas',
                            value: '$totalRombel Kelas',
                            count: totalRombel,
                            suffix: 'Kelas',
                            icon: Icons.menu_book_rounded,
                            iconColor: AppColors.primary,
                            onTap: () {
                              appState.setAdminFilters(className: 'all');
                              appState.navTo('s05');
                            },
                          ),
                          _MetricCardSquare(
                            title: 'Laki-laki',
                            value: '$countL Siswa',
                            count: countL,
                            suffix: 'Siswa',
                            icon: Icons.male_rounded,
                            iconColor: AppColors.primary,
                            onTap: () {
                              appState.setAdminFilters(gender: 'Laki-laki');
                              appState.navTo('s05');
                            },
                          ),
                          _MetricCardSquare(
                            title: 'Perempuan',
                            value: '$countP Siswa',
                            count: countP,
                            suffix: 'Siswa',
                            icon: Icons.female_rounded,
                            iconColor: const Color(0xFFEC4899),
                            onTap: () {
                              appState.setAdminFilters(gender: 'Perempuan');
                              appState.navTo('s05');
                            },
                          ),
                          _MetricCardSquareAction(
                            title: 'Cetak Laporan',
                            value: 'Pratinjau >',
                            icon: Icons.print_outlined,
                            iconColor: AppColors.primary,
                            onTap: () {
                              PrintDialogModal.show(
                                context: context,
                                schoolProfile: appState.schoolProfile,
                                students: appState.studentsData,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Major Distribution Interactive Section
                      MajorDistributionSection(
                        majors: [
                          MajorStatItem(
                            code: 'PPLG',
                            fullName: 'Rekayasa Perangkat Lunak & Gim',
                            subtitle: 'Kelas X, XI, XII',
                            studentCount: countPPLG,
                            rombelCount: rombelPPLG,
                            icon: Icons.code_rounded,
                            accentColor: const Color(0xFF4F46E5),
                            lightBg: const Color(0xFFEEF2FF),
                            onTap: () {
                              appState.setAdminSearch('PPLG');
                              appState.navTo('s05');
                            },
                          ),
                          MajorStatItem(
                            code: 'Farmasi',
                            fullName: 'Farmasi Klinis & Komunitas',
                            subtitle: 'Kelas X, XI, XII',
                            studentCount: countFarmasi,
                            rombelCount: rombelFarmasi,
                            icon: Icons.medication_liquid_rounded,
                            accentColor: const Color(0xFF059669),
                            lightBg: const Color(0xFFECFDF5),
                            onTap: () {
                              appState.setAdminSearch('Farmasi');
                              appState.navTo('s05');
                            },
                          ),
                          MajorStatItem(
                            code: 'Analis Kimia',
                            fullName: 'Kimia Analisis Industri',
                            subtitle: 'Program 4 Tahun (Kelas X s/d XIII)',
                            studentCount: countKimia,
                            rombelCount: rombelKimia,
                            icon: Icons.science_rounded,
                            accentColor: const Color(0xFFD97706),
                            lightBg: const Color(0xFFFFFBEB),
                            onTap: () {
                              appState.setAdminSearch('Analis Kimia');
                              appState.navTo('s05');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Gender Distribution Bar Card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Rasio Gender Siswa',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.male_rounded, size: 14, color: AppColors.primary),
                                    Text(' $percentL%', style: TextStyle(fontSize: 11, color: textMuted)),
                                    const SizedBox(width: 8),
                                    const Text('•', style: TextStyle(fontSize: 11)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.female_rounded, size: 14, color: Color(0xFFEC4899)),
                                    Text(' $percentP%', style: TextStyle(fontSize: 11, color: textMuted)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                height: 8,
                                child: (percentL == 0 && percentP == 0)
                                    ? Container(color: isDark ? AppColors.borderDark : AppColors.borderLight)
                                    : Row(
                                        children: [
                                          if (percentL > 0)
                                            Expanded(
                                              flex: percentL,
                                              child: Container(color: AppColors.primary),
                                            ),
                                          if (percentP > 0)
                                            Expanded(
                                              flex: percentP,
                                              child: Container(color: const Color(0xFFEC4899)),
                                            ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Recent Students Activity Feed
                      RecentStudentsFeed(
                        students: appState.recentStudents,
                        onSeeAll: () => appState.navTo('s05'),
                      ),
                      const SizedBox(height: 14),

                      // Primary Dashboard Action
                      PrimaryButton(
                        label: 'Tambah Siswa Baru',
                        icon: Icons.person_add_alt_outlined,
                        fullWidth: true,
                        onPressed: () {
                          StudentFormModal.show(
                            context: context,
                            rombelList: appState.rombelList,
                            onSubmit: (student) {
                              appState.addStudent(student);
                              appState.navTo('s05');
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Bottom System Status Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.verified_user_outlined, color: AppColors.success, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sistem Manajemen Aktif',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
                                  ),
                                  Text(
                                    'Semua data terverifikasi & tersinkronisasi Cloud Firestore',
                                    style: TextStyle(fontSize: 11, color: textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Logout Action
                      DangerButton(
                        label: 'Keluar dari Aplikasi (Logout)',
                        icon: Icons.logout_rounded,
                        fullWidth: true,
                        onPressed: () async {
                          await appState.logout();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(
              role: AppRole.admin,
              activeScreen: 's04',
              onSelectTab: (screen) => appState.navTo(screen),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCardSquare extends StatelessWidget {
  final String title;
  final String value;
  final int count;
  final String suffix;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _MetricCardSquare({
    required this.title,
    required this.value,
    required this.count,
    required this.suffix,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, color: iconColor, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedCount(
                count: count,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
                suffix: suffix,
                suffixStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCardSquareAction extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _MetricCardSquareAction({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(icon, color: iconColor, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
