import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_card.dart';

class PatientQrPreview extends StatelessWidget {
  const PatientQrPreview({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Escanear QR del paciente'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppCard(
            child: Center(
              child: Icon(
                Icons.qr_code_scanner,
                size: 96,
                color: AppColors.colorPrimario,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Maqueta del escáner. La cámara aún no está conectada. '
            'Puedes simular la lectura del ID PAC-DEMO-001.',
          ),
        ],
      ),
    ),
    actions: [
      OutlinedButton(
        style: ButtonThemes.secondary(),
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(
        style: ButtonThemes.primary(),
        onPressed: () => Navigator.pop(context, 'PAC-DEMO-001'),
        child: const Text('Simular lectura'),
      ),
    ],
  );
}
