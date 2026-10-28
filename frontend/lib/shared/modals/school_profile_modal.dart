import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/school_profile_model.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_text_field.dart';

class SchoolProfileModal extends StatefulWidget {
  final SchoolProfileModel initialProfile;
  final ValueChanged<SchoolProfileModel> onSubmit;

  const SchoolProfileModal({
    super.key,
    required this.initialProfile,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required SchoolProfileModel initialProfile,
    required ValueChanged<SchoolProfileModel> onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SchoolProfileModal(
        initialProfile: initialProfile,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<SchoolProfileModal> createState() => _SchoolProfileModalState();
}

class _SchoolProfileModalState extends State<SchoolProfileModal> {
  late TextEditingController _nameController;
  late TextEditingController _npsnController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _academicYearController;
  late TextEditingController _principalNameController;
  late TextEditingController _principalNipController;

  late String _selectedSemester;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _nameController = TextEditingController(text: p.name);
    _npsnController = TextEditingController(text: p.npsn);
    _addressController = TextEditingController(text: p.address);
    _phoneController = TextEditingController(text: p.phone);
    _emailController = TextEditingController(text: p.email);
    _academicYearController = TextEditingController(text: p.academicYear);
    _principalNameController = TextEditingController(text: p.principalName);
    _principalNipController = TextEditingController(text: p.principalNip);
    _selectedSemester = p.semester;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _npsnController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _academicYearController.dispose();
    _principalNameController.dispose();
    _principalNipController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Nama sekolah tidak boleh kosong');
      return;
    }

    final updated = widget.initialProfile.copyWith(
      name: name,
      npsn: _npsnController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      academicYear: _academicYearController.text.trim(),
      semester: _selectedSemester,
      principalName: _principalNameController.text.trim(),
      principalNip: _principalNipController.text.trim(),
    );

    widget.onSubmit(updated);
    Navigator.pop(context);
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          children: [
            // Modal Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.location_city_outlined, color: AppColors.primary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Ubah Identitas Sekolah & Kop',
                            style: TextStyle(
                              fontSize: 17,
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

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Nama Sekolah *',
                      hint: 'SMK AK Nusa Bangsa',
                      controller: _nameController,
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'NPSN Sekolah',
                            hint: '20103456',
                            controller: _npsnController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Telepon Sekolah',
                            hint: '(0251) 8345678',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\(\)\s]')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    AppTextField(
                      label: 'Alamat Lengkap Sekolah',
                      hint: 'Jl. KH. Sholeh Iskandar No. 1, Bogor',
                      controller: _addressController,
                    ),
                    const SizedBox(height: 14),

                    AppTextField(
                      label: 'Email Resmi Sekolah',
                      hint: 'info@smk-aknusalab.sch.id',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Tahun Ajaran',
                            hint: '2025/2026',
                            controller: _academicYearController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDropdown<String>(
                            label: 'Semester',
                            value: _selectedSemester,
                            items: const [
                              DropdownMenuItem(value: 'Semester Genap', child: Text('Semester Genap')),
                              DropdownMenuItem(value: 'Semester Ganjil', child: Text('Semester Ganjil')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSemester = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Nama Kepala Sekolah',
                            hint: 'Drs. H. Ahmad Fauzi, M.Pd.',
                            controller: _principalNameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\.\,\'\`]")),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'NIP Kepala Sekolah',
                            hint: '19720815 199803 1 004',
                            controller: _principalNipController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]')),
                            ],
                          ),
                        ),
                      ],
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
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Simpan Identitas',
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
