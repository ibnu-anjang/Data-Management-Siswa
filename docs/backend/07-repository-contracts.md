# Repository Contracts

Centralize Firebase access in repositories.

## AuthRepository
- `login(email, password)`
- `logout()`
- `getCurrentUser()`
- `getUserProfile(uid)`
- `getUserRole(uid)`
- `observeAuthState()`

## StudentRepository
- `getStudents()`
- `getStudentById(studentId)`
- `createStudent(student)`
- `updateStudent(studentId, data)`
- `deleteStudent(studentId)`
- `searchStudents(query)`
- `getStudentsByClass(classId)`

## ClassRepository
- `getClasses()`
- `getActiveClasses()`
- `createClass(classModel)`
- `updateClass(classId, data)`
- `deactivateClass(classId)`

Repositories handle Firebase, serialization and Firebase error mapping.

Repositories must not render UI, navigate, show dialogs, or contain widget code.
