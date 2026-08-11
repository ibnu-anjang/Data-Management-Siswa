# Backend AI Agent Rules

Implement the Firebase backend according to `docs/backend/00-overview.md` through `09-acceptance-tests.md`.

## Before coding
Inspect the existing Flutter project, pubspec.yaml, lib/, Firebase configuration, firebase_options.dart, existing models/screens/state management/repositories, and Firestore rules. Do not assume the project is empty.

## Do not invent requirements
Use the simplest solution compatible with the docs and existing code. If a decision affects architecture, security, schema, or dependencies, ask for approval.

## Firebase
Use Firebase Authentication and Cloud Firestore. Do not add custom backend, external search engine, Cloud Functions, Storage, or other Firebase services without explicit approval.

## Security
Authorization must be enforced with Firebase Security Rules. Client is read-only. Never allow Client to become Admin. Never store passwords in Firestore.

## Data
Use `users/{uid}`, `students/{studentId}`, `classes/{classId}`. Students reference classes through `classId`.

## UI
The approved UI/UX is the source of truth. Do not redesign colors, typography, layout, navigation, spacing, or components unless explicitly requested.

## Code
Prefer simple, readable, strongly typed code, minimal dependencies, and existing project conventions. Avoid unnecessary abstractions.

## Change discipline
Before major changes, identify affected files and risks. After changes, run formatter, analyzer and tests where available. Report remaining issues honestly.

## Implementation order
1. Inspect
2. Firebase verification
3. Models
4. Auth
5. Repositories
6. Admin CRUD
7. Search
8. Class filter
9. Client read-only
10. Security Rules
11. Dashboard
12. Validation/loading/error states
13. Testing

Do not claim completion until the acceptance tests have been checked.
