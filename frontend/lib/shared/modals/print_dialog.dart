import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/models/school_profile_model.dart';
import '../widgets/app_buttons.dart';

class PrintDialogModal extends StatelessWidget {
  final SchoolProfileModel schoolProfile;
  final List<StudentModel> students;

  const PrintDialogModal({
    super.key,
    required this.schoolProfile,
    required this.students,
  });

  static Future<void> show({
    required BuildContext context,
    required SchoolProfileModel schoolProfile,
    required List<StudentModel> students,
  }) {
    return showDialog(
      context: context,
      builder: (context) => PrintDialogModal(
        schoolProfile: schoolProfile,
        students: students,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: dialogBg,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        child: Column(
          children: [
            // Modal Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.print_outlined, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pratinjau Cetak Laporan Data Siswa',
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
            const Divider(),

            // Document Preview Paper (White background for realistic print preview)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kop Sekolah
                      Center(
                        child: Column(
                          children: [
                            Text(
                              schoolProfile.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NPSN: ${schoolProfile.npsn} | ${schoolProfile.address}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Telp: ${schoolProfile.phone} | Email: ${schoolProfile.email}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Divider(color: Colors.black, thickness: 2),
                            const SizedBox(height: 12),
                            const Text(
                              'LAPORAN DATA SISWA AKTIF',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Tahun Ajaran ${schoolProfile.academicYear} — ${schoolProfile.semester}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Data Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 16,
                          headingRowHeight: 36,
                          dataRowMinHeight: 36,
                          dataRowMaxHeight: 36,
                          headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
                          columns: const [
                            DataColumn(label: Text('#', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('NIS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Nama Siswa', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Kelas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Gender', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                          ],
                          rows: students.asMap().entries.map((entry) {
                            final idx = entry.key + 1;
                            final s = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(Text('$idx', style: const TextStyle(color: Colors.black, fontSize: 12))),
                                DataCell(Text(s.nis, style: const TextStyle(color: Colors.black, fontSize: 12))),
                                DataCell(Text(s.name, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600))),
                                DataCell(Text(s.className, style: const TextStyle(color: Colors.black, fontSize: 12))),
                                DataCell(Text(s.gender, style: const TextStyle(color: Colors.black, fontSize: 12))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Tanda Tangan Kepala Sekolah
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bogor, 12 Agustus 2026', style: TextStyle(fontSize: 11, color: Colors.black)),
                              const Text('Kepala Sekolah,', style: TextStyle(fontSize: 11, color: Colors.black)),
                              const SizedBox(height: 50),
                              Text(
                                schoolProfile.principalName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(
                                'NIP. ${schoolProfile.principalNip}',
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
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
            const Divider(),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Tutup',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Cetak Sekarang',
                      icon: Icons.print,
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perintah cetak dokumen dikirim ke printer/PDF.'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
