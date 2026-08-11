# UI State & Interaction Rules

Every data-driven screen must consider complete state.

## Loading
Use for initial fetches and mutations.
Prevent duplicate actions.
Prefer layout-preserving feedback where practical.

## Empty
Differentiate:
- no data exists
- search/filter returned no results

No-data states should provide a relevant CTA where applicable.

## Error
Explain:
- what failed
- whether retry is possible
- what safe action is available

Never show raw stack traces.

## Success
Use concise feedback:
- Data siswa berhasil ditambahkan
- Data siswa berhasil diperbarui
- Data siswa berhasil dihapus

## Form validation
Validate before request.
Use field-level errors where useful.
Handle server/API errors separately.
Do not mark every field invalid immediately on initial load.

## Delete
```text
Delete tap
 -> Confirmation
 -> Cancel OR Confirm
 -> Loading
 -> Success/Error
```

## Search
Search may be local or remote depending on data size/backend.
If remote live search is used, debounce where appropriate.

## Filter
Show selected class, provide clear/reset, combine predictably with search.

## Navigation after mutation
Create/edit: return to approved destination and refresh/update data.
Delete: remain on list and remove/refresh item.
Logout: clear session and return to login.

## Animation
Use only when it improves understanding or feedback.
No decorative animation by default.
