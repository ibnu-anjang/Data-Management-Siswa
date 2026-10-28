/**
 * SEED DEMO DATA — SekolahKu Firebase
 * =====================================
 * Script ini upload data siswa demo ke Firestore.
 * Jalankan SEKALI sebelum demo, hapus setelah selesai.
 *
 * Cara jalankan:
 *   node scripts/seed_demo_data.js
 */

const { initializeApp } = require('firebase/app');
const { getFirestore, collection, addDoc, setDoc, doc, getDocs, deleteDoc, serverTimestamp } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword } = require('firebase/auth');

// ── Firebase Config (dari firebase_options.dart) ──
const firebaseConfig = {
  apiKey: 'AIzaSyCs6K3IH3XRng4ib9HULRwbKsgRBi2IKXY',
  authDomain: 'sekolahku-app-a3895.firebaseapp.com',
  projectId: 'sekolahku-app-a3895',
  storageBucket: 'sekolahku-app-a3895.firebasestorage.app',
  messagingSenderId: '23768516341',
  appId: '1:23768516341:web:edd7194dc6b07d664027bc',
};

// ── Demo Student Data ──
const demoStudents = [
  // ── Jurusan PPLG ──
  { id: 101, name: 'Ahmad Rafli',       nisn: '0071234501', nis: '210101', class: 'XII PPLG 1',        major: 'PPLG',         gender: 'Laki-laki',  birthPlace: 'Bogor',     birthDate: '15 Mei 2007',      religion: 'Islam',   phone: '0812-3456-7890', address: 'Jl. Sudirman No. 10',      guardianName: 'Bpk. Subagyo',       guardianPhone: '0812-3456-7890', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223423/gx9wp6apnfcx9iry3vuo.jpg' },
  { id: 102, name: 'Eko Prasetyo',      nisn: '0081234505', nis: '210105', class: 'XI PPLG 1',         major: 'PPLG',         gender: 'Laki-laki',  birthPlace: 'Depok',     birthDate: '18 Juli 2008',     religion: 'Islam',   phone: '0856-7788-9900', address: 'Jl. Pahlawan No. 2',       guardianName: 'Ibu Kartini',        guardianPhone: '0856-7788-9900', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223430/rtrv8icowqy1ihglxj7k.jpg' },
  { id: 103, name: 'Hendra Wijaya',     nisn: '0091234508', nis: '210108', class: 'X PPLG 1',          major: 'PPLG',         gender: 'Laki-laki',  birthPlace: 'Bogor',     birthDate: '30 Desember 2009', religion: 'Budha',   phone: '0817-5555-6666', address: 'Jl. Gajah Mada No. 9',     guardianName: 'Bpk. Wijaya',        guardianPhone: '0817-5555-6666', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223433/gvdpefhenna9r3gkz0td.jpg' },
  { id: 104, name: 'Lutfi Hakim',       nisn: '0081234512', nis: '210112', class: 'XI PPLG 2',         major: 'PPLG',         gender: 'Laki-laki',  birthPlace: 'Bogor',     birthDate: '17 Oktober 2008',  religion: 'Islam',   phone: '0823-6677-8899', address: 'Jl. Diponegoro No. 18',    guardianName: 'Bpk. Hakim',         guardianPhone: '0823-6677-8899', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223437/byrroqm5gls79i2jkzne.jpg' },
  { id: 105, name: 'Nanda Pratama',     nisn: '0091234514', nis: '210114', class: 'X PPLG 2',          major: 'PPLG',         gender: 'Laki-laki',  birthPlace: 'Bogor',     birthDate: '12 Desember 2009', religion: 'Kristen', phone: '0825-8899-0011', address: 'Jl. Imam Bonjol No. 11',   guardianName: 'Bpk. Pratama',       guardianPhone: '0825-8899-0011', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223439/phd83nbbtiecpxsop3un.jpg' },

  // ── Jurusan Farmasi ──
  { id: 106, name: 'Siti Nurhaliza',    nisn: '0071234502', nis: '210102', class: 'XI Farmasi 1',      major: 'Farmasi',      gender: 'Perempuan',  birthPlace: 'Jakarta',   birthDate: '20 Agustus 2007',  religion: 'Islam',   phone: '0813-8877-6655', address: 'Jl. Melati No. 5',         guardianName: 'Ibu Rahmawati',      guardianPhone: '0813-8877-6655', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223424/ola7i3uhqgacwxzmej63.jpg' },
  { id: 107, name: 'Dina Mariana',      nisn: '0071234504', nis: '210104', class: 'X Farmasi 2',       major: 'Farmasi',      gender: 'Perempuan',  birthPlace: 'Bogor',     birthDate: '05 November 2007', religion: 'Islam',   phone: '0821-4433-2211', address: 'Jl. Anggrek No. 8',        guardianName: 'Bpk. Bambang',       guardianPhone: '0821-4433-2211', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223427/jysuriemipfdwx1rmbuw.jpg' },
  { id: 108, name: 'Gita Gutawa',       nisn: '0081234507', nis: '210107', class: 'XII Farmasi 1',     major: 'Farmasi',      gender: 'Perempuan',  birthPlace: 'Jakarta',   birthDate: '11 Agustus 2008',  religion: 'Katolik', phone: '0813-3333-4444', address: 'Jl. Cendrawasih No. 4',    guardianName: 'Bpk. Erwin',         guardianPhone: '0813-3333-4444', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223432/wfncgvxozb54hv2ixyti.jpg' },
  { id: 109, name: 'Kartika Sari',      nisn: '0071234511', nis: '210111', class: 'X Farmasi 1',       major: 'Farmasi',      gender: 'Perempuan',  birthPlace: 'Bogor',     birthDate: '03 Maret 2007',    religion: 'Islam',   phone: '0822-5544-3311', address: 'Jl. Kencana No. 7',        guardianName: 'Ibu Dewi',           guardianPhone: '0822-5544-3311', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223437/hqxxivtf6qasnbcgz7bu.jpg' },
  { id: 110, name: 'Maya Sari',         nisn: '0091234513', nis: '210113', class: 'XII Farmasi 2',     major: 'Farmasi',      gender: 'Perempuan',  birthPlace: 'Bekasi',    birthDate: '25 September 2009',religion: 'Islam',   phone: '0824-7788-9900', address: 'Jl. Ahmad Yani No. 5',     guardianName: 'Ibu Sari',           guardianPhone: '0824-7788-9900', status: 'Alumni', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223438/jnds6gkesxp3pw4j4hvb.jpg' },

  // ── Jurusan Analis Kimia (Khusus 4 Tahun: Sampai Kelas 13) ──
  { id: 111, name: 'Budi Santoso',      nisn: '0071234503', nis: '210103', class: 'XIII Analis Kimia 1',major: 'Analis Kimia', gender: 'Laki-laki',  birthPlace: 'Bandung',   birthDate: '10 Januari 2007',  religion: 'Kristen', phone: '0815-9988-1122', address: 'Jl. Mawar No. 12',         guardianName: 'Bpk. Santoso',       guardianPhone: '0815-9988-1122', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223425/bymuqbwcbd1dbvkyb5oa.jpg' },
  { id: 112, name: 'Fajar Hidayat',     nisn: '0081234506', nis: '210106', class: 'XII Analis Kimia 1', major: 'Analis Kimia', gender: 'Laki-laki',  birthPlace: 'Sukabumi',  birthDate: '22 April 2008',    religion: 'Islam',   phone: '0812-1111-2222', address: 'Jl. Pemuda No. 15',        guardianName: 'Bpk. Hidayat',       guardianPhone: '0812-1111-2222', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223431/yqrgedzc1tivydcwys9h.jpg' },
  { id: 113, name: 'Indah Permata',     nisn: '0091234509', nis: '210109', class: 'XI Analis Kimia 1',  major: 'Analis Kimia', gender: 'Perempuan',  birthPlace: 'Tangerang', birthDate: '04 Februari 2009', religion: 'Islam',   phone: '0818-7777-8888', address: 'Jl. Hayam Wuruk No. 21',   guardianName: 'Ibu Syamsiah',       guardianPhone: '0818-7777-8888', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223435/vqwb5ohx1eidmlwdteg7.jpg' },
  { id: 114, name: 'Joko Widodo',       nisn: '0091234510', nis: '210110', class: 'X Analis Kimia 1',   major: 'Analis Kimia', gender: 'Laki-laki',  birthPlace: 'Solo',      birthDate: '21 Juni 2009',     religion: 'Islam',   phone: '0819-9999-0000', address: 'Jl. Veteran No. 33',       guardianName: 'Bpk. Notomihardjo',  guardianPhone: '0819-9999-0000', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223436/dmqtippcccl7lfpkdwwg.jpg' },
  { id: 115, name: 'Olivia Permata',    nisn: '0071234515', nis: '210115', class: 'XIII Analis Kimia 2',major: 'Analis Kimia', gender: 'Perempuan',  birthPlace: 'Bandung',   birthDate: '08 Agustus 2007',  religion: 'Kristen', phone: '0826-9900-1122', address: 'Jl. Siliwangi No. 22',     guardianName: 'Ibu Permata',        guardianPhone: '0826-9900-1122', status: 'Aktif', photoUrl: 'https://res.cloudinary.com/hbzlmngj/image/upload/v1793223440/zlpujzcb6ikmddfzubfy.jpg' },
];

// ── Settings (Rombel + School Profile) ──
const settingsData = {
  rombelList: [
    // PPLG
    'X PPLG 1', 'X PPLG 2',
    'XI PPLG 1', 'XI PPLG 2',
    'XII PPLG 1', 'XII PPLG 2',
    // Farmasi
    'X Farmasi 1', 'X Farmasi 2',
    'XI Farmasi 1', 'XI Farmasi 2',
    'XII Farmasi 1', 'XII Farmasi 2',
    // Analis Kimia (sampai Kelas 13)
    'X Analis Kimia 1', 'X Analis Kimia 2',
    'XI Analis Kimia 1', 'XI Analis Kimia 2',
    'XII Analis Kimia 1', 'XII Analis Kimia 2',
    'XIII Analis Kimia 1', 'XIII Analis Kimia 2',
  ],
  schoolProfile: {
    name: 'SMK AK Nusa Bangsa',
    npsn: '20103456',
    address: 'Jl. KH. Sholeh Iskandar No. 1, Bogor',
    phone: '(0251) 8345678',
    email: 'info@smk-aknusalab.sch.id',
    academicYear: '2025/2026',
    semester: 'Semester Genap',
    principalName: 'Drs. H. Ahmad Fauzi, M.Pd.',
    principalNip: '19720815 199803 1 004',
  },
};

async function main() {
  console.log('🔥 SekolahKu — Demo Data Seeder');
  console.log('================================\n');

  const app = initializeApp(firebaseConfig);
  const db = getFirestore(app);
  const auth = getAuth(app);

  console.log('🔑 Authenticating as admin@sekolahku.sch.id...');
  await signInWithEmailAndPassword(auth, 'admin@sekolahku.sch.id', 'admin123');
  console.log('   Authenticated successfully!\n');

  // ── 1. Clear existing students ──
  console.log('🗑️  Clearing existing students...');
  const existingSnap = await getDocs(collection(db, 'students'));
  const deletePromises = existingSnap.docs.map(d => deleteDoc(d.ref));
  await Promise.all(deletePromises);
  console.log(`   Deleted ${existingSnap.size} existing student(s)\n`);

  // ── 2. Upload demo students ──
  console.log('📚 Uploading demo students...');
  for (const student of demoStudents) {
    await addDoc(collection(db, 'students'), {
      ...student,
      updatedAt: serverTimestamp(),
    });
    console.log(`   ✅ ${student.name} (${student.nis}) — ${student.class}`);
  }

  // ── 3. Seed/update settings ──
  console.log('\n⚙️  Writing settings (rombel + school profile)...');
  await setDoc(doc(db, 'settings', 'app'), settingsData);
  console.log('   ✅ Settings saved\n');

  console.log('🎉 Done! Firestore seeded with:');
  console.log(`   - ${demoStudents.length} students`);
  console.log(`   - ${settingsData.rombelList.length} rombel (classes)`);
  console.log('   - School profile: SMK AK Nusa Bangsa\n');
  console.log('💡 Tip: Jalankan "node scripts/seed_demo_data.js --clear" untuk hapus semua data');
  process.exit(0);
}

main().catch(err => {
  console.error('❌ Error:', err.message);
  process.exit(1);
});
