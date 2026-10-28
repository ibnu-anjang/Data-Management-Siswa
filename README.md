# 🏫 SekolahKu — Modern Student Data Management Platform

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License MIT" />
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Web%20%7C%20Windows-brightgreen" alt="Platforms" />
  <img src="https://img.shields.io/badge/Design_System-Token--Based%201%3A1-success" alt="Design System" />
</p>

**SekolahKu** adalah platform sistem informasi dan manajemen data siswa berbasis **Flutter** dan **Google Firebase (Firestore & Auth)**. Dirancang dengan pendekatan *mobile-first*, performa *zero-lag*, pembagian hak akses bertingkat (*Role-Based Access Control*), serta simulator interaktif 1:1 untuk presentasi dan pengujian langsung.

---

## ⚡ Coba Langsung (Live Demo & Kiosk Mode)

Aplikasi dirancang agar **100% Zero-Config** tanpa mewajibkan instalasi environment Flutter/SDK di komputer pengunjung:

* **Laptop Windows (Stand Pameran):** Dobel-klik file [`BUKA_SEKOLAHKU_WINDOWS.bat`](BUKA_SEKOLAHKU_WINDOWS.bat) untuk langsung membuka simulator di Google Chrome / Microsoft Edge.
* **Semua Platform (Web Browser):** Buka berkas [`design/index.html`](design/index.html) menggunakan browser apa pun.
* **Panduan Stand Festival:** Panduan operasional 1-lembar tersedia di [`docs/PANDUAN_PAMERAN_STAND.md`](docs/PANDUAN_PAMERAN_STAND.md).

---

## 💎 Fitur Unggulan Produk

### 1. 🛡️ Role-Based Access Control (Admin vs Client)
* **Admin (Akses Penuh):** Kelola data siswa (CRUD), manajemen Rombel (Kelas), ubah profil & kop sekolah, konfirmasi hapus data aman, serta cetak laporan komprehensif.
* **Client / Guru (Read-Only):** Tinjauan ringkasan siswa, pencarian cepat, filter status/kelas, dan cetak daftar tanpa risiko manipulasi data tak sengaja.

### 2. ⚡ Interaksi Cepat & Responsif
* **Instant Search & Clear:** Pencarian langsung berdasarkan NIS maupun nama dengan tombol reset instan.
* **Drag-to-Scroll Filter Chips:** Penyaringan kelas dan gender dengan interaksi geser yang mulus.
* **Zero-Lag Theme Engine:** Pergantian instan mode Terang (*Light*), Gelap (*Dark*), dan Sistem tanpa memuat ulang layar aktif.

### 3. 🔄 Dynamic Rombel Auto-Sync
* Pengubahan nama rombel/kelas (misal: *XII IPA 1* → *XII MIPA 1*) pada menu pengaturan profil secara otomatis memperbarui seluruh data siswa terkait dalam database (*batch synchronization*).

### 4. 🖨️ Cetak Laporan Resmi Ber-Kop Surat
* Menghasilkan pratinjau cetak (*Print Preview*) lengkap dengan Kop Surat Sekolah (NPSN, Alamat, Akreditasi), tabel berformat formal, dan lembar pengesahan Kepala Sekolah yang siap dicetak (*Ctrl + P*) atau disimpan ke PDF.

---

## 🔐 Akun Demo

| Peran Pengguna | Email Login | Kata Sandi | Hak Akses |
|---|---|---|---|
| **Administrator** | `admin@sekolahku.sch.id` | `admin123` | Akses Penuh (CRUD Siswa & Rombel) |
| **Client / Guru** | `client@sekolahku.sch.id` | `client123` | Read-Only (Pencarian & Cetak) |

---

## 🏛️ Arsitektur Teknologi

```text
┌────────────────────────────────────────────────────────┐
│                   SekolahKu Frontend                   │
│   • Flutter Mobile (Android/iOS)                       │
│   • Flutter Web & Interactive 1:1 Simulator            │
│   • Token-Based Design System (AppColors & AppTheme)   │
└───────────────────────────┬────────────────────────────┘
                            │ HTTPS / Secure WSS
┌───────────────────────────▼────────────────────────────┐
│              Google Cloud Firebase Services            │
│   • Firebase Authentication (Email / Password)         │
│   • Cloud Firestore (Real-time NoSQL Data Streams)     │
│   • Security Rules (Granular Role Authorization)       │
└────────────────────────────────────────────────────────┘
```

---

## 📂 Struktur Direktori Proyek

```text
.
├── BUKA_SEKOLAHKU_WINDOWS.bat # Launcher otomatis untuk pameran di Windows
├── design/                   # Prototipe Web Simulator 1:1 High-Fidelity
│   ├── index.html            # Simulator HP & Panel Demo Terintegrasi
│   ├── styles.css            # Token Design System & Safe Area Layout
│   ├── app.js                # State Machine & Logika Interaktivitas
│   └── lucide.min.js         # Library icon offline-ready
├── docs/                     # Dokumentasi Arsitektur & Panduan
│   ├── ARCHITECTURE.md       # Blueprint arsitektur & skema data
│   ├── PANDUAN_PAMERAN_STAND.md # Panduan 1-lembar operator stand
│   └── SETUP_GUIDE.md        # Panduan instalasi developer
├── frontend/                 # Kode Sumber Aplikasi Flutter
│   ├── lib/                  # Screens (S01-S09), Core Models, State & Services
│   └── test/                 # Automated Widget & Unit Tests
└── LICENSE                   # MIT License
```

---

## 📄 Lisensi

Proyek ini dilindungi di bawah lisensi [MIT License](LICENSE).  
Hak Cipta (c) 2026 **Ibnu Anjang**.
