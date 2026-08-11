# UI Design System

This is the proposed baseline. It is not part of the original project brief. If the developer approves different values, update this file before implementation.

## Visual direction
Modern / clean / professional / calm / practical / readable / lightweight.

Avoid:
- glassmorphism
- excessive gradients
- neon colors
- giant hero typography
- excessive rounded containers
- heavy shadows
- floating cards everywhere
- decorative charts without meaning

## Color tokens
```text
Primary       #2563EB
Background    #F8FAFC
Surface       #FFFFFF
Text          #0F172A
TextMuted     #64748B
Border        #E2E8F0
Success       #16A34A
Warning       #D97706
Danger        #DC2626
Info          #0284C7
```

Use tokens rather than arbitrary widget colors.

## Typography
Preferred: Inter.

```text
Display       28 / 700
Heading       22 / 700
Section       18 / 600
Title         16 / 600
Body          14 / 400
Body Medium   14 / 500
Caption       12 / 400
Button        14 / 600
```

## Spacing
4-point scale:
```text
4  8  12  16  20  24  32  40  48
```
Prefer 8/16/24 for major relationships.

## Radius
```text
Small  8
Medium 12
Large  16
Pill   999
```
Default controls: 8. Cards/surfaces: 12.

## Elevation
Prefer borders and surface contrast over heavy shadows.
Use elevation mainly for dialogs, menus, and floating elements.

## Buttons
Primary = filled, main action.
Secondary = outlined/low emphasis.
Danger = destructive action only.
Avoid ambiguous icon-only actions.

## Inputs
Label + field + helper/error.
Support visible focus, readable hints, clear validation.

## Lists
Prioritize scanability:
```text
Name
Class / identifier
Optional metadata
Actions
```

## Accessibility
- readable contrast
- comfortable touch targets
- important meaning not conveyed by color alone
- clear labels
- reasonable text scaling

## Responsive
Respect safe areas, avoid fixed widths where unnecessary, prevent overflow, handle small/large phone widths.
