import 'package:flutter/material.dart';

import '../model/form_builder_models.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';

class FormElementCard extends StatelessWidget {
  const FormElementCard({
    super.key,
    required this.element,
    required this.position,
    this.onEdit,
    this.onRemove,
    this.onUp,
    this.onDown,
  });
  final ConsultationFormElement element;
  final int position;
  final VoidCallback? onEdit, onRemove, onUp, onDown;

  @override
  Widget build(BuildContext context) => AppCard(
    color: element.type == 'GROUP'
        ? AppColors.colorFondoBajo
        : AppColors.colorFondo,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$position. ${element.label}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.colorTexto,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppBadge(
              label: element.type == 'GROUP'
                  ? 'Sección'
                  : consultationFieldTypes[element.field?.fieldType] ?? '',
              color: AppColors.colorPrimarioContainer,
            ),
            if (element.type == 'FIELD')
              AppBadge(
                label: element.isRequired ? 'Obligatorio' : 'Opcional',
                color: AppColors.colorSuperficieAlta,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (onEdit != null)
              Tooltip(
                message: 'Configurar ${element.label}',
                child: OutlinedButton.icon(
                  style: ButtonThemes.secondary(),
                  onPressed: onEdit,
                  icon: const Icon(Icons.tune, size: 20),
                  label: Text(
                    element.type == 'GROUP' ? 'Editar sección' : 'Configurar',
                  ),
                ),
              ),
            IconButton(
              tooltip: 'Subir ${element.label}',
              onPressed: onUp,
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              tooltip: 'Bajar ${element.label}',
              onPressed: onDown,
              icon: const Icon(Icons.arrow_downward),
            ),
            IconButton(
              tooltip: onRemove == null
                  ? 'Quita primero los campos de esta sección'
                  : 'Quitar ${element.label}',
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ],
    ),
  );
}
