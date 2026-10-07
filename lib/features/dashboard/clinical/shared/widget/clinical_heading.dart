import 'package:medimaya_app/shared/ui/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class ClinicalHeading extends StatelessWidget {
  const ClinicalHeading({
    super.key,
    required this.title,
    required this.description,
    this.action,
  });
  final String title, description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final heading = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: AppColors.colorTexto,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: AppTextStyles.description),
        ],
      );
      if (action == null) return heading;
      if (box.maxWidth >= 720) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: heading),
            const SizedBox(width: 24),
            action!,
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading,
          const SizedBox(height: 16),
          Align(alignment: Alignment.centerLeft, child: action),
        ],
      );
    },
  );
}
