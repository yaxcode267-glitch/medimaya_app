import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import 'input_form.dart';
import 'select_option.dart';

/// Desplegable con la misma pinta que [AppInput].
class AppSelect extends StatelessWidget {
  final String name;
  final List<SelectOption> options;
  final String value;
  final ValueChanged<String> onChanged;

  final bool required;
  final bool enabled;

  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? emptyText;
  final String? Function(String?)? validator;

  const AppSelect({
    super.key,
    required this.name,
    required this.options,
    required this.value,
    required this.onChanged,
    this.required = false,
    this.enabled = true,
    this.hint,
    this.helperText,
    this.errorText,
    this.emptyText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: options.any((option) => option.value == value)
          ? value
          : null,
      isExpanded: true,
      items: [
        for (final option in options)
          DropdownMenuItem(
            value: option.value,
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: enabled ? (v) => onChanged(v ?? '') : null,
      style: const TextStyle(fontSize: 16, color: AppColors.colorTexto),
      decoration:
          appFieldDecoration(
            labelText: required ? '$name *' : name,
            hintText: hint,
            errorText: errorText,
          ).copyWith(
            helperText: helperText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 20,
            ),
            enabledBorder: enabled
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.colorOutlineVariant,
                    ),
                  )
                : null,
          ),
      hint: emptyText == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                emptyText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.colorTextoSecundario,
                ),
              ),
            ),
      validator: (current) {
        if (required && (current == null || current.isEmpty)) {
          return '$name es requerido';
        }

        return validator?.call(current);
      },
    );
  }
}
