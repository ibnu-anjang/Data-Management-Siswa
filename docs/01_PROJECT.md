# Project Definition

## Project
Student Management App — Flutter mobile application for managing and viewing student information.

## Feature Priority Matrix

### Admin (Priority: ★★★★★ — Highest Operational Priority)
Primary purpose: full student management with real-time Firebase backend sync.
- Login
- Dashboard (Operational Summary)
- Full CRUD (Create, Read, Update, Delete)
- Search
- Class Filter
- Delete Confirmation Dialog
- Firebase Realtime/Firestore Integration

### Client (Priority: ★★☆☆☆ — Secondary Read-Only Module)
Primary purpose: lightweight read-only consumption of student information and recap data.
- Login
- Home (Recap Summary)
- Read-only Student List
- Search
- Class Filter
- Profile & Session

## Functional scope

### Authentication
- Login
- role-aware routing
- logout

### Client
- Home/landing page containing recap data
- approved client navigation

### Admin
- dashboard/admin page
- student management
- search
- class filter
- add student
- edit student
- delete student
- delete confirmation
- logout

### Data
Student fields must follow the actual backend/database schema.
Do not invent mandatory fields without approval.

## Quality goals
- easy to understand
- CRUD is the clearest operational flow
- shallow navigation
- usable forms
- clear feedback
- loading/error/empty states
- consistent UI
- maintainable Flutter code

## Design direction
Modern, clean, professional, practical, readable, human-designed.

Avoid:
- default glassmorphism
- decorative gradients
- too many cards
- meaningless dashboard statistics
- heavy shadows
- excessive rounded corners
- unnecessary animation
- generic AI-generated dashboard aesthetics

## Definition of done
A screen is done when:
- layout follows its specification
- navigation works
- async states are handled where relevant
- forms validate
- success/error feedback exists
- no unapproved visual improvisation exists
- code follows the architecture rules
