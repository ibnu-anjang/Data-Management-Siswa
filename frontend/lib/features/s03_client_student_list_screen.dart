import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../core/state/app_state.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';
import '../shared/widgets/app_search_field.dart';
import '../shared/widgets/student_card.dart';
import '../shared/widgets/state_views.dart';
import '../shared/widgets/active_filter_summary.dart';
import '../shared/modals/student_detail_modal.dart';
import '../shared/modals/print_dialog.dart';
import '../shared/modals/filter_bottom_sheet_modal.dart';

class S03ClientStudentListScreen extends StatelessWidget {
  final AppState appState;

  const S03ClientStudentListScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final filteredStudents = appState.filteredClientStudents;
    final activeFilterCount = appState.clientActiveFilterCount;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (1:1 design/index.html line 339)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Siswa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Data seluruh siswa terdaftar',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search & Filter Header Section (1:1 design/index.html line 346 - NO bulet bulet chips)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppSearchField(
                          query: appState.clientSearchQuery,
                          onChanged: (val) => appState.setClientSearch(val),
                          onClear: () => appState.setClientSearch(''),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Filter Button (1:1 with design/index.html .btn.btn-secondary.btn-sm)
                      InkWell(
                        onTap: () {
                          FilterBottomSheetModal.show(
                            context: context,
                            rombelList: appState.rombelList,
                            initialClass: appState.clientFilterClass,
                            initialGender: appState.clientFilterGender,
                            initialStatus: appState.clientFilterStatus,
                            onApply: (c, g, s) => appState.setClientFilters(className: c, gender: g, status: s),
                            onReset: () => appState.resetClientFilters(),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.tune_rounded, size: 16, color: textColor),
                              const SizedBox(width: 5),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              if (activeFilterCount > 0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '$activeFilterCount',
                                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Cetak Button (1:1 with design/index.html .btn.btn-secondary.btn-sm)
                      InkWell(
                        onTap: () {
                          PrintDialogModal.show(
                            context: context,
                            schoolProfile: appState.schoolProfile,
                            students: filteredStudents,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.print_outlined, size: 16, color: textColor),
                              const SizedBox(width: 5),
                              Text(
                                'Cetak',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ActiveFilterSummary(
                    activeClass: appState.clientFilterClass,
                    activeGender: appState.clientFilterGender,
                    activeStatus: appState.clientFilterStatus,
                    onClearClass: () => appState.setClientFilterClass('all'),
                    onClearGender: () => appState.setClientFilters(gender: 'all'),
                    onClearStatus: () => appState.setClientFilters(status: 'all'),
                    onClearAll: () => appState.resetClientFilters(),
                  ),
                ],
              ),
            ),

            // Student List Body with State Machine
            Expanded(
              child: _buildBody(context, filteredStudents),
            ),

            // Bottom Nav Bar
            AppBottomNavBar(
              role: AppRole.client,
              activeScreen: 's03',
              onSelectTab: (screen) => appState.navTo(screen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List filteredStudents) {
    if (appState.isLoadingData) {
      return const LoadingStateView(message: 'Memuat data siswa dari database...');
    }

    if (appState.dataError != null) {
      return ErrorStateView(
        title: 'Gagal Memuat Data',
        description: appState.dataError ?? 'Terjadi kesalahan koneksi server.',
        onRetry: () => appState.navTo('s03'),
      );
    }

    if (filteredStudents.isEmpty) {
      final emptyView = EmptyStateView(
        title: 'Siswa Tidak Ditemukan',
        description: 'Tidak ada data siswa yang cocok dengan filter atau kata kunci.',
        actionLabel: 'Reset Filter',
        onAction: () => appState.resetClientFilters(),
      );
      return RefreshIndicator(
        onRefresh: appState.refreshData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            alignment: Alignment.center,
            child: emptyView,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: appState.refreshData,
      color: AppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return StudentCard(
          student: student,
          isAdmin: false,
          onTap: () {
            StudentDetailModal.show(context, student);
          },
        );
      },
    ),
    );
  }
}
