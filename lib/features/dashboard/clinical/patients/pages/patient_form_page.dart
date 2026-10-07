import 'package:flutter/material.dart';

import '../model/patients_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

class PatientFormPage extends StatelessWidget {
  const PatientFormPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: "Editar ${patientsSection.singular}",
    child: ClinicalRecordContent(
      section: patientsSection,
      id: id,
      fieldBuilder: (field, value) => field.label == 'ID'
          ? AppInput(name: 'ID', initialValue: value, readOnly: true)
          : null,
    ),
  );
}
