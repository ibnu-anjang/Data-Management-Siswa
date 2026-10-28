import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';
import '../models/school_profile_model.dart';
import '../services/firestore_service.dart';

enum AppRole { admin, client }

// Admin email addresses (in lowercase) — extend this list as needed
const List<String> _adminEmails = [
  'admin@sekolahku.sch.id',
  'sekolahkudatasiswa@gmail.com',
];

/// Checks whether a given email has admin privileges
bool _isAdminEmail(String email) {
  final lower = email.trim().toLowerCase();
  return _adminEmails.contains(lower);
}

// ────────────────────────────────────────────────────────
// Default seed data (used if Firestore is empty)
// ────────────────────────────────────────────────────────

const _defaultSchoolProfile = SchoolProfileModel(
  name: "SMK AK Nusa Bangsa",
  npsn: "20103456",
  address: "Jl. KH. Sholeh Iskandar No. 1, Bogor",
  phone: "(0251) 8345678",
  email: "info@smk-aknusalab.sch.id",
  academicYear: "2025/2026",
  semester: "Semester Genap",
  principalName: "Drs. H. Ahmad Fauzi, M.Pd.",
  principalNip: "19720815 199803 1 004",
);

const List<String> _defaultRombelList = [
  "X IPA 1", "X IPA 2", "X IPS 1",
  "XI IPA 1", "XI IPA 2", "XI IPS 1",
  "XII IPA 1", "XII IPA 2", "XII IPS 1",
];

// ────────────────────────────────────────────────────────
// AppState
// ────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // ── Theme (isolated ValueNotifier — zero screen rebuild on theme change) ──
  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);
  ThemeMode get themeMode => themeNotifier.value;

  // ── Auth State ──
  User? _firebaseUser;
  AppRole _currentRole = AppRole.client;
  AppRole get currentRole => _currentRole;
  User? get firebaseUser => _firebaseUser;
  String get userEmail => _firebaseUser?.email ?? '';
  String get userName => _firebaseUser?.displayName ?? userEmail.split('@').first;

  // ── Navigation ──
  String _activeScreen = 's01';
  String get activeScreen => _activeScreen;

  // ── Data Loading ──
  bool _isLoadingData = true;
  bool get isLoadingData => _isLoadingData;
  String? _dataError;
  String? get dataError => _dataError;

  // ── Students & Settings (live Firestore stream) ──
  List<StudentModel> _studentsData = [];
  StreamSubscription<List<StudentModel>>? _studentsSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _settingsSubscription;

  // ── Rombel (Classes) ──
  List<String> _rombelList = List.from(_defaultRombelList);
  List<String> get rombelList => List.unmodifiable(_rombelList);

  // ── School Profile ──
  SchoolProfileModel _schoolProfile = _defaultSchoolProfile;
  SchoolProfileModel get schoolProfile => _schoolProfile;

  // ── Toast ──
  String? _toastMessage;
  String? get toastMessage => _toastMessage;

  // ── Search & Filter State ──
  String _clientSearchQuery = '';
  String _clientFilterClass = 'all';
  String _clientFilterGender = 'all';
  String _clientFilterStatus = 'all';

  String _adminSearchQuery = '';
  String _adminFilterClass = 'all';
  String _adminFilterGender = 'all';
  String _adminFilterStatus = 'all';

  // ────────────────────────────────────────────────────────
  // Constructor
  // ────────────────────────────────────────────────────────

  AppState() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // ────────────────────────────────────────────────────────
  // Auth State Listener
  // ────────────────────────────────────────────────────────

  void _onAuthStateChanged(User? user) {
    _firebaseUser = user;
    if (user == null) {
      // User is signed out
      _studentsSubscription?.cancel();
      _studentsSubscription = null;
      _settingsSubscription?.cancel();
      _settingsSubscription = null;
      _studentsData = [];
      _activeScreen = 's01';
      notifyListeners();
    } else {
      // User is signed in — determine role, then load data
      _currentRole = _isAdminEmail(user.email ?? '') ? AppRole.admin : AppRole.client;
      _activeScreen = _currentRole == AppRole.admin ? 's04' : 's02';
      _loadAllData();
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────────
  // Data Loading
  // ────────────────────────────────────────────────────────

  Future<void> refreshData() async {
    // Firestore streams already keep data real-time.
    // This adds a visual UX delay for pull-to-refresh.
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadAllData() async {
    _isLoadingData = true;
    _dataError = null;
    notifyListeners();

    try {
      // 1. Seed settings (rombel + school profile) if first-time setup
      await _firestoreService.seedSettingsIfEmpty(
        defaultRombelList: _defaultRombelList,
        defaultProfile: _defaultSchoolProfile,
      );

      // 2. Real-time stream for settings (rombelList + schoolProfile)
      _settingsSubscription?.cancel();
      _settingsSubscription = _firestoreService.streamSettings().listen(
        (doc) {
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            final rombel = List<String>.from(data['rombelList'] ?? []);
            if (rombel.isNotEmpty) _rombelList = rombel;

            final profile = data['schoolProfile'] as Map<String, dynamic>?;
            if (profile != null) {
              _schoolProfile = SchoolProfileModel(
                name: profile['name'] as String? ?? '',
                npsn: profile['npsn'] as String? ?? '',
                address: profile['address'] as String? ?? '',
                phone: profile['phone'] as String? ?? '',
                email: profile['email'] as String? ?? '',
                academicYear: profile['academicYear'] as String? ?? '',
                semester: profile['semester'] as String? ?? '',
                principalName: profile['principalName'] as String? ?? '',
                principalNip: profile['principalNip'] as String? ?? '',
              );
            }
            notifyListeners();
          }
        },
      );

      // 3. Subscribe to real-time student stream
      _studentsSubscription?.cancel();
      _studentsSubscription = _firestoreService.streamStudents().listen(
        (students) {
          _studentsData = students;
          _isLoadingData = false;
          _dataError = null;
          notifyListeners();
        },
        onError: (e) {
          _dataError = 'Gagal memuat data: $e';
          _isLoadingData = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _dataError = 'Gagal inisialisasi data: $e';
      _isLoadingData = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────────
  // Toast
  // ────────────────────────────────────────────────────────

  void showToast(String msg) {
    _toastMessage = msg;
    notifyListeners();
  }

  void clearToast() => _toastMessage = null;

  // ────────────────────────────────────────────────────────
  // Theme
  // ────────────────────────────────────────────────────────

  void setThemeMode(ThemeMode mode) {
    if (themeNotifier.value == mode) return;
    themeNotifier.value = mode;
  }

  void cycleThemeMode() {
    if (themeNotifier.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (themeNotifier.value == ThemeMode.dark) {
      setThemeMode(ThemeMode.system);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  // ────────────────────────────────────────────────────────
  // Navigation
  // ────────────────────────────────────────────────────────

  void navTo(String screen) {
    if (_activeScreen == screen) return;
    _activeScreen = screen;
    notifyListeners();
  }

  void setRole(AppRole role) {
    if (_currentRole == role) return;
    _currentRole = role;
    _activeScreen = role == AppRole.admin ? 's04' : 's02';
    notifyListeners();
  }

  // ────────────────────────────────────────────────────────
  // Authentication
  // ────────────────────────────────────────────────────────

  /// Login with Firebase Auth — returns null on success, error message on failure
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Email tidak terdaftar. Periksa kembali.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Kata sandi salah. Periksa kembali.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'user-disabled':
          return 'Akun ini telah dinonaktifkan.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi nanti.';
        default:
          return e.message ?? 'Login gagal. Coba lagi.';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  /// Sign out from Firebase Auth
  Future<void> logout() async {
    await _auth.signOut();
    // _onAuthStateChanged will handle navigation back to s01
  }

  // ────────────────────────────────────────────────────────
  // School Profile
  // ────────────────────────────────────────────────────────

  Future<void> updateSchoolProfile(SchoolProfileModel newProfile) async {
    _schoolProfile = newProfile;
    notifyListeners();
    await _firestoreService.saveSchoolProfile(newProfile);
    showToast('Identitas Sekolah Berhasil Diperbarui');
  }

  // ────────────────────────────────────────────────────────
  // Search & Filter — Client
  // ────────────────────────────────────────────────────────

  String get clientSearchQuery => _clientSearchQuery;
  String get clientFilterClass => _clientFilterClass;
  String get clientFilterGender => _clientFilterGender;
  String get clientFilterStatus => _clientFilterStatus;

  void setClientSearch(String query) {
    if (_clientSearchQuery == query) return;
    _clientSearchQuery = query;
    notifyListeners();
  }

  void setClientFilters({String? className, String? gender, String? status}) {
    bool changed = false;
    if (className != null && _clientFilterClass != className) {
      _clientFilterClass = className; changed = true;
    }
    if (gender != null && _clientFilterGender != gender) {
      _clientFilterGender = gender; changed = true;
    }
    if (status != null && _clientFilterStatus != status) {
      _clientFilterStatus = status; changed = true;
    }
    if (changed) notifyListeners();
  }

  void setClientFilterClass(String className) {
    setClientFilters(className: className);
  }

  void resetClientFilters() {
    _clientFilterClass = 'all';
    _clientFilterGender = 'all';
    _clientFilterStatus = 'all';
    _clientSearchQuery = '';
    notifyListeners();
  }

  int get clientActiveFilterCount {
    int count = 0;
    if (_clientFilterClass != 'all') count++;
    if (_clientFilterGender != 'all') count++;
    if (_clientFilterStatus != 'all') count++;
    return count;
  }

  // ────────────────────────────────────────────────────────
  // Search & Filter — Admin
  // ────────────────────────────────────────────────────────

  String get adminSearchQuery => _adminSearchQuery;
  String get adminFilterClass => _adminFilterClass;
  String get adminFilterGender => _adminFilterGender;
  String get adminFilterStatus => _adminFilterStatus;

  void setAdminSearch(String query) {
    if (_adminSearchQuery == query) return;
    _adminSearchQuery = query;
    notifyListeners();
  }

  void setAdminFilters({String? className, String? gender, String? status}) {
    bool changed = false;
    if (className != null && _adminFilterClass != className) {
      _adminFilterClass = className; changed = true;
    }
    if (gender != null && _adminFilterGender != gender) {
      _adminFilterGender = gender; changed = true;
    }
    if (status != null && _adminFilterStatus != status) {
      _adminFilterStatus = status; changed = true;
    }
    if (changed) notifyListeners();
  }

  void setAdminFilterClass(String className) {
    setAdminFilters(className: className);
  }

  void resetAdminFilters() {
    _adminFilterClass = 'all';
    _adminFilterGender = 'all';
    _adminFilterStatus = 'all';
    _adminSearchQuery = '';
    notifyListeners();
  }

  int get adminActiveFilterCount {
    int count = 0;
    if (_adminFilterClass != 'all') count++;
    if (_adminFilterGender != 'all') count++;
    if (_adminFilterStatus != 'all') count++;
    return count;
  }

  // ────────────────────────────────────────────────────────
  // Filtered Students
  // ────────────────────────────────────────────────────────

  List<StudentModel> get studentsData => List.unmodifiable(_studentsData);

  List<StudentModel> get filteredClientStudents => _filterStudents(
        _clientSearchQuery, _clientFilterClass, _clientFilterGender, _clientFilterStatus);

  List<StudentModel> get filteredAdminStudents => _filterStudents(
        _adminSearchQuery, _adminFilterClass, _adminFilterGender, _adminFilterStatus);

  List<StudentModel> _filterStudents(
      String query, String filterClass, String filterGender, String filterStatus) {
    final q = query.trim().toLowerCase();
    return _studentsData.where((student) {
      final matchesQuery = q.isEmpty ||
          student.name.toLowerCase().contains(q) ||
          student.nis.toLowerCase().contains(q) ||
          student.className.toLowerCase().contains(q);
      final matchesClass = filterClass == 'all' || student.className == filterClass;
      final matchesGender = filterGender == 'all' || student.gender == filterGender;
      final matchesStatus = filterStatus == 'all' || student.status == filterStatus;
      return matchesQuery && matchesClass && matchesGender && matchesStatus;
    }).toList();
  }

  int getStudentCountByClass(String className) {
    if (className == 'all') return _studentsData.length;
    return _studentsData.where((s) => s.className == className).length;
  }

  // ────────────────────────────────────────────────────────
  // Student CRUD — Firestore-backed
  // ────────────────────────────────────────────────────────

  Future<void> addStudent(StudentModel newStudent) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch % 100000;
      final student = newStudent.copyWith(id: id);
      await _firestoreService.addStudent(student);
      showToast('Data siswa "${student.name}" berhasil ditambahkan!');
      // List auto-updates via stream — no manual insert needed
    } catch (e) {
      showToast('Gagal menambahkan siswa: $e');
    }
  }

  Future<void> updateStudent(StudentModel updatedStudent) async {
    try {
      await _firestoreService.updateStudent(updatedStudent);
      showToast('Data siswa "${updatedStudent.name}" berhasil diperbarui!');
    } catch (e) {
      showToast('Gagal memperbarui siswa: $e');
    }
  }

  Future<void> deleteStudent(StudentModel student) async {
    try {
      await _firestoreService.deleteStudent(student.docId);
      showToast('Data siswa "${student.name}" telah dihapus.');
    } catch (e) {
      showToast('Gagal menghapus siswa: $e');
    }
  }

  // Kept for legacy callers that pass int ID — delegates to docId lookup
  Future<void> deleteStudentById(int id) async {
    final student = _studentsData.where((s) => s.id == id).firstOrNull;
    if (student != null) await deleteStudent(student);
  }

  // ────────────────────────────────────────────────────────
  // Rombel CRUD — Firestore-backed
  // ────────────────────────────────────────────────────────

  Future<void> addRombel(String className) async {
    final trimmed = className.trim();
    if (trimmed.isEmpty) return;
    if (_rombelList.contains(trimmed)) {
      showToast('Kelas "$trimmed" sudah ada!');
      return;
    }
    _rombelList.add(trimmed);
    notifyListeners();
    await _firestoreService.saveRombelList(_rombelList);
    showToast('Kelas "$trimmed" berhasil ditambahkan!');
  }

  Future<void> updateRombel(String oldName, String newName) async {
    final trimmedNew = newName.trim();
    if (trimmedNew.isEmpty) return;
    final index = _rombelList.indexOf(oldName);
    if (index != -1) {
      _rombelList[index] = trimmedNew;
      // Auto-sync students in renamed class using atomic batch write (1 single network trip)
      final toUpdate = _studentsData.where((s) => s.className == oldName).toList();
      notifyListeners();
      await _firestoreService.saveRombelList(_rombelList);
      if (toUpdate.isNotEmpty) {
        await _firestoreService.batchUpdateStudentClass(toUpdate, trimmedNew);
      }
      showToast('Kelas "$oldName" diperbarui menjadi "$trimmedNew" & data siswa tersinkronisasi.');
    }
  }

  /// Delete a rombel with data integrity protection (Restrict rule).
  /// Rejects deletion if students are still enrolled in this class.
  Future<bool> deleteRombel(String className) async {
    final studentCount = getStudentCountByClass(className);
    if (studentCount > 0) {
      showToast('Tidak dapat menghapus: Masih ada $studentCount siswa di kelas "$className".');
      return false;
    }
    _rombelList.remove(className);
    notifyListeners();
    await _firestoreService.saveRombelList(_rombelList);
    showToast('Kelas "$className" telah dihapus.');
    return true;
  }

  // ────────────────────────────────────────────────────────
  // Dispose
  // ────────────────────────────────────────────────────────

  @override
  void dispose() {
    _studentsSubscription?.cancel();
    _settingsSubscription?.cancel();
    themeNotifier.dispose();
    super.dispose();
  }
}
