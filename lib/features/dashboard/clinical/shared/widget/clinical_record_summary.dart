import 'package:flutter/material.dart';

import '../model/clinical_section.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';

class ClinicalRecordSummary extends StatelessWidget {
  const ClinicalRecordSummary({
    super.key,
    required this.section,
    required this.values,
  });
  final ClinicalSection section;
  final Map<String, String> values;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final width = box.maxWidth >= 600
          ? (box.maxWidth - 24) / 2
          : box.maxWidth;
      return Wrap(
        spacing: 24,
        runSpacing: 24,
        children: [
          for (final field in section.fields)
            SizedBox(
              width: field.multiline ? box.maxWidth : width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorTextoSecundario,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (field.label == 'Disponibilidad')
                    AppBadge(
                      label: values[field.label] ?? 'Sin definir',
                      color: values[field.label] == 'Activo'
                          ? AppColors.exito
                          : AppColors.colorOutlineVariant,
                    )
                  else
                    SelectableText(
                      (values[field.label]?.isNotEmpty ?? false)
                          ? values[field.label]!
                          : 'No registrado',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.colorTexto,
                      ),
                    ),
                ],
              ),
            ),
        ],
      );
    },
  );
}
