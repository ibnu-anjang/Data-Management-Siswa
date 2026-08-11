# Information Architecture

## Structure
```text
App
├── Authentication
│   └── Login
├── Client
│   ├── Home / Recap
│   └── Student List (if approved)
└── Admin
    ├── Dashboard
    ├── Student Management
    │   ├── Add Student
    │   ├── Edit Student
    │   └── Delete Confirmation
    └── Account / Logout
```

## Recommended screen inventory
This is a design recommendation, not an additional source requirement.

1. Login
2. Client Home / Recap
3. Client Student List
4. Admin Dashboard
5. Admin Student Management
6. Add Student
7. Edit Student
8. Delete Confirmation

Screens may be merged only if the UX remains clear.

## Suggested routes
```text
/login
/client/home
/client/students
/admin/home
/admin/students
/admin/students/create
/admin/students/:id/edit
```

Exact routing technology is implementation-specific.

## Student information hierarchy
1. Student name
2. identifier/NIS if present in actual data model
3. class
4. secondary information
5. actions

Do not let action icons overpower the student's identity.

## UX priority
Highest:
1. Login
2. Student list
3. Add/Edit form
4. Delete confirmation

Secondary:
5. Dashboard statistics
6. Decorative visuals
