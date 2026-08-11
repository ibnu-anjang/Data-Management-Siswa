# Firebase Security Rules

## Access matrix

| Resource | Admin | Client |
|---|---|---|
| Own user profile | Read | Read |
| students | Read/Write | Read |
| classes | Read/Write | Read |

Unauthenticated users have no protected Firestore access.

Admin:
- students: read/create/update/delete
- classes: read/create/update/delete/deactivate

Client:
- students: read only
- classes: read only

Normal users cannot modify their role.

## Principles
1. Deny by default.
2. Require authentication.
3. Verify role before writes.
4. Never trust UI-only checks.
5. Never expose passwords.
6. Never allow client writes to students/classes.

Before changing existing rules, inspect the current Firebase project and preserve unrelated working rules.

Test:
- Admin student CRUD allowed
- Client student writes denied
- Admin class management allowed
- Client class writes denied
- Unauthenticated access denied
