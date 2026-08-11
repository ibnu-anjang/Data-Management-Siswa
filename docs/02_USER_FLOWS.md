# User Flows

## Authentication
```text
App Start
  -> Login
      -> invalid: validation/error
      -> client: Client Home
      -> admin: Admin Dashboard
```

Logout:
```text
Current Screen -> Logout -> Clear Session -> Login
```

## Client
```text
Login
  -> Client Home / Recap
      -> approved client destinations
```

Client is a consumer of information, not a student-data administrator.

## Admin
```text
Login
  -> Admin Dashboard
      -> Student Management
          -> Search
          -> Filter Class
          -> Add
              -> Form -> Validate -> Save
          -> Edit
              -> Form -> Validate -> Update
          -> Delete
              -> Confirmation -> Cancel OR Confirm -> Delete
```

## CRUD UX rules

### Create
Open form -> validate -> submit -> show progress -> success/error -> update list.

### Read
Student identity should be easy to scan.

### Update
Existing values are prefilled. Save means update.

### Delete
Never delete directly from the first destructive tap. Show confirmation and identify the student.

## Search/filter
- search narrows visible students
- class filter narrows visible students
- both can be combined
- filters can be cleared
- no matching results get a dedicated empty state

## Navigation
Primary destinations should be visible.
CRUD actions should be reachable quickly.
Back behavior must be predictable.
