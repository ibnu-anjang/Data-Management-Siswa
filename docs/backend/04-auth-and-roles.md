# Authentication and Roles

Use Firebase Authentication with Email + Password. Passwords are never stored in Firestore.

## Login
`LoginScreen → AuthRepository → FirebaseAuth → users/{uid} → role → route`

- `admin` → Admin Dashboard
- `client` → Client Home

## Logout
1. `FirebaseAuth.signOut()`
2. Clear relevant local auth state
3. Navigate to Login
4. Prevent protected screen access

Only `admin` and `client` roles are supported.

A user must never change their own role through normal UI. A client must never promote itself to admin.

Missing/unsupported role: controlled error + deny protected access.
