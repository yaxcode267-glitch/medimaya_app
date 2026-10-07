import 'package:flutter/material.dart';

// Themes
import '../../themes/app_colors.dart';

// Widget
import 'input_form.dart';
import 'select_option.dart';

/// Desplegable con la misma pinta que [AppInput].
class AppSelect extends StatefulWidget {
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
  State<AppSelect> createState() => _AppSelectState();
}

class _AppSelectState extends State<AppSelect> {
  bool _synchronizing = false;
  final _field = GlobalKey<FormFieldState<String>>();
  String? get _value =>
      widget.options.any((option) => option.value == widget.value)
      ? widget.value
      : null;

  @override
  void didUpdateWidget(AppSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = _field.currentState?.value;
    if (oldWidget.value != widget.value ||
        (current != null &&
            !widget.options.any((option) => option.value == current))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _field.currentState?.value == _value) return;
        _synchronizing = true;
        _field.currentState?.didChange(_value);
        _synchronizing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: _field,
      initialValue: _value,
      isExpanded: true,
      items: [
        for (final option in widget.options)
          DropdownMenuItem(
            value: option.value,
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: widget.enabled
          ? (v) {
              if (!_synchronizing) widget.onChanged(v ?? '');
            }
          : null,
      style: const TextStyle(fontSize: 16, color: AppColors.colorTexto),
      decoration:
          appFieldDecoration(
            labelText: widget.required ? '${widget.name} *' : widget.name,
            hintText: widget.hint,
            errorText: widget.errorText,
          ).copyWith(
            helperText: widget.helperText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 20,
            ),
            enabledBorder: widget.enabled
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.colorOutlineVariant,
                    ),
                  )
                : null,
          ),
      hint: widget.emptyText == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                widget.emptyText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.colorTextoSecundario,
                ),
              ),
            ),
      validator: (current) {
        if (widget.required && (current == null || current.isEmpty)) {
          return '${widget.name} es requerido';
        }

        return widget.validator?.call(current);
      },
    );
  }
}
