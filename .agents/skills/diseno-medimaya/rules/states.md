# Estados y accesibilidad

## Los cuatro estados

Toda lista, formulario y fetch cubre los cuatro. Una pantalla que solo maneja el camino feliz está incompleta.

### 1. Cargando

`CircularProgressIndicator` centrado. Nunca una pantalla en blanco, nunca contenido viejo sin marcar.

```dart
loading ? const Center(child: CircularProgressIndicator()) : contenido
```

`AppDataTable` y `AppEmptyState` ya lo hacen. `DashboardLayout` envuelve su `child` en `AnimatedBuilder(animation: profile)`, así que la página no necesita su propio spinner para el perfil.

### 2. Vacío

`AppEmptyState` con un mensaje que dice **qué hacer**, no solo que no hay datos:

```dart
AppEmptyState(
  message: 'Aún no hay pacientes registrados',
  icon: Icons.people_outline,
  action: ElevatedButton(...),   // "Registrar paciente"
)
```

Un vacío sin acción es una pantalla muerta. Si la pantalla tiene un `FAB` para crear, enlázalo.

### 3. Error

El error **no se maneja en la UI**. La cadena ya existe:

```
service → HttpClient.httpClient → SessionInterceptor → AlertInterceptor → AlertDialog
```

- `AlertInterceptor` muestra el mensaje al usuario. No lo re-llames, no re-lanza, no re-intentes.
- La UI solo añade contexto que el interceptor no puede saber («No se pudo cargar el catálogo»).
- Si necesitas un estado de error en pantalla además del diálogo, expón `String? error` en el store y límpialo al reintentar.

Nunca `catch (_) {}` en la UI. Un fallo silencioso cuesta horas de debug.

### 4. Con datos

El estado normal. Si la respuesta viene vacía pero es válida, es estado 2, no un error.

## Store: flags que toda pantalla necesita

```dart
bool loading = false;
bool loaded  = false;   // ya se intentó cargar, aunque fuera sin red
List<X> items = const [];
```

- `loading` para el spinner.
- `loaded` distingue «nunca cargado» de «cargado y vacío». Sin esto, la app redirige al login en bucle (`router.dart` comprueba `loaded`).
- Guarda en caché con `StorageClient` y sirve primero desde ahí: `_loadFromCache()` antes de `fetch()`, como en `ProfileController.load()`.

## Accesibilidad

- **`tooltip` en español en todo `IconButton` sin etiqueta visible.** Obligatorio, no opcional.
- **Never colour alone.** Estado = color + texto o icono. Un badge `exito` con «Pagada» funciona; un punto verde solo, no.
- **Contraste AA** en texto sobre cualquier fondo. `AppBadge` ya calcula el color de texto por `computeLuminance()`; aplica el mismo criterio en cualquier superficie nueva.
- **Target táctil ≥ 44px** con separación suficiente entre acciones vecinas.
- **`Semantics`** cuando un contenedor es pulsable pero no tiene texto visible. `InkWell` sobre un `Container` sin `Text` necesita la etiqueta explícita.
- **`autofillHints`** en email (`AutofillHints.email`), nombre, teléfono. En login mejora tanto la experiencia como la accesibilidad.
- **Etiquetas de formulario**: `AppInput` pone `name` como `labelText` y añade `*` si `required`. No dupliques el nombre como texto suelto.
- **`showDatePicker`** con `locale: const Locale('es')` — `AppInput(date: true)` ya lo hace.

## Feedback de acciones

- Éxito: `AppAlert` o `SnackBar` con mensaje en español. «Perfil actualizado», no «OK».
- Destructivo: `AppConfirm.show` con `ConfirmTone.warning` antes de borrar, como hace `_logout` en `DashboardLayout`.
- Disable: mientras una acción está en vuelo, el botón debe quedar deshabilitado. `AppDataTable` ya hace esto con su `reload`.