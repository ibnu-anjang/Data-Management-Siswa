# Backend Acceptance Tests

## Authentication
- AUTH-01: Admin valid login → Admin Dashboard.
- AUTH-02: Client valid login → Client Home.
- AUTH-03: Invalid credentials rejected.
- AUTH-04: Logout → Login.
- AUTH-05: Client cannot elevate role.

## Admin Students
- STU-01: View list.
- STU-02: Search NIS.
- STU-03: Search name.
- STU-04: Filter class.
- STU-05: Detail.
- STU-06: Create valid student.
- STU-07: Required fields rejected when empty.
- STU-08: Duplicate NIS rejected.
- STU-09: Update student.
- STU-10: Delete after confirmation.
- STU-11: Cancel delete preserves student.

## Client Students
- CLI-01: View list.
- CLI-02: Search NIS/name.
- CLI-03: Filter class.
- CLI-04: Detail.
- CLI-05: Create denied.
- CLI-06: Update denied.
- CLI-07: Delete denied.

## Classes
- CLS-01: Admin reads classes.
- CLS-02: Admin creates class.
- CLS-03: Admin updates class.
- CLS-04: Admin deactivates class.
- CLS-05: Client reads classes.
- CLS-06: Client class writes denied.

## Security
- SEC-01: Unauthenticated protected Firestore access denied.
- SEC-02: Client student write denied.
- SEC-03: Client class write denied.
- SEC-04: Admin student CRUD allowed.
- SEC-05: Admin class management allowed.

## Data integrity
- DATA-01: Student uses classId.
- DATA-02: Class rename does not require editing every student.
- DATA-03: NIS remains unique.
- DATA-04: Failed writes never show fake success.
- DATA-05: Dashboard counts reflect actual data.
