# AGENTS.md — MediMaya

App clínica Flutter (MediMaya). Paquete `medimaya_app`, Material 3, Dart null safety.
Texto de usuario siempre en **español**.

## Skills — léelas antes de tocar código

Están en `.agents/skills/<nombre>/SKILL.md`. Aplícalas según la tarea:

| Skill | Cuándo |
|---|---|
| `anti-overengineering` | Antes de añadir una capa, un helper, un test o un try/catch; y al limpiar código existente (comentarios, wrappers, abstracciones de una sola implementación). |
| `diseno-medimaya` | Cualquier cambio de UI: widget, page, formulario, tabla, color, spacing, responsive, estados. |
| `dart-flutter-patterns` | Patrones Dart/Flutter: null safety, estado, async, widget architecture, GoRouter, Dio. |
| `flutter-dart-code-review` | Revisar código Dart/Flutter: checklist de idioms, widgets, performance, accesibilidad. |
| `codebase-design` | Decidir dónde va un módulo, si un seam es real, profundidad de interfaces. |
| `flutter-apply-architecture-best-practices` | Estructurar capas UI / Logic / Data. |
| `flutter-build-responsive-layout` | Layouts adaptativos con `LayoutBuilder`, `MediaQuery`, `Expanded/Flexible`. |
| `flutter-fix-layout-issues` | Overflows y constraints no acotados (`RenderFlex overflowed`). |
| `flutter-implement-json-serialization` | `fromJson` / `toJson` en DTOs. |
| `flutter-setup-declarative-routing` | `MaterialApp.router`, `go_router`, deep linking. |
| `flutter-add-widget-test` | Tests de widget con `WidgetTester`. |

Las skills de la comunidad (las que empiezan por `flutter-`, más
`dart-flutter-patterns`, `flutter-dart-code-review` y `codebase-design`) vienen de
`flutter/agent-plugins`, `affaan-m/ecc` y `mattpocock/skills`. Se actualizan con:

```bash
npx skills update
```

`anti-overengineering` es un symlink a `~/.agents/skills/anti-overengineering`;
por eso no se actualiza con `npx skills update`.

## Arquitectura

```
lib/
  features/<area>/<sub>/    model/ service/ store/ pages/ *routes.dart
  shared/
    api/                    config, const, error, interceptors, network
    ui/                     layouts/, themes/, widget/common, widget/forms
    utils/
  router/                   router.dart, const.dart
```

Una feature = `model` (DTOs puros) + `service` (HTTP) + `store` (ChangeNotifier
singleton) + `pages` (UI). Ejemplo de referencia: `lib/features/dashboard/profile/`.
No añadas una quinta capa.

## Comandos

```bash
flutter analyze     # debe salir limpio
flutter test        # debe pasar
dart format lib test
dart fix --apply    # fixes automáticos; revisar el diff
```

## Reglas que no se negocian

- **UI**: solo `AppColors`, `ButtonThemes` y widgets `App*` de `lib/shared/ui/`. Cero
  colores y radios hardcodeados en páginas.
- **Estados**: toda lista o formulario cubre cargando, vacío (`AppEmptyState`),
  error (`AppAlert`) y con datos.
- **Responsive**: `LayoutBuilder` dentro de widgets, `Responsive` a nivel pantalla.
  Funciona a 360 / 600 / 1280 px.
- **Capas**: sin interfaz de una sola implementación, sin factory, sin
  repositorio+usecase para un CRUD, sin paquete de estado nuevo. `ChangeNotifier`
  con singleton es el patrón.
- **Errores**: nada de `catch (_) {}` que traga. Los errores HTTP los maneja
  `AlertInterceptor`; la UI no re-lanza ni re-intenta.
- **Ciclo de vida**: todo controller/subscription se libera en `dispose()`.
- **Límites**: un archivo de más de ~250 líneas puras se divide por responsabilidad.
- **Git**: nada de sufijos `_v2`, `_final`, backups ni archivos comentados.

## Herramientas

Este archivo es la fuente de verdad y las skills viven solo en `.agents/skills/`.
No se duplican en `.claude/`, `.codex/`, `.cursor/` ni `.github/`.

| Herramienta | Cómo llega la skill |
|---|---|
| opencode | `opencode.json` registra `.agents/skills` como path de skills |
| Cualquier otra |Lee este `AGENTS.md` y abre `.agents/skills/<nombre>/SKILL.md` cuando aplique |

Si usas otra herramienta y quieres que descubra las skills automáticamente:

```bash
mkdir -p .claude && ln -s ../.agents/skills .claude/skills && ln -s AGENTS.md .claude/CLAUDE.md
```

Actualizar las skills de la comunidad: `npx skills update`.