import 'package:flutter/material.dart';

import '../model/form_builder_models.dart';

import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class FieldPlacementInputs extends StatelessWidget {
  const FieldPlacementInputs({
    super.key,
    required this.groups,
    required this.parent,
    required this.requirement,
    required this.defaultRequired,
    required this.onParentChanged,
    required this.onRequirementChanged,
  });
  final List<ConsultationFormElement> groups;
  final String parent, requirement;
  final bool defaultRequired;
  final ValueChanged<String> onParentChanged, onRequirementChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      AppSelect(
        name: 'Sección',
        value: parent,
        options: [
          const SelectOption(value: '', label: 'Sin sección'),
          for (final group in groups)
            SelectOption(value: group.id, label: group.label),
        ],
        onChanged: onParentChanged,
      ),
      const SizedBox(height: 16),
      AppSelect(
        name: 'Obligatoriedad en este formulario',
        value: requirement,
        options: [
          SelectOption(
            value: 'inherit',
            label: 'Heredar (${defaultRequired ? 'obligatorio' : 'opcional'})',
          ),
          const SelectOption(value: 'yes', label: 'Obligatorio'),
          const SelectOption(value: 'no', label: 'Opcional'),
        ],
        onChanged: onRequirementChanged,
      ),
    ],
  );
}
