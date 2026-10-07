import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';

class ClinicalPreview extends StatelessWidget {
  const ClinicalPreview({
    super.key,
    required this.slug,
    required this.readOnly,
  });
  final String slug;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    if (slug == 'patients') {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial clínico',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Vista de ejemplo del historial. No contiene consultas reales.',
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              style: ButtonThemes.secondary(),
              onPressed: () => context.go('/dashboard/consultations/demo-1'),
              child: const Text('Explorar consulta de ejemplo'),
            ),
          ],
        ),
      );
    }
    if (slug != 'consultation-forms' && slug != 'consultations') {
      return const SizedBox.shrink();
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slug == 'consultations'
                ? 'Registro clínico'
                : 'Vista previa del formulario',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Sección de ejemplo · Evaluación general'),
          const SizedBox(height: 16),
          AppInput(name: 'Motivo de consulta', maxLines: 3, readOnly: readOnly),
          const SizedBox(height: 16),
          AppInput(name: 'Observaciones', maxLines: 3, readOnly: readOnly),
          const SizedBox(height: 24),
          const AppEmptyState(
            icon: Icons.attach_file,
            message:
                'Sin documentos de ejemplo. La carga de archivos estará '
                'disponible al conectar el módulo.',
          ),
        ],
      ),
    );
  }
}
