import 'package:flutter/material.dart';

import '../model/form_builder_models.dart';
import 'form_field_editor.dart';
import 'form_element_card.dart';
import 'form_element_preview.dart';

import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

class ConsultationFormBuilder extends StatefulWidget {
  const ConsultationFormBuilder({super.key, this.editing = false});
  final bool editing;

  @override
  State<ConsultationFormBuilder> createState() =>
      _ConsultationFormBuilderState();
}

class _ConsultationFormBuilderState extends State<ConsultationFormBuilder> {
  final _catalog = [...formFieldExamples];
  final Map<String, Map<String, String>> _documentTypes = {};
  final List<ConsultationFormElement> _elements = [];
  int _sequence = 0;
  bool _preview = false;

  @override
  void initState() {
    super.initState();
    if (widget.editing) {
      _elements.addAll([
        ConsultationFormElement(
          id: 'group-evaluation',
          type: 'GROUP',
          name: 'Evaluación',
        ),
        ConsultationFormElement(
          id: 'field-example',
          type: 'FIELD',
          field: formFieldExamples.first,
          parentId: 'group-evaluation',
        ),
      ]);
    }
  }

  Future<void> _editField({
    ConsultationFormElement? element,
    bool document = false,
  }) async {
    final result = await showDialog<ConsultationFormElement>(
      context: context,
      builder: (context) => FormFieldEditor(
        catalog: _catalog,
        documentOnly: document || element?.field?.fieldType == 'document',
        documentTypes: _documentTypes,
        groups: _elements.where((item) => item.type == 'GROUP').toList(),
        usedFieldIds: _elements
            .map((item) => item.field?.id)
            .whereType<String>()
            .toSet(),
        nextId: 'draft-${++_sequence}',
        element: element,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (result.documentTypeId != null && result.documentType != null) {
        _documentTypes[result.documentTypeId!] = result.documentType!;
      }
      if (result.field?.fieldType != 'document' &&
          !_catalog.any((field) => field.id == result.field?.id)) {
        _catalog.add(result.field!);
      }
      final index = _elements.indexWhere((item) => item.id == result.id);
      if (index < 0) {
        _elements.add(result);
      } else {
        _elements[index] = result;
      }
    });
  }

  Future<void> _editGroup([ConsultationFormElement? element]) async {
    var groupName = element?.name ?? '';
    final form = GlobalKey<FormState>();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(element == null ? 'Agregar sección' : 'Editar sección'),
        content: Form(
          key: form,
          child: AppInput(
            name: 'Nombre de la sección',
            initialValue: groupName,
            onChanged: (value) => groupName = value,
            required: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ButtonThemes.primary(),
            onPressed: () {
              if (form.currentState!.validate()) {
                Navigator.pop(context, groupName.trim());
              }
            },
            child: Text(element == null ? 'Agregar' : 'Aplicar sección'),
          ),
        ],
      ),
    );
    if (!mounted || name == null) return;
    setState(() {
      final group = ConsultationFormElement(
        id: element?.id ?? 'group-${++_sequence}',
        type: 'GROUP',
        name: name,
      );
      if (element == null) {
        _elements.add(group);
      } else {
        _elements[_elements.indexOf(element)] = group;
      }
    });
  }

  void _move(ConsultationFormElement element, int direction) {
    final siblings = _elements
        .where((item) => item.parentId == element.parentId)
        .toList();
    final target = siblings.indexOf(element) + direction;
    final from = _elements.indexOf(element),
        to = _elements.indexOf(siblings[target]);
    setState(() {
      _elements[from] = siblings[target];
      _elements[to] = element;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roots = _elements
        .where((element) => element.parentId == null)
        .toList();
    final ordered = [
      for (final root in roots) ...[
        root,
        ..._elements.where((element) => element.parentId == root.id),
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Estructura del formulario',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.colorTexto,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_elements.where((item) => item.type == 'FIELD').length} campos · '
          '${_elements.where((item) => item.type == 'GROUP').length} secciones',
        ),
        const SizedBox(height: 8),
        const Text(
          'Agrupa la información en secciones. Agrega campos o documentos y usa las flechas para ordenar.',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.colorTextoSecundario,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              style: ButtonThemes.primary(),
              onPressed: () => _editField(),
              icon: const Icon(Icons.add),
              label: const Text('Agregar campo'),
            ),
            OutlinedButton.icon(
              style: ButtonThemes.secondary(),
              onPressed: () => _editField(document: true),
              icon: const Icon(Icons.attach_file),
              label: const Text('Agregar documento'),
            ),
            OutlinedButton.icon(
              style: ButtonThemes.secondary(),
              onPressed: () => _editGroup(),
              icon: const Icon(Icons.folder_open),
              label: const Text('Agregar sección'),
            ),
            OutlinedButton.icon(
              style: ButtonThemes.secondary(),
              onPressed: () => setState(() => _preview = !_preview),
              icon: Icon(
                _preview ? Icons.edit_outlined : Icons.visibility_outlined,
              ),
              label: Text(_preview ? 'Volver al editor' : 'Vista previa'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (ordered.isEmpty)
          const AppEmptyState(
            icon: Icons.dynamic_form_outlined,
            message:
                'Agrega un campo existente o crea uno nuevo para comenzar.',
          ),
        for (final element in ordered)
          Padding(
            key: ValueKey(element.id),
            padding: EdgeInsets.only(
              left: element.parentId == null ? 0 : 16,
              bottom: 16,
            ),
            child: _preview
                ? FormElementPreview(element: element)
                : FormElementCard(
                    element: element,
                    position: ordered.indexOf(element) + 1,
                    onEdit: element.type == 'FIELD'
                        ? () => _editField(element: element)
                        : () => _editGroup(element),
                    onRemove:
                        _elements.any((child) => child.parentId == element.id)
                        ? null
                        : () => setState(() => _elements.remove(element)),
                    onUp:
                        _elements.firstWhere(
                              (item) => item.parentId == element.parentId,
                            ) ==
                            element
                        ? null
                        : () => _move(element, -1),
                    onDown:
                        _elements.lastWhere(
                              (item) => item.parentId == element.parentId,
                            ) ==
                            element
                        ? null
                        : () => _move(element, 1),
                  ),
          ),
      ],
    );
  }
}
