# 🏫 SekolahKu — Data Management Siswa

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License MIT" />
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Status-1%3A1%20Verified%20Prototype-success" alt="Status Prototype" />
</p>

Aplikasi Mobile Management Data Siswa (**SekolahKu**) berbasis **Flutter** dan **Firebase Firestore** dengan simulasi Prototipe Web Interaktif 1:1 High-Fidelity.

---

## ⚡ Cara Menjalankan Prototipe Web Interaktif

Prototipe web interaktif dapat langsung dibuka melalui peramban (browser):

1. Buka berkas [`design/index.html`](design/index.html) menggunakan Browser (Chrome/Firefox/Edge) atau VS Code Live Server.
2. Di dalam peramban, Anda akan melihat **Simulator HP Interaktif** beserta **Panel Presentasi & Handoff Frontend** secara berdampingan (*side-by-side*).

---

## 🚀 Perintah Melanjutkan Conversation AI (Revisi Proyek)

Jika ingin melakukan revisi atau konsultasi lebih lanjut dengan agen AI Antigravity, jalankan perintah CLI berikut di terminal:

```bash
agy --conversation=0b9e4099-61f4-4ca3-908d-5a5bb1938f33
```

---

## 🎯 Prioritas Fitur Operasional

- **ADMIN (`★★★★★` Priority):**
  - **S01:** Authentication / Login Screen (Quick Theme Switcher)
  - **S04:** Dashboard Ringkasan Statistik Operasional Admin
  - **S05:** Kelola Data Siswa (CRUD Utama, Filter Chips Drag-to-Scroll, Instant Search + Clear X, & Red Delete Button)
  - **S06:** Modal Form Tambah Siswa Baru
  - **S07:** Modal Form Edit Data Siswa
  - **S08:** Dialog Konfirmasi Hapus Data Siswa
  - **S09:** Profil & Pengaturan Session
  - **S10:** Modal Form Tambah Rombel Baru (`+ Rombel`)
  - **S11:** Modal Form Edit Nama Rombel (`✎ Rombel`) dengan Auto Sync Data Siswa

- **CLIENT (`★★☆☆☆` Priority):**
  - **S01:** Authentication / Login Screen
  - **S02:** Beranda Ringkasan Total Siswa & Daftar Kelas Aktif (Read-Only)
  - **S03:** Read-Only Student List dengan Search & Filter Chips
  - **S09:** Profil & Pengaturan (Read-Only)

---

## 🎨 Token Sistem Desain (AppColors)

- **Primary Color:** `#2563EB` (Blue 600)
- **Background Color:** `#F8FAFC` (Slate 50)
- **Surface Color:** `#FFFFFF` (White)
- **Text Primary:** `#0F172A` (Slate 900)
- **Text Muted:** `#64748B` (Slate 500)
- **Danger Color:** `#DC2626` (Red 600)
- **Control Radius:** `8.0px` | **Card Radius:** `12.0px`

---

## ⏱ Estimasi Pengerjaan Realistis (Senior Fullstack Developer — Tanpa AI)

| Tahapan Pengerjaan | Scope Pekerjaan | Estimasi Waktu Realistis |
| :--- | :--- | :--- |
| **Phase 1: Setup & Data Modeling** | Project setup (Flutter + Firebase SDK), Firestore Rules, Auth Provider, Model Classes, ThemeData Setup | **2 – 3 Hari** (16–24 jam) |
| **Phase 2: Auth & Client App** | Screen S01 Login (Form validation, Auth state stream), S02 Client Home, S03 Client Student List (Search & Filter) | **3 – 4 Hari** (24–32 jam) |
| **Phase 3: Admin Operations (CRUD)** | S04 Admin Dashboard, S05 Admin Student CRUD, S06/S07 Student Form BottomSheet, S08 Delete Dialog | **4 – 5 Hari** (32–40 jam) |
| **Phase 4: Rombel CRUD & State** | S09 Profile, S10/S11 Rombel CRUD Modal & Batch Firestore Sync, Offline/Loading/Error Handling | **3 – 4 Hari** (24–32 jam) |
| **Phase 5: Testing & Polish** | Integration testing, Unit testing, Device compatibility, Bug fixing, Polish UI | **2 – 3 Hari** (16–24 jam) |
| **TOTAL ESTIMASI REALISTIS** | **Full Production Ready App (Flutter + Firebase)** | **14 – 19 Hari Kerja (3 – 4 Minggu)** |

---

## 📂 Struktur Direktori Proyek

```text
.
├── design/                   # Prototipe Web Interaktif High-Fidelity 1:1
│   ├── index.html            # Application Simulator & Side-by-Side Panel
│   ├── styles.css            # Design System & Mobile Safe Area Layout
│   ├── app.js                # Interactivity, State Machine, & Permission Guards
│   └── docs/                 # Dokumen Internal (Memory, Context, Audit UX, & Rekap Revisi)
├── docs/                     # Dokumentasi Spesifikasi Arsitektur Sistem (S01 - S11)
├── LICENSE                   # MIT License
└── README.md                 # Dokumentasi Utama Repository
```

---

## 📄 Lisensi

Proyek ini dilindungi di bawah lisensi [MIT License](LICENSE).  
Copyright (c) 2026 **Ibnu Anjang**.
