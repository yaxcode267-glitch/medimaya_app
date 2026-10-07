import 'package:flutter/material.dart';

import '../model/consultation_fields_section.dart';
import '../widget/field_config_summary.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFieldShowPage extends StatelessWidget {
  const ConsultationFieldShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title: 'Detalle de ${consultationFieldsSection.singular}',
    child: ClinicalRecordContent(
      section: consultationFieldsSection,
      id: id,
      readOnly: true,
      structure: FieldConfigSummary(
        config: consultationFieldExampleConfigs[id] ?? const {},
      ),
    ),
  );
}
