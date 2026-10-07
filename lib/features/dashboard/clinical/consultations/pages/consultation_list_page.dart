import '../../shared/widget/clinical_data_view.dart';
import '../../patients/model/patients_section.dart';

import 'package:flutter/material.dart';

import '../model/consultations_section.dart';
import '../../shared/widget/clinical_list_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationListPage extends StatelessWidget {
  const ConsultationListPage({super.key});

  @override
  Widget build(BuildContext context) => ClinicalDataView(
    sections: [consultationsSection, patientsSection],
    builder: _buildLoaded,
  );

  Widget _buildLoaded(BuildContext context) => DashboardLayout(
    title: consultationsSection.title,
    child: ClinicalListContent(section: consultationsSection),
  );
}
