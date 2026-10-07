import 'package:flutter/material.dart';

import '../model/consultation_forms_section.dart';
import '../../shared/widget/clinical_list_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFormListPage extends StatelessWidget {
  const ConsultationFormListPage({super.key});

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: consultationFormsSection.title,
    child: ClinicalListContent(section: consultationFormsSection),
  );
}
