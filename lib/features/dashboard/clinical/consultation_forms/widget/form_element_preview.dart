import 'package:flutter/material.dart';

import '../model/form_builder_models.dart';
import 'field_choice_preview.dart';

import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class FormElementPreview extends StatelessWidget {
  const FormElementPreview({
    super.key,
    required this.element,
    this.documentTypes = const {},
  });
  final ConsultationFormElement element;
  final Map<String, Map<String, String>> documentTypes;

  @override
  Widget build(BuildContext context) {
    final config = element.effectiveConfig;
    final field = element.field;
    if (field == null) {
      return Text(element.label, style: Theme.of(context).textTheme.titleLarge);
    }
    final options = (config['options'] as List?)?.cast<String>() ?? [];
    if (field.fieldType == 'document') {
      final document =
          element.documentType ?? documentTypes[element.documentTypeId];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${field.label}${element.isRequired ? ' *' : ''}'),
          const SizedBox(height: 8),
          Text(
            document == null
                ? 'Selecciona un tipo de documento en la configuración.'
                : '${document['name']} · ${document['max_size_mb']} MB por archivo',
          ),
          if (document != null)
            Text('Formatos: ${document['allowed_extensions']}'),
          const SizedBox(height: 8),
          const Text('Vista previa · Carga de archivos no disponible.'),
        ],
      );
    }
    if (field.fieldType == 'checkbox' || field.fieldType == 'radio') {
      return FieldChoicePreview(
        label: '${field.label}${element.isRequired ? ' *' : ''}',
        checkbox: field.fieldType == 'checkbox',
        options: options,
      );
    }
    if (field.fieldType == 'select') {
      return AppSelect(
        name: field.label,
        required: element.isRequired,
        value: '',
        options: [
          for (final option in options)
            SelectOption(value: option, label: option),
        ],
        onChanged: (_) {},
      );
    }
    return AppInput(
      name: field.label,
      required: element.isRequired,
      date: field.fieldType == 'date',
      maxLines: field.fieldType == 'textarea' ? 3 : 1,
      keyboardType: field.fieldType == 'number'
          ? TextInputType.number
          : TextInputType.text,
      hint: config['placeholder']?.toString(),
      helperText: field.fieldType == 'number'
          ? [
              if (config['unit'] != null) 'Unidad: ${config['unit']}',
              if (config['min'] != null) 'Mínimo: ${config['min']}',
              if (config['max'] != null) 'Máximo: ${config['max']}',
            ].join(' · ')
          : null,
    );
  }
}
