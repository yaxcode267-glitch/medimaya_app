import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/consultation_fields_section.dart';
import '../../consultation_forms/model/form_builder_models.dart';
import '../../consultation_forms/widget/field_config_inputs.dart';
import '../../consultation_forms/widget/form_element_preview.dart';
import '../../shared/widget/clinical_notice.dart';

import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class ConsultationFieldEditor extends StatefulWidget {
  const ConsultationFieldEditor({
    super.key,
    this.example = const {},
    this.config = const {},
  });
  final Map<String, String> example;
  final Map<String, Object?> config;

  @override
  State<ConsultationFieldEditor> createState() =>
      _ConsultationFieldEditorState();
}

class _ConsultationFieldEditorState extends State<ConsultationFieldEditor> {
  final _form = GlobalKey<FormState>();
  final _label = TextEditingController();
  final _placeholder = TextEditingController();
  final _unit = TextEditingController();
  final _minimum = TextEditingController();
  final _maximum = TextEditingController();
  final _options = TextEditingController();
  String _type = 'text', _active = 'Activo', _required = 'No';
  ConsultationFormElement? _preview;

  @override
  void initState() {
    super.initState();
    _label.text = widget.example['Etiqueta'] ?? '';
    _type =
        consultationFieldTypes.entries
            .where((entry) => entry.value == widget.example['Tipo'])
            .firstOrNull
            ?.key ??
        'text';
    _active = widget.example['Disponibilidad'] ?? 'Activo';
    _required = widget.example['Obligatorio'] ?? 'No';
    _placeholder.text = widget.config['placeholder']?.toString() ?? '';
    _unit.text = widget.config['unit']?.toString() ?? '';
    _minimum.text = widget.config['min']?.toString() ?? '';
    _maximum.text = widget.config['max']?.toString() ?? '';
    _options.text = (widget.config['options'] as List?)?.join('\n') ?? '';
    for (final controller in [
      _label,
      _placeholder,
      _unit,
      _minimum,
      _maximum,
      _options,
    ]) {
      controller.addListener(_invalidatePreview);
    }
  }

  void _invalidatePreview() {
    if (_preview != null) setState(() => _preview = null);
  }

  @override
  void dispose() {
    for (final controller in [
      _label,
      _placeholder,
      _unit,
      _minimum,
      _maximum,
      _options,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showPreview() {
    if (!_form.currentState!.validate()) return;
    final config = <String, Object?>{
      'placeholder': _placeholder.text.trim(),
      if (_type == 'number') ...{
        'unit': _unit.text.trim(),
        'min': num.tryParse(_minimum.text),
        'max': num.tryParse(_maximum.text),
      },
      if (_type == 'select' || _type == 'radio')
        'options': _options.text
            .split('\n')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList(),
    };
    setState(
      () => _preview = ConsultationFormElement(
        id: 'preview',
        type: 'FIELD',
        field: ConsultationFieldDefinition(
          id: 'preview-field',
          label: _label.text.trim(),
          fieldType: _type,
          required: _required == 'Sí',
          config: config,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: ListView(
      children: [
        const ClinicalNotice(),
        const SizedBox(height: 24),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Datos del campo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              AppInput(
                name: 'Etiqueta',
                controller: _label,
                required: true,
                validator: (value) => (value?.trim().length ?? 0) > 200
                    ? 'Máximo 200 caracteres.'
                    : null,
              ),
              const SizedBox(height: 16),
              AppSelect(
                name: 'Tipo',
                value: _type,
                options: [
                  for (final entry in consultationFieldTypes.entries.where(
                    (entry) => entry.key != 'document',
                  ))
                    SelectOption(value: entry.key, label: entry.value),
                ],
                onChanged: (value) => setState(() {
                  _type = value;
                  _preview = null;
                }),
              ),
              const SizedBox(height: 16),
              AppSelect(
                name: 'Obligatorio',
                value: _required,
                options: const [
                  SelectOption(value: 'Sí', label: 'Sí'),
                  SelectOption(value: 'No', label: 'No'),
                ],
                onChanged: (value) => setState(() {
                  _required = value;
                  _preview = null;
                }),
              ),
              const SizedBox(height: 16),
              AppSelect(
                name: 'Disponibilidad',
                value: _active,
                options: const [
                  SelectOption(value: 'Activo', label: 'Activo'),
                  SelectOption(value: 'Inactivo', label: 'Inactivo'),
                ],
                onChanged: (value) => setState(() {
                  _active = value;
                  _preview = null;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Valores predeterminados del campo. Cada formulario puede personalizarlos.',
              ),
              const SizedBox(height: 16),
              FieldConfigInputs(
                type: _type,
                placeholder: _placeholder,
                unit: _unit,
                minimum: _minimum,
                maximum: _maximum,
                options: _options,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              style: ButtonThemes.primary(),
              onPressed: _showPreview,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Probar configuración'),
            ),
            OutlinedButton(
              style: ButtonThemes.secondary(),
              onPressed: () => context.go(consultationFieldsSection.path),
              child: const Text('Volver al listado'),
            ),
          ],
        ),
        if (_preview case final element?) ...[
          const SizedBox(height: 24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vista previa del campo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                FormElementPreview(key: ObjectKey(element), element: element),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          style: ButtonThemes.primary(),
          onPressed: null,
          child: const Text('Guardar (próximamente)'),
        ),
      ],
    ),
  );
}
