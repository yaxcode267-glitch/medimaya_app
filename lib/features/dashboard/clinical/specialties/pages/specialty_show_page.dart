import '../../shared/widget/clinical_data_view.dart';

import 'package:flutter/material.dart';

import '../model/specialties_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class SpecialtyShowPage extends StatelessWidget {
  const SpecialtyShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) =>
      ClinicalDataView(sections: [specialtiesSection], builder: _buildLoaded);

  Widget _buildLoaded(BuildContext context) => DashboardLayout(
    title: 'Detalle de ${specialtiesSection.singular}',
    child: ClinicalRecordContent(
      section: specialtiesSection,
      id: id,
      readOnly: true,
    ),
  );
}
