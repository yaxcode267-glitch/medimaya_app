import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Model
import '../../categories/model/category.model.dart';
// Service
import '../../categories/service/category_service.dart';

// Widget
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

/// Desplegable de categorías del inventario. Carga solo las activas salvo que
/// se pida lo contrario, porque el backend no acepta como categoría de un
/// producto una que esté desactivada.
class CategoryField extends StatefulWidget {
  /// Valor de [AppSelect] que significa "ninguna categoría".
  ///
  /// Un desplegable no admite `null` como valor de opción, así que "sin
  /// categoría" viaja como cadena vacía y quien lo use hace la traducción.
  static const none = '';

  final String value;
  final ValueChanged<String> onChanged;

  /// Añade la opción "todas" en lugar de "sin categoría", para filtrar.
  final bool includeAll;
  final bool onlyActive;
  final bool required;
  final bool enabled;

  final String name;
  final String? hint;
  final String? helperText;
  final String? errorText;

  /// Opción a incluir aunque no esté en la lista, para no perder de vista la
  /// categoría ya guardada cuando está desactivada.
  final SelectOption? extraOption;

  const CategoryField({
    super.key,
    required this.value,
    required this.onChanged,
    this.includeAll = false,
    this.onlyActive = true,
    this.required = false,
    this.enabled = true,
    this.name = 'Categoría',
    this.hint,
    this.helperText,
    this.errorText,
    this.extraOption,
  });

  @override
  State<CategoryField> createState() => _CategoryFieldState();
}

class _CategoryFieldState extends State<CategoryField> {
  final _service = CategoryService();

  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final categories = await _service.list(
        active: widget.onlyActive ? 'active' : 'all',
      );

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _loading = false;
      });
    } on DioException {
      // El interceptor ya muestra el error; sin categorías el desplegable
      // queda solo con la opción "sin categoría".
      if (!mounted) return;

      setState(() => _loading = false);
    }
  }

  List<SelectOption> _options() {
    final extra = widget.extraOption;
    final options = <SelectOption>[
      SelectOption(
        value: CategoryField.none,
        label: widget.includeAll ? 'Todas las categorías' : 'Sin categoría',
      ),
      for (final category in _categories)
        SelectOption(value: category.id, label: category.name),
    ];

    if (extra != null) {
      final seen = options.any((option) => option.value == extra.value);
      if (!seen) options.add(extra);
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return AppSelect(
      name: widget.name,
      value: widget.value,
      onChanged: widget.onChanged,
      required: widget.required,
      enabled: widget.enabled && !_loading,
      hint: widget.hint,
      helperText: widget.helperText,
      errorText: widget.errorText,
      emptyText: _loading ? 'Cargando categorías…' : 'Sin categorías',
      options: _loading ? const [] : _options(),
    );
  }
}
