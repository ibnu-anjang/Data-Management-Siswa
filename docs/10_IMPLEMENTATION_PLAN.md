# Implementation Plan

## Phase 0 — Inspect
- Flutter version
- pubspec
- folders
- dependencies
- theme
- routing
- API/network
- models
- tests

Do not rewrite anything.

## Phase 1 — Foundation
- theme
- typography
- colors
- base components
- routing foundation
- app shell

Run:
```bash
flutter analyze
flutter test
```

## Phase 2 — Authentication
- login UI
- validation
- loading/error
- role routing
- session handling

Verify client/admin separation and invalid-login behavior.

## Phase 3 — Client (Priority: ★★☆☆☆ — Lightweight Read-Only)
- recap/home
- read-only student list
- search & filter
- loading/error/empty

Use real backend data in final behavior.

## Phase 4 — Admin Student Management & Firebase (Priority: ★★★★★ — Core Focus)
Highest operational priority:
- list
- search
- class filter
- Firebase integration & live sync
- loading/empty/error states

## Phase 5 — Create
- form
- validation
- loading
- API create
- success/error
- list refresh/update

## Phase 6 — Update
- prefilled form
- validation
- API update
- success/error
- list refresh/update

## Phase 7 — Delete
- delete action
- confirmation
- API delete
- loading
- success/error
- list refresh

Never bypass confirmation.

## Phase 8 — Logout
- clear session
- reset route stack
- protected route enforcement

## Phase 9 — Polish
Only after functionality:
- spacing
- alignment
- typography
- micro-interactions
- accessibility
- responsive edge cases

## Phase 10 — Final QA
Check:
- login
- role routing
- client recap
- admin
- list
- search
- filter
- add
- edit
- delete confirmation
- delete
- logout
- loading
- empty
- errors
- overflow
- debug UI
- fake final data
- flutter analyze
- tests
