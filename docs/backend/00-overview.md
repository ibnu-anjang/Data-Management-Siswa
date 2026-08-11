# Backend Overview

## Project
Aplikasi Manajemen Data Siswa

## Backend
Firebase Authentication + Cloud Firestore.

## Roles
### Admin
Full management: login, dashboard, read/search/filter students, detail, create/update/delete students, manage classes/rombel, profile, logout.

### Client
Read-only: login, home, read/search/filter students, detail, profile, logout.

Client cannot create, update, delete students or manage classes.

## Core Collections
- `users/{uid}`
- `students/{studentId}`
- `classes/{classId}`

## Principle
Admin = data manager. Client = read-only information consumer.

Authorization MUST be enforced by Firebase Security Rules, not only by hiding UI buttons.

## Scope
Do not add attendance, grades, parent management, chat, notifications, payment, custom backend server, search engine, or other ERP features unless explicitly approved.
