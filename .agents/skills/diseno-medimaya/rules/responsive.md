# Responsive

## Breakpoints

`Responsive` (`lib/shared/ui/themes/responsive.dart`) is the single source:

| Breakpoint | Range | Layout |
| --- | --- | --- |
| Mobile | `< 600` | `Drawer`, una columna, `AppFilterTabs` compacto |
| Tablet | `600–1024` | Contenido centrado, dos columnas donde caben |
| Desktop | `>= 1024` | Sidebar fija de 280px, contenido hasta 1200px |

## Two tools, two levels

- **Inside a widget** — `LayoutBuilder`, reading `box.maxWidth`. The width you need is the widget's own box, not the screen's.
- **At screen level** — `Responsive.isMobile/isTablet/isDesktop(context)`, reading `MediaQuery`. For deciding shell-level things: sidebar vs drawer, column count for the page.

Don't use `MediaQuery` inside a leaf widget. Don't use `LayoutBuilder` to decide whether the whole page is desktop.

## The established patterns

**Two-column form row** (`ProfilePage`):

```dart
LayoutBuilder(
  builder: (context, box) {
    final a = AppInput(name: 'Nombres', controller: _a, required: true);
    final b = AppInput(name: 'Apellidos', controller: _b, required: true);

    if (box.maxWidth >= 560) {
      return Row(
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [a, const SizedBox(height: 12), b],
    );
  },
)
```

**Actions row** (`FormActions`): `Row` with `Expanded` at `>= 420`, `Column` with `stretch` below.

**Filter tabs** (`AppFilterTabs`): measures `box.maxWidth / options.length < 96` to compact padding and font so labels don't truncate.

**Sidebar**: `Sidebar.widthFor(context)` returns `min(280, width * 0.85)` so the menu never swallows the screen on a phone.

## Rules

- **A page must work at 360px wide** with no horizontal scroll. Check it.
- `Row` and `Column` need a cross-axis constraint: use `Expanded`, `Flexible`, or `crossAxisAlignment: CrossAxisAlignment.stretch`. An unbounded `Row` inside a `ScrollView` is the classic `RenderFlex overflowed` cause.
- **`crossAxisAlignment: CrossAxisAlignment.stretch` when stacking form fields**, so inputs fill the width instead of hugging their intrinsic size.
- Content is capped at 1200px and centred — `DashboardLayout` does this. Don't add another `ConstrainedBox` inside a page.
- Long text: `Flexible` + `maxLines: 1` + `TextOverflow.ellipsis`. Flexible text in a `Row`; a plain `Text` in a `Row` overflows.
- Touch targets ≥ 44px, including icon buttons.
- Bottom safe area: when a `FAB` overlaps content, `DashboardLayout` reserves `fabReserve = 88` in the padding. Don't add a second manual offset.

## Per-platform

`DashboardLayout` handles the shell per platform: `Drawer` on mobile and tablet, fixed sidebar on desktop, `MediaQuery.viewPaddingOf(context).bottom` applied to the FAB. Use `Sidebar.widthFor(context)` if you build a `Drawer` yourself. Don't re-derive these per page.