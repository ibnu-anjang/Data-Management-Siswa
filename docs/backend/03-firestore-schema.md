# Firestore Schema

## `users/{uid}`

```json
{
  "uid": "abc123",
  "name": "Administrator",
  "email": "admin@example.com",
  "role": "admin",
  "createdAt": "Timestamp"
}
```

## `students/{studentId}`

```json
{
  "id": "student001",
  "nis": "12345",
  "name": "Budi Santoso",
  "classId": "class001",
  "major": "RPL",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```

## `classes/{classId}`

```json
{
  "id": "class001",
  "name": "XI RPL 1",
  "grade": "XI",
  "major": "RPL",
  "isActive": true,
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```

Use top-level `students` and `classes`. Do not use nested student collections unless explicitly approved.

Class filter: `where classId == selectedClassId`.

Search must use a simple Firestore-compatible strategy appropriate to project scale. Do not add external search infrastructure without approval.
