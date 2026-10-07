import 'package:flutter/material.dart';

import '../model/clinical_section.dart';

import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class ClinicalFields extends StatelessWidget {
  const ClinicalFields({
    super.key,
    required this.fields,
    required this.values,
    required this.readOnly,
    this.fieldBuilder,
  });
  final List<ClinicalField> fields;
  final Map<String, String> values;
  final bool readOnly;
  final Widget? Function(ClinicalField field, String? value)? fieldBuilder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final columns = box.maxWidth >= 600 ? 2 : 1;
      final width = (box.maxWidth - (columns - 1) * 16) / columns;
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          for (final field in fields)
            SizedBox(
              width: field.multiline ? box.maxWidth : width,
              child:
                  fieldBuilder?.call(field, values[field.label]) ??
                  (field.options.isNotEmpty
                      ? AppSelect(
                          name: field.label,
                          required: field.required,
                          options: [
                            for (final option in field.options)
                              SelectOption(value: option, label: option),
                          ],
                          value: values[field.label] ?? '',
                          enabled: !readOnly,
                          onChanged: (_) {},
                        )
                      : AppInput(
                          name: field.label,
                          required: field.required,
                          initialValue: values[field.label],
                          readOnly: readOnly,
                          date: field.date && !readOnly,
                          maxLines: field.multiline ? 3 : 1,
                        )),
            ),
        ],
      );
    },
  );
}
