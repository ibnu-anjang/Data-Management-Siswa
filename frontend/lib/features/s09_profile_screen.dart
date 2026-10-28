import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app/theme/app_colors.dart';
import '../core/services/cloudinary_service.dart';
import '../core/state/app_state.dart';
import '../shared/widgets/app_bottom_nav_bar.dart';
import '../shared/widgets/app_buttons.dart';
import '../shared/widgets/app_avatar.dart';
import '../shared/modals/rombel_form_modal.dart';
import '../shared/modals/school_profile_modal.dart';

class S09ProfileScreen extends StatefulWidget {
  final AppState appState;

  const S09ProfileScreen({super.key, required this.appState});

  @override
  State<S09ProfileScreen> createState() => _S09ProfileScreenState();
}

class _S09ProfileScreenState extends State<S09ProfileScreen> {
  bool _isUploadingPhoto = false;

  Future<void> _handlePickProfilePhoto() async {
    if (_isUploadingPhoto) return;
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
                  'Foto Profil Pengguna',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  title: Text('Pilih dari Galeri', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUploadPhoto(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                  title: Text('Ambil Foto Kamera', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndUploadPhoto(ImageSource.camera);
                  },
                ),
                if (widget.appState.userPhotoUrl.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                    title: const Text('Hapus Foto Profil (Kembali ke Inisial)', style: TextStyle(color: AppColors.danger)),
                    onTap: () async {
                      Navigator.pop(ctx);
                      await widget.appState.updateUserPhoto('');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Foto profil berhasil dihapus. Kembali ke foto inisial.'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadPhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );
      if (file == null) return;

      setState(() => _isUploadingPhoto = true);
      final uploadedUrl = await CloudinaryService().uploadImage(file);
      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        await widget.appState.updateUserPhoto(uploadedUrl);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto profil berhasil diperbarui!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui foto: $e'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
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

    final isAdmin = appState.currentRole == AppRole.admin;
    final school = appState.schoolProfile;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar (1:1 with design/index.html line 463)
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
                          'Profil & Pengaturan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Kelola akun dan sistem',
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

            // Scrollable Content Body (1:1 with design/index.html line 470)
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
                    // Profile User Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onTap: () => _handlePickProfilePhoto(),
                                borderRadius: BorderRadius.circular(32),
                                child: _isUploadingPhoto
                                    ? Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isAdmin ? AppColors.primary : AppColors.success,
                                        ),
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : AppAvatar(
                                        name: appState.userName.isNotEmpty
                                            ? appState.userName
                                            : (isAdmin ? 'Administrator' : 'Client'),
                                        photoUrl: appState.userPhotoUrl,
                                        size: 52,
                                        backgroundColor: isAdmin ? AppColors.primary : AppColors.success,
                                        textColor: Colors.white,
                                        fontSize: 20,
                                        showBorder: true,
                                        borderColor: isAdmin ? AppColors.primary : AppColors.success,
                                        borderWidth: 2,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () => _handlePickProfilePhoto(),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceDark : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 11,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isAdmin ? 'Administrator Utama' : 'Pengunjung (Client)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  appState.userEmail.isNotEmpty
                                      ? appState.userEmail
                                      : (isAdmin ? 'admin@sekolahku.sch.id' : 'client@sekolahku.sch.id'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isAdmin ? AppColors.primaryLight : AppColors.successBg,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    isAdmin ? 'Peran: Admin' : 'Peran: Client',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isAdmin ? AppColors.primary : AppColors.successText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Admin School Profile Section (S14 - 1:1 line 480)
                    if (isAdmin) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Identitas Sekolah & Kop Laporan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (isAdmin) ...[
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.edit_outlined, size: 14),
                              label: const Text('Ubah Identitas', style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              ),
                              onPressed: () {
                                SchoolProfileModal.show(
                                  context: context,
                                  initialProfile: school,
                                  onSubmit: (updated) => widget.appState.updateSchoolProfile(updated),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              school.name,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textColor),
                            ),
                            const SizedBox(height: 4),
                            Text('NPSN: ${school.npsn} • T.A. ${school.academicYear} (${school.semester})', style: TextStyle(fontSize: 12, color: textMuted)),
                            Text('Kepala Sekolah: ${school.principalName}', style: TextStyle(fontSize: 12, color: textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Admin Rombel Section (1:1 design/index.html line 493 & design/app.js renderRombelManager)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Kelola Kelas (Rombel)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text('Rombel', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            onPressed: () {
                              RombelFormModal.show(
                                context: context,
                                onSubmit: (newClass) => appState.addRombel(newClass),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: appState.rombelList.map((cls) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cls,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textMuted,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      RombelFormModal.show(
                                        context: context,
                                        className: cls,
                                        onSubmit: (newName) => appState.updateRombel(cls, newName),
                                      );
                                    },
                                    child: Icon(Icons.edit_outlined, size: 14, color: textMuted),
                                  ),
                                  const SizedBox(width: 2),
                                  InkWell(
                                    onTap: () => _confirmDeleteRombel(context, cls),
                                    child: const Icon(Icons.close, size: 14, color: AppColors.danger),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Pilihan Tema (1:1 design/index.html line 508)
                    Text(
                      'Pilihan Tema',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ThemeSegmentButton(
                          label: 'Terang',
                          icon: Icons.wb_sunny_outlined,
                          isSelected: appState.themeMode == ThemeMode.light,
                          onTap: () => appState.setThemeMode(ThemeMode.light),
                        ),
                        const SizedBox(width: 8),
                        _ThemeSegmentButton(
                          label: 'Gelap',
                          icon: Icons.nightlight_round,
                          isSelected: appState.themeMode == ThemeMode.dark,
                          onTap: () => appState.setThemeMode(ThemeMode.dark),
                        ),
                        const SizedBox(width: 8),
                        _ThemeSegmentButton(
                          label: 'Sistem',
                          icon: Icons.monitor_outlined,
                          isSelected: appState.themeMode == ThemeMode.system,
                          onTap: () => appState.setThemeMode(ThemeMode.system),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Logout Button (1:1 design/index.html line 523)
                    DangerButton(
                      label: 'Keluar dari Akun',
                      icon: Icons.logout,
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
              role: appState.currentRole,
              activeScreen: 's09',
              onSelectTab: (screen) => appState.navTo(screen),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteRombel(BuildContext context, String cls) {
    final count = widget.appState.getStudentCountByClass(cls);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    if (count > 0) {
      // Data Integrity Protection: Block deletion if students are enrolled
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: cardBg,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.warningBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  'Kelas Tidak Dapat Dihapus',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masih ada $count siswa terdaftar di kelas "$cls".\n\nUntuk menjaga integritas data dan mencegah hilangnya siswa dari filter, silakan ubah atau pindahkan kelas siswa tersebut terlebih dahulu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Mengerti',
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Empty class: confirm deletion
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: cardBg,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.dangerBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline, color: AppColors.danger, size: 26),
                ),
                const SizedBox(height: 14),
                Text(
                  'Hapus Kelas "$cls"?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kelas ini belum memiliki siswa. Apakah Anda yakin ingin menghapusnya dari daftar rombel?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Batal',
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DangerButton(
                        label: 'Hapus',
                        onPressed: () {
                          Navigator.pop(ctx);
                          widget.appState.deleteRombel(cls);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class _ThemeSegmentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeSegmentButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final activeColor = isSelected ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: activeColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: activeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
