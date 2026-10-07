import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/clinical_section.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/widget/common/confirm_dialog.dart';

class ClinicalTableActions extends StatelessWidget {
  const ClinicalTableActions({
    super.key,
    required this.section,
    required this.index,
    required this.active,
    required this.onChanged,
  });
  final ClinicalSection section;
  final int index;
  final bool active;
  final ValueChanged<bool> onChanged;

  Future<void> _toggle(BuildContext context) async {
    final confirmed = await AppConfirm.show(
      context: context,
      title: '${active ? 'Desactivar' : 'Activar'} ${section.singular}',
      message: 'El cambio solo se aplica a este listado de ejemplo y se pierde al salir.',
      confirmText: active ? 'Desactivar' : 'Activar',
    );
    if (confirmed == true && context.mounted) onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    final path = '${section.path}/demo-${index + 1}';
    final canToggle =
        hasPermission('${section.slug}:activate') ||
        (['patients', 'consultations'].contains(section.slug) &&
            hasPermission('${section.slug}:update'));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Ver detalle',
          onPressed: () => context.go(path),
          icon: const Icon(Icons.visibility_outlined, size: 20),
        ),
        if (hasPermission('${section.slug}:update'))
          IconButton(
            tooltip: 'Editar ejemplo',
            onPressed: () => context.go('$path/edit'),
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
        if (canToggle)
          IconButton(
            tooltip: active ? 'Desactivar' : 'Activar',
            onPressed: () => _toggle(context),
            icon: Icon(
              active ? Icons.block : Icons.check_circle_outline,
              size: 20,
              color: active ? AppColors.error : AppColors.exito,
            ),
          ),
      ],
    );
  }
}
