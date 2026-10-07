import 'package:flutter/material.dart';

import '../model/consultations_section.dart';
import '../widget/consultation_patient_field.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFormPage extends StatelessWidget {
  const ConsultationFormPage({super.key, this.id});
  final String? id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title:
        "${id == null ? 'Crear' : 'Editar'} ${consultationsSection.singular}",
    child: ClinicalRecordContent(
      section: consultationsSection,
      id: id,
      fieldBuilder: (field, value) => field.label == 'Paciente'
          ? ConsultationPatientField(initialPatient: value)
          : null,
    ),
  );
}
