# Componentes App\*

Everything in `lib/shared/ui/widget/` is the app's component library. Compose from it. Do not write a raw `Container` with a border and radius where one of these exists.

## Catálogo

| Componente | Archivo | Para qué |
| --- | --- | --- |
| `AppCard` | `common/app_card.dart` | Superficie de contenido: formularios, cabeceras, detalle. `icon:` opcional en 48×48 |
| `AppBadge` | `common/app_badge.dart` | Etiqueta de estado. Calcula el color del texto por luminancia |
| `AppEmptyState` | `common/app_empty_state.dart` | Estado vacío con icono circular y mensaje centrado. `action:` opcional |
| `AppDataTable` | `common/data_table.dart` | Tabla con scroll vertical y horizontal, estados y botón recargar |
| `TableColumn` | `common/data_table.dart` | Columna: `key`, `label`, `align` |
| `AppFilterTabs` | `common/filter_tabs.dart` | Filtros tipo pestaña. `FilterOption(value, label, icon)` |
| `AppAlert` | `common/app_alert.dart` | Aviso / toast de resultado |
| `AppConfirm` | `common/confirm_dialog.dart` | Confirmación modal. `ConfirmTone.warning` / destructive |
| `InfoCard` | `common/info_card.dart` | Tarjeta informativa |
| `AppInput` | `forms/input_form.dart` | Campo de texto: `password`, `date`, `readOnly`, `required`, `validator`, `controller` |
| `appFieldDecoration()` | `forms/input_form.dart` | Decoración compartida para `DropdownButton` y selects que no pueden usar `AppInput` |
| `FormActions` | `forms/form_actions.dart` | Fila Cancelar / Guardar, apila bajo 420px |

## Layouts

| Layout | Para qué |
| --- | --- |
| `DashboardLayout(title:, child:, fab:)` | Toda pantalla del dashboard. Sidebar fija en desktop, `Drawer` en móvil. Limita el contenido a 1200px y lo centra |
| `AuthLayout` | Login y registro |

No reimplementes la carcasa de una pantalla. `DashboardLayout` ya resuelve sidebar, `Drawer`, `SafeArea`, `TopBar` con botón atrás, `maxWidth` y el hueco del FAB.

## Usage rules

- **`AppInput` para todo campo de texto**, incluido email, contraseña y fecha. `date: true` abre `showDatePicker` con `Locale('es')` y escribe `YYYY-MM-DD`.
- **Validación con `FormBuilderValidators`**, componiendo en el `validator:` del `AppInput`. El `required` de `AppInput` ya emite «X es requerido».
- **`AppDataTable` recibe `List<Map<String, dynamic>>`.** Un `Widget` en una celda se renderiza tal cual; cualquier otro valor se muestra como texto, con `—` para nulos. Es el mecanismo para poner un `AppBadge` dentro de una celda.
- **Pasa `reload:` a `AppDataTable`** cuando haya fuente remota. El botón «Recargar» ya está incluido y se deshabilita mientras carga.
- **Estilos de botón siempre desde `ButtonThemes`.** No construyas `ButtonStyle` a mano en una página.
- **No copies un `App*Widget` a una página** para modificarlo. Cámbialo en `shared/ui/widget/`, donde beneficia a todas las pantallas.

## Crear uno nuevo

Solo cuando ningún componente existente encaje, y cuando la necesidad aparezca en **dos o más pantallas**. Un componente usado una sola vez se queda en la página como método privado (`_header()` en `ProfilePage`).

El nuevo widget va en:

- `lib/shared/ui/widget/common/` si es de presentación (card, badge, tabla, diálogo).
- `lib/shared/ui/widget/forms/` si manipula entrada del usuario.

Requisitos mínimos: prefijo `App`, `const` constructor con `super.key`, colores y radios de `AppColors`, y reutilización de `appFieldDecoration` si toca un campo.