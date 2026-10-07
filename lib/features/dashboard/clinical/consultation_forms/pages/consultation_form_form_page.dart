import 'package:flutter/material.dart';

import '../model/consultation_forms_section.dart';
import '../widget/consultation_form_builder.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFormFormPage extends StatelessWidget {
  const ConsultationFormFormPage({super.key, this.id});
  final String? id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title:
        "${id == null ? 'Crear' : 'Editar'} ${consultationFormsSection.singular}",
    child: ClinicalRecordContent(
      section: consultationFormsSection,
      id: id,
      structure: ConsultationFormBuilder(
        key: ValueKey(id),
        editing: id != null,
      ),
    ),
  );
}
