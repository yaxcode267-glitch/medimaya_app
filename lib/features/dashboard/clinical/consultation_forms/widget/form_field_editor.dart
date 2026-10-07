import '../model/field_config_override.dart';

import 'package:medimaya_app/shared/ui/themes/app_text_styles.dart';

import '../../shared/store/field_config_controller.dart';

import 'package:flutter/material.dart';

import '../model/form_builder_models.dart';
import 'field_config_inputs.dart';
import 'field_placement_inputs.dart';

import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class FormFieldEditor extends StatefulWidget {
  const FormFieldEditor({
    super.key,
    required this.catalog,
    required this.groups,
    required this.usedFieldIds,
    required this.nextId,
    this.element,
    this.documentOnly = false,
    this.documentTypes = const {},
  });
  final List<ConsultationFieldDefinition> catalog;
  final List<ConsultationFormElement> groups;
  final Set<String> usedFieldIds;
  final String nextId;
  final ConsultationFormElement? element;
  final bool documentOnly;
  final Map<String, Map<String, String>> documentTypes;

  @override
  State<FormFieldEditor> createState() => _FormFieldEditorState();
}

class _FormFieldEditorState extends State<FormFieldEditor> {
  final _form = GlobalKey<FormState>();
  final _label = TextEditingController();
  final _config = FieldConfigController();
  bool _create = false;
  bool _defaultRequired = false;
  String _type = 'text', _required = 'inherit', _parent = '';
  String? _fieldId, _documentTypeId;
  Map<String, String>? _documentType;

  @override
  void initState() {
    super.initState();
    _create = widget.documentOnly;
    if (widget.documentOnly) _type = 'document';
    final element = widget.element;
    if (element != null) {
      _fieldId = element.field?.id;
      _parent = element.parentId ?? '';
      _required = element.requiredOverride == null
          ? 'inherit'
          : element.requiredOverride!
          ? 'yes'
          : 'no';
      _documentTypeId = element.documentTypeId;
      _documentType = element.documentType;
      _loadField(element.field!, element.effectiveConfig);
    }
  }

  void _loadField(
    ConsultationFieldDefinition field,
    Map<String, Object?> config,
  ) {
    _type = field.fieldType;
    _label.text = field.label;
    _defaultRequired = field.required;
    _config.load(config);
  }

  @override
  void dispose() {
    _label.dispose();
    _config.dispose();
    super.dispose();
  }

  void _apply() {
    if (!_form.currentState!.validate()) return;
    _config.type = _type;
    final config = _config.toConfig();
    final field = _create
        ? ConsultationFieldDefinition(
            id: widget.element?.field?.id ?? 'field-${widget.nextId}',
            label: widget.documentOnly
                ? _documentType!['name']!
                : _label.text.trim(),
            fieldType: _type,
            required: _defaultRequired,
            config: config,
          )
        : widget.catalog.firstWhere((field) => field.id == _fieldId);
    Navigator.pop(
      context,
      ConsultationFormElement(
        id: widget.element?.id ?? widget.nextId,
        type: 'FIELD',
        field: field,
        parentId: _parent.isEmpty ? null : _parent,
        requiredOverride: _required == 'inherit' ? null : _required == 'yes',
        documentTypeId: _type == 'document' ? _documentTypeId : null,
        documentType: _type == 'document' ? _documentType : null,
        config: fieldConfigOverride(config, field.config),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    contentTextStyle: AppTextStyles.dialog,
    title: Text(
      widget.documentOnly
          ? (widget.element == null
                ? 'Agregar documento'
                : 'Configurar documento')
          : (widget.element == null ? 'Agregar campo' : 'Configurar campo'),
    ),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.element == null && !widget.documentOnly) ...[
                AppSelect(
                  name: 'Origen del campo',
                  value: _create ? 'new' : 'existing',
                  options: const [
                    SelectOption(value: 'existing', label: 'Asignar existente'),
                    SelectOption(value: 'new', label: 'Crear campo nuevo'),
                  ],
                  onChanged: (value) => setState(() {
                    _create = value == 'new';
                    _fieldId = null;
                    _loadField(
                      const ConsultationFieldDefinition(
                        id: '',
                        label: '',
                        fieldType: 'text',
                      ),
                      {},
                    );
                    _documentTypeId = null;
                    _documentType = null;
                  }),
                ),
                const SizedBox(height: 16),
              ],
              if (!_create)
                AppSelect(
                  name: 'Campo de consulta',
                  required: true,
                  enabled: widget.element == null,
                  value: _fieldId ?? '',
                  options: [
                    for (final field in widget.catalog)
                      if (!widget.usedFieldIds.contains(field.id) ||
                          widget.element?.field?.id == field.id)
                        SelectOption(value: field.id, label: field.label),
                  ],
                  emptyText: 'Selecciona un campo disponible',
                  onChanged: (value) => setState(() {
                    _fieldId = value;
                    final field = widget.catalog.firstWhere(
                      (field) => field.id == value,
                    );
                    _loadField(field, field.config);
                    _documentTypeId = null;
                    _documentType = null;
                  }),
                ),
              if (_create) ...[
                if (!widget.documentOnly) ...[
                  AppInput(
                    name: 'Nombre del campo',
                    controller: _label,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  AppSelect(
                    name: 'Tipo de campo',
                    value: _type,
                    options: [
                      for (final type in consultationFieldTypes.entries.where(
                        (type) => type.key != 'document',
                      ))
                        SelectOption(value: type.key, label: type.value),
                    ],
                    onChanged: (value) => setState(() => _type = value),
                  ),
                ],
                SwitchListTile(
                  title: const Text('Obligatorio por defecto'),
                  value: _defaultRequired,
                  onChanged: (value) =>
                      setState(() => _defaultRequired = value),
                ),
              ],
              if (_create || _fieldId != null) ...[
                const SizedBox(height: 16),
                FieldPlacementInputs(
                  groups: widget.groups,
                  parent: _parent,
                  requirement: _required,
                  defaultRequired: _defaultRequired,
                  onParentChanged: (value) => setState(() => _parent = value),
                  onRequirementChanged: (value) =>
                      setState(() => _required = value),
                ),
                const SizedBox(height: 16),
                FieldConfigInputs(
                  type: _type,
                  placeholder: _config.placeholder,
                  unit: _config.unit,
                  minimum: _config.minimum,
                  maximum: _config.maximum,
                  options: _config.options,
                  documentTypeId: _documentTypeId,
                  documentTypes: widget.documentTypes,
                  selectedDocument: _documentType,
                  onDocumentTypeChanged: (id, document) => setState(() {
                    _documentTypeId = id;
                    _documentType = document;
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    actions: [
      OutlinedButton(
        style: ButtonThemes.secondary(),
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(
        style: ButtonThemes.primary(),
        onPressed: _apply,
        child: const Text('Aplicar a la maqueta'),
      ),
    ],
  );
}
