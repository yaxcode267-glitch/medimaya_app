import 'package:flutter/material.dart';

import 'document_type_create_dialog.dart';
import 'document_type_details.dart';

import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class DocumentTypePicker extends StatefulWidget {
  const DocumentTypePicker({
    super.key,
    required this.documents,
    required this.value,
    required this.onChanged,
    this.selectedDocument,
  });
  final Map<String, Map<String, String>> documents;
  final String? value;
  final Map<String, String>? selectedDocument;
  final void Function(String id, Map<String, String> document) onChanged;

  @override
  State<DocumentTypePicker> createState() => _DocumentTypePickerState();
}

class _DocumentTypePickerState extends State<DocumentTypePicker> {
  final Map<String, Map<String, String>> _created = {};

  Future<void> _create() async {
    final document = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const DocumentTypeCreateDialog(),
    );
    if (!mounted || document == null) return;
    final id = 'document-draft-${DateTime.now().microsecondsSinceEpoch}';
    setState(() => _created[id] = document);
    widget.onChanged(id, document);
  }

  @override
  Widget build(BuildContext context) {
    final documents = {
      ...widget.documents,
      ..._created,
      if (widget.value != null && widget.selectedDocument != null)
        widget.value!: widget.selectedDocument!,
    };
    final selected = documents[widget.value];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelect(
          key: ValueKey(widget.value),
          name: 'Tipo de documento',
          required: true,
          value: widget.value ?? '',
          options: [
            for (final entry in documents.entries)
              if (entry.value['active'] == 'Activo' ||
                  widget.value == entry.key)
                SelectOption(
                  value: entry.key,
                  label: entry.value['name'] ?? '',
                ),
          ],
          onChanged: (id) => widget.onChanged(id, documents[id]!),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            style: ButtonThemes.secondary(),
            onPressed: _create,
            icon: const Icon(Icons.add),
            label: const Text('Crear tipo de documento'),
          ),
        ),
        if (selected != null) ...[
          const SizedBox(height: 16),
          DocumentTypeDetails(document: selected),
        ],
      ],
    );
  }
}
