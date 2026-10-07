import 'package:flutter/material.dart';

class FieldConfigController extends ChangeNotifier {
  final placeholder = TextEditingController();
  final unit = TextEditingController();
  final minimum = TextEditingController();
  final maximum = TextEditingController();
  final options = TextEditingController();
  String type = 'text';

  FieldConfigController() {
    for (final controller in controllers) {
      controller.addListener(notifyListeners);
    }
  }

  List<TextEditingController> get controllers => [
    placeholder,
    unit,
    minimum,
    maximum,
    options,
  ];

  void load(Map<String, Object?> config) {
    placeholder.text = config['placeholder']?.toString() ?? '';
    unit.text = config['unit']?.toString() ?? '';
    minimum.text = config['min']?.toString() ?? '';
    maximum.text = config['max']?.toString() ?? '';
    options.text = (config['options'] as List?)?.join('\n') ?? '';
  }

  Map<String, Object?> toConfig() => {
    if (type != 'document') 'placeholder': placeholder.text.trim(),
    if (type == 'number') ...{
      'unit': unit.text.trim(),
      'min': num.tryParse(minimum.text),
      'max': num.tryParse(maximum.text),
    },
    if (type == 'select' || type == 'radio')
      'options': options.text
          .split('\n')
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(),
  };

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
