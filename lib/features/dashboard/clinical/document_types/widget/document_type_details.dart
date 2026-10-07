import 'package:flutter/material.dart';

import '../model/extension_groups.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/info_card.dart';

class DocumentTypeDetails extends StatelessWidget {
  const DocumentTypeDetails({super.key, required this.document});
  final Map<String, String> document;

  @override
  Widget build(BuildContext context) {
    final extensions = (document['Extensiones permitidas'] ?? '')
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
    final description = document['Descripción']?.trim() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoCard(
          icon: Icons.description_outlined,
          label: 'Descripción',
          value: description.isEmpty ? 'Sin descripción.' : description,
          isValueBold: false,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, box) {
            final size = InfoCard(
              icon: Icons.file_present_outlined,
              label: 'Tamaño máximo por archivo',
              value: '${document['Tamaño máximo (MB)'] ?? '—'} MB',
            );
            final formats = InfoCard(
              icon: Icons.folder_copy_outlined,
              label: 'Formatos permitidos',
              value: '${extensions.length} extensiones',
              subtitle: '${groups.length} grupos de archivos',
            );
            return box.maxWidth >= 600
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: size),
                      const SizedBox(width: 16),
                      Expanded(child: formats),
                    ],
                  )
                : Column(children: [size, const SizedBox(height: 16), formats]);
          },
        ),
        const SizedBox(height: 24),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Extensiones permitidas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorTexto,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Formatos seleccionados para este tipo de documento.',
                style: TextStyle(color: AppColors.colorTextoSecundario),
              ),
              if (extensions.isEmpty) ...[
                const SizedBox(height: 16),
                const Text('No hay extensiones configuradas.'),
              ],
              for (final group in groups.entries) ...[
                const SizedBox(height: 20),
                Text(
                  group.key,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
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
          ),
        ),
      ],
    );
  }
}
