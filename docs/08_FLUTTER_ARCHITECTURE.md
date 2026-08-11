# Flutter Architecture

This is an implementation recommendation, not a mandatory framework choice.

## Layers
```text
Presentation
    ↓
State / Controller
    ↓
Repository
    ↓
Data Source / API
```

## Feature-first
```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
├── shared/
│   └── widgets/
└── features/
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── client/
    │   └── presentation/
    └── students/
        ├── data/
        ├── domain/
        └── presentation/
```

## Data model
Follow the real backend/database schema.

Example only:
```dart
class Student {
  final String id;
  final String name;
  final String? studentNumber;
  final String? className;
}
```

Do not invent fields or API contracts.

## Repository
Repository handles:
- fetch
- create
- update
- delete
- error mapping

UI must not call HTTP directly.

## State management
If the project already has a state-management solution, keep it.
If none exists, use the simplest maintainable option.
Do not add a large framework for fashion.

## Routing
Must support:
- protected routes
- role-aware routing
- predictable back behavior

## Theme
Centralize colors, typography, component styles, and reusable visual tokens.

## Error mapping
Example:
```text
Timeout -> Koneksi terlalu lama. Coba lagi.
401     -> Sesi berakhir. Silakan login kembali.
500     -> Terjadi kesalahan server. Coba lagi.
```

Exact behavior depends on backend.

## Code quality
Prefer:
- small widgets
- const where useful
- meaningful names
- no giant build methods
- no duplicated UI
- no business logic inside widgets
- no premature abstraction
