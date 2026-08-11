# Business Rules

## Students
Only Admin can mutate student data. Client is read-only.

### Create
Required: NIS, name, class, major.
Validate all fields, unique NIS, existing class, active class.

Flow:
Admin → Add Student → Validate → Check NIS → Create → Success → Refresh.

### Read
Admin and Client may read NIS, name, class, major.

### Search
Support NIS and name. Search never mutates data.

### Filter
Filter by class using `classId`.

### Update
Admin only:
Detail → Edit → Validate → Update → update `updatedAt` → refresh.

### Delete
Admin only. Confirmation required.
Cancel = no change.
Confirm = delete → refresh → success.

## Classes
Admin: create/read/update/deactivate.
Client: read only.

Prefer `isActive=false` over hard deletion when students still reference a class.

## Dashboard
Statistics must come from actual Firestore data. Never hardcode counts.

## UI states
Every Firebase operation needs loading/success/error handling. Provide useful empty states. Never show fake success after a failed write. Map Firebase exceptions to user-friendly messages.
