import '../../shared/store/field_config_controller.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/consultation_fields_section.dart';
import '../../consultation_forms/model/form_builder_models.dart';
import '../../consultation_forms/widget/field_config_inputs.dart';
import '../../consultation_forms/widget/form_element_preview.dart';
import '../../shared/widget/clinical_notice.dart';

import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
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
  final _config = FieldConfigController();
  String _type = 'text', _active = 'Activo', _required = 'No';
  ConsultationFormElement? _preview;

  @override
  void initState() {
    super.initState();
    _label.text = widget.example['label'] ?? '';
    _type =
        consultationFieldTypes.entries
            .where((entry) => entry.value == widget.example['field_type'])
            .firstOrNull
            ?.key ??
        'text';
    _active = widget.example['active'] ?? 'Activo';
    _required = widget.example['required'] ?? 'No';
    _config.load(widget.config);
    for (final controller in [
      _label,
      _config.placeholder,
      _config.unit,
      _config.minimum,
      _config.maximum,
      _config.options,
    ]) {
      controller.addListener(_invalidatePreview);
    }
  }

  void _invalidatePreview() {
    if (_preview != null) setState(() => _preview = null);
  }

  @override
  void dispose() {
    _label.dispose();
    _config.dispose();
    super.dispose();
  }

  void _showPreview() {
    if (!_form.currentState!.validate()) return;
    _config.type = _type;
    final config = _config.toConfig();
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
        Column(
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
        const SizedBox(height: 24),
        Column(
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
              placeholder: _config.placeholder,
              unit: _config.unit,
              minimum: _config.minimum,
              maximum: _config.maximum,
              options: _config.options,
            ),
          ],
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
          Column(
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
