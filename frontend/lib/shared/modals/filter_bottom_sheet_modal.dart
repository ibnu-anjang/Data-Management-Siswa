import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_text_field.dart';

class FilterBottomSheetModal extends StatefulWidget {
  final List<String> rombelList;
  final String initialClass;
  final String initialGender;
  final String initialStatus;
  final Function(String selectedClass, String selectedGender, String selectedStatus) onApply;
  final VoidCallback onReset;

  const FilterBottomSheetModal({
    super.key,
    required this.rombelList,
    required this.initialClass,
    required this.initialGender,
    required this.initialStatus,
    required this.onApply,
    required this.onReset,
  });

  static Future<void> show({
    required BuildContext context,
    required List<String> rombelList,
    required String initialClass,
    required String initialGender,
    required String initialStatus,
    required Function(String selectedClass, String selectedGender, String selectedStatus) onApply,
    required VoidCallback onReset,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheetModal(
        rombelList: rombelList,
        initialClass: initialClass,
        initialGender: initialGender,
        initialStatus: initialStatus,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<FilterBottomSheetModal> createState() => _FilterBottomSheetModalState();
}

class _FilterBottomSheetModalState extends State<FilterBottomSheetModal> {
  late String _selectedClass;
  late String _selectedGender;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.initialClass;
    _selectedGender = widget.initialGender;
    _selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    final classItems = [
      const DropdownMenuItem(value: 'all', child: Text('-- Semua Rombel (Semua Kelas) --')),
      ...widget.rombelList.map((c) => DropdownMenuItem(value: c, child: Text(c))),
    ];

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filter Data Siswa',
                            style: TextStyle(
                              fontSize: 18,
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

            // Filter Fields Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDropdown<String>(
                      label: 'Kategori Rombel (Kelas)',
                      value: _selectedClass,
                      items: classItems,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedClass = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    AppDropdown<String>(
                      label: 'Jenis Kelamin',
                      value: _selectedGender,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('-- Semua Gender --')),
                        DropdownMenuItem(value: 'Laki-laki', child: Text('👦 Laki-laki')),
                        DropdownMenuItem(value: 'Perempuan', child: Text('👧 Perempuan')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGender = val);
                      },
                    ),
                    const SizedBox(height: 14),

                    AppDropdown<String>(
                      label: 'Status Keaktifan',
                      value: _selectedStatus,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('-- Semua Status --')),
                        DropdownMenuItem(value: 'Aktif', child: Text('Siswa Aktif')),
                        DropdownMenuItem(value: 'Alumni', child: Text('Alumni')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStatus = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Reset Filter',
                      onPressed: () {
                        widget.onReset();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Terapkan Filter',
                      icon: Icons.check,
                      onPressed: () {
                        widget.onApply(_selectedClass, _selectedGender, _selectedStatus);
                        Navigator.pop(context);
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
