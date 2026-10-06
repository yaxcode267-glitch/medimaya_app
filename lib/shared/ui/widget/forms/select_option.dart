// Solo modelo simple, sin widgets.

/// Opción de un [AppSelect]. Un [value] vacío significa "sin elegir", que es
/// un estado válido en los desplegables donde el campo es opcional.
class SelectOption {
  final String value;
  final String label;

  const SelectOption({required this.value, required this.label});
}
