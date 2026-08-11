# Data Model

## User
Fields: `uid`, `name`, `email`, `role`, `createdAt`.

Allowed roles: `admin`, `client`.

## Student
Fields: `id`, `nis`, `name`, `classId`, `major`, `createdAt`, `updatedAt`.

Required: NIS, name, class, major.

Constraints:
- NIS required and unique
- classId must reference an existing class
- required fields cannot be empty

## Class / Rombel
Fields: `id`, `name`, `grade`, `major`, `isActive`, `createdAt`, `updatedAt`.

## Relationship
Student belongs to Class through `classId`.

Do not duplicate class name inside student as source of truth.

`students/{studentId}.classId → classes/{classId}`

This allows class renaming without updating every student document.
