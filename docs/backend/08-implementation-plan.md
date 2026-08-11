# Backend Implementation Plan

## Phase 0 — Inspect
Inspect Flutter project, pubspec.yaml, lib/, Firebase configuration, firebase_options.dart, existing models/screens/state management/repositories, and Firestore rules.

Do not overwrite working code blindly.

## Phase 1 — Firebase
Verify Firebase project connection, Auth, and Firestore. Use minimal dependencies.

## Phase 2 — Models
Implement UserModel, StudentModel, ClassModel with Firestore serialization.

## Phase 3 — Auth
Implement login, logout, auth state, profile loading, role routing.

## Phase 4 — Repositories
Implement AuthRepository, StudentRepository, ClassRepository. Start with reads, then writes.

## Phase 5 — Admin CRUD
Student list, detail, add, edit, delete, confirmation.

## Phase 6 — Search
NIS/name search using a Firestore-compatible strategy. No external search service.

## Phase 7 — Class filter
All classes + selected class filtering.

## Phase 8 — Client
Home, Student List, Detail, Search, Filter, Profile, Logout. No mutation.

## Phase 9 — Security Rules
Implement and test role-based access.

## Phase 10 — Dashboard
Connect statistics to actual Firestore data.

## Phase 11 — State handling
Loading, empty, error and retry where useful.

## Phase 12 — Integration
Connect approved UI to repositories without redesigning UI.

## Phase 13 — Testing
Run formatter, analyzer/tests, then verify `09-acceptance-tests.md`.
