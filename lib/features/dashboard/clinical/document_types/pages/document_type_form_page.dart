import 'package:flutter/material.dart';

import '../model/document_types_section.dart';
import '../widget/extension_groups_field.dart';
import '../../shared/widget/clinical_record_content.dart';

import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class DocumentTypeFormPage extends StatelessWidget {
  const DocumentTypeFormPage({super.key, this.id});
  final String? id;

  @override
  Widget build(BuildContext context) => DashboardLayout(
    title:
        "${id == null ? 'Crear' : 'Editar'} ${documentTypesSection.singular}",
    child: ClinicalRecordContent(
      section: documentTypesSection,
      id: id,
      fieldBuilder: (field, value) => field.label == 'Extensiones permitidas'
          ? ExtensionGroupsField(initialValue: value)
          : null,
    ),
  );
}
