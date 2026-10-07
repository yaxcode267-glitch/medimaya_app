import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class FieldChoicePreview extends StatefulWidget {
  const FieldChoicePreview({
    super.key,
    required this.label,
    required this.checkbox,
    this.options = const [],
  });
  final String label;
  final bool checkbox;
  final List<String> options;

  @override
  State<FieldChoicePreview> createState() => _FieldChoicePreviewState();
}

class _FieldChoicePreviewState extends State<FieldChoicePreview> {
  bool _checked = false;
  String? _selected;

  @override
  Widget build(BuildContext context) {
    if (widget.checkbox) {
      return CheckboxListTile(
        title: Text(widget.label),
        value: _checked,
        activeColor: AppColors.colorPrimario,
        onChanged: (value) => setState(() => _checked = value ?? false),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (value) => setState(() => _selected = value),
          child: Column(
            children: [
              for (final option in widget.options)
                RadioListTile<String>(
                  value: option,
                  title: Text(option),
                  activeColor: AppColors.colorPrimario,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
