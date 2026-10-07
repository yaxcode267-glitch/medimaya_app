import 'package:medimaya_app/shared/ui/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'extension_groups_field.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

class DocumentTypeCreateDialog extends StatefulWidget {
  const DocumentTypeCreateDialog({super.key});

  @override
  State<DocumentTypeCreateDialog> createState() =>
      _DocumentTypeCreateDialogState();
}

class _DocumentTypeCreateDialogState extends State<DocumentTypeCreateDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _size = TextEditingController(text: '10');

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    contentTextStyle: AppTextStyles.dialog,
    title: const Text('Crear tipo de documento'),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Se agregará al formulario de ejemplo. No se guarda en la API.',
              ),
              const SizedBox(height: 16),
              AppInput(
                name: 'Nombre del tipo de documento',
                controller: _name,
                required: true,
                validator: (value) => (value?.trim().length ?? 0) > 150
                    ? 'Máximo 150 caracteres.'
                    : null,
              ),
              const SizedBox(height: 16),
              AppInput(
                name: 'Descripción',
                controller: _description,
                maxLines: 2,
                validator: (value) => (value?.length ?? 0) > 500
                    ? 'Máximo 500 caracteres.'
                    : null,
              ),
              const SizedBox(height: 16),
              AppInput(
                name: 'Tamaño máximo (MB)',
                controller: _size,
                required: true,
                keyboardType: TextInputType.number,
                validator: (value) => (int.tryParse(value ?? '') ?? 0) <= 0
                    ? 'Ingresa un número entero mayor que cero.'
                    : null,
              ),
              const SizedBox(height: 24),
              FormField<Set<String>>(
                initialValue: const {},
                validator: (value) => value == null || value.isEmpty
                    ? 'Selecciona al menos una extensión.'
                    : null,
                onSaved: (value) => Navigator.pop(context, <String, String>{
                  'Nombre': _name.text.trim(),
                  'Descripción': _description.text.trim(),
                  'Tamaño máximo (MB)': _size.text.trim(),
                  'Extensiones permitidas': value!.join(', '),
                  'Disponibilidad': 'Activo',
                }),
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExtensionGroupsField(onChanged: field.didChange),
                    if (field.errorText case final error?)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          error,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                  ],
                ),
              ),
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
        onPressed: () {
          if (_form.currentState!.validate()) _form.currentState!.save();
        },
        child: const Text('Crear y asignar'),
      ),
    ],
  );
}
