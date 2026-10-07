import '../store/clinical_form_notifier.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/clinical_section.dart';
import 'clinical_fields.dart';
import 'clinical_heading.dart';
import 'clinical_record_summary.dart';
import 'clinical_notice.dart';
import 'clinical_preview.dart';

import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';

class ClinicalRecordContent extends StatelessWidget {
  const ClinicalRecordContent({
    super.key,
    required this.section,
    this.id,
    this.readOnly = false,
    this.fieldBuilder,
    this.structure,
  });
  final Widget? structure;
  final ClinicalSection section;
  final String? id;
  final bool readOnly;
  final Widget? Function(
    ClinicalField field,
    String? value,
    ClinicalFormNotifier notifier,
  )?
  fieldBuilder;

  @override
  Widget build(BuildContext context) {
    final index = id == null ? -1 : section.indexOfId(id!);
    return id != null && index < 0
        ? const Center(child: AppEmptyState(message: 'Este ejemplo no existe.'))
        : ListView(
            children: [
              const ClinicalNotice(),
              const SizedBox(height: 24),
              ClinicalHeading(
                title: readOnly
                    ? 'Información de ${section.singular}'
                    : 'Datos de ${section.singular}',
                description: readOnly
                    ? section.description
                    : 'Completa los datos. Los campos con * son obligatorios.',
              ),
              const SizedBox(height: 20),
              readOnly
                  ? ClinicalRecordSummary(
                      section: section,
                      values: section.rows[index],
                    )
                  : ClinicalFields(
                      fields: section.fields,
                      fieldBuilder: fieldBuilder,
                      values: index < 0 ? const {} : section.rows[index],
                      readOnly: readOnly,
                    ),
              const SizedBox(height: 24),
              structure ??
                  ClinicalPreview(slug: section.slug, readOnly: readOnly),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  if (!readOnly)
                    ElevatedButton(
                      style: ButtonThemes.primary(),
                      onPressed: null,
                      child: const Text('Guardar (próximamente)'),
                    ),
                  OutlinedButton(
                    style: ButtonThemes.secondary(),
                    onPressed: () => context.go(section.path),
                    child: const Text('Volver al listado'),
                  ),
                ],
              ),
            ],
          );
  }
}
