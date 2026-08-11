# 🎨 UX AUDIT & DESIGN SYSTEM SPECIFICATION REPORT

> **Aplikasi:** SekolahKu (Data Management Siswa)  
> **Platform Baseline:** Mobile Web Prototype (1:1 Baseline for Flutter)  
> **Dokumen Audit:** `design/docs/UX_AUDIT_REPORT.md`  
> **Command Resume Percakapan AI:**  
> ```bash
> agy --conversation=0b9e4099-61f4-4ca3-908d-5a5bb1938f33
> ```

---

## 💎 1. Design Tokens & Color Palette System

Sistem warna dan token visual dirancang dengan kontras yang terukur (WCAG compliant) dan konsisten antara tema Terang (*Light*) dan Gelap (*Dark*):

| Token Name | Color Hex | Usage Description |
| :--- | :--- | :--- |
| `primary` | `#2563EB` (Blue 600) | Warna utama brand, tombol aktif, badge utama, & tab aktif |
| `primary-hover` | `#1D4ED8` (Blue 700) | State hover & active tombol utama |
| `background` | `#F8FAFC` (Slate 50) | Warna latar belakang layar utama aplikasi |
| `surface` | `#FFFFFF` (White) | Warna permukaan kartu, modal dialog, & navbar |
| `text-primary` | `#0F172A` (Slate 900) | Warna judul utama, nama siswa, & teks utama |
| `text-muted` | `#64748B` (Slate 500) | Warna sub-informasi, NIS, label sekunder, & placeholder |
| `border` | `#E2E8F0` (Slate 200) | Warna garis pemisah kartu, input border, & navbar top border |
| `danger` | `#DC2626` (Red 600) | Warna khusus aksi destruktif (Tombol Hapus & Toast Error) |
| `danger-bg` | `#FEF2F2` (Red 50) | Warna latar belakang badge/button aksi destruktif |

---

## 📐 2. Radii & Layout Specifications

- **Control Radius:** `8.0px` (Input text, dropdown select, & action buttons)
- **Card Radius:** `12.0px` (Kartu informasi siswa, modal dialog, & container)
- **Viewport Frame:** Width `375px`, Height `760px`, Border Radius `36px` (Menyerupai layar iPhone 14 / Android Modern)
- **Mobile Safe Area Navigation:** Height `64px`, Padding Bottom `12px`, Home Indicator Position `bottom: 4px`

---

## ⚡ 3. Aturan Interaksi & State Permission Guards

Aplikasi menggunakan **State Machine Guard** untuk menjaga keamanan data selama pengguna menguji berbagai skenario simulasi:

1. **Normal (Loaded) State:** Seluruh fitur CRUD (Create, Read, Update, Delete) berfungsi 100% interaktif.
2. **Loading Skeleton State:** Seluruh aksi manipulasi data diblokir. Menampilkan *toast*: `"Sedang memuat data... Mohon tunggu."`
3. **Error State:** Seluruh aksi manipulasi data diblokir. Menampilkan *toast*: `"Koneksi bermasalah. Data tidak dapat diakses."`
4. **Empty State:** Aksi Edit dan Hapus diblokir (karena tidak ada data). Menampilkan *toast*: `"Data kosong. Tidak ada data untuk diubah atau dihapus."` Aksi Tambah Siswa Baru tetap dibuka untuk mengisi data.

---

## 🖱️ 4. Pengalaman Pengguna (Micro-Interactions & Desktop Accessibility)

* **Mouse Drag-to-Scroll:** Barisan *chip filter* kelas dapat ditarik (*dragged*) menggunakan mouse pada layar desktop tanpa tergantung pada scrollbar sentuh.
* **Zero Browser Alert:** Tidak ada pop-up browser bawaan (`alert()` / `prompt()`). Seluruh pengalaman pengguna diisolasi di dalam kartu modal HTML asli.
* **Instant Search & Clear Button:** Input pencarian dilengkapi dengan tombol silang (**X**) untuk menghapus kata kunci pencarian secara instan.
* **Sinkronisasi Otomatis Rombel:** Pengubahan nama kelas di `S11` secara otomatis memperbarui seluruh data siswa yang terdaftar di kelas tersebut secara real-time.

---

> **Kesimpulan Audit:** Prototipe `design/index.html` telah memenuhi seluruh standar UX modern dan siap di-handoff ke tim Frontend Flutter. 🚀
