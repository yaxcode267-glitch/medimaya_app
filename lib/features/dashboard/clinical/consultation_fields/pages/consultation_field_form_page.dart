import 'package:flutter/material.dart';

import '../model/consultation_fields_section.dart';
import '../widget/consultation_field_editor.dart';

import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFieldFormPage extends StatelessWidget {
  const ConsultationFieldFormPage({super.key, this.id});
  final String? id;

  @override
  Widget build(BuildContext context) {
    final index = consultationFieldsSection.indexOfId(id ?? '');
    return DashboardLayout(
      title: '${id == null ? 'Crear' : 'Editar'} campo de consulta',
      child: id != null && index < 0
          ? const Center(
              child: AppEmptyState(message: 'Este campo de ejemplo no existe.'),
            )
          : ConsultationFieldEditor(
              key: ValueKey(id),
              example: index < 0
                  ? const {}
                  : consultationFieldsSection.examples[index],
              config: consultationFieldExampleConfigs[id] ?? const {},
            ),
    );
  }
}
