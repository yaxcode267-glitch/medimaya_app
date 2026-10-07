import 'package:flutter/material.dart';

import '../model/specialties_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class SpecialtyFormPage extends StatelessWidget {
  const SpecialtyFormPage({super.key, this.id});
  final String? id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: "${id == null ? 'Crear' : 'Editar'} ${specialtiesSection.singular}",
    child: ClinicalRecordContent(section: specialtiesSection, id: id),
  );
}
