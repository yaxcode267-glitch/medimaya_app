import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class ButtonThemes {
  static const minimumSize = Size(0, 52);
  static const padding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);
  static const textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static ButtonStyle primary() {
    return ElevatedButton.styleFrom(
      minimumSize: minimumSize,
      padding: padding,
      textStyle: textStyle,
      backgroundColor: AppColors.colorPrimario,
      foregroundColor: Colors.white,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  static ButtonStyle secondary() {
    return OutlinedButton.styleFrom(
      minimumSize: minimumSize,
      padding: padding,
      textStyle: textStyle,
      foregroundColor: AppColors.colorPrimario,
      side: BorderSide(color: AppColors.colorPrimario, width: 2),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
