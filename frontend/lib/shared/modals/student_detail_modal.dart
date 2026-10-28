import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/student_model.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_avatar.dart';

class StudentDetailModal extends StatelessWidget {
  final StudentModel student;

  const StudentDetailModal({
    super.key,
    required this.student,
  });

  static Future<void> show(BuildContext context, StudentModel student) {
    return showDialog(
      context: context,
      builder: (context) => StudentDetailModal(student: student),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final infoBoxBg = isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.person_pin_outlined, color: AppColors.primary, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Detail Siswa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content Body Wrapped in Expanded
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Top Hero Profile Header Card (1:1 design/app.js openDetailModal)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: infoBoxBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          AppAvatar(
                            name: student.name,
                            photoUrl: student.photoUrl,
                            size: 72,
                            borderRadius: 18,
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            fontSize: 28,
                            showBorder: true,
                            borderColor: AppColors.primary.withValues(alpha: 0.3),
                            borderWidth: 2,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            student.name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 12, color: textMuted),
                              children: [
                                const TextSpan(text: 'NISN: '),
                                TextSpan(
                                  text: student.nisn,
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                const TextSpan(text: '  •  NIS: '),
                                TextSpan(
                                  text: student.nis,
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            alignment: WrapAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Kelas ${student.className}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  student.gender,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textMuted),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: student.status == 'Alumni' ? (isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight) : AppColors.successBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  student.status == 'Alumni' ? 'Alumni' : 'Siswa Aktif',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: student.status == 'Alumni' ? textMuted : AppColors.successText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // High-Contrast Detail Info Rows (1:1 with styles.css .detail-row)
                    _DetailRowItem(icon: Icons.location_city_outlined, label: 'Tempat Lahir', value: student.birthPlace.isNotEmpty ? student.birthPlace : '-'),
                    _DetailRowItem(icon: Icons.calendar_today_outlined, label: 'Tanggal Lahir', value: student.birthDate.isNotEmpty ? student.birthDate : '-'),
                    _DetailRowItem(icon: Icons.menu_book_outlined, label: 'Agama', value: student.religion.isNotEmpty ? student.religion : '-'),
                    _DetailRowItem(icon: Icons.phone_android_outlined, label: 'Nomor Telepon', value: student.phone.isNotEmpty ? student.phone : '-'),
                    _DetailRowItem(icon: Icons.location_on_outlined, label: 'Alamat Rumah', value: student.address.isNotEmpty ? student.address : '-'),
                    _DetailRowItem(icon: Icons.person_outlined, label: 'Wali Siswa', value: student.guardianName.isNotEmpty ? student.guardianName : '-'),
                    _DetailRowItem(icon: Icons.phone_outlined, label: 'Kontak Wali', value: student.guardianPhone.isNotEmpty ? student.guardianPhone : '-'),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Footer Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                label: 'Tutup Detail Siswa',
                icon: Icons.close,
                fullWidth: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRowItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left 3px primary accent line 1:1 with styles.css .detail-row
            Container(
              width: 3,
              color: AppColors.primary,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
