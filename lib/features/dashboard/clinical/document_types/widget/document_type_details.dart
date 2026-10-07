import 'package:medimaya_app/shared/ui/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../model/extension_groups.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';

class DocumentTypeDetails extends StatelessWidget {
  const DocumentTypeDetails({super.key, required this.document});
  final Map<String, String> document;

  @override
  Widget build(BuildContext context) {
    final extensions = (document['allowed_extensions'] ?? '')
        .split(',')
        .map((value) => value.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    final groups = <String, List<String>>{
      for (final group in documentExtensionGroups.entries)
        if (group.value.any(extensions.contains))
          group.key: group.value.where(extensions.contains).toList(),
    };
    final others = extensions.difference(
      documentExtensionGroups.values.expand((value) => value).toSet(),
    );
    if (others.isNotEmpty) groups['Otros formatos'] = others.toList();
    final description = document['description']?.trim() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Descripción', style: AppTextStyles.label),
        const SizedBox(height: 8),
        SelectableText(
          description.isEmpty ? 'Sin descripción.' : description,
          style: AppTextStyles.body,
        ),
        const Divider(height: 32),
        const Text('Tamaño máximo por archivo', style: AppTextStyles.label),
        const SizedBox(height: 8),
        Text('${document['max_size_mb'] ?? '—'} MB', style: AppTextStyles.body),
        const Divider(height: 32),
        const Text('Formatos permitidos', style: AppTextStyles.label),
        const SizedBox(height: 8),
        Text(
          '${extensions.length} extensiones · ${groups.length} grupos de archivos',
          style: AppTextStyles.body,
        ),
        const Divider(height: 32),
        const Text('Extensiones permitidas', style: AppTextStyles.title),
        const SizedBox(height: 8),
        const Text('Formatos seleccionados para este tipo de documento.'),
        if (extensions.isEmpty) ...[
          const SizedBox(height: 16),
          const Text('No hay extensiones configuradas.'),
        ],
        for (final group in groups.entries) ...[
          const SizedBox(height: 20),
          Text(group.key, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final extension in group.value)
                AppBadge(
                  label: '.${extension.toUpperCase()}',
                  color: AppColors.colorPrimarioContainer,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
