import '../../shared/widget/clinical_data_view.dart';
import '../../patients/model/patients_section.dart';

import 'package:flutter/material.dart';

import '../model/consultations_section.dart';
import '../widget/consultation_patient_field.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFormPage extends StatelessWidget {
  const ConsultationFormPage({super.key, this.id});
  final String? id;

  @override
  Widget build(BuildContext context) => ClinicalDataView(
    sections: [consultationsSection, patientsSection],
    builder: _buildLoaded,
  );

  Widget _buildLoaded(BuildContext context) => DashboardLayout(
    title:
        "${id == null ? 'Crear' : 'Editar'} ${consultationsSection.singular}",
    child: ClinicalRecordContent(
      section: consultationsSection,
      id: id,
      fieldBuilder: (field, value, notifier) => field.key == 'patient_name'
          ? ConsultationPatientField(
              initialPatient: value,
              onChanged: (patient) {
                notifier.setValue(
                  'patient_name',
                  '${patient['first_name'] ?? ''} ${patient['last_name'] ?? ''}'
                      .trim(),
                );
                notifier.setValue('patient_id', patient['id'] ?? '');
              },
            )
          : null,
    ),
  );
}
