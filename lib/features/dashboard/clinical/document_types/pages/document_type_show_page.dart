import '../../shared/widget/clinical_data_view.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/document_types_section.dart';
import '../widget/document_type_details.dart';
import '../../shared/widget/clinical_notice.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

class DocumentTypeShowPage extends StatelessWidget {
  const DocumentTypeShowPage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) =>
      ClinicalDataView(sections: [documentTypesSection], builder: _buildLoaded);

  Widget _buildLoaded(BuildContext context) {
    final index = documentTypesSection.indexOfId(id);
    return DashboardLayout(
      title: 'Detalle de tipo de documento',
      child: index < 0
          ? Center(
              child: AppEmptyState(
                icon: Icons.folder_off_outlined,
                message: 'Este tipo de documento de ejemplo no existe.',
                action: OutlinedButton(
                  style: ButtonThemes.secondary(),
                  onPressed: () => context.go(documentTypesSection.path),
                  child: const Text('Volver al listado'),
                ),
              ),
            )
          : DocumentTypeShowContent(
              id: id,
              document: documentTypesSection.rows[index],
            ),
    );
  }
}

class DocumentTypeShowContent extends StatelessWidget {
  const DocumentTypeShowContent({
    super.key,
    required this.id,
    required this.document,
  });
  final String id;
  final Map<String, String> document;

  @override
  Widget build(BuildContext context) {
    final active = document['active'] == 'Activo';
    return ListView(
      children: [
        const ClinicalNotice(),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, box) {
            final heading = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TIPO DE DOCUMENTO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  document['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorTexto,
                  ),
                ),
                const SizedBox(height: 12),
                AppBadge(
                  label: active ? 'Activo' : 'Inactivo',
                  color: active
                      ? AppColors.exito
                      : AppColors.colorOutlineVariant,
                ),
              ],
            );
            if (!hasPermission('document-types:update')) return heading;
            final edit = ElevatedButton.icon(
              style: ButtonThemes.primary(),
              onPressed: () =>
                  context.go('${documentTypesSection.path}/$id/edit'),
              icon: const Icon(Icons.edit_outlined, size: 20),
              label: const Text('Editar tipo'),
            );
            return box.maxWidth >= 600
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: heading),
                      const SizedBox(width: 16),
                      edit,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [heading, const SizedBox(height: 16), edit],
                  );
          },
        ),
        const SizedBox(height: 24),
        DocumentTypeDetails(document: document),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            style: ButtonThemes.secondary(),
            onPressed: () => context.go(documentTypesSection.path),
            icon: const Icon(Icons.arrow_back, size: 20),
            label: const Text('Volver al listado'),
          ),
        ),
      ],
    );
  }
}
