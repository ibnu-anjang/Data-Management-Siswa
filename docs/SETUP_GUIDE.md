# 🛠️ Panduan Instalasi & Deployment Developer — SekolahKu

Panduan langkah demi langkah untuk mengonfigurasi, menjalankan, dan melakukan deployment aplikasi **SekolahKu**.

---

## 📋 1. Kebutuhan Perangkat Lunak (Prerequisites)

| Perangkat Lunak | Versi Minimal | Fungsi |
|---|---|---|
| **Flutter SDK** | `^3.12.0` | Framework pengembangan aplikasi |
| **Dart SDK** | `^3.0.0` | Bahasa pemrograman utama |
| **Node.js & npm** | `^18.0.0` | Menjalankan Firebase CLI & script data seeder |
| **Google Chrome** | Terkini | Target peramban untuk Flutter Web |

Verifikasi penginstalan di terminal:
```bash
flutter --version
node -v
npm -v
```

---

## ⚡ 2. Quickstart (Menjalankan Frontend)

1. Masuk ke direktori `frontend`:
   ```bash
   cd frontend
   ```

2. Unduh seluruh paket dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan pengujian otomatis untuk memverifikasi integritas kode:
   ```bash
   flutter test
   flutter analyze
   ```

4. Jalankan aplikasi di browser Chrome:
   ```bash
   flutter run -d chrome
   ```

---

## 🔥 3. Konfigurasi Firebase (Backend Setup)

Jika Anda ingin menghubungkan dengan proyek Firebase pribadi:

1. **Install Firebase CLI & FlutterFire:**
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```

2. **Generate Konfigurasi FlutterFire:**
   ```bash
   cd frontend
   flutterfire configure --project=YOUR_PROJECT_ID --platforms=android,web --yes
   ```

3. **Deploy Security Rules:**
   ```bash
   # Dari root direktori proyek
   firebase deploy --only firestore:rules
   ```

4. **Inisialisasi Data Demo Awal (Optional):**
   ```bash
   cd scripts
   npm install
   node seed_demo_data.js
   ```

---

## 🚀 4. Build Production

### Web Production:
```bash
cd frontend
flutter build web --release
```
Hasil kompilasi akan berada di direktori `frontend/build/web/` yang siap di-deploy ke Firebase Hosting, Vercel, atau GitHub Pages.

### Android APK:
```bash
cd frontend
flutter build apk --release
```
Berkas APK akan berada di `frontend/build/app/outputs/flutter-apk/app-release.apk`.
