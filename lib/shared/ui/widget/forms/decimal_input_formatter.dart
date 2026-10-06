import 'package:flutter/services.dart';

/// Formateador para decimal de hasta dos decimales, usado en el precio.
class DecimalInputFormatter extends TextInputFormatter {
  DecimalInputFormatter({this.decimalRange = 2});

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // El símbolo de coma no llega por teclado numérico, pero se protege por
    // si acaso (el backend espera punto/decimal). El formulario pide punto.
    if (text.isEmpty) return newValue;

    final regex = RegExp('^\\d+(\\.\\d{0,$decimalRange})?\$');

    if (regex.hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}
