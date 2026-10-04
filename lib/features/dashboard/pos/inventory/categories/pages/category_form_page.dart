import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Model
import '../model/category.model.dart';
// Service
import '../service/category_service.dart';

// Api
import 'package:medimaya_app/shared/api/error/api_error.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/forms/form_actions.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

/// Formulario de alta y edición. Sin [id] crea una categoría; con [id] la
/// carga y la actualiza.
class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key, this.id});

  final String? id;

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = CategoryService();

  final _name = TextEditingController();
  final _description = TextEditingController();

  bool _loading = false;
  bool _saving = false;
  String? _error;

  /// Errores 422 del backend, para mostrarlos en el campo que corresponde.
  String? _nameError;
  String? _descriptionError;

  bool get _isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final category = await _service.get(widget.id!);

      if (!mounted) return;

      setState(() {
        _name.text = category.name;
        _description.text = category.description ?? '';
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _error = ApiError.fromDio(e).message;
        _loading = false;
      });
    }
  }

  String? _maxLength(String? value, int max) =>
      (value?.trim().length ?? 0) > max ? 'Máximo $max caracteres' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final description = _description.text.trim();

    setState(() {
      _saving = true;
      _nameError = null;
      _descriptionError = null;
    });

    final input = CategoryInput(
      name: _name.text.trim(),
      description: description.isEmpty ? null : description,
    );

    try {
      final id = widget.id;

      if (id == null) {
        await _service.create(input);
      } else {
        await _service.update(id, input);
      }

      if (!mounted) return;

      context.pop(true);
    } on DioException catch (e) {
      if (!mounted) return;

      final apiError = ApiError.fromDio(e);

      setState(() {
        _saving = false;
        _nameError = apiError.errorFor('name');
        _descriptionError = apiError.errorFor('description');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: _isEdit ? 'Editar categoría' : 'Crear categoría',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: AppEmptyState(
                icon: Icons.error_outline,
                message: _error!,
                action: OutlinedButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Reintentar'),
                ),
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInput(
                      name: 'Nombre',
                      controller: _name,
                      required: true,
                      readOnly: _saving,
                      hint: 'Ej. Medicamentos',
                      errorText: _nameError,
                      validator: (value) => _maxLength(value, 150),
                    ),

                    const SizedBox(height: 16),

                    AppInput(
                      name: 'Descripción',
                      controller: _description,
                      maxLines: 4,
                      readOnly: _saving,
                      hint: 'Qué productos agrupa esta categoría',
                      errorText: _descriptionError,
                      validator: (value) => _maxLength(value, 500),
                    ),

                    const SizedBox(height: 24),

                    FormActions(
                      saveFlex: 1,
                      cancel: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          style: ButtonThemes.secondary(),
                          onPressed: _saving ? null : () => context.pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      save: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ButtonThemes.primary(),
                          onPressed: _saving ? null : _submit,
                          child: _saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isEdit
                                      ? 'Guardar cambios'
                                      : 'Crear categoría',
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
