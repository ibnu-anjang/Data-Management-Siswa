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
import '../shared/modals/student_detail_modal.dart';

class S02ClientHomeScreen extends StatefulWidget {
  final AppState appState;

  const S02ClientHomeScreen({super.key, required this.appState});

  @override
  State<S02ClientHomeScreen> createState() => _S02ClientHomeScreenState();
}

class _S02ClientHomeScreenState extends State<S02ClientHomeScreen> {
  String _selectedMajorFilter = 'Semua';
  final TextEditingController _nisnCheckController = TextEditingController();
  String? _nisnCheckError;

  @override
  void dispose() {
    _nisnCheckController.dispose();
    super.dispose();
  }

  void _handleNisnCheck() {
    final nisn = _nisnCheckController.text.trim();
    if (nisn.isEmpty) {
      setState(() => _nisnCheckError = 'Masukkan 10 digit NISN');
      return;
    }

    final student = widget.appState.studentsData.where((s) => s.nisn == nisn).firstOrNull;
    if (student != null) {
      setState(() => _nisnCheckError = null);
      _nisnCheckController.clear();
      StudentDetailModal.show(context, student);
    } else {
      setState(() => _nisnCheckError = 'NISN "$nisn" tidak ditemukan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final totalSiswa = appState.studentsData.length;
    final totalRombel = appState.rombelList.length;
    final school = appState.schoolProfile;

    // Major statistics
    final countPPLG = appState.getStudentCountByMajor('PPLG');
    final rombelPPLG = appState.getRombelListByMajor('PPLG').length;

    final countFarmasi = appState.getStudentCountByMajor('Farmasi');
    final rombelFarmasi = appState.getRombelListByMajor('Farmasi').length;

    final countKimia = appState.getStudentCountByMajor('Analis Kimia');
    final rombelKimia = appState.getRombelListByMajor('Analis Kimia').length;

    // Filtered rombels based on selected tab
    final filteredRombels = _selectedMajorFilter == 'Semua'
        ? appState.rombelList
        : appState.getRombelListByMajor(_selectedMajorFilter);

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
                  AppAvatar(
                    name: appState.userName.isNotEmpty ? appState.userName : 'Client',
                    photoUrl: appState.userPhotoUrl,
                    size: 38,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    fontSize: 16,
                    showBorder: true,
                    borderColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          school.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Portal Informasi Siswa (Client)',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.infoBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Pengunjung',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content Body
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
                      // Time-based Greeting & Today's Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppDateUtils.getTimeGreeting()}, Pengunjung',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${AppDateUtils.getFormattedToday()} • T.A. ${school.academicYear}',
                                  style: TextStyle(fontSize: 11, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Spotlight Quick Search
                      DashboardSpotlightSearch(
                        appState: appState,
                        hintText: 'Cari cepat siswa (Nama, NISN, atau Kelas)...',
                        onSeeAll: () => appState.navTo('s03'),
                      ),
                      const SizedBox(height: 14),

                      // Top Summary Hero KPI Card (with AnimatedCount & Tap Action)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            appState.resetClientFilters();
                            appState.navTo('s03');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ringkasan Total Siswa',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      AnimatedCount(
                                        count: totalSiswa,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                        suffix: 'Siswa',
                                        suffixStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
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
                                              '$totalRombel Rombel Aktif',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              school.name,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: textMuted,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 26),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Interactive Major Breakdown Section
                      MajorDistributionSection(
                        title: 'Program Keahlian Terdaftar',
                        subtitle: 'Pilih jurusan untuk filter kelas & siswa',
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
                              setState(() => _selectedMajorFilter = 'PPLG');
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
                              setState(() => _selectedMajorFilter = 'Farmasi');
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
                              setState(() => _selectedMajorFilter = 'Analis Kimia');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // NISN Self-Checker Tool Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cek Status Data Siswa Mandiri',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        'Masukkan NISN untuk melihat data validasi sekolah',
                                        style: TextStyle(fontSize: 11, color: textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 42,
                                    child: TextField(
                                      controller: _nisnCheckController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 13, color: textColor),
                                      decoration: InputDecoration(
                                        hintText: 'Contoh: 0071234501',
                                        hintStyle: TextStyle(fontSize: 12, color: textMuted),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        filled: true,
                                        fillColor: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: borderColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: AppColors.primary),
                                        ),
                                      ),
                                      onSubmitted: (_) => _handleNisnCheck(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: _handleNisnCheck,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Cek', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                            if (_nisnCheckError != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.danger),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _nisnCheckError!,
                                      style: const TextStyle(fontSize: 11, color: AppColors.danger),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rombel List Section Header with Interactive Filter Tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Daftar Rombongan Belajar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${filteredRombels.length} Kelas',
                            style: TextStyle(
                              fontSize: 12,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Filter Pills for Rombel
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Semua', 'PPLG', 'Farmasi', 'Analis Kimia'].map((tag) {
                            final isSelected = _selectedMajorFilter == tag;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: ChoiceChip(
                                label: Text(tag),
                                selected: isSelected,
                                onSelected: (val) {
                                  if (val) setState(() => _selectedMajorFilter = tag);
                                },
                                labelStyle: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? Colors.white : textColor,
                                ),
                                selectedColor: AppColors.primary,
                                backgroundColor: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Rombel Items List (Clicking opens S03 filtered to that class!)
                      if (filteredRombels.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Center(
                            child: Text(
                              'Tidak ada rombel untuk kategori "$_selectedMajorFilter"',
                              style: TextStyle(fontSize: 12, color: textMuted),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredRombels.length,
                          itemBuilder: (context, index) {
                            final cls = filteredRombels[index];
                            final count = appState.getStudentCountByClass(cls);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    appState.setClientFilterClass(cls);
                                    appState.navTo('s03');
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryLight,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Kelas $cls',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                '$count Siswa Terdaftar',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.chevron_right, color: textMuted, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),

                      // Recent Students Activity Feed for Client
                      RecentStudentsFeed(
                        title: 'Data Siswa Terbaru Ditambahkan',
                        students: appState.recentStudents,
                        onSeeAll: () => appState.navTo('s03'),
                      ),
                      const SizedBox(height: 18),

                      // Red Logout Button for Client
                      DangerButton(
                        label: 'Keluar dari Akun (Logout)',
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
              role: AppRole.client,
              activeScreen: 's02',
              onSelectTab: (screen) => appState.navTo(screen),
            ),
          ],
        ),
      ),
    );
  }
}
