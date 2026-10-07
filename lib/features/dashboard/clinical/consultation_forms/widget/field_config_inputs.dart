import 'package:flutter/material.dart';

import '../../document_types/widget/document_type_picker.dart';

import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

class FieldConfigInputs extends StatelessWidget {
  const FieldConfigInputs({
    super.key,
    required this.type,
    required this.placeholder,
    required this.unit,
    required this.minimum,
    required this.maximum,
    required this.options,
    this.documentTypeId,
    this.onDocumentTypeChanged,
    this.documentTypes = const {},
    this.selectedDocument,
  });
  final String type;
  final TextEditingController placeholder, unit, minimum, maximum, options;
  final String? documentTypeId;
  final Map<String, Map<String, String>> documentTypes;
  final Map<String, String>? selectedDocument;
  final void Function(String id, Map<String, String> document)?
  onDocumentTypeChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (type != 'document') ...[
        AppInput(name: 'Texto de ayuda', controller: placeholder),
        const SizedBox(height: 16),
      ],
      if (type == 'number') ...[
        AppInput(name: 'Unidad', controller: unit, hint: 'Ejemplo: kg'),
        const SizedBox(height: 16),
        AppInput(
          name: 'Valor mínimo',
          controller: minimum,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          validator: (value) =>
              value != null && value.isNotEmpty && num.tryParse(value) == null
              ? 'Ingresa un número válido.'
              : null,
        ),
        const SizedBox(height: 16),
        AppInput(
          name: 'Valor máximo',
          controller: maximum,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return null;
            final max = num.tryParse(value);
            final min = num.tryParse(minimum.text);
            if (max == null) return 'Ingresa un número válido.';
            return min != null && max < min
                ? 'El máximo debe ser mayor o igual al mínimo.'
                : null;
          },
        ),
        const SizedBox(height: 16),
      ],
      if (type == 'select' || type == 'radio') ...[
        AppInput(
          name: 'Opciones (una por línea)',
          controller: options,
          maxLines: 4,
          required: true,
        ),
        const SizedBox(height: 16),
      ],
      if (type == 'document' && onDocumentTypeChanged != null)
        DocumentTypePicker(
          documents: documentTypes,
          value: documentTypeId,
          selectedDocument: selectedDocument,
          onChanged: onDocumentTypeChanged!,
        ),
    ],
  );
}
