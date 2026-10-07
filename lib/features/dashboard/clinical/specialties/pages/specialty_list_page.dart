import 'package:flutter/material.dart';

import '../model/specialties_section.dart';
import '../../shared/widget/clinical_list_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class SpecialtyListPage extends StatelessWidget {
  const SpecialtyListPage({super.key});

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: specialtiesSection.title,
    child: ClinicalListContent(section: specialtiesSection),
  );
}
