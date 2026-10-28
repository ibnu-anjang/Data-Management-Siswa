# 🛠️ PANDUAN MEMBUAT ULANG APLIKASI (MANUAL SETUP GUIDE)
## SekolahKu — Data Management Siswa (Flutter + Firebase)

> **Dokumen ini dibuat khusus sebagai panduan langkah demi langkah** untuk menyiapkan, mengonfigurasi, dan menjalankan ulang proyek aplikasi **SekolahKu** dari kondisi kode yang sudah ada (bukan dari nol/0).

---

## 🗂️ DAFTAR ISI

1. [Persyaratan Perangkat Lunak (Prerequisites)](#1-persyaratan-perangkat-lunak)
2. [Langkah 1: Mempersiapkan Struktur Proyek](#2-langkah-1-mempersiapkan-struktur-proyek)
3. [Langkah 2: Setup Dependency Flutter](#3-langkah-2-setup-dependency-flutter)
4. [Langkah 3: Konfigurasi Firebase CLI](#4-langkah-3-konfigurasi-firebase-cli)
5. [Langkah 4: Konfigurasi FlutterFire (Generate Config)](#5-langkah-4-konfigurasi-flutterfire)
6. [Langkah 5: Aktifkan Firebase Auth & Buat Pengguna](#6-langkah-5-aktifkan-firebase-auth)
7. [Langkah 6: Deploy Firestore Security Rules](#7-langkah-6-deploy-firestore-security-rules)
8. [Langkah 7: Populate Data Awal (Demo Seeding)](#8-langkah-7-populate-data-awal)
9. [Langkah 8: Menjalankan Aplikasi](#9-langkah-8-menjalankan-aplikasi)
10. [Troubleshooting & Pemeliharaan](#10-troubleshooting--pemeliharaan)

---

## 1. Persyaratan Perangkat Lunak {#1-persyaratan-perangkat-lunak}

Pastikan perangkat lunak berikut telah terinstall di komputer Anda:

| Perangkat Lunak | Versi Minimal | Fungsi |
|---|---|---|
| **Flutter SDK** | `^3.12.0` | Framework pengembangan aplikasi |
| **Dart SDK** | `^3.0.0` | Bahasa pemrograman utama |
| **Node.js & npm** | `^18.0.0` | Menjalankan Firebase CLI & script seeder |
| **Firebase CLI** | `^13.0.0` | Mengelola project Firebase |
| **Google Chrome** | Terkini | Browser target running web |

### Cek Penginstalan:
```bash
flutter --version
node -v
npm -v
firebase --version
```

---

## 2. Langkah 1: Mempersiapkan Struktur Proyek {#2-langkah-1-mempersiapkan-struktur-proyek}

Struktur direktori proyek terdiri dari:
```
data_management_siswa/
├── design/          → Prototipe UI (HTML/CSS/JS)
├── docs/            → Dokumen teknis & panduan
│   └── setup/       → [DOKUMEN INI]
├── firebase/        → Firestore rules & index config
├── frontend/        → Kode sumber Flutter App
└── scripts/         → Script seeder data demo
```

Masuk ke folder proyek utama:
```bash
cd /path/to/data_management_siswa
```

---

## 3. Langkah 2: Setup Dependency Flutter {#3-langkah-2-setup-dependency-flutter}

Masuk ke direktori `frontend` dan bersihkan cache sebelum mengunduh paket dependency:

```bash
cd frontend

# Bersihkan build cache lama
flutter clean

# Unduh paket dependency (firebase_core, firebase_auth, cloud_firestore, dll.)
flutter pub get
```

Pastikan tidak ada error dengan menjalankan analisa kode:
```bash
flutter analyze
```

---

## 4. Langkah 3: Konfigurasi Firebase CLI {#4-langkah-3-konfigurasi-firebase-cli}

1. **Login ke Akun Firebase Google Anda:**
   ```bash
   firebase login
   ```
   *(Atau `firebase login:add` jika ingin menambahkan akun baru).*

2. **Daftarkan/Pilih Project Firebase:**
   Pastikan Anda sudah memiliki project Firebase (contoh: `data-management-siswa`).
   ```bash
   # Cek daftar project Firebase milik Anda
   firebase projects:list

   # Hubungkan direktori proyek dengan project Firebase
   firebase use data-management-siswa
   ```

---

## 5. Langkah 4: Konfigurasi FlutterFire {#5-langkah-4-konfigurasi-flutterfire}

Langkah ini akan membuat file `frontend/lib/firebase_options.dart` secara otomatis yang memuat API Keys & Config Firebase untuk Android dan Web.

1. **Install FlutterFire CLI (jika belum ada):**
   ```bash
   dart pub global activate flutterfire_cli
   export PATH="$PATH:$HOME/.pub-cache/bin"
   ```

2. **Jalankan Konfigurasi FlutterFire:**
   ```bash
   cd frontend
   flutterfire configure --project=data-management-siswa --platforms=android,web --yes
   ```

Setelah perintah di atas selesai, file `lib/firebase_options.dart` dan `android/app/google-services.json` akan otomatis tergenerasi.

---

## 6. Langkah 5: Aktifkan Firebase Auth & Buat Pengguna {#6-langkah-5-aktifkan-firebase-auth}

### A. Melalui Firebase Console (GUI):
1. Buka [Firebase Console](https://console.firebase.google.com/).
2. Pilih project **data-management-siswa**.
3. Pilih menu **Authentication** → Klik **Get Started**.
4. Di tab **Sign-in method**, pilih **Email/Password** → Aktifkan (**Enable**) → Klik **Save**.
5. Di tab **Users**, klik **Add user** untuk membuat 2 akun demo:

| Email | Password | Peran |
|---|---|---|
| `admin@sekolahku.sch.id` | `admin123` | **Admin** (Akses Penuh CRUD) |
| `client@sekolahku.sch.id` | `client123` | **Client** (Read-Only) |

---

## 7. Langkah 6: Deploy Firestore Security Rules {#7-langkah-6-deploy-firestore-security-rules}

Pastikan keamanan database Firestore dikonfigurasi agar read diperbolehkan untuk pengguna terautentikasi, dan write khusus untuk admin:

File aturan keamanan berada di `firebase/firestore.rules`:
```json
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /students/{studentId} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null
        && (request.auth.token.email.matches('.*admin.*')
            || request.auth.token.email == 'ibnumaulidi08@gmail.com');
    }

    match /settings/{docId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && (request.auth.token.email.matches('.*admin.*')
            || request.auth.token.email == 'ibnumaulidi08@gmail.com');
    }
  }
}
```

Deploy aturan ini ke cloud:
```bash
# Dari root direktori proyek
firebase deploy --only firestore:rules
```

---

## 8. Langkah 7: Populate Data Awal (Demo Seeding) {#8-langkah-7-populate-data-awal}

Jika database Firestore masih kosong dan Anda ingin mengisi 15 data siswa demo serta data Rombel & Profil Sekolah:

### Cara Cepat (Otomatis saat App Pertama Dibuka):
Aplikasi sudah diprogram untuk mengisi data Rombel & Profil Sekolah secara otomatis saat Admin pertama kali login.

### Cara Manual (Via Script Node.js):
```bash
cd scripts
npm install
node seed_demo_data.js
```

---

## 9. Langkah 8: Menjalankan Aplikasi {#9-langkah-8-menjalankan-aplikasi}

Setelah semua konfigurasi Firebase dan dependency selesai:

```bash
cd frontend

# Menjalankan di Chrome Web (Port 3000)
flutter run -d chrome --web-port=3000
```

### Menguji Akses Login:
1. Masukkan Email: `admin@sekolahku.sch.id` | Password: `admin123` → Masuk ke **Dashboard Admin** (Kelola Siswa, Rombel, Cetak).
2. Masukkan Email: `client@sekolahku.sch.id` | Password: `client123` → Masuk ke **Portal Client** (Read-only list, Detail Siswa).

---

## 10. Troubleshooting & Pemeliharaan {#10-troubleshooting--pemeliharaan}

| Masalah | Penyebab | Solusi |
|---|---|---|
| `FirebaseOptions have not been configured` | File `firebase_options.dart` belum dibuat | Jalankan `flutterfire configure` ulang di folder `frontend` |
| `PERMISSION_DENIED` pada Firestore | User belum login atau rules memblokir | Pastikan sudah login dan email menggunakan kata `admin` |
| Tampilan tidak berubah setelah edit kode | Cache browser / hot reload tertahan | Tekan `R` di terminal untuk Hot Restart atau jalankan `flutter clean` |
| `flutter analyze` warning `withOpacity` | Sintaks opsional Flutter SDK baru | Gunakan `.withValues()` atau biarkan karena hanya berupa info warning |

---

*Panduan ini menjamin aplikasi SekolahKu dapat dikonfigurasi ulang secara cepat dan presisi tanpa perlu menulis ulang kode dari awal.* 🚀
