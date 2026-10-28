import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';
import '../core/state/app_state.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';
import '../shared/widgets/app_search_field.dart';
import '../shared/widgets/student_card.dart';
import '../shared/widgets/state_views.dart';
import '../shared/widgets/active_filter_summary.dart';
import '../shared/widgets/confirmation_dialog.dart';
import '../shared/modals/student_form_modal.dart';
import '../shared/modals/student_detail_modal.dart';
import '../shared/modals/print_dialog.dart';
import '../shared/modals/filter_bottom_sheet_modal.dart';

class S05AdminStudentListScreen extends StatelessWidget {
  final AppState appState;

  const S05AdminStudentListScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final filteredStudents = appState.filteredAdminStudents;
    final activeFilterCount = appState.adminActiveFilterCount;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar 1:1 with design/index.html line 414
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          'Kelola Data Siswa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tambah, ubah, atau hapus siswa',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Siswa', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      StudentFormModal.show(
                        context: context,
                        rombelList: appState.rombelList,
                        onSubmit: (newStudent) => appState.addStudent(newStudent),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Search & Filter Header Section (1:1 design/index.html line 424 - NO bulet bulet chips)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppSearchField(
                          query: appState.adminSearchQuery,
                          onChanged: (val) => appState.setAdminSearch(val),
                          onClear: () => appState.setAdminSearch(''),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Filter Button (1:1 with design/index.html .btn.btn-secondary.btn-sm)
                      InkWell(
                        onTap: () {
                          FilterBottomSheetModal.show(
                            context: context,
                            rombelList: appState.rombelList,
                            initialClass: appState.adminFilterClass,
                            initialGender: appState.adminFilterGender,
                            initialStatus: appState.adminFilterStatus,
                            onApply: (c, g, s) => appState.setAdminFilters(className: c, gender: g, status: s),
                            onReset: () => appState.resetAdminFilters(),
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
                    activeClass: appState.adminFilterClass,
                    activeGender: appState.adminFilterGender,
                    activeStatus: appState.adminFilterStatus,
                    onClearClass: () => appState.setAdminFilterClass('all'),
                    onClearGender: () => appState.setAdminFilters(gender: 'all'),
                    onClearStatus: () => appState.setAdminFilters(status: 'all'),
                    onClearAll: () => appState.resetAdminFilters(),
                  ),
                ],
              ),
            ),

            // Main Student List Area with State View Handling
            Expanded(
              child: _buildBody(context, filteredStudents),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(
              role: AppRole.admin,
              activeScreen: 's05',
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
        onRetry: () => appState.navTo('s05'),
      );
    }

    if (filteredStudents.isEmpty) {
      final emptyView = EmptyStateView(
        title: 'Tidak Ada Data Siswa',
        description: 'Tidak ada data siswa yang sesuai dengan filter atau kata kunci.',
        actionLabel: 'Tambah Siswa Baru',
        onAction: () {
          StudentFormModal.show(
            context: context,
            rombelList: appState.rombelList,
            onSubmit: (newStudent) => appState.addStudent(newStudent),
          );
        },
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
          isAdmin: true,
          onTap: () {
            StudentDetailModal.show(context, student);
          },
          onEdit: () {
            StudentFormModal.show(
              context: context,
              student: student,
              rombelList: appState.rombelList,
              onSubmit: (updated) => appState.updateStudent(updated),
            );
          },
          onDelete: () async {
            final confirm = await ConfirmationDialog.show(context, student);
            if (confirm == true) {
              appState.deleteStudent(student);
            }
          },
        );
      },
    ),
    );
  }
}
