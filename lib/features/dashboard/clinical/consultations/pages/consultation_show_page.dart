import '../../shared/widget/clinical_data_view.dart';
import '../../patients/model/patients_section.dart';

import 'package:flutter/material.dart';

import '../model/consultations_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationShowPage extends StatelessWidget {
  const ConsultationShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) => ClinicalDataView(
    sections: [consultationsSection, patientsSection],
    builder: _buildLoaded,
  );

  Widget _buildLoaded(BuildContext context) => DashboardLayout(
    title: 'Detalle de ${consultationsSection.singular}',
    child: ClinicalRecordContent(
      section: consultationsSection,
      id: id,
      readOnly: true,
    ),
  );
}
