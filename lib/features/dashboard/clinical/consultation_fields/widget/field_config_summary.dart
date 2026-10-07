import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';

class FieldConfigSummary extends StatelessWidget {
  const FieldConfigSummary({super.key, required this.config});
  final Map<String, Object?> config;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuración predeterminada',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        if (config.isEmpty) const Text('Sin configuración adicional.'),
        for (final entry in config.entries)
          if (entry.value != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${switch (entry.key) {
                  'placeholder' => 'Texto de ayuda',
                  'unit' => 'Unidad',
                  'min' => 'Valor mínimo',
                  'max' => 'Valor máximo',
                  'options' => 'Opciones',
                  _ => entry.key,
                }}: ${entry.value is List ? (entry.value as List).join(', ') : entry.value}',
              ),
            ),
      ],
    ),
  );
}
