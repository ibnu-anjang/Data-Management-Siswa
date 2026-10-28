import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String docId; // Firestore document ID (empty string for new/local students)
  final int id;       // Legacy numeric ID (kept for UI compatibility)
  final String name;
  final String nisn;
  final String nis;
  final String className;
  final String major;
  final String gender; // 'Laki-laki' or 'Perempuan'
  final String birthPlace;
  final String birthDate;
  final String religion;
  final String phone;
  final String guardianName;
  final String guardianPhone;
  final String address;
  final String status; // 'Aktif' or 'Alumni'
  final String photoUrl; // Cloudinary CDN image URL (empty string if no photo)

  const StudentModel({
    this.docId = '',
    required this.id,
    required this.name,
    required this.nisn,
    required this.nis,
    required this.className,
    required this.major,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.religion,
    required this.phone,
    required this.guardianName,
    required this.guardianPhone,
    required this.address,
    this.status = 'Aktif',
    this.photoUrl = '',
  });

  StudentModel copyWith({
    String? docId,
    int? id,
    String? name,
    String? nisn,
    String? nis,
    String? className,
    String? major,
    String? gender,
    String? birthPlace,
    String? birthDate,
    String? religion,
    String? phone,
    String? guardianName,
    String? guardianPhone,
    String? address,
    String? status,
    String? photoUrl,
  }) {
    return StudentModel(
      docId: docId ?? this.docId,
      id: id ?? this.id,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      nis: nis ?? this.nis,
      className: className ?? this.className,
      major: major ?? this.major,
      gender: gender ?? this.gender,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      religion: religion ?? this.religion,
      phone: phone ?? this.phone,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      address: address ?? this.address,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  /// Convert to Firestore document map
  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'nisn': nisn,
        'nis': nis,
        'class': className,
        'major': major,
        'gender': gender,
        'birthPlace': birthPlace,
        'birthDate': birthDate,
        'religion': religion,
        'phone': phone,
        'guardianName': guardianName,
        'guardianPhone': guardianPhone,
        'address': address,
        'status': status,
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  /// Create StudentModel from a Firestore DocumentSnapshot
  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      docId: doc.id,
      id: (data['id'] as num?)?.toInt() ?? 0,
      name: data['name'] as String? ?? '',
      nisn: data['nisn'] as String? ?? '',
      nis: data['nis'] as String? ?? '',
      className: data['class'] as String? ?? '',
      major: data['major'] as String? ?? '',
      gender: data['gender'] as String? ?? 'Laki-laki',
      birthPlace: data['birthPlace'] as String? ?? '',
      birthDate: data['birthDate'] as String? ?? '',
      religion: data['religion'] as String? ?? 'Islam',
      phone: data['phone'] as String? ?? '',
      guardianName: data['guardianName'] as String? ?? '',
      guardianPhone: data['guardianPhone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      status: data['status'] as String? ?? 'Aktif',
      photoUrl: data['photoUrl'] as String? ?? '',
    );
  }

  /// Legacy JSON support (kept for backward compatibility)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nisn': nisn,
        'nis': nis,
        'class': className,
        'major': major,
        'gender': gender,
        'birthPlace': birthPlace,
        'birthDate': birthDate,
        'religion': religion,
        'phone': phone,
        'guardianName': guardianName,
        'guardianPhone': guardianPhone,
        'address': address,
        'status': status,
        'photoUrl': photoUrl,
      };

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      nisn: json['nisn'] as String? ?? '',
      nis: json['nis'] as String? ?? '',
      className: json['class'] as String? ?? '',
      major: json['major'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Laki-laki',
      birthPlace: json['birthPlace'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      religion: json['religion'] as String? ?? 'Islam',
      phone: json['phone'] as String? ?? '',
      guardianName: json['guardianName'] as String? ?? '',
      guardianPhone: json['guardianPhone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      status: json['status'] as String? ?? 'Aktif',
      photoUrl: json['photoUrl'] as String? ?? '',
    );
  }
}
