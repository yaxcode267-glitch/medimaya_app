/// Utilidades globales de fechas (espejo de `fechas.ts` del frontend).
///
/// Aceptan un [DateTime] o un texto con fecha (lo que viene del backend).
/// Si el valor es nulo o no se puede interpretar:
///  - Los formateadores devuelven `'-'`.
///  - [toInputDate] devuelve `''`.
class DateUtils {
  static const _months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static const _monthsShort = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  static DateTime? _toDate(Object? input) {
    if (input == null) return null;
    if (input is DateTime) return input;
    return DateTime.tryParse(input.toString());
  }

  /// Convierte a [DateTime] un valor que puede venir `null` o como texto
  /// (ej: `"2026-09-16T14:30:00.000000Z"`). Devuelve `null` si no es fecha válida.
  static DateTime? tryParse(Object? input) => _toDate(input);

  static String _pad(int value) => value.toString().padLeft(2, '0');

  /// "16 septiembre 2026"
  static String formatDate(Object? input) {
    final date = _toDate(input);
    if (date == null) return '-';
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  /// Igual que [formatDate] pero con el día de dos dígitos: "01 septiembre 2026"
  static String formatFullDate(Object? input) {
    final date = _toDate(input);
    if (date == null) return '-';
    return '${_pad(date.day)} ${_months[date.month - 1]} ${date.year}';
  }

  /// "16/09/2026"
  static String formatShortDate(Object? input) {
    final date = _toDate(input);
    if (date == null) return '-';
    return '${_pad(date.day)}/${_pad(date.month)}/${date.year}';
  }

  /// "16 sep 2026"
  static String formatAbbreviatedDate(Object? input) {
    final date = _toDate(input);
    if (date == null) return '-';
    return '${date.day} ${_monthsShort[date.month - 1]} ${date.year}';
  }

  /// "14:30"
  static String formatTime(Object? input) {
    final date = _toDate(input);
    if (date == null) return '-';
    return '${_pad(date.hour)}:${_pad(date.minute)}';
  }

  /// "16 septiembre 2026, 14:30"
  static String formatDateTime(Object? input) {
    final date = _toDate(input);
    if (date == null) return '-';
    return '${formatDate(date)}, ${formatTime(date)}';
  }

  /// "2026-09-16" (formato para inputs de fecha `yyyy-MM-dd`)
  static String toInputDate(Object? input) {
    final date = _toDate(input);
    if (date == null) return '';
    return '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
  }

  /// Fecha de hoy en formato para inputs de fecha.
  static String todayInput() => toInputDate(DateTime.now());

  static bool isValidDate(Object? input) => _toDate(input) != null;
}
