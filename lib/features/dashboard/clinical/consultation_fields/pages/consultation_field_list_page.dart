import 'package:flutter/material.dart';

import '../model/consultation_fields_section.dart';
import '../../shared/widget/clinical_list_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFieldListPage extends StatelessWidget {
  const ConsultationFieldListPage({super.key});

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: consultationFieldsSection.title,
    child: ClinicalListContent(section: consultationFieldsSection),
  );
}
