# Backend Architecture

Flutter → Firebase Authentication → Cloud Firestore → Firebase Security Rules.

No custom backend server is required.

## Recommended structure

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── validators/
│   └── utils/
├── models/
│   ├── user_model.dart
│   ├── student_model.dart
│   └── class_model.dart
├── repositories/
│   ├── auth_repository.dart
│   ├── student_repository.dart
│   └── class_repository.dart
├── screens/
│   ├── auth/
│   ├── admin/
│   ├── client/
│   └── profile/
└── widgets/
    ├── student/
    ├── class/
    └── common/
```

Models represent data. Repositories handle Firebase. Screens handle presentation/interaction. Widgets are reusable UI. Validators handle input validation.

Do not scatter direct Firestore calls across widgets.
