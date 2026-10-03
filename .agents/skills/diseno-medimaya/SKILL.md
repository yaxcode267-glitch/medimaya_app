---
name: diseno-medimaya
description: Use when creating or changing any UI in medimaya_app - widgets, pages, forms, tables, colors, spacing, theming, responsive layout, Material 3. Triggers: Flutter UI, pantalla, page, widget, botón, formulario, tabla, estilo, color, spacing, responsive, mobile, tablet, desktop, dark mode, MaterialApp, theme, AppColors, AppCard, AppInput, AppDataTable.
---

# Diseño en medimaya_app

App clínica/medical (MediMaya). Todo el texto de cara al usuario está en **español**.
El diseño es el producto: esta skill define cómo se ve y se siente cada pantalla.

## Sistema de diseño existente — úsalo, no lo re-inventes

Todo ya vive en `lib/shared/ui/`:

| Necesito | Usar |
|---|---|
| Color | `AppColors.*` de `lib/shared/ui/themes/app_colors.dart` |
| Botón primario / secundario | `ButtonThemes.primary()` / `ButtonThemes.secondary()` |
| Superficie de contenido | `AppCard` |
| Estado vacío | `AppEmptyState` |
| Etiqueta / estado | `AppBadge` |
| Tabla de datos | `AppDataTable` + `TableColumn` |
| Filtros por pestañas | `AppFilterTabs` + `FilterOption` |
| Campo de texto | `AppInput` (+ `appFieldDecoration` para dropdowns) |
| Fila Guardar / Cancelar | `FormActions` |
| Confirmación modal | `AppConfirm.show` (`ConfirmTone`) |
| Aviso / toast | `AppAlert` |
| Tarjeta informativa | `InfoCard` |
| Sidebar del dashboard | `DashboardLayout(title:, child:, fab:)` |
| Layout de auth | `AuthLayout` |
| Breakpoints | `Responsive.isMobile/isTablet/isDesktop/value` |

**Nunca** escribas `Color(0xFF...)`, `BorderRadius.circular(...)` de un botón o un
`TextField` pelado en una página. Si falta un componente, créalo en
`lib/shared/ui/widget/` con prefijo `App` y reutilízalo en el resto de la app.

## Paleta

`AppColors` es la única fuente de color. Semántica, no decoración:

- Marca: `colorPrimario` `#0B8793`, `colorSecundario` `#0D2B2E`
- Superficies: `colorFondo` (superficie), `colorFondoBajo` (fondo de página), `colorSuperficie`, `colorSuperficieAlta` (hover)
- Texto: `colorTexto`, `colorTextoSecundario`
- Estado: `exito`, `error`, `advertencia`, `informacion`

Reglas:
- Un color nuevo significa cambiar `AppColors`, no hardcodearlo en un widget.
- Estados semánticos usan los tokens de estado. Un badge de "Pagada" es `exito`, no verde cualquiera.
- Sobre texto: blanco o `colorTexto` según `computeLuminance()` (patrón ya usado en `AppBadge`).
- No uses rojo/verde/ámbar solo para decorAR; comunican estado.

## Espaciado y forma

Escala de espaciado: **4, 8, 12, 16, 20, 24, 32**. Nunca un número suelto.

- Radio de tarjeta/input/botón: **12–16**; badge/píldora: `999`.
- Altura mínima de botón: **44** (objetivo táctil). Icono dentro de botón: `size: 18–22`.
- Padding estándar de `AppCard`: `EdgeInsets.all(20)`.
- Filas de formulario: `SizedBox(height: 16)` entre campos, `24` antes de `FormActions`.
- Densidad de tabla: `headingRowHeight`/`dataRowHeight: 56`, `columnSpacing: 32`.
- Tipografía: cuerpo `14–16`, etiquetas/badges `11–13`, títulos `19–20`. `FontWeight.w600/w700` para jerarquía; `w500` para texto normal.

## Responsive — obligatorio

Breakpoints (`Responsive`): mobile `< 600`, tablet `600–1024`, desktop `>= 1024`.

- Dentro de un widget usa `LayoutBuilder` + `box.maxWidth` (ver `FormActions`, `filter_tabs.dart`).
- A nivel de pantalla usa `Responsive.isDesktop(context)`.
- Desktop muestra sidebar fija; móvil, `Drawer`. Eso lo resuelve `DashboardLayout`, no lo reimplementes.
- Patrón dos-columnas: `Row` con `Expanded` sobre `>= 560`, si no `Column` con `crossAxisAlignment: stretch` (ver `ProfilePage`).
- El contenido se limita a `maxWidth: 1200` y se centra.
- Áreas táctiles ≥ 44px. Etiqueta larga → `Flexible` + `TextOverflow.ellipsis`, nunca recorte duro.
- Toda vista debe funcionar a 360px de ancho sin scroll horizontal.

## Estados obligatorios

Cada lista, formulario y fetch cubre cuatro casos, siempre:

1. **Cargando** — `CircularProgressIndicator` centrado, nunca pantalla en blanco.
2. **Vacío** — `AppEmptyState` con mensaje útil (no "sin datos"), y acción cuando aplica.
3. **Error** — mensaje legible vía `AppAlert`. Los errores los muestra `AlertInterceptor`; la UI solo añade contexto si falta.
4. **Éxito con datos**.

Accesibilidad: `tooltip` en todo `IconButton` sin etiqueta. `Semantics` cuando un container es pulsable sin texto. No transmits información solo por color.

## Checklist antes de entregar UI

- [ ] Reutilicé `AppColors` / `ButtonThemes` / widgets `App*`; cero colores y radios hardcodeados.
- [ ] Textos en español, sin placeholders English.
- [ ] Se ve bien a 360, 600 y 1280 de ancho.
- [ ] Estados de carga, vacío y error presentes.
- [ ] Target táctil ≥ 44, `tooltip` en iconos, contraste AA.
- [ ] Sin `print()` de depuración.
- [ ] `flutter analyze` limpio.