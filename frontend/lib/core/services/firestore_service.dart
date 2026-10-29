import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';
import '../models/school_profile_model.dart';

/// Centralized Firestore data access layer.
/// All reads/writes to Firebase Firestore go through this service.
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService._internal() {
    // Enable offline persistence with unlimited cache for instant zero-lag offline access
    _db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // ──────────────────────────────────────────────
  // Collection References
  // ──────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _studentsRef =>
      _db.collection('students');

  DocumentReference<Map<String, dynamic>> get _settingsRef =>
      _db.collection('settings').doc('app');

  // ──────────────────────────────────────────────
  // STUDENTS: Real-time stream & Atomic Batch
  // ──────────────────────────────────────────────

  /// Continuous real-time stream of all students ordered by name
  Stream<List<StudentModel>> streamStudents() {
    return _studentsRef
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentModel.fromFirestore(doc))
            .toList());
  }

  /// Add a new student document to Firestore
  Future<void> addStudent(StudentModel student) async {
    await _studentsRef.add(student.toFirestore());
  }

  /// Update an existing student document in Firestore
  Future<void> updateStudent(StudentModel student) async {
    if (student.docId.isNotEmpty) {
      await _studentsRef.doc(student.docId).update(student.toFirestore());
      return;
    }
    // Fallback if docId was not populated in memory
    final query = await _studentsRef.where('id', isEqualTo: student.id).limit(1).get();
    if (query.docs.isNotEmpty) {
      await _studentsRef.doc(query.docs.first.id).update(student.toFirestore());
    }
  }

  /// Atomically update the class of multiple students using a single Firestore batch
  Future<void> batchUpdateStudentClass(List<StudentModel> students, String newClassName) async {
    if (students.isEmpty) return;
    final batch = _db.batch();
    for (final s in students) {
      if (s.docId.isNotEmpty) {
        batch.update(_studentsRef.doc(s.docId), {
          'class': newClassName,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
    await batch.commit();
  }

  /// Delete a student document from Firestore
  Future<void> deleteStudent(String docId) async {
    if (docId.isEmpty) return;
    await _studentsRef.doc(docId).delete();
  }

  /// Real-time stream of settings document (rombelList + schoolProfile)
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamSettings() {
    return _settingsRef.snapshots();
  }


  // ──────────────────────────────────────────────
  // ROMBEL (CLASS LIST): Stored in settings doc
  // ──────────────────────────────────────────────

  /// Get rombel list from Firestore settings document
  Future<List<String>> getRombelList() async {
    final doc = await _settingsRef.get();
    if (!doc.exists || doc.data() == null) return [];
    final data = doc.data()!;
    return List<String>.from(data['rombelList'] ?? []);
  }

  /// Save the full rombel list to Firestore
  Future<void> saveRombelList(List<String> rombelList) async {
    await _settingsRef.set(
      {'rombelList': rombelList},
      SetOptions(merge: true),
    );
  }

  // ──────────────────────────────────────────────
  // SCHOOL PROFILE: Stored in settings doc
  // ──────────────────────────────────────────────

  /// Get school profile from Firestore settings document
  Future<SchoolProfileModel?> getSchoolProfile() async {
    final doc = await _settingsRef.get();
    if (!doc.exists || doc.data() == null) return null;
    final data = doc.data()!;
    final profile = data['schoolProfile'] as Map<String, dynamic>?;
    if (profile == null) return null;
    return SchoolProfileModel(
      name: profile['name'] as String? ?? '',
      npsn: profile['npsn'] as String? ?? '',
      address: profile['address'] as String? ?? '',
      phone: profile['phone'] as String? ?? '',
      email: profile['email'] as String? ?? '',
      academicYear: profile['academicYear'] as String? ?? '',
      semester: profile['semester'] as String? ?? '',
      principalName: profile['principalName'] as String? ?? '',
      principalNip: profile['principalNip'] as String? ?? '',
    );
  }

  /// Save school profile to Firestore settings document
  Future<void> saveSchoolProfile(SchoolProfileModel profile) async {
    await _settingsRef.set(
      {
        'schoolProfile': {
          'name': profile.name,
          'npsn': profile.npsn,
          'address': profile.address,
          'phone': profile.phone,
          'email': profile.email,
          'academicYear': profile.academicYear,
          'semester': profile.semester,
          'principalName': profile.principalName,
          'principalNip': profile.principalNip,
        }
      },
      SetOptions(merge: true),
    );
  }

  /// Initialize settings doc with defaults if it does not exist
  Future<void> seedSettingsIfEmpty({
    required List<String> defaultRombelList,
    required SchoolProfileModel defaultProfile,
  }) async {
    final doc = await _settingsRef.get();
    if (doc.exists) return; // Already initialized, skip
    await _settingsRef.set({
      'rombelList': defaultRombelList,
      'schoolProfile': {
        'name': defaultProfile.name,
        'npsn': defaultProfile.npsn,
        'address': defaultProfile.address,
        'phone': defaultProfile.phone,
        'email': defaultProfile.email,
        'academicYear': defaultProfile.academicYear,
        'semester': defaultProfile.semester,
        'principalName': defaultProfile.principalName,
        'principalNip': defaultProfile.principalNip,
      },
    });
  }
}
