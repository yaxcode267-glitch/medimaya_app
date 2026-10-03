import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/app_colors.dart';

class AppInput extends StatefulWidget {
  final String name;

  final bool required;
  final bool password;
  final bool date;
  final bool readOnly;

  final String? hint;
  final String? helperText;
  final String? errorText;

  final String? Function(String?)? validator;

  final TextEditingController? controller;
  final String? initialValue;

  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  /// Rango que puede elegir el usuario en el selector de fechas. Si se omite
  /// se abre un rango de 100 años atrás a 20 años adelante.
  final DateTimeRange? dateRange;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppInput({
    super.key,
    required this.name,
    this.required = false,
    this.password = false,
    this.date = false,
    this.readOnly = false,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.maxLines = 1,
    this.autofocus = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.dateRange,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late final TextEditingController _controller;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final range = widget.dateRange;

    final date = await showDatePicker(
      context: context,
      initialDate: range == null ? now : _withinRange(now, range),
      firstDate: range?.start ?? DateTime(now.year - 100),
      lastDate: range?.end ?? DateTime(now.year + 20),
      locale: const Locale('es'),
    );

    if (date == null) return;

    _controller.text =
        '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// `showDatePicker` exige que la fecha inicial caiga dentro del rango.
  DateTime _withinRange(DateTime date, DateTimeRange range) {
    if (date.isBefore(range.start)) return range.start;
    if (date.isAfter(range.end)) return range.end;
    return date;
  }

  String? _validate(String? value) {
    if (widget.required && (value == null || value.trim().isEmpty)) {
      return '${widget.name} es requerido';
    }

    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: widget.date || widget.readOnly,
      obscureText: widget.password && !_showPassword,
      keyboardType: widget.date ? TextInputType.datetime : widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: widget.autofillHints,
      inputFormatters: widget.inputFormatters,
      validator: _validate,
      onTap: widget.date ? _selectDate : null,
      decoration:
          appFieldDecoration(
            labelText: widget.required ? '${widget.name} *' : widget.name,
            hintText: widget.hint,
            errorText: widget.errorText,
          ).copyWith(
            helperText: widget.helperText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: widget.maxLines > 1 ? 20 : 22,
            ),
            alignLabelWithHint: widget.maxLines > 1,
            prefixIcon: widget.date
                ? const Icon(Icons.calendar_today_outlined, size: 22)
                : widget.prefixIcon,
            suffixIcon: widget.password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    tooltip: _showPassword ? 'Ocultar' : 'Mostrar',
                  )
                : widget.suffixIcon,
          ),
      style: const TextStyle(fontSize: 16),
    );
  }
}

/// Estilo base de los campos de la app. Lo reutilizan los desplegables, que no
/// pueden usar [AppInput] pero deben verse igual.
InputDecoration appFieldDecoration({
  String? labelText,
  String? hintText,
  String? errorText,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    errorText: errorText,
    filled: true,
    fillColor: AppColors.colorFondo,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    labelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.colorTextoSecundario,
    ),
  );
}
