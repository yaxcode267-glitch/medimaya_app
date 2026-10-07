import 'package:flutter_test/flutter_test.dart';
import 'package:medimaya_app/features/dashboard/clinical/consultation_forms/model/field_config_override.dart';

void main() {
  test(
    'ignores empty, null and deeply equal values without mutating defaults',
    () {
      final defaults = <String, Object?>{
        'min': 0,
        'unit': 'kg',
        'options': ['A', 'B'],
      };
      final config = <String, Object?>{
        'min': 0,
        'max': null,
        'unit': '',
        'options': ['A', 'B'],
      };
      expect(fieldConfigOverride(config, defaults), isEmpty);
      expect(defaults['unit'], 'kg');
      expect(config.containsKey('max'), isTrue);
    },
  );
  test(
    'retains differences including zero, false and changed option order',
    () {
      expect(
        fieldConfigOverride(
          {
            'min': 0,
            'enabled': false,
            'options': ['B', 'A'],
          },
          {
            'min': 1,
            'enabled': true,
            'options': ['A', 'B'],
          },
        ),
        {
          'min': 0,
          'enabled': false,
          'options': ['B', 'A'],
        },
      );
    },
  );
  test('an unchanged override inherits future catalog updates', () {
    final override = fieldConfigOverride(
      {'unit': 'kg', 'max': 100},
      {'unit': 'kg', 'max': 100},
    );
    expect(
      {
        ...{'unit': 'g', 'max': 200},
        ...override,
      },
      {'unit': 'g', 'max': 200},
    );
  });
}
