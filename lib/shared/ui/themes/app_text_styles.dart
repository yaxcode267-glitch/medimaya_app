import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTexto,
  );
  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTexto,
  );
  static const body = TextStyle(
    fontSize: 16,
    height: 1.5,
    color: AppColors.colorTexto,
  );
  static const description = TextStyle(
    fontSize: 15,
    height: 1.5,
    color: AppColors.colorTextoSecundario,
  );
  static const dialog = TextStyle(
    fontSize: 15,
    height: 1.5,
    color: AppColors.colorTexto,
  );
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextoSecundario,
    height: 1.4,
  );
}
