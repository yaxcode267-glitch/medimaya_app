# Color

`AppColors` (`lib/shared/ui/themes/app_colors.dart`) is the only source of colour in the app. If a screen needs a colour that isn't there, add it there.

## Tokens

| Token | Hex | Use |
| --- | --- | --- |
| `colorPrimario` | `#0B8793` | Primary action, active state, brand |
| `colorSecundario` | `#0D2B2E` | Brand secondary, dark surfaces |
| `colorFondo` | `#FFFFFF` | Card and field surface |
| `colorFondoBajo` | `#E9F2F3` | Page background behind cards |
| `colorSuperficie` | `#E3ECED` | Subtle fills |
| `colorSuperficieAlta` | `#DDE7E8` | Hover on transparent surfaces |
| `colorTexto` | `#191C1D` | Primary text |
| `colorTextoSecundario` | `#3F4849` | Labels, inactive items, hints |
| `colorPrimarioContainer` | `#BEF3F8` | Icon badge background, active menu item |
| `colorOnPrimarioContainer` | `#002023` | Text on `colorPrimarioContainer` |
| `colorOutlineVariant` | `#BFC8C9` | Borders and dividers |
| `exito` | `#16A34A` | Paid, active, success |
| `error` | `#DC2626` | Failed, invalid, destructive |
| `advertencia` | `#F59E0B` | Pending, needs attention |
| `informacion` | `#2563EB` | Neutral notice |

## Rules

- **Semantics over decoration.** A `Pagada` badge is `exito`, a `Pendiente` badge is `advertencia`. Never a colour picked for looks.
- **Never colour alone.** Pair status colour with text or an icon, so the meaning survives colour blindness and greyscale printing.
- **Contrast.** Body text on `colorFondo` or `colorFondoBajo` passes AA. On a filled badge, compute it: `AppBadge` uses `color.computeLuminance() > 0.45 ? colorTexto : Colors.white`. Reuse that rule, don't eyeball it.
- **Borders, not shadows.** Surfaces are outlined with `colorOutlineVariant`, matching `AppCard` and `AppDataTable`. Don't introduce drop shadows to separate layers.
- **No raw hex in a page.** `Color(0xFF...)` belongs in `AppColors` only. Same for `Colors.deepPurple` and the Material palette — they're not this brand.
- **Buttons.** `ButtonThemes.primary()` (filled `colorPrimario`) for the main action, `ButtonThemes.secondary()` (2px outlined `colorPrimario`) for everything else. One primary per screen; a row of five primaries has none.

## State layers

Use the tokens as-is:

- Default surface: `colorFondo`
- Page behind it: `colorFondoBajo`
- Hover on a transparent tap target: `colorSuperficieAlta`
- Selected item in `Sidebar` / `AppFilterTabs`: `colorPrimarioContainer` background with `colorPrimario` text

This is why `Sidebar` sets `hoverColor: Colors.transparent` when the item is active — the container already carries the signal. Follow that pattern rather than adding a second highlight.