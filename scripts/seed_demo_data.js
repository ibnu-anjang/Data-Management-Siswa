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
  { id: 101, name: 'Ahmad Rafli',       nis: '210101', class: 'XII IPA 1', gender: 'Laki-laki',  birthDate: '15 Mei 2007',      religion: 'Islam',   address: 'Jl. Sudirman No. 10',      guardianName: 'Bpk. Subagyo',       guardianPhone: '0812-3456-7890', status: 'Aktif' },
  { id: 102, name: 'Siti Nurhaliza',    nis: '210102', class: 'XII IPA 1', gender: 'Perempuan',   birthDate: '20 Agustus 2007',  religion: 'Islam',   address: 'Jl. Melati No. 5',         guardianName: 'Ibu Rahmawati',      guardianPhone: '0813-8877-6655', status: 'Aktif' },
  { id: 103, name: 'Budi Santoso',      nis: '210103', class: 'XII IPA 2', gender: 'Laki-laki',  birthDate: '10 Januari 2007',  religion: 'Kristen', address: 'Jl. Mawar No. 12',         guardianName: 'Bpk. Santoso',       guardianPhone: '0815-9988-1122', status: 'Aktif' },
  { id: 104, name: 'Dina Mariana',      nis: '210104', class: 'XII IPS 1', gender: 'Perempuan',   birthDate: '05 November 2007', religion: 'Islam',   address: 'Jl. Anggrek No. 8',        guardianName: 'Bpk. Bambang',       guardianPhone: '0821-4433-2211', status: 'Aktif' },
  { id: 105, name: 'Eko Prasetyo',      nis: '210105', class: 'XI IPA 1',  gender: 'Laki-laki',  birthDate: '18 Juli 2008',     religion: 'Islam',   address: 'Jl. Pahlawan No. 2',       guardianName: 'Ibu Kartini',        guardianPhone: '0856-7788-9900', status: 'Aktif' },
  { id: 106, name: 'Fajar Hidayat',     nis: '210106', class: 'XI IPA 2',  gender: 'Laki-laki',  birthDate: '22 April 2008',    religion: 'Islam',   address: 'Jl. Pemuda No. 15',        guardianName: 'Bpk. Hidayat',       guardianPhone: '0812-1111-2222', status: 'Aktif' },
  { id: 107, name: 'Gita Gutawa',       nis: '210107', class: 'XI IPS 1',  gender: 'Perempuan',   birthDate: '11 Agustus 2008',  religion: 'Katolik', address: 'Jl. Cendrawasih No. 4',    guardianName: 'Bpk. Erwin',         guardianPhone: '0813-3333-4444', status: 'Aktif' },
  { id: 108, name: 'Hendra Wijaya',     nis: '210108', class: 'X IPA 1',   gender: 'Laki-laki',  birthDate: '30 Desember 2009', religion: 'Budha',   address: 'Jl. Gajah Mada No. 9',     guardianName: 'Bpk. Wijaya',        guardianPhone: '0817-5555-6666', status: 'Aktif' },
  { id: 109, name: 'Indah Permata',     nis: '210109', class: 'X IPA 2',   gender: 'Perempuan',   birthDate: '04 Februari 2009', religion: 'Islam',   address: 'Jl. Hayam Wuruk No. 21',   guardianName: 'Ibu Syamsiah',       guardianPhone: '0818-7777-8888', status: 'Aktif' },
  { id: 110, name: 'Joko Widodo',       nis: '210110', class: 'X IPS 1',   gender: 'Laki-laki',  birthDate: '21 Juni 2009',     religion: 'Islam',   address: 'Jl. Veteran No. 33',       guardianName: 'Bpk. Notomihardjo',  guardianPhone: '0819-9999-0000', status: 'Aktif' },
  { id: 111, name: 'Kartika Sari',      nis: '210111', class: 'XII IPA 2', gender: 'Perempuan',   birthDate: '03 Maret 2007',    religion: 'Islam',   address: 'Jl. Kencana No. 7',        guardianName: 'Ibu Dewi',           guardianPhone: '0822-5544-3311', status: 'Aktif' },
  { id: 112, name: 'Lutfi Hakim',       nis: '210112', class: 'XI IPA 1',  gender: 'Laki-laki',  birthDate: '17 Oktober 2008',  religion: 'Islam',   address: 'Jl. Diponegoro No. 18',    guardianName: 'Bpk. Hakim',         guardianPhone: '0823-6677-8899', status: 'Aktif' },
  { id: 113, name: 'Maya Sari',         nis: '210113', class: 'X IPS 1',   gender: 'Perempuan',   birthDate: '25 September 2009',religion: 'Islam',   address: 'Jl. Ahmad Yani No. 5',     guardianName: 'Ibu Sari',           guardianPhone: '0824-7788-9900', status: 'Alumni' },
  { id: 114, name: 'Nanda Pratama',     nis: '210114', class: 'X IPA 1',   gender: 'Laki-laki',  birthDate: '12 Desember 2009', religion: 'Kristen', address: 'Jl. Imam Bonjol No. 11',   guardianName: 'Bpk. Pratama',       guardianPhone: '0825-8899-0011', status: 'Aktif' },
  { id: 115, name: 'Olivia Permata',    nis: '210115', class: 'XII IPS 1', gender: 'Perempuan',   birthDate: '08 Agustus 2007',  religion: 'Kristen', address: 'Jl. Siliwangi No. 22',     guardianName: 'Ibu Permata',        guardianPhone: '0826-9900-1122', status: 'Aktif' },
];

// ── Settings (Rombel + School Profile) ──
const settingsData = {
  rombelList: ['X IPA 1', 'X IPA 2', 'X IPS 1', 'XI IPA 1', 'XI IPA 2', 'XI IPS 1', 'XII IPA 1', 'XII IPA 2', 'XII IPS 1'],
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
