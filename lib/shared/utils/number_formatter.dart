// Utilidades numéricas.

class NumberFormatter {
  static String toStringAsFixed(double value) => value.toStringAsFixed(2);
}

extension PriceExtension on num {
  String toPrice() => toStringAsFixed(2);
}
