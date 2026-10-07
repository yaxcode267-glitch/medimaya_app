import 'package:flutter_test/flutter_test.dart';
import 'package:medimaya_app/features/dashboard/clinical/shared/store/field_config_controller.dart';

void main() {
  test('loads numeric config and excludes config of other field types', () {
    final controller = FieldConfigController()..type = 'number';
    addTearDown(controller.dispose);
    controller.load({
      'placeholder': 'Peso',
      'unit': 'kg',
      'min': 0,
      'max': 250,
    });
    expect(controller.toConfig(), {
      'placeholder': 'Peso',
      'unit': 'kg',
      'min': 0,
      'max': 250,
    });
    controller.type = 'select';
    controller.options.text = ' Sí\nNo\nSí\n ';
    expect(controller.toConfig(), {
      'placeholder': 'Peso',
      'options': ['Sí', 'No'],
    });
    controller.load({});
    expect(controller.unit.text, isEmpty);
    expect(controller.options.text, isEmpty);
  });
}
