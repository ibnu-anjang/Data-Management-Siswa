# Screen Specifications

## S01 — Login
Purpose: authenticate and route by role.

Layout:
```text
App identity
Welcome title
Supporting text
Email
Password
Login button
Optional supporting text
```

States:
- idle
- validation error
- loading
- authentication error
- success/navigation

Rules:
- password visibility control
- keyboard must not cover active controls
- prevent duplicate submission while loading

## S02 — Client Home / Recap
Purpose: show recap data required by the brief.

Suggested layout:
```text
Greeting
Recap summary
Meaningful visualization (optional)
Relevant information
```

Do not invent statistics. All displayed statistics must come from real data.

States:
- loading
- loaded
- error
- empty where relevant

## S03 — Client Student List
Purpose: consume student information if included in approved scope.

Layout:
```text
Title
Search
Student list
```

Never expose admin CRUD controls to client.

States:
loading / loaded / empty / search-empty / error

## S04 — Admin Dashboard
Purpose: operational overview.

Suggested:
```text
Greeting
Small summary
Primary action
Recent students or useful summary
```

Dashboard is secondary to CRUD.

## S05 — Admin Student Management
This is the primary CRUD screen.

Layout:
```text
Title + Add
Search
Class filter
Student list
Student identity
Class
Edit
Delete
```

States:
loading / loaded / empty / search-filter empty / error / mutation progress

## S06 — Add/Edit Student
Use one reusable form.

Add mode: empty values.
Edit mode: prefilled values.

Only use fields confirmed by the actual data model.

Possible proposal-only baseline:
- name
- student ID/NIS
- class
- gender
- address

These are not mandatory until confirmed.

Validation:
- required fields
- format validation where applicable
- field-level errors

Submit:
- show progress
- prevent duplicates
- clear success/error feedback

## S07 — Delete Confirmation
```text
Hapus siswa?

[Student Name] akan dihapus.
Tindakan ini tidak dapat dibatalkan.

[ Batal ] [ Hapus ]
```

Rules:
- explicit destructive action
- identify student
- safe cancel
- no API delete before confirmation

## S08 — Account / Logout
Optional depending on final navigation.

Logout:
- clear session
- navigate to login
- protect admin routes
