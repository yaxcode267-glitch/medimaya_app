# Espaciado, forma y tipografía

## Spacing scale

Only these values: **4, 8, 12, 16, 20, 24, 32**. A stray `14` or `18` in a page means a value was invented instead of taken from the scale.

| Context | Value |
| --- | --- |
| Between icon and its label | 6–10 |
| Between tight siblings (chips, inline buttons) | 8 |
| Between form fields | 16 |
| Between form fields, related pair | 12 |
| Padding inside `AppCard` | 20 |
| Above `FormActions` | 24 |
| Above a major section | 24–32 |
| Card inside card | 16 |

## Radii

| Element | Radius |
| --- | --- |
| Card, panel | 16 |
| Input, button, menu item | 12 |
| Badge, pill | 999 |
| Icon container inside a card | 14 |

`AppCard` uses 16, `input_form.dart` uses 12, `Sidebar` uses 12, `ButtonThemes` uses 20. Match the component you're composing with.

## Heights

- Button: **44** minimum. `SizedBox(height: 44, child: ElevatedButton(...))`, as `ProfilePage` does.
- Icon-only button: 44×44 with a `tooltip`.
- Table row: 56 (heading and data rows).
- `AppCard` icon container: 48×48, icon at `size: 24`.
- `AppEmptyState` icon circle: 64 diameter.

## Icons

- Inside a button: `size: 18`.
- Inline with a 14–16 label: `size: 16`–`20`.
- Standalone in a card: `size: 24` in a 48 container.
- Use the `Icons.*_outlined` family for navigation and menu items, matching `Sidebar` and `sidebar_config.dart`. Solid icons are for selected/active states and status.
- Every `IconButton` without a visible label needs a `tooltip` in Spanish.

## Typography

| Role | Size | Weight |
| --- | --- | --- |
| Screen title | 19–20 | `w700` |
| Card section title | 16–18 | `w600` |
| Body / input text | 16 | `w400` |
| Table and list text | 14 | `w400` |
| Label / field label | 14–16 | `w500` |
| Badge / caption | 12–13 | `w600` |
| Section header uppercase | 11 | `w700`, `letterSpacing: 1.1` |

Rules:
- Weight carries hierarchy. Don't get hierarchy from size alone on a dense screen.
- Inputs use `fontSize: 16`. Below 16, iOS zooms the viewport on focus.
- All colour: `AppColors.colorTexto` for primary text, `colorTextoSecundario` for labels and inactive items.
- Long labels get `maxLines: 1` + `TextOverflow.ellipsis` (see `Sidebar`), or wrap deliberately. Never let text overflow its box.