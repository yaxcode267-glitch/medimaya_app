import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

// Model
import '../model/product.model.dart';
// Service
import '../service/product_service.dart';
// Widgets
import '../widget/category_field.dart';
import '../widget/product_image_field.dart';

// Api
import 'package:medimaya_app/shared/api/error/api_error.dart';
// Themes
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_empty_state.dart';
import 'package:medimaya_app/shared/ui/widget/forms/decimal_input_formatter.dart';
import 'package:medimaya_app/shared/ui/widget/forms/form_actions.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';
// Layouts
import 'package:medimaya_app/shared/ui/layouts/dashboard/dashboard_layout.dart';

/// Formulario de alta y edición. Sin [id] crea un producto; con [id] lo carga
/// y actualiza. Permite adjuntar imagen (JPG/PNG/WEBP, máx 2 MB).
class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key, this.id});

  final String? id;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProductService();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();

  String? _categoryId = CategoryField.none;

  MultipartFile? _imageFile;
  String? _currentImageUrl;

  bool _loading = false;
  bool _saving = false;
  String? _error;

  String? _nameError;
  String? _priceError;
  String? _descriptionError;
  String? _imageError;
  String? _categoryError;

  bool get _isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final product = await _service.get(widget.id!);

      if (!mounted) return;

      setState(() {
        _name.text = product.name;
        _price.text = product.price.toStringAsFixed(2);
        _description.text = product.description ?? '';
        _categoryId = product.categoryId ?? CategoryField.none;
        _currentImageUrl = product.imageUrl;
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
    final category = _categoryId == CategoryField.none ? null : _categoryId;

    final parsedPrice = double.tryParse(
      _price.text.trim().replaceAll(',', '.'),
    );
    if (parsedPrice == null) {
      setState(() {
        _priceError = 'Ingresa un precio válido';
      });
      return;
    }

    setState(() {
      _saving = true;
      _nameError = null;
      _priceError = null;
      _descriptionError = null;
      _imageError = null;
      _categoryError = null;
    });

    final input = ProductInput(
      name: _name.text.trim(),
      price: parsedPrice,
      description: description.isEmpty ? null : description,
      categoryId: category,
    );

    try {
      final id = widget.id;

      if (id == null) {
        await _service.create(input, image: _imageFile);
      } else {
        await _service.update(id, input, image: _imageFile);
      }

      if (!mounted) return;

      context.pop(true);
    } on DioException catch (e) {
      if (!mounted) return;

      final apiError = ApiError.fromDio(e);

      setState(() {
        _saving = false;
        _nameError = apiError.errorFor('name');
        _priceError = apiError.errorFor('price');
        _descriptionError = apiError.errorFor('description');
        _imageError = apiError.errorFor('image');
        _categoryError = apiError.errorFor('category_id');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: _isEdit ? 'Editar producto' : 'Crear producto',
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
                      hint: 'Ej. Ibuprofeno 400 mg',
                      errorText: _nameError,
                      validator: (value) => _maxLength(value, 200),
                    ),

                    const SizedBox(height: 16),

                    CategoryField(
                      value: _categoryId ?? CategoryField.none,
                      onChanged: (value) => setState(() => _categoryId = value),
                      enabled: !_saving,
                      errorText: _categoryError,
                      extraOption:
                          _isEdit &&
                              _categoryId != null &&
                              _categoryId != CategoryField.none
                          ? SelectOption(
                              value: _categoryId!,
                              label: 'Categoría actual',
                            )
                          : null,
                    ),

                    const SizedBox(height: 16),

                    AppInput(
                      name: 'Precio (S/)',
                      controller: _price,
                      required: true,
                      readOnly: _saving,
                      hint: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [DecimalInputFormatter()],
                      errorText: _priceError,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Precio es requerido';
                        }
                        final parsed = double.tryParse(
                          value.trim().replaceAll(',', '.'),
                        );
                        if (parsed == null) return 'Ingresa un precio válido';
                        if (parsed < 0) {
                          return 'El precio no puede ser negativo';
                        }
                        if (parsed > 99999999.99) {
                          return 'El precio es demasiado alto';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    AppInput(
                      name: 'Descripción',
                      controller: _description,
                      maxLines: 4,
                      readOnly: _saving,
                      hint: 'Descripción breve del producto',
                      errorText: _descriptionError,
                      validator: (value) => _maxLength(value, 500),
                    ),

                    const SizedBox(height: 16),

                    ProductImageField(
                      imageUrl: _currentImageUrl,
                      file: _imageFile,
                      enabled: !_saving,
                      errorText: _imageError,
                      onChanged: (file) => setState(() => _imageFile = file),
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
                                      : 'Crear producto',
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
