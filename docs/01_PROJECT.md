# Project Definition

## Project
Student Management App — Flutter mobile application for managing and viewing student information.

## Roles

### Client
Primary purpose: consume student information and recap data.

### Admin
Primary purpose: manage student records.

Admin capabilities:
- view student list
- search
- filter by class
- create
- read
- update
- delete
- confirm delete
- logout

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
