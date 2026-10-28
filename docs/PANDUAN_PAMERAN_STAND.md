# 🎪 Panduan Operasional Stand & Pameran Festival Sekolah
## Aplikasi SekolahKu — Data Management Siswa

> **Dokumen Khusus untuk Penjaga Stand / Operator Laptop Windows**  
> *Gunakan panduan ini jika pengembang (Ibnu Anjang) berhalangan hadir secara langsung.*

---

## ⚡ Langkah Kilat Menjalankan di Laptop Windows (1 Menit)

Aplikasi telah disiapkan agar **100% Zero-Config** (tidak perlu menginstall Flutter, Dart, Android Studio, Firebase CLI, ataupun Node.js):

1. **Jalankan File Launcher:**
   - Buka folder proyek `data_management_siswa`.
   - **Double-click** berkas [`BUKA_SEKOLAHKU_WINDOWS.bat`](../BUKA_SEKOLAHKU_WINDOWS.bat) (atau buka langsung [`design/index.html`](../design/index.html) menggunakan Google Chrome / Microsoft Edge).
2. **Aktifkan Kiosk Mode (Layar Penuh):**
   - Begitu browser terbuka, tekan tombol **`F11`** pada keyboard agar browser masuk ke mode Fullscreen (tampilan bersih tanpa address bar).
3. **Stand Siap Digunakan!** Pengunjung festival dapat langsung berinteraksi dengan simulasi ponsel di layar.

---

## 🎮 Cheat Sheet Demo untuk Pengunjung / Juri

Jika ada juri atau pengunjung yang menghampiri stand, tunjukkan 4 fitur unggulan berikut (hanya butuh 30 detik):

| No | Fitur yang Ditunjukkan | Cara Melakukannya di Simulator | Poin yang Ditekankan |
|---|---|---|---|
| **1** | **Login & Multi-Peran** | Di layar S01, klik tombol **"Admin"** atau **"Client"** | Sistem role-based permission (Admin punya hak kelola penuh, Client hanya read-only). |
| **2** | **CRUD Siswa Cepat** | Di menu Kelola Siswa (S05 Admin), klik tombol **"+ Siswa"** atau **"Edit"** | Validasi form otomatis, segment chip gender, dan tombol hapus konfirmasi merah anti-salah-klik. |
| **3** | **Sinkronisasi Rombel** | Buka menu **Profil (S09)** → Tambah Rombel baru (`+ Rombel`) atau Ubah nama kelas | Perubahan nama rombel otomatis mensinkronkan seluruh data siswa yang terdaftar di kelas tersebut. |
| **4** | **Cetak Laporan PDF** | Klik tombol **"Cetak"** di pojok kanan atas list siswa | Format laporan otomatis ber-Kop Sekolah resmi, tabel rapi, dan siap cetak/simpan PDF (`Ctrl + P`). |
| **5** | **Switch Tema Cepat** | Klik tombol Matahari / Bulan di header atas | Desain responsif dengan tema Terang (Light) & Gelap (Dark) tanpa reload. |

---

## 🔍 Informasi Akun Demo & Spesifikasi Sekolah

- **Akun Admin:** `admin@sekolahku.sch.id` | Kata Sandi: `admin123`
- **Akun Client:** `client@sekolahku.sch.id` | Kata Sandi: `client123`
- **Profil Sekolah Demo:** SMK AK Nusa Bangsa (Bogor)
- **Kepala Sekolah:** Drs. H. Ahmad Fauzi, M.Pd. (NIP: 19720815 199803 1 004)
- **Tahun Ajaran:** 2025/2026 — Semester Genap

---

## 💡 Jawaban Cepat Pertanyaan Juri (FAQ)

- **Q: Apakah aplikasi ini berbasis Mobile atau Web?**  
  *A:* Aplikasi ini dibangun menggunakan framework **Flutter** yang bersifat multiplatform (Android & Web) dengan arsitektur backend **Google Firebase (Firestore & Auth)**. Tampilan di laptop festival menggunakan simulator interaktif 1:1 High-Fidelity untuk memudahkan juri dan pengunjung mencoba tanpa harus menginstall APK.
- **Q: Apakah data tersimpan secara real-time?**  
  *A:* Ya, pada versi Flutter produksi, aplikasi terhubung dengan stream Firebase Firestore sehingga penambahan, pengubahan, dan penghapusan data tersinkronisasi secara instan tanpa perlu refresh.
- **Q: Bagaimana keamanan data siswa dijaga?**  
  *A:* Keamanan diatur di level database menggunakan *Firestore Security Rules*. Akun biasa (Client) hanya memiliki izin `read`, sedangkan operasi `create`, `update`, dan `delete` hanya diizinkan untuk akun ber-role Admin.

---

## 🚨 Troubleshooting Ringan di Stand

- **Tampilan mengecil atau terpotong:** Tekan `Ctrl + 0` di browser untuk reset zoom ke 100%.
- **Ingin keluar dari layar penuh:** Tekan kembali tombol `F11`.
- **Data simulator berantakan setelah dimainkan pengunjung:** Cukup tekan `F5` (Refresh) di browser untuk mengembalikan seluruh data demo ke kondisi awal.
