# AI CLI Workflow Prompts

## /inspect
```text
Inspect this Flutter project before making changes.

Read the project documentation first.

Inspect:
- pubspec.yaml
- lib/
- routing
- theme
- state management
- API/network layer
- models
- tests

Do not modify code.

Return:
1. architecture summary
2. existing conventions
3. relevant files
4. risks
5. recommended first step
```

## /ux
```text
Act as a UX designer.
Do not write Flutter code.

Based on the requirements and documentation, design the requested flow.

Return:
- user goal
- entry point
- screen hierarchy
- interactions
- success path
- error path
- empty path
- loading path
- navigation
- accessibility considerations

Do not invent features.
Ask before making a materially different UX decision.
```

## /ui
```text
Act as a UI designer.
Do not write production code yet.

Follow 04_UI_DESIGN_SYSTEM.md exactly.

Design one screen only.

Return:
- layout hierarchy
- components
- spacing relationships
- typography
- color token usage
- interaction states
- responsive considerations

Do not add decorative elements without purpose.
```

## /implement
```text
Implement the approved screen.

First inspect the existing project and relevant files.

Follow:
- 04_UI_DESIGN_SYSTEM.md
- 05_SCREEN_SPECIFICATIONS.md
- 06_COMPONENTS.md
- 08_FLUTTER_ARCHITECTURE.md
- 09_AI_RULES.md

Do not change approved UX or visual design.

Implement only the requested scope.

After:
- run flutter analyze
- run relevant tests
- report files changed
- report validation
- report remaining issues
```

## /review-ui
```text
Review the current Flutter UI against the documentation.

Do not modify code.

Evaluate:
- hierarchy
- spacing
- typography
- alignment
- color consistency
- component consistency
- loading/empty/error states
- accessibility
- AI-slop patterns

Return issues as P0/P1/P2/P3 with exact references where possible.
```

## /review-crud
```text
Audit the student CRUD flow.

Check:
- list
- search
- class filter
- create
- update
- delete
- delete confirmation
- loading
- empty
- search empty
- error
- success feedback

Do not modify code.

Return PASS/FAIL, missing behavior, suspicious behavior, and prioritized fixes.
```

## /fix
```text
Fix only the explicitly approved issues.
Do not refactor unrelated code.
Do not redesign UI.
Do not change API contracts.

After fixing:
- analyze
- test relevant functionality
- summarize exact changes
```

## /polish
```text
Perform visual polish only.

Do not change:
- navigation
- feature scope
- information hierarchy
- API behavior

Focus on:
- spacing
- alignment
- typography
- component consistency
- accessibility
- small interaction feedback

Identify proposed changes before applying them.
```

## /qa
```text
Run a final QA audit against all project documentation.

Do not modify code.

Check:
- requirements
- authentication
- role routing
- client recap
- admin
- student CRUD
- search/filter
- delete confirmation
- logout
- states
- visual consistency
- architecture
- analyze/test status

Return a PASS/FAIL/NEEDS REVIEW checklist.
```
