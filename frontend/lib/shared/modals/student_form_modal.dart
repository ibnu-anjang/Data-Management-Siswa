import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/services/cloudinary_service.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_text_field.dart';

class StudentFormModal extends StatefulWidget {
  final StudentModel? initialStudent;
  final List<String> rombelList;
  final ValueChanged<StudentModel> onSubmit;

  const StudentFormModal({
    super.key,
    this.initialStudent,
    required this.rombelList,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    StudentModel? student,
    required List<String> rombelList,
    required ValueChanged<StudentModel> onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StudentFormModal(
        initialStudent: student,
        rombelList: rombelList,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<StudentFormModal> createState() => _StudentFormModalState();
}

class _StudentFormModalState extends State<StudentFormModal> {
  late TextEditingController _nameController;
  late TextEditingController _nisnController;
  late TextEditingController _nisController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthDateController;
  late TextEditingController _guardianNameController;
  late TextEditingController _guardianPhoneController;

  String? _selectedClass;
  String _selectedGender = 'Laki-laki';
  String _selectedStatus = 'Aktif';
  String _selectedReligion = 'Islam';

  String? _nameError;
  String? _nisnError;
  String? _nisError;
  String? _birthPlaceError;
  String? _classError;
  String? _phoneError;
  String? _birthDateError;
  String? _addressError;
  String? _guardianNameError;
  String? _guardianPhoneError;

  // ── Photo Upload State ──
  String _photoUrl = '';
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  bool _isUploading = false;
  bool _isPhotoRemoved = false;

  @override
  void initState() {
    super.initState();
    final s = widget.initialStudent;
    _nameController = TextEditingController(text: s?.name ?? '');
    _nisnController = TextEditingController(text: s?.nisn ?? '');
    _nisController = TextEditingController(text: s?.nis ?? '');
    _birthPlaceController = TextEditingController(text: s?.birthPlace ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _addressController = TextEditingController(text: s?.address ?? '');
    _birthDateController = TextEditingController(text: s?.birthDate ?? '15 Mei 2007');
    _guardianNameController = TextEditingController(text: s?.guardianName ?? '');
    _guardianPhoneController = TextEditingController(text: s?.guardianPhone ?? '');

    _selectedClass = (s != null && widget.rombelList.contains(s.className))
        ? s.className
        : (widget.rombelList.isNotEmpty ? widget.rombelList.first : null);

    if (s != null) {
      _selectedGender = s.gender;
      _selectedStatus = s.status;
      _selectedReligion = s.religion.isNotEmpty ? s.religion : 'Islam';
      _photoUrl = s.photoUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nisnController.dispose();
    _nisController.dispose();
    _birthPlaceController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _pickedImage = file;
          _pickedImageBytes = bytes;
          _isPhotoRemoved = false;
        });
      }
    } catch (e) {
      // Ignored or handled gracefully
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2007, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).brightness == Brightness.dark
                ? const ColorScheme.dark(primary: AppColors.primary)
                : const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      final formatted = '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      setState(() {
        _birthDateController.text = formatted;
        _birthDateError = null;
      });
    }
  }

  void _handleAvatarTap() {
    if (_isUploading) return;
    if (_pickedImageBytes != null || _photoUrl.isNotEmpty) {
      _showPhotoOptionBottomSheet();
    } else {
      _pickPhoto();
    }
  }

  void _showPhotoOptionBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Kelola Foto Siswa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  title: Text('Pilih Foto Baru dari File / Galeri', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                  title: const Text('Hapus Foto', style: TextStyle(color: AppColors.danger)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _pickedImage = null;
                      _pickedImageBytes = null;
                      _photoUrl = '';
                      _isPhotoRemoved = true;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _extractMajorFromClass(String className) {
    final parts = className.trim().split(RegExp(r'\s+'));
    if (parts.length >= 3) {
      return parts.sublist(1, parts.length - 1).join(' ');
    } else if (parts.length == 2) {
      return parts[1];
    }
    return className;
  }

  void _handleSubmit() async {
    if (_isUploading) return;

    final nameTrim = _nameController.text.trim();
    final nisnTrim = _nisnController.text.trim();
    final nisTrim = _nisController.text.trim();
    final birthPlaceTrim = _birthPlaceController.text.trim();
    final phoneTrim = _phoneController.text.trim();
    final addressTrim = _addressController.text.trim();
    final birthDateTrim = _birthDateController.text.trim();
    final guardianNameTrim = _guardianNameController.text.trim();
    final guardianPhoneTrim = _guardianPhoneController.text.trim();

    // Validasi semua data siswa wajib diisi lengkap
    if (nameTrim.isEmpty ||
        nisnTrim.isEmpty ||
        nisTrim.isEmpty ||
        birthPlaceTrim.isEmpty ||
        phoneTrim.isEmpty ||
        addressTrim.isEmpty ||
        birthDateTrim.isEmpty ||
        guardianNameTrim.isEmpty ||
        guardianPhoneTrim.isEmpty ||
        _selectedClass == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data siswa wajib diisi dengan lengkap.'),
          backgroundColor: AppColors.danger,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Highlight errors visually as well
      setState(() {
        _nameError = nameTrim.isEmpty ? 'Wajib diisi' : null;
        _nisnError = nisnTrim.isEmpty ? 'Wajib diisi' : null;
        _nisError = nisTrim.isEmpty ? 'Wajib diisi' : null;
        _birthPlaceError = birthPlaceTrim.isEmpty ? 'Wajib diisi' : null;
        _phoneError = phoneTrim.isEmpty ? 'Wajib diisi' : null;
        _addressError = addressTrim.isEmpty ? 'Wajib diisi' : null;
        _birthDateError = birthDateTrim.isEmpty ? 'Wajib diisi' : null;
        _classError = _selectedClass == null ? 'Pilih kelas' : null;
        _guardianNameError = guardianNameTrim.isEmpty ? 'Wajib diisi' : null;
        _guardianPhoneError = guardianPhoneTrim.isEmpty ? 'Wajib diisi' : null;
      });
      return;
    }

    // Additional format validations
    setState(() {
      _nameError = RegExp(r'[0-9]').hasMatch(nameTrim) ? 'Nama tidak boleh mengandung angka' : null;
      if (!RegExp(r"^[a-zA-Z\s\-\.\'\`]+$").hasMatch(nameTrim)) _nameError = 'Nama hanya boleh karakter huruf dan strip (-)';
      
      _nisnError = (!RegExp(r'^[0-9]+$').hasMatch(nisnTrim) || nisnTrim.length != 10) ? 'NISN harus 10 digit angka' : null;
      _nisError = (!RegExp(r'^[0-9]+$').hasMatch(nisTrim)) ? 'NIS hanya boleh berisi angka' : null;
      
      _phoneError = (phoneTrim.length < 9 || phoneTrim.length > 15) ? 'Nomor telepon tidak valid' : null;
      _guardianPhoneError = (guardianPhoneTrim.length < 9 || guardianPhoneTrim.length > 15) ? 'Nomor telepon wali tidak valid' : null;
    });

    if (_nameError != null ||
        _nisnError != null ||
        _nisError != null ||
        _phoneError != null ||
        _guardianPhoneError != null) {
      return;
    }

    setState(() => _isUploading = true);

    String finalPhotoUrl = _photoUrl;

    if (_pickedImage != null) {
      final uploadedUrl = await CloudinaryService().uploadImage(_pickedImage!);
      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        finalPhotoUrl = uploadedUrl;
      }
    } else if (_isPhotoRemoved) {
      finalPhotoUrl = '';
    }

    final newStudent = StudentModel(
      docId: widget.initialStudent?.docId ?? '',
      id: widget.initialStudent?.id ?? 0,
      name: nameTrim,
      nisn: nisnTrim,
      nis: nisTrim,
      className: _selectedClass!,
      major: _extractMajorFromClass(_selectedClass!),
      gender: _selectedGender,
      birthPlace: birthPlaceTrim,
      birthDate: birthDateTrim,
      religion: _selectedReligion,
      phone: phoneTrim,
      guardianName: guardianNameTrim,
      guardianPhone: guardianPhoneTrim,
      address: addressTrim,
      status: _selectedStatus,
      photoUrl: finalPhotoUrl,
    );

    widget.onSubmit(newStudent);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final isEdit = widget.initialStudent != null;
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height - mediaQuery.viewInsets.bottom - 48;
    final maxHeight = availableHeight > 280 ? availableHeight : 280.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: maxHeight,
        ),
        child: Column(
          children: [
            // Header 1:1 with design/index.html line 577
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEdit ? 'Ubah Data Siswa' : 'Tambah Siswa Baru',
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
            const Divider(height: 1),

            // Form Body Scrollable (1:1 design/index.html lines 584-655)
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Picker Component
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onTap: _isUploading ? null : _handleAvatarTap,
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryLight,
                                    border: Border.all(color: AppColors.primary, width: 2),
                                  ),
                                  child: ClipOval(
                                    child: _pickedImageBytes != null
                                        ? Image.memory(
                                            _pickedImageBytes!,
                                            fit: BoxFit.cover,
                                            width: 86,
                                            height: 86,
                                          )
                                        : (_photoUrl.isNotEmpty
                                            ? Image.network(
                                                _photoUrl,
                                                fit: BoxFit.cover,
                                                width: 86,
                                                height: 86,
                                                errorBuilder: (context, error, stackTrace) => const Icon(
                                                  Icons.person_rounded,
                                                  size: 46,
                                                  color: AppColors.primary,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.person_rounded,
                                                size: 46,
                                                color: AppColors.primary,
                                              )),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: _isUploading ? null : _handleAvatarTap,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.photo_library_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Foto Profil Siswa (Opsional)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    AppTextField(
                      label: 'Nama Lengkap *',
                      hint: 'Masukkan nama lengkap',
                      controller: _nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\.\'\`]")),
                      ],
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'NISN *',
                            hint: '10 digit angka',
                            controller: _nisnController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            errorText: _nisnError,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            label: 'NIS *',
                            hint: 'Contoh: 210103',
                            controller: _nisController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            errorText: _nisError,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    AppDropdown<String>(
                      label: 'Kelas (Rombel) *',
                      value: _selectedClass,
                      errorText: _classError,
                      items: widget.rombelList.map((cls) {
                        return DropdownMenuItem(
                          value: cls,
                          child: Text('Kelas $cls'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedClass = val;
                            _classError = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Gender Options (1:1 with design/styles.css .gender-option)
                    Text(
                      'Jenis Kelamin *',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _GenderOptionChip(
                            label: 'Laki-laki',
                            isSelected: _selectedGender == 'Laki-laki',
                            onTap: () => setState(() => _selectedGender = 'Laki-laki'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _GenderOptionChip(
                            label: 'Perempuan',
                            isSelected: _selectedGender == 'Perempuan',
                            onTap: () => setState(() => _selectedGender = 'Perempuan'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Tempat Lahir *',
                            hint: 'Misal: Jakarta',
                            controller: _birthPlaceController,
                            errorText: _birthPlaceError,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            label: 'Tanggal Lahir *',
                            hint: 'Pilih tanggal',
                            controller: _birthDateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            errorText: _birthDateError,
                            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppDropdown<String>(
                            label: 'Agama *',
                            value: _selectedReligion,
                            items: const [
                              DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                              DropdownMenuItem(value: 'Kristen', child: Text('Kristen')),
                              DropdownMenuItem(value: 'Katolik', child: Text('Katolik')),
                              DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                              DropdownMenuItem(value: 'Budha', child: Text('Budha')),
                              DropdownMenuItem(value: 'Konghucu', child: Text('Konghucu')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedReligion = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppDropdown<String>(
                            label: 'Status Siswa *',
                            value: _selectedStatus,
                            items: const [
                              DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
                              DropdownMenuItem(value: 'Alumni', child: Text('Alumni')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedStatus = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    AppTextField(
                      label: 'Nomor Telepon Siswa *',
                      hint: 'Contoh: 08123456789',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      errorText: _phoneError,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]')),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Nama Wali / Ortu *',
                            hint: 'Nama wali/orang tua',
                            controller: _guardianNameController,
                            errorText: _guardianNameError,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\.\'\`]")),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            label: 'No. Telp Wali *',
                            hint: 'Contoh: 08123456789',
                            controller: _guardianPhoneController,
                            keyboardType: TextInputType.phone,
                            errorText: _guardianPhoneError,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s]')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    AppTextField(
                      label: 'Alamat Rumah *',
                      hint: 'Alamat rumah lengkap',
                      controller: _addressController,
                      maxLines: 2,
                      errorText: _addressError,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Footer Actions (1:1 design/index.html line 660)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Batal',
                      onPressed: _isUploading ? null : () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: _isUploading
                          ? 'Mengunggah Foto...'
                          : (isEdit ? 'Simpan Perubahan' : 'Simpan Data'),
                      icon: Icons.check,
                      isLoading: _isUploading,
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

class _GenderOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : textColor,
          ),
        ),
      ),
    );
  }
}
