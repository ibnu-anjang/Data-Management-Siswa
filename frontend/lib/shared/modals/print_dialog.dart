import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/models/school_profile_model.dart';
import '../widgets/app_buttons.dart';

class PrintDialogModal extends StatefulWidget {
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
  State<PrintDialogModal> createState() => _PrintDialogModalState();
}

class _PrintDialogModalState extends State<PrintDialogModal> {
  bool _isDownloading = false;
  bool _isPrinting = false;

  static String _monthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  Future<Uint8List> _buildPdfBytes() async {
    final pdf = pw.Document();
    final profile = widget.schoolProfile;
    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Kop Surat Sekolah
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    profile.name.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'NPSN: ${profile.npsn} | ${profile.address}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Text(
                    'Telp: ${profile.phone} | Email: ${profile.email}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Divider(thickness: 1.5),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'LAPORAN DATA SISWA AKTIF',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  pw.Text(
                    'Tahun Ajaran ${profile.academicYear} - ${profile.semester}',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                  ),
                  pw.Text(
                    'Total: ${widget.students.length} Siswa Terdata',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // Tabel Data Siswa
            pw.TableHelper.fromTextArray(
              headers: ['No', 'NISN', 'NIS', 'Nama Lengkap', 'Kelas', 'L/P', 'Status', 'No. HP'],
              data: widget.students.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final s = entry.value;
                return [
                  '$idx',
                  s.nisn.isNotEmpty ? s.nisn : '-',
                  s.nis,
                  s.name,
                  s.className,
                  s.gender == 'Laki-laki' ? 'L' : 'P',
                  s.status,
                  s.phone.isNotEmpty ? s.phone : '-',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.centerLeft,
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
                6: pw.Alignment.center,
              },
              headerAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                4: pw.Alignment.center,
                5: pw.Alignment.center,
                6: pw.Alignment.center,
              },
            ),
            pw.SizedBox(height: 24),

            // Lembar Pengesahan / Tanda Tangan Kepala Sekolah
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Bogor, ${now.day} ${_monthName(now.month)} ${now.year}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text('Kepala Sekolah,', style: const pw.TextStyle(fontSize: 9)),
                    pw.SizedBox(height: 40),
                    pw.Text(
                      profile.principalName,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                    pw.Text(
                      'NIP. ${profile.principalNip}',
                      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _handleDownloadPdf() async {
    setState(() => _isDownloading = true);
    try {
      final pdfBytes = await _buildPdfBytes();
      final cleanSchoolName = widget.schoolProfile.name
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
          .replaceAll(RegExp(r'_+'), '_');
      final fileName = 'Laporan_Data_Siswa_$cleanSchoolName.pdf';

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: fileName,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File PDF "$fileName" berhasil diunduh.'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunduh PDF: $e'),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _handlePrintDirect() async {
    setState(() => _isPrinting = true);
    try {
      final pdfBytes = await _buildPdfBytes();
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'Laporan_Data_Siswa_${widget.schoolProfile.name}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka dialog cetak: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final school = widget.schoolProfile;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: dialogBg,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 620,
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
            const Divider(height: 1),

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
                              school.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'NPSN: ${school.npsn} | ${school.address}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Telp: ${school.phone} | Email: ${school.email}',
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
                              'Tahun Ajaran ${school.academicYear} - ${school.semester}',
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
                          rows: widget.students.asMap().entries.map((entry) {
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
                              Text(
                                'Bogor, ${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}',
                                style: const TextStyle(fontSize: 11, color: Colors.black),
                              ),
                              const Text('Kepala Sekolah,', style: TextStyle(fontSize: 11, color: Colors.black)),
                              const SizedBox(height: 50),
                              Text(
                                school.principalName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(
                                'NIP. ${school.principalNip}',
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
            const Divider(height: 1),

            // Actions: Mobile-friendly full width Download PDF and side-by-side secondary actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary Action: Download PDF (Full width, big thumb target)
                  PrimaryButton(
                    label: _isDownloading ? 'Mengunduh PDF...' : 'Download File PDF',
                    icon: Icons.download_rounded,
                    isLoading: _isDownloading,
                    fullWidth: true,
                    onPressed: (_isDownloading || _isPrinting) ? null : _handleDownloadPdf,
                  ),
                  const SizedBox(height: 10),

                  // Secondary Actions: Cetak Printer & Tutup side-by-side
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Tutup',
                          fullWidth: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SecondaryButton(
                          label: _isPrinting ? 'Mempersiapkan...' : 'Cetak Printer',
                          icon: Icons.print_outlined,
                          fullWidth: true,
                          onPressed: (_isDownloading || _isPrinting) ? null : _handlePrintDirect,
                        ),
                      ),
                    ],
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
