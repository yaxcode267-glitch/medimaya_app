import '../store/clinical_form_notifier.dart';

import 'package:flutter/material.dart';

import '../model/clinical_section.dart';

import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class ClinicalFields extends StatefulWidget {
  const ClinicalFields({
    super.key,
    required this.fields,
    required this.values,
    required this.readOnly,
    this.fieldBuilder,
    this.notifier,
  });
  final ClinicalFormNotifier? notifier;
  final List<ClinicalField> fields;
  final Map<String, String> values;
  final bool readOnly;
  final Widget? Function(
    ClinicalField field,
    String? value,
    ClinicalFormNotifier notifier,
  )?
  fieldBuilder;

  @override
  State<ClinicalFields> createState() => _ClinicalFieldsState();
}

class _ClinicalFieldsState extends State<ClinicalFields> {
  late ClinicalFormNotifier _notifier;
  @override
  void initState() {
    super.initState();
    _notifier = widget.notifier ?? ClinicalFormNotifier(widget.values);
  }

  @override
  void dispose() {
    if (widget.notifier == null) _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _notifier,
    builder: (context, _) => LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth >= 600 ? 2 : 1;
        final width = (box.maxWidth - (columns - 1) * 16) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final field in widget.fields)
              SizedBox(
                width: field.multiline ? box.maxWidth : width,
                child:
                    widget.fieldBuilder?.call(
                      field,
                      _notifier.values[field.key],
                      _notifier,
                    ) ??
                    (field.options.isNotEmpty
                        ? AppSelect(
                            name: field.label,
                            required: field.required,
                            options: [
                              for (final option in field.options)
                                SelectOption(value: option, label: option),
                            ],
                            value: _notifier.values[field.key] ?? '',
                            enabled: !widget.readOnly,
                            onChanged: (value) =>
                                _notifier.setValue(field.key, value),
                          )
                        : AppInput(
                            name: field.label,
                            required: field.required,
                            initialValue: _notifier.values[field.key],
                            onChanged: (value) =>
                                _notifier.setValue(field.key, value),
                            readOnly: widget.readOnly,
                            date: field.date && !widget.readOnly,
                            maxLines: field.multiline ? 3 : 1,
                          )),
              ),
          ],
        );
      },
    ),
  );
}
