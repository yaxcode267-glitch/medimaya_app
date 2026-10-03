import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class ButtonThemes {
  static ButtonStyle primary() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.colorPrimario,
      foregroundColor: Colors.white,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  static ButtonStyle secondary() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.colorPrimario,
      side: BorderSide(color: AppColors.colorPrimario, width: 2),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
