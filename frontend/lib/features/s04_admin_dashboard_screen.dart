import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../core/state/app_state.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/modals/student_form_modal.dart';
import '../shared/modals/print_dialog.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Branded 1:1 with design/index.html
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
                          'Dashboard Admin',
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
                    // Top Greeting & School Badge Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, Administrator',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textColor),
                              ),
                              Text(
                                'T.A. ${school.academicYear} • ${school.semester}',
                                style: TextStyle(fontSize: 11, color: textMuted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              school.name,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Hero Main KPI Card (1:1 with renderS04)
                    Container(
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
                                    Text(
                                      'Total Siswa Terdaftar',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textMuted),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '$totalSiswa',
                                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: textColor),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Siswa',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textMuted),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.people_alt_outlined, color: AppColors.primary, size: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '$totalRombel Rombel',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successBg,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '$countAktif Siswa Aktif (${totalSiswa > 0 ? ((countAktif / totalSiswa) * 100).round() : 0}%)',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.successText),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2x2 Key Metric Cards Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        _MetricCardSquare(
                          title: 'Rombel / Kelas',
                          value: '$totalRombel Kelas',
                          icon: Icons.menu_book_rounded,
                          iconColor: AppColors.primary,
                        ),
                        _MetricCardSquare(
                          title: 'Laki-laki',
                          value: '$countL Siswa',
                          icon: Icons.person_outlined,
                          iconColor: AppColors.primary,
                        ),
                        _MetricCardSquare(
                          title: 'Perempuan',
                          value: '$countP Siswa',
                          icon: Icons.person_outline_rounded,
                          iconColor: const Color(0xFFEC4899),
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
                    const SizedBox(height: 12),

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
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.person, size: 12, color: AppColors.primary),
                                  Text(' $percentL%', style: TextStyle(fontSize: 11, color: textMuted)),
                                  const SizedBox(width: 8),
                                  const Text('•', style: TextStyle(fontSize: 11)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.person, size: 12, color: Color(0xFFEC4899)),
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
                    const SizedBox(height: 12),

                    // Rombel Distribution Card
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
                          Text(
                            'Jumlah Siswa per Rombel',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
                          ),
                          const SizedBox(height: 12),
                          if (appState.rombelList.isEmpty)
                            Text('Belum ada data kelas', style: TextStyle(fontSize: 11, color: textMuted))
                          else
                            ...appState.rombelList.map((rombel) {
                              final count = appState.getStudentCountByClass(rombel);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.class_outlined, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          rombel,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$count Siswa',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textMuted),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Dashboard Action
                    PrimaryButton(
                      label: 'Tambah Siswa Baru',
                      icon: Icons.person_add_alt_outlined,
                      fullWidth: true,
                      onPressed: () {
                        appState.navTo('s05');
                        StudentFormModal.show(
                          context: context,
                          rombelList: appState.rombelList,
                          onSubmit: (student) => appState.addStudent(student),
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
                                  'Semua data terverifikasi & tersinkronisasi',
                                  style: TextStyle(fontSize: 11, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Logout Action explicitly shown on Dashboard for requirement
                    SecondaryButton(
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

class _MetricCardSquare extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCardSquare({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Container(
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
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
