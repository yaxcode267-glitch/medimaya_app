import 'package:flutter/material.dart';

import '../model/consultation_forms_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFormShowPage extends StatelessWidget {
  const ConsultationFormShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: 'Detalle de ${consultationFormsSection.singular}',
    child: ClinicalRecordContent(
      section: consultationFormsSection,
      id: id,
      readOnly: true,
    ),
  );
}
