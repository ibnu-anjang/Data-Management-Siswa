import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_text_field.dart';

class RombelFormModal extends StatefulWidget {
  final String? initialClassName;
  final ValueChanged<String> onSubmit;

  const RombelFormModal({
    super.key,
    this.initialClassName,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    String? className,
    required ValueChanged<String> onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RombelFormModal(
        initialClassName: className,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<RombelFormModal> createState() => _RombelFormModalState();
}

class _RombelFormModalState extends State<RombelFormModal> {
  late TextEditingController _nameController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialClassName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _nameController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Nama kelas tidak boleh kosong');
      return;
    }

    widget.onSubmit(text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final isEdit = widget.initialClassName != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEdit ? 'Ubah Nama Kelas' : 'Tambah Kelas Baru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

            Padding(
              padding: const EdgeInsets.all(20),
              child: AppTextField(
                label: 'Nama Kelas / Rombel *',
                hint: 'Contoh: XII IPA 3',
                controller: _nameController,
                errorText: _errorText,
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: isEdit ? 'Simpan' : 'Tambah',
                      icon: Icons.check,
                      onPressed: _handleSubmit,
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
