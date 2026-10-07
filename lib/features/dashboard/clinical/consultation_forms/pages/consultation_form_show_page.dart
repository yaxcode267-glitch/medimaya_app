import '../../shared/widget/clinical_data_view.dart';
import '../../consultation_fields/model/consultation_fields_section.dart';
import '../../document_types/model/document_types_section.dart';

import 'package:flutter/material.dart';

import '../model/consultation_forms_section.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class ConsultationFormShowPage extends StatelessWidget {
  const ConsultationFormShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) => ClinicalDataView(
    sections: [
      consultationFormsSection,
      documentTypesSection,
      consultationFieldsSection,
    ],
    builder: _buildLoaded,
  );

  Widget _buildLoaded(BuildContext context) => DashboardLayout(
    title: 'Detalle de ${consultationFormsSection.singular}',
    child: ClinicalRecordContent(
      section: consultationFormsSection,
      id: id,
      readOnly: true,
    ),
  );
}
