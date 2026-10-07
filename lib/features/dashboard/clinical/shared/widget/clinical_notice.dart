import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class ClinicalNotice extends StatelessWidget {
  const ClinicalNotice({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: AppColors.colorPrimarioContainer,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.colorOnPrimarioContainer,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Modo de prueba. ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: 'Datos de ejemplo. Los cambios no se guardan.',
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.colorOnPrimarioContainer,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
