# 🎓 PANDUAN BELAJAR: MEMBUAT APLIKASI SEKOLAHKU DARI NOL (FOR UJIKOM/EXAM)
## Panduan Langkah Demi Langkah Menulis Kode Aplikasi Flutter + Firebase Data Management Siswa

> **Tujuan Dokumen ini:** Dibuat khusus untuk bahan belajar Anda jika saat **Ujikom (Uji Kompetensi)** penguji meminta Anda **membuat atau menjelaskan ulang kodenya dari awal (from scratch)**.

---

## 🗂️ DAFTAR ISI

1. [Konsep Utama & Mental Model Aplikasi](#1-konsep-utama--mental-model-aplikasi)
2. [Tahap 1: Inisialisasi Proyek & Dependency](#2-tahap-1-inisialisasi-proyek--dependency)
3. [Tahap 2: Membuat Sistem Warna & Tema (`AppColors` & `AppTheme`)](#3-tahap-2-membuat-sistem-warna--tema)
4. [Tahap 3: Membuat Data Model (`StudentModel`)](#4-tahap-3-membuat-data-model)
5. [Tahap 4: Membuat Database Layer (`FirestoreService`)](#5-tahap-4-membuat-database-layer)
6. [Tahap 5: Membuat State Management Utama (`AppState`)](#6-tahap-5-membuat-state-management-utama)
7. [Tahap 6: Menghubungkan Firebase di `main.dart`](#7-tahap-6-menghubungkan-firebase-di-maindart)
8. [Tahap 7: Membuat Layar-Layar Utama (S01–S12)](#8-tahap-7-membuat-layar-layar-utama)
9. [Rumus Penting yang Sering Ditanyakan Penguji](#9-rumus-penting-yang-sering-ditanyakan-penguji)
10. [Tips Menjawab Pertanyaan Penguji Ujikom](#10-tips-menjawab-pertanyaan-penguji-ujikom)

---

## 1. Konsep Utama & Mental Model Aplikasi {#1-konsep-utama--mental-model-aplikasi}

Sebelum menulis kode, pahami **3 Pilar Utama** aplikasi ini:

```
┌─────────────────────────────────────────────────────────┐
│                    MaterialApp (main.dart)              │
└────────────────────────────┬────────────────────────────┘
                             │ (Mendengarkan AppState)
┌────────────────────────────▼────────────────────────────┐
│                  AppState (ChangeNotifier)               │
│  - Peran: Admin / Client (otomatis dari email login)    │
│  - Stream Realtime: Firestore → _studentsData           │
│  - ThemeNotifier: ValueNotifier<ThemeMode> (Zero-lag)   │
└─────────────┬──────────────────────────────┬────────────┘
              │                              │
┌─────────────▼─────────────┐  ┌─────────────▼─────────────┐
│  FirestoreService (Cloud) │  │    UI Screens (Features)   │
│  - Collection: students   │  │  - S01: Login            │
│  - Document: settings/app │  │  - S02: Client Home      │
└───────────────────────────┘  │  - S03: Client List      │
                               │  - S04: Admin Dashboard  │
                               │  - S05: Admin Student    │
                               │  - S09: Profile & Rombel │
                               └──────────────────────────┘
```

### Dua Peran Pengguna (Role-Aware):
- **Admin** (Email mengandung `admin` atau `admin@sekolahku.sch.id`): Akses penuh ke Dashboard S04, Kelola Siswa S05 (CRUD), Kelola Rombel S09.
- **Client** (Email umum): Akses ke Beranda S02 (Recap), Daftar Siswa S03 (Read-only + Filter + Print), tanpa tombol Edit/Hapus.

---

## 2. Tahap 1: Inisialisasi Proyek & Dependency {#2-tahap-1-inisialisasi-proyek--dependency}

Jika diminta membuat dari terminal:

```bash
# 1. Buat project Flutter baru
flutter create frontend
cd frontend

# 2. Tambahkan paket-paket utama
flutter pub add firebase_core firebase_auth cloud_firestore google_fonts
```

### Konfigurasi `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.15.1
  firebase_auth: ^5.6.2
  cloud_firestore: ^5.6.9
  google_fonts: ^6.2.1
```

---

## 3. Tahap 2: Membuat Sistem Warna & Tema (`AppColors` & `AppTheme`) {#3-tahap-2-membuat-sistem-warna--tema}

Buat file di `lib/app/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Color
  static const primary = Color(0xFF2563EB); // Biru Utama
  static const primaryLight = Color(0xFFDBEAFE);

  // Status Colors
  static const danger = Color(0xFFDC2626); // Merah untuk Hapus
  static const dangerBg = Color(0xFFFEE2E2);
  static const success = Color(0xFF16A34A); // Hijau untuk Aktif
  static const successBg = Color(0xFFDCFCE7);

  // Surface & Neutral
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF1E293B);
  static const borderLight = Color(0xFFE2E8F0);
  static const borderDark = Color(0xFF334155);

  static const textLight = Color(0xFF0F172A);
  static const textDark = Color(0xFFF8FAFC);
  static const textMutedLight = Color(0xFF64748B);
  static const textMutedDark = Color(0xFF94A3B8);
}
```

---

## 4. Tahap 3: Membuat Data Model (`StudentModel`) {#4-tahap-3-membuat-data-model}

Buat file di `lib/core/models/student_model.dart`.
*Kunci Ujikom: Model harus punya konstruktor `fromFirestore` dan method `toFirestore` untuk komunikasi dengan cloud.*

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String docId;    // Document ID dari Firestore
  final int id;          // ID numerik
  final String name;     // Nama Lengkap
  final String nis;      // NIS Siswa
  final String className;// Nama Kelas (Rombel)
  final String gender;   // 'Laki-laki' / 'Perempuan'
  final String status;   // 'Aktif' / 'Alumni'
  final String address;
  final String birthDate;
  final String religion;
  final String guardianName;
  final String guardianPhone;

  const StudentModel({
    this.docId = '',
    required this.id,
    required this.name,
    required this.nis,
    required this.className,
    required this.gender,
    required this.address,
    required this.birthDate,
    required this.religion,
    required this.guardianName,
    required this.guardianPhone,
    this.status = 'Aktif',
  });

  // Konversi dari DocumentSnapshot Firestore ke Object Dart
  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      docId: doc.id,
      id: (data['id'] as num?)?.toInt() ?? 0,
      name: data['name'] as String? ?? '',
      nis: data['nis'] as String? ?? '',
      className: data['class'] as String? ?? '',
      gender: data['gender'] as String? ?? 'Laki-laki',
      address: data['address'] as String? ?? '',
      birthDate: data['birthDate'] as String? ?? '',
      religion: data['religion'] as String? ?? 'Islam',
      guardianName: data['guardianName'] as String? ?? '',
      guardianPhone: data['guardianPhone'] as String? ?? '',
      status: data['status'] as String? ?? 'Aktif',
    );
  }

  // Konversi dari Object Dart ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toFirestore() => {
    'id': id,
    'name': name,
    'nis': nis,
    'class': className,
    'gender': gender,
    'address': address,
    'birthDate': birthDate,
    'religion': religion,
    'guardianName': guardianName,
    'guardianPhone': guardianPhone,
    'status': status,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  StudentModel copyWith({
    String? docId, int? id, String? name, String? nis, String? className,
    String? gender, String? address, String? birthDate, String? religion,
    String? guardianName, String? guardianPhone, String? status,
  }) {
    return StudentModel(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      name: name ?? this.name,
      nis: nis ?? this.nis,
      className: className ?? this.className,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      religion: religion ?? this.religion,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      status: status ?? this.status,
    );
  }
}
```

---

## 5. Tahap 4: Membuat Database Layer (`FirestoreService`) {#5-tahap-4-membuat-database-layer}

Buat file di `lib/core/services/firestore_service.dart`.
*Semua operasi CRUD Firestore terpusat di sini.*

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream data siswa secara real-time (otomatis terupdate jika ada perubahan di Firestore)
  Stream<List<StudentModel>> streamStudents() {
    return _db.collection('students').orderBy('name').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => StudentModel.fromFirestore(doc)).toList(),
    );
  }

  // Tambah Siswa
  Future<void> addStudent(StudentModel student) async {
    await _db.collection('students').add(student.toFirestore());
  }

  // Edit Siswa
  Future<void> updateStudent(StudentModel student) async {
    if (student.docId.isEmpty) return;
    await _db.collection('students').doc(student.docId).update(student.toFirestore());
  }

  // Hapus Siswa
  Future<void> deleteStudent(String docId) async {
    if (docId.isEmpty) return;
    await _db.collection('students').doc(docId).delete();
  }
}
```

---

## 6. Tahap 5: Membuat State Management Utama (`AppState`) {#6-tahap-5-membuat-state-management-utama}

Buat file di `lib/core/state/app_state.dart`.

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';
import '../services/firestore_service.dart';

enum AppRole { admin, client }

class AppState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // 1. Theme Switcher Isolasi (ValueNotifier agar ganti tema bebas lag)
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  ThemeMode get themeMode => themeNotifier.value;

  void setThemeMode(ThemeMode mode) {
    if (themeNotifier.value == mode) return;
    themeNotifier.value = mode;
  }

  // 2. Auth State
  User? _firebaseUser;
  AppRole _currentRole = AppRole.client;
  String _activeScreen = 's01';

  AppRole get currentRole => _currentRole;
  String get activeScreen => _activeScreen;
  User? get firebaseUser => _firebaseUser;

  // 3. Data Realtime Siswa
  List<StudentModel> _studentsData = [];
  List<StudentModel> get studentsData => List.unmodifiable(_studentsData);
  StreamSubscription? _sub;

  AppState() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  void _onAuthChanged(User? user) {
    _firebaseUser = user;
    if (user == null) {
      _sub?.cancel();
      _studentsData = [];
      _activeScreen = 's01';
    } else {
      // Tentukan peran berdasarkan email
      _currentRole = (user.email ?? '').contains('admin') ? AppRole.admin : AppRole.client;
      _activeScreen = _currentRole == AppRole.admin ? 's04' : 's02';
      
      // Listen stream siswa secara realtime
      _sub?.cancel();
      _sub = _firestoreService.streamStudents().listen((data) {
        _studentsData = data;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  // 4. Method Login Firebase Auth Real
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login gagal';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // 5. Action Navigasi
  void navTo(String screen) {
    _activeScreen = screen;
    notifyListeners();
  }

  // 6. Action CRUD Siswa
  Future<void> addStudent(StudentModel s) => _firestoreService.addStudent(s);
  Future<void> updateStudent(StudentModel s) => _firestoreService.updateStudent(s);
  Future<void> deleteStudent(StudentModel s) => _firestoreService.deleteStudent(s.docId);
}
```

---

## 7. Tahap 6: Menghubungkan Firebase di `main.dart` {#7-tahap-6-menghubungkan-firebase-di-maindart}

Buka `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/state/app_state.dart';
import 'app/theme/app_theme.dart';
import 'features/s01_login_screen.dart';
import 'features/s02_client_home_screen.dart';
import 'features/s03_client_student_list_screen.dart';
import 'features/s04_admin_dashboard_screen.dart';
import 'features/s05_admin_student_list_screen.dart';
import 'features/s09_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SekolahKuApp());
}

class SekolahKuApp extends StatefulWidget {
  const SekolahKuApp({super.key});

  @override
  State<SekolahKuApp> createState() => _SekolahKuAppState();
}

class _SekolahKuAppState extends State<SekolahKuApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder memastikan pergantian tema instan tanpa merender ulang layar
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _appState.themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'SekolahKu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: ListenableBuilder(
            listenable: _appState,
            builder: (context, _) => _buildScreen(_appState.activeScreen),
          ),
        );
      },
    );
  }

  Widget _buildScreen(String screen) {
    switch (screen) {
      case 's01': return S01LoginScreen(appState: _appState);
      case 's02': return S02ClientHomeScreen(appState: _appState);
      case 's03': return S03ClientStudentListScreen(appState: _appState);
      case 's04': return S04AdminDashboardScreen(appState: _appState);
      case 's05': return S05AdminStudentListScreen(appState: _appState);
      case 's09': return S09ProfileScreen(appState: _appState);
      default: return S01LoginScreen(appState: _appState);
    }
  }
}
```

---

## 8. Tahap 7: Membuat Layar-Layar Utama {#8-tahap-7-membuat-layar-layar-utama}

### Ringkasan Logika Tiap Layar:

1. **`S01LoginScreen`**:
   - Memiliki form controller `_emailController` & `_passwordController`.
   - Mengganti dummy login dengan memanggil `await widget.appState.login(email, password)`.
   - Menampilkan error `_errorMessage` jika login gagal.

2. **`S04AdminDashboardScreen`**:
   - **Perhitungan Rasio Gender Real-time**:
     ```dart
     final totalSiswa = appState.studentsData.length;
     final countL = appState.studentsData.where((s) => s.gender == 'Laki-laki').length;
     final countP = appState.studentsData.where((s) => s.gender == 'Perempuan').length;

     // Jika 0 siswa, persentase harus 0% (bukan 50%)
     final percentL = totalSiswa > 0 ? ((countL / totalSiswa) * 100).round() : 0;
     final percentP = totalSiswa > 0 ? ((countP / totalSiswa) * 100).round() : 0;
     ```

3. **`S05AdminStudentListScreen`**:
   - Menampilkan `ListView.builder` berisi `StudentCard`.
   - Tombol **Edit** memanggil `StudentFormModal.show(...)`.
   - Tombol **Hapus** memanggil `ConfirmationDialog.show(...)` lalu `appState.deleteStudent(student)`.

---

## 9. Rumus Penting yang Sering Ditanyakan Penguji {#9-rumus-penting-yang-sering-ditanyakan-penguji}

| Pertanyaan Penguji | Jawaban & Potongan Kode |
|---|---|
| **Bagaimana cara kalkulasi persen gender secara realtime?** | `final percentL = totalSiswa > 0 ? ((countL / totalSiswa) * 100).round() : 0;`<br>Gunakan pengecekan `totalSiswa > 0` agar saat data kosong hasilnya `0%` (bukan error division by zero atau 50%). |
| **Bagaimana aplikasi membedakan tampilan Admin dan Client?** | Menggunakan variabel `_currentRole` di `AppState`. Saat user login, jika email mengandung kata `admin`, `_currentRole = AppRole.admin` dan mengarahkan ke `S04`. Jika bukan, ke `S02` (Client read-only). |
| **Bagaimana pergantian tema dilakukan tanpa lag?** | Menggunakan `ValueNotifier<ThemeMode>` yang terisolasi dari `ChangeNotifier` utama. `MaterialApp` dibungkus `ValueListenableBuilder<ThemeMode>`, sehingga saat tema berubah, **hanya MaterialApp yang meng-update themeMode**, tanpa merebuild seluruh tree layar. |
| **Bagaimana data dari Firestore otomatis memperbarui UI?** | Menggunakan `FirestoreService.streamStudents()` yang mengembalikan `Stream<List<StudentModel>>`. Di `AppState`, stream didengarkan (`listen`), dan setiap ada dokumen baru/edit/hapus di cloud, `_studentsData` terupdate dan `notifyListeners()` memicu UI rebuild. |

---

## 10. Tips Menjawab Pertanyaan Penguji Ujikom {#10-tips-menjawab-pertanyaan-penguji-ujikom}

1. **Jelaskan Alur Data dengan Percaya Diri:**
   > *"Aplikasi ini menggunakan pola arsitektur State Management berbasis `ChangeNotifier` dengan `FirestoreService` sebagai data layer. Data siswa disinkronkan secara real-time dari Cloud Firestore menggunakan Stream listener."*

2. **Jelaskan Fitur Auth:**
   > *"Authentication ditangani oleh Firebase Auth dengan skema role-based access. Admin memiliki hak akses CRUD penuh, sedangkan Client hanya memiliki akses Read-Only untuk melihat data dan mencetak laporan."*

3. **Jelaskan Optimasi Performa:**
   > *"Untuk memastikan pergantian tema tidak patah-patah, saya memisahkan state tema ke dalam `ValueNotifier<ThemeMode>` terpisah dari `AppState` utama. Ini menjamin perpindahan tema terjadi dalam 1 frame."*

---

*Dokumen ini merupakan panduan lengkap untuk mempelajari alur logika dan penulisan kode aplikasi SekolahKu dari nol saat pengujian/Ujikom.*
