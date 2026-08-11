# Screen Specifications (Complete S01 – S11 Mapping)

## S01 — Login
Purpose: Authenticate users and route by role (Admin vs Client).

Layout:
```text
App Branding & Logo
Welcome Title & Subtitle
Email Input
Password Input (with Toggle Eye Visibility)
Login Submit Button
Demo Role Quick Buttons (Admin / Client)
Quick Theme Switcher Button (Top Right)
```

States: idle, loading, validation error, auth error, success/navigation.

---

## S02 — Client Home / Recap (Priority ★★☆☆☆)
Purpose: Display recap summary for Client role (Read-Only).

Layout:
```text
Header Title & Subtitle
Total Students Recap Card
Class List & Enrollment Counts
Bottom Navigation
```

---

## S03 — Client Student List (Priority ★★☆☆☆)
Purpose: Consume read-only student information.

Layout:
```text
Title
Search Input (with Clear X button)
Horizontal Class Filter Chips (Mouse Drag-to-Scroll)
Student List Items (Read-Only)
```

Never expose admin CRUD controls to client.

---

## S04 — Admin Dashboard (Priority ★★★★★)
Purpose: Provide administrative recap statistics and quick action entry points.

Layout:
```text
Dashboard Header
Total Students Card + Quick "+ Tambah Siswa" Button
Recently Added Students List
Bottom Navigation
```

---

## S05 — Admin Student Management (Priority ★★★★★ — Primary CRUD)
Purpose: Full administrative student management.

Layout:
```text
Header + "+ Siswa" Action Button
Search Input (with Clear X button)
Horizontal Class Filter Chips (Mouse Drag-to-Scroll + Live Record Counts)
Student List Items (with Edit Pencil & Red Delete Trash Buttons)
Bottom Navigation
```

---

## S06 — Add Student Form (Modal)
Purpose: Modal dialog to input new student details.

Layout:
```text
Modal Header ("Tambah Siswa Baru")
Nama Lengkap (Text Input)
NIS (Numeric Input)
Kelas (Dropdown Select)
Jenis Kelamin (Radio Buttons: Laki-laki / Perempuan)
Alamat Lengkap (Textarea - resize: none)
Modal Footer [ Batal ] [ Simpan Data ]
```

---

## S07 — Edit Student Form (Modal)
Purpose: Modal dialog to modify existing student details.

Layout:
```text
Modal Header ("Ubah Data Siswa")
Pre-filled Student Fields
Modal Footer [ Batal ] [ Simpan Data ]
```

---

## S08 — Delete Confirmation Dialog (Modal)
Purpose: Explicit destructive confirmation before deleting a student.

Layout:
```text
Warning Icon & Header ("Hapus Data Siswa?")
Target Student Name & NIS Card
Destructive Warning Text
Dialog Footer [ Batal ] [ Ya, Hapus (Red) ]
```

---

## S09 — Account / Profile / Settings
Purpose: Manage account session, theme preferences, and access Rombel CRUD.

Layout:
```text
Profile User Card (Admin vs Client Badge)
Kelola Kelas / Rombel Section (Admin Only)
Theme Switcher Segmented Control (Light / Dark / System)
Logout Button (Red)
Bottom Navigation
```

---

## S10 — Add Rombel / Class Form (Modal)
Purpose: Administrative modal dialog to add a new class (Rombongan Belajar).

Layout:
```text
Modal Header ("Tambah Kelas Baru")
Nama Kelas Input (e.g. "XII IPS 2")
Modal Footer [ Batal ] [ Simpan ]
```

---

## S11 — Edit Rombel / Class Form (Modal)
Purpose: Administrative modal dialog to rename an existing class (Rombongan Belajar).

Layout:
```text
Modal Header ("Ubah Nama Kelas")
Pre-filled Class Name Input
Modal Footer [ Batal ] [ Simpan ]
```

Rules:
- Renaming a class automatically updates all student records assigned to that class.
- Dynamically updates filter chips in S03 & S05 and select options in S06 & S07.
