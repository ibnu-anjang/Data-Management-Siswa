class SchoolProfileModel {
  final String name;
  final String npsn;
  final String address;
  final String phone;
  final String email;
  final String academicYear;
  final String semester;
  final String principalName;
  final String principalNip;

  const SchoolProfileModel({
    required this.name,
    required this.npsn,
    required this.address,
    required this.phone,
    required this.email,
    required this.academicYear,
    required this.semester,
    required this.principalName,
    required this.principalNip,
  });

  SchoolProfileModel copyWith({
    String? name,
    String? npsn,
    String? address,
    String? phone,
    String? email,
    String? academicYear,
    String? semester,
    String? principalName,
    String? principalNip,
  }) {
    return SchoolProfileModel(
      name: name ?? this.name,
      npsn: npsn ?? this.npsn,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      academicYear: academicYear ?? this.academicYear,
      semester: semester ?? this.semester,
      principalName: principalName ?? this.principalName,
      principalNip: principalNip ?? this.principalNip,
    );
  }
}
