import '../../shared/widget/clinical_data_view.dart';

import 'package:flutter/material.dart';

import '../model/patients_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class PatientShowPage extends StatelessWidget {
  const PatientShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) =>
      ClinicalDataView(sections: [patientsSection], builder: _buildLoaded);

  Widget _buildLoaded(BuildContext context) => DashboardLayout(
    title: 'Detalle de ${patientsSection.singular}',
    child: ClinicalRecordContent(
      section: patientsSection,
      id: id,
      readOnly: true,
    ),
  );
}
