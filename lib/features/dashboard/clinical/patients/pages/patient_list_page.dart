import 'package:flutter/material.dart';

import '../model/patients_section.dart';
import '../../shared/widget/clinical_list_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class PatientListPage extends StatelessWidget {
  const PatientListPage({super.key});

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: patientsSection.title,
    child: ClinicalListContent(section: patientsSection, allowCreate: false),
  );
}
