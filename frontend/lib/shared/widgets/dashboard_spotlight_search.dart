import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/state/app_state.dart';
import '../modals/student_detail_modal.dart';
import 'app_avatar.dart';

/// Instant spotlight search bar with real-time preview dropdown for dashboards.
/// Uses TapRegion to guarantee click interactions on student items work 100% reliably.
class DashboardSpotlightSearch extends StatefulWidget {
  final AppState appState;
  final String hintText;
  final VoidCallback onSeeAll;

  const DashboardSpotlightSearch({
    super.key,
    required this.appState,
    this.hintText = 'Cari cepat siswa (Nama, NISN, atau Kelas)...',
    required this.onSeeAll,
  });

  @override
  State<DashboardSpotlightSearch> createState() => _DashboardSpotlightSearchState();
}

class _DashboardSpotlightSearchState extends State<DashboardSpotlightSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<StudentModel> _results = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _controller.text.trim().isNotEmpty) {
        setState(() => _isOpen = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _results = [];
        _isOpen = false;
      });
    } else {
      setState(() {
        _results = widget.appState.searchStudentsInstant(trimmed, limit: 5);
        _isOpen = true;
      });
    }
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _results = [];
      _isOpen = false;
    });
    _focusNode.unfocus();
  }

  void _handleStudentTap(StudentModel student) {
    setState(() => _isOpen = false);
    _focusNode.unfocus();
    StudentDetailModal.show(context, student);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final dropdownBg = isDark ? AppColors.surfaceSubtleDark : Colors.white;

    final hasQuery = _controller.text.trim().isNotEmpty;
    final showDropdown = _isOpen && hasQuery;

    return TapRegion(
      onTapOutside: (_) {
        if (_isOpen) {
          setState(() => _isOpen = false);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input Bar
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOpen ? AppColors.primary : borderColor,
                width: _isOpen ? 1.5 : 1.0,
              ),
              boxShadow: _isOpen
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: _isOpen ? AppColors.primary : textMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onQueryChanged,
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        setState(() => _isOpen = true);
                      }
                    },
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: 12.5,
                        color: textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (hasQuery)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: textMuted,
                    splashRadius: 18,
                    onPressed: _clearSearch,
                  ),
                const SizedBox(width: 4),
              ],
            ),
          ),

          // Live Results Preview Dropdown Card
          if (showDropdown) ...[
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: dropdownBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _results.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tidak ada siswa yang cocok dengan "${_controller.text.trim()}".',
                              style: TextStyle(fontSize: 12, color: textMuted),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          child: Text(
                            'HASIL PENCARIAN CEPAT (${_results.length})',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ..._results.map((student) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _handleStudentTap(student),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                child: Row(
                                  children: [
                                    AppAvatar(
                                      name: student.name,
                                      photoUrl: student.photoUrl,
                                      size: 38,
                                      borderRadius: 8,
                                      backgroundColor: AppColors.primaryLight,
                                      textColor: AppColors.primary,
                                      fontSize: 15,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'NISN: ${student.nisn} • ${student.className}',
                                            style: TextStyle(fontSize: 11, color: textMuted),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Detail',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const Divider(height: 8),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() => _isOpen = false);
                              _focusNode.unfocus();
                              widget.onSeeAll();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Buka Semua di Layar Data Siswa',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
