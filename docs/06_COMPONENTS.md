# Component Inventory

Create reusable components when repetition or consistency justifies them.

## Core
- AppScaffold
- AppBar
- PrimaryButton
- SecondaryButton
- DangerButton
- AppTextField
- AppDropdown
- SearchField
- StudentListItem
- StudentActions
- EmptyState
- ErrorState
- LoadingState
- ConfirmationDialog
- StatusMessage/Snackbar

## Component rules
1. Do not duplicate the same control visually.
2. Use theme tokens.
3. Behavior is passed through parameters.
4. Components do not contain unrelated business logic.
5. Do not over-abstract one-off UI.
6. Use semantic names.

## Suggested Flutter structure
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
    ├── client/
    └── students/
```
