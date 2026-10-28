# 🏛️ Arsitektur Sistem & Spesifikasi Teknis — SekolahKu

Dokumen ini memuat arsitektur menyeluruh, token desain, model data, serta aturan keamanan backend untuk platform **SekolahKu (Data Management Siswa)**.

---

## 📐 1. Arsitektur Berlapis (Layered Architecture)

Aplikasi dibangun dengan pemisahan tanggung jawab yang jelas (*Separation of Concerns*):

```text
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   • Screens: S01 (Auth), S02/S03 (Client), S04/S05     │
│   • Reusable Modals & Dialogs (CRUD, Rombel, Detail)   │
│   • Custom Widgets (SearchField, FilterChips, Cards)   │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                    State Management                    │
│   • AppState (ChangeNotifier — Single Source of Truth) │
│   • Isolated ThemeNotifier (ValueNotifier<ThemeMode>)  │
│   • Reactive Search & Filter Computation Engine        │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                    Data & Services                     │
│   • FirestoreService (Real-time Stream & Atomic Batch) │
│   • Models (StudentModel, SchoolProfileModel)          │
└───────────────────────────┬────────────────────────────┘
                            │ HTTPS / Secure WSS
┌───────────────────────────▼────────────────────────────┐
│                  Google Cloud Backend                  │
│   • Firebase Authentication (Role Token Verification)  │
│   • Cloud Firestore (NoSQL Collection & Indexes)       │
│   • Firestore Security Rules (RBAC Authorization)      │
└────────────────────────────────────────────────────────┘
```

---

## 🎨 2. Design System & Visual Tokens

Sistem desain menggunakan token terukur yang menjamin konsistensi pada tema Terang (*Light*) dan Gelap (*Dark*):

### Palet Warna Utama (`AppColors`)
| Token | Nilai Hex | Fungsi / Penggunaan |
|---|---|---|
| `primary` | `#2563EB` | Warna brand utama, tombol aksi, tab aktif |
| `primary-hover` | `#1D4ED8` | State hover & active tombol utama |
| `background` | `#F8FAFC` | Latar belakang layar aplikasi (Light) |
| `background-dark` | `#0B1120` | Latar belakang layar aplikasi (Dark) |
| `surface` | `#FFFFFF` | Permukaan kartu, modal bottom sheet, navbar (Light) |
| `surface-dark` | `#1E293B` | Permukaan kartu, modal dialog (Dark) |
| `text-primary` | `#0F172A` | Teks utama, judul, dan nama siswa (Light) |
| `text-muted` | `#64748B` | Sub-teks, NIS, dan label sekunder |
| `danger` | `#DC2626` | Aksi destruktif (Tombol hapus & pesan error) |
| `border` | `#E2E8F0` | Garis batas input dan pemisah kartu |

### Tipografi & Dimensi
* **Font Family:** `Inter` (Google Fonts) dengan bobot 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold).
* **Control Radius:** `8.0px` (Input field, button, chip filter).
* **Card Radius:** `12.0px` (Kartu siswa, modal bottom sheet container).
* **Zero-Lag Theme Engine:** Pergantian tema diisolasi pada level `ValueNotifier<ThemeMode>` sehingga tidak memicu *re-render* pada pohon widget layar aktif.

---

## 🗄️ 3. Skema Data (Cloud Firestore)

### Collection: `students`
Menyimpan seluruh data entitas siswa:

```json
{
  "id": "String (Auto-generated Firestore Document ID)",
  "name": "String (Contoh: 'Ahmad Rafli')",
  "nisn": "String (10 digit angka unik)",
  "nis": "String (Nomor Induk Siswa)",
  "class": "String (Contoh: 'XII IPA 1')",
  "gender": "String ('Laki-laki' | 'Perempuan')",
  "birthDate": "String (Contoh: '15 Mei 2007')",
  "religion": "String ('Islam' | 'Kristen' | 'Katolik' | 'Hindu' | 'Budha' | 'Konghucu')",
  "address": "String (Alamat tempat tinggal)",
  "guardianName": "String (Nama orang tua / wali)",
  "guardianPhone": "String (Nomor kontak wali)",
  "status": "String ('Aktif' | 'Alumni')",
  "photoUrl": "String (URL CDN / default placeholder)",
  "createdAt": "Timestamp (Server Timestamp)",
  "updatedAt": "Timestamp (Server Timestamp)"
}
```

### Collection: `settings` (Doc: `app`)
Menyimpan konfigurasi rombel dan profil sekolah:

```json
{
  "rombelList": [
    "X IPA 1", "X IPA 2", "X IPS 1",
    "XI IPA 1", "XI IPA 2", "XI IPS 1",
    "XII IPA 1", "XII IPA 2", "XII IPS 1"
  ],
  "schoolProfile": {
    "name": "SMK AK Nusa Bangsa",
    "npsn": "20103456",
    "address": "Jl. KH. Sholeh Iskandar No. 1, Bogor",
    "phone": "(0251) 8345678",
    "email": "info@smk-aknusalab.sch.id",
    "academicYear": "2025/2026",
    "semester": "Semester Genap",
    "principalName": "Drs. H. Ahmad Fauzi, M.Pd.",
    "principalNip": "19720815 199803 1 004"
  }
}
```

---

## 🔄 4. Dynamic Batch Synchronization (Atomic Rombel Sync)

Ketika Administrator mengubah nama suatu rombel/kelas (misalnya dari `XII IPA 1` menjadi `XII MIPA 1`):
1. Sistem membuka transaksi atomic `WriteBatch` di Firestore.
2. Memperbarui dokumen `settings/app` dengan nama rombel baru.
3. Mencari seluruh dokumen siswa di koleksi `students` yang memiliki atribut `class == oldName`.
4. Memperbarui atribut `class = newName` secara massal dalam satu siklus commit.
5. Menjamin konsistensi data 100% tanpa risiko data siswa tertinggal pada rombel lama.

---

## 🛡️ 5. Keamanan & Otorisasi (Security Rules)

Aturan keamanan diterapkan di tingkat database (*Firestore Security Rules*):

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Koleksi Siswa: Siapa pun yang login bisa membaca, tulis hanya Admin
    match /students/{studentId} {
      allow read: if request.auth != null;
      allow create, update, delete: if request.auth != null
        && (request.auth.token.email.matches('.*admin.*')
            || request.auth.token.email == 'sekolahkudatasiswa@gmail.com');
    }

    // Koleksi Pengaturan: Read publik untuk user login, write khusus Admin
    match /settings/{docId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && (request.auth.token.email.matches('.*admin.*')
            || request.auth.token.email == 'sekolahkudatasiswa@gmail.com');
    }
  }
}
```

---

## 📱 6. Pemetaan Modul Layar

| Kode Layar | Nama Modul | Akses Peran | Deskripsi Fungsional |
|---|---|:---:|---|
| **S01** | **Authentication** | Publik | Login email & kata sandi, toggle visibilitas, quick role switch demo |
| **S02** | **Client Recap** | Client | Beranda rekapitulasi data siswa dan rombel aktif (Read-Only) |
| **S03** | **Client Student List** | Client | Eksplorasi siswa, search instan, filter chips, detail siswa, cetak |
| **S04** | **Admin Dashboard** | Admin | Ringkasan statistik KPI (total siswa, gender ratio, quick action) |
| **S05** | **Admin Student CRUD** | Admin | Kelola data siswa lengkap (tambah, edit, konfirmasi hapus, cetak) |
| **S09** | **Profile & Settings** | Admin/Client | Pengaturan akun, toggle tema, identitas sekolah, kelola rombel |
| **Modals** | **Form & Print** | Beragam | Form input siswa, dialog hapus, detail siswa, dan pratinjau cetak resmi |
