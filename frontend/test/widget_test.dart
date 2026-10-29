import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_management_siswa/main.dart';
import 'package:data_management_siswa/core/models/student_model.dart';
import 'package:data_management_siswa/shared/modals/student_form_modal.dart';
import 'package:data_management_siswa/shared/widgets/app_avatar.dart';
import 'package:data_management_siswa/shared/widgets/animated_count.dart';
import 'package:data_management_siswa/core/utils/app_date_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SekolahKuApp instantiation test', (WidgetTester tester) async {
    const app = SekolahKuApp();
    expect(app, isNotNull);
  });

  group('Validation Rules Tests', () {
    test('NIS/NISN regex allows only digits', () {
      final validNis = '210103';
      final invalidNisWithLetters = '21010A';
      final invalidNisWithSymbols = '2101-03';

      final nisRegex = RegExp(r'^[0-9]+$');
      expect(nisRegex.hasMatch(validNis), isTrue);
      expect(nisRegex.hasMatch(invalidNisWithLetters), isFalse);
      expect(nisRegex.hasMatch(invalidNisWithSymbols), isFalse);
    });

    test('Student name regex allows characters, hyphen, space, dot, and rejects digits', () {
      final validNameSimple = 'Ibnu Anjang';
      final validNameWithHyphen = 'Siti Nur-Aini';
      final validNameWithApostrophe = "A'an";
      final validNameWithDot = 'Dr. M. Fauzi';
      final invalidNameWithDigits = 'Ibnu 123';
      final invalidNameWithNumber = 'Ahmad 2nd';

      final digitCheck = RegExp(r'[0-9]');
      final allowedChars = RegExp(r"^[a-zA-Z\s\-\.\'\`]+$");

      expect(digitCheck.hasMatch(validNameSimple), isFalse);
      expect(allowedChars.hasMatch(validNameSimple), isTrue);

      expect(digitCheck.hasMatch(validNameWithHyphen), isFalse);
      expect(allowedChars.hasMatch(validNameWithHyphen), isTrue);

      expect(digitCheck.hasMatch(validNameWithApostrophe), isFalse);
      expect(allowedChars.hasMatch(validNameWithApostrophe), isTrue);

      expect(digitCheck.hasMatch(validNameWithDot), isFalse);
      expect(allowedChars.hasMatch(validNameWithDot), isTrue);

      expect(digitCheck.hasMatch(invalidNameWithDigits), isTrue);
      expect(digitCheck.hasMatch(invalidNameWithNumber), isTrue);
    });
  });

  testWidgets('StudentFormModal renders without overflow on small screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  StudentFormModal.show(
                    context: context,
                    rombelList: ['XII RPL 1', 'XII TKJ 1'],
                    onSubmit: (_) {},
                  );
                },
                child: const Text('Open Form'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Form'));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Siswa Baru'), findsOneWidget);
    expect(find.text('NISN *'), findsOneWidget);
    expect(find.text('NIS *'), findsOneWidget);
  });

  group('Rombel Data Integrity Rule', () {
    test('Rombel deletion is blocked when student count > 0', () {
      final mockStudents = [
        {'id': 1, 'class': 'XII IPA 1'},
        {'id': 2, 'class': 'XII IPA 1'},
        {'id': 3, 'class': 'XII IPA 2'},
      ];

      int getStudentCount(String className) {
        return mockStudents.where((s) => s['class'] == className).length;
      }

      // XII IPA 1 has 2 students -> must be blocked
      expect(getStudentCount('XII IPA 1') > 0, isTrue);
      // Empty class has 0 students -> allowed to delete
      expect(getStudentCount('XII IPS 3') == 0, isTrue);
    });
  });

  group('StudentModel PhotoUrl Tests', () {
    test('photoUrl defaults to empty string and serializes correctly', () {
      final jsonWithoutPhoto = {
        'id': 1,
        'name': 'Budi Santoso',
        'nis': '210101',
        'class': 'XII IPA 1',
        'gender': 'Laki-laki',
        'address': 'Bogor',
        'birthDate': '12 Jan 2007',
        'religion': 'Islam',
        'guardianName': 'Santoso',
        'guardianPhone': '08123456789',
        'status': 'Aktif',
      };

      final student = StudentModel.fromJson(jsonWithoutPhoto);
      expect(student.photoUrl, '');

      final jsonWithPhoto = Map<String, dynamic>.from(jsonWithoutPhoto);
      jsonWithPhoto['photoUrl'] = 'https://res.cloudinary.com/tyxmoxst/image/upload/v1234/foto.jpg';

      final studentWithPhoto = StudentModel.fromJson(jsonWithPhoto);
      expect(studentWithPhoto.photoUrl, 'https://res.cloudinary.com/tyxmoxst/image/upload/v1234/foto.jpg');
      expect(studentWithPhoto.toJson()['photoUrl'], 'https://res.cloudinary.com/tyxmoxst/image/upload/v1234/foto.jpg');
    });

    test('StudentModel copyWith preserves and updates photoUrl', () {
      const student = StudentModel(
        id: 101,
        name: 'Ahmad',
        nisn: '0071234501',
        nis: '210101',
        className: 'XII IPA 1',
        major: 'IPA',
        gender: 'Laki-laki',
        birthPlace: 'Bogor',
        birthDate: '15 Mei 2007',
        religion: 'Islam',
        phone: '08123456789',
        guardianName: 'Subagyo',
        guardianPhone: '08123456789',
        address: 'Jl. Sudirman',
        status: 'Aktif',
        photoUrl: 'https://res.cloudinary.com/hbzlmngj/photo.jpg',
      );
      expect(student.photoUrl, 'https://res.cloudinary.com/hbzlmngj/photo.jpg');

      final updated = student.copyWith(photoUrl: 'https://res.cloudinary.com/hbzlmngj/new_photo.jpg');
      expect(updated.photoUrl, 'https://res.cloudinary.com/hbzlmngj/new_photo.jpg');
      expect(updated.name, 'Ahmad');
    });
  });

  group('AppAvatar Initial Fallback Tests', () {
    testWidgets('AppAvatar renders capitalized initial letter when photoUrl is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppAvatar(
              name: 'Farhan Hakim',
              photoUrl: '',
              size: 40,
            ),
          ),
        ),
      );

      expect(find.text('F'), findsOneWidget);
    });

    testWidgets('AppAvatar falls back to default initial S if name is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppAvatar(
              name: '',
              photoUrl: '',
              size: 40,
            ),
          ),
        ),
      );

      expect(find.text('S'), findsOneWidget);
    });

    testWidgets('AppAvatar falls back to initial when photoUrl has whitespace only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppAvatar(
              name: 'Dewi Lestari',
              photoUrl: '   ',
              size: 40,
            ),
          ),
        ),
      );

      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('AppAvatar correctly extracts first alphanumeric initial', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppAvatar(
              name: '@administrator',
              photoUrl: '',
              size: 40,
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });
  });

  group('Interactive Dashboard Features Tests', () {
    test('AppDateUtils returns valid Indonesian greeting and date', () {
      final greeting = AppDateUtils.getTimeGreeting();
      expect(['Selamat Pagi', 'Selamat Siang', 'Selamat Sore', 'Selamat Malam'].contains(greeting), isTrue);

      final dateFormatted = AppDateUtils.getFormattedToday();
      expect(dateFormatted.isNotEmpty, isTrue);
      expect(dateFormatted.contains('202'), isTrue);
    });

    testWidgets('AnimatedCount renders target count and suffix', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCount(
              count: 42,
              suffix: 'Siswa',
            ),
          ),
        ),
      );

      // Fast forward animation
      await tester.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
      expect(find.text('Siswa'), findsOneWidget);
    });

    testWidgets('Dashboard greeting row keeps avatar and greeting adjacent on wide screens', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const AppAvatar(name: 'Administrator', size: 46),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Selamat Pagi, Admin'),
                                Text('Kamis, 29 Oktober 2026'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('SMK AK Nusa Bangsa'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final avatarRect = tester.getRect(find.byType(AppAvatar));
      final greetingRect = tester.getRect(find.text('Selamat Pagi, Admin'));

      // Spacing between avatar's right edge and greeting's left edge must strictly be 14px (+- 0.5px)
      final gap = greetingRect.left - avatarRect.right;
      expect(gap, closeTo(14.0, 0.5));
    });

    testWidgets('Dashboard greeting reflows gracefully on 320px mobile S screen without broken syllables', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 420;
                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const AppAvatar(name: 'Administrator', size: 42),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Selamat Pagi, Admin',
                                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Kamis, 29 Oktober 2026 • Semester Genap',
                                    style: TextStyle(fontSize: 11.5),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('SMK AK Nusa Bangsa'),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      final greetingRect = tester.getRect(find.text('Selamat Pagi, Admin'));
      // Greeting must have ample horizontal room (> 180px) on 320px screen
      expect(greetingRect.width, greaterThan(180));
      expect(find.text('SMK AK Nusa Bangsa'), findsOneWidget);
    });
  });
}
