import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
// Widget
import 'package:medimaya_app/shared/ui/widget/common/app_alert.dart';

/// Campo de imagen del producto: elige un archivo y lo entrega como
/// `MultipartFile` para el `multipart/form-data`.
///
/// El backend solo acepta `jpg`, `jpeg`, `png` y `webp` de hasta 2 MB, así que
/// el archivo se valida aquí para no gastar un viaje con un rechazo previsible.
///
/// El archivo pendiente se guarda en el widget porque es quien sabe mostrar su
/// vista previa; la página solo recibe el `MultipartFile` para enviarlo.
class ProductImageField extends StatefulWidget {
  final String? imageUrl;
  final MultipartFile? file;
  final bool enabled;
  final String? errorText;
  final ValueChanged<MultipartFile?> onChanged;

  const ProductImageField({
    super.key,
    this.imageUrl,
    this.file,
    this.enabled = true,
    this.errorText,
    required this.onChanged,
  });

  @override
  State<ProductImageField> createState() => _ProductImageFieldState();
}

class _ProductImageFieldState extends State<ProductImageField> {
  static const _maxBytes = 2 * 1024 * 1024;
  static const _extensions = {'jpg', 'jpeg', 'png', 'webp'};

  final _picker = ImagePicker();

  XFile? _picked;

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );

    if (image == null || !mounted) return;

    final extension = image.name.split('.').last.toLowerCase();

    if (!_extensions.contains(extension)) {
      AppAlert.warning('Elige una imagen JPG, PNG o WEBP.');
      return;
    }

    if (await image.length() > _maxBytes) {
      AppAlert.warning('La imagen supera los 2 MB.');
      return;
    }

    if (!mounted) return;

    setState(() => _picked = image);

    widget.onChanged(
      MultipartFile.fromBytes(await image.readAsBytes(), filename: image.name),
    );
  }

  Future<void> _pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 85,
    );

    if (image == null || !mounted) return;

    final extension = image.name.split('.').last.toLowerCase();

    if (!_extensions.contains(extension)) {
      AppAlert.warning('Elige una imagen JPG, PNG o WEBP.');
      return;
    }

    if (await image.length() > _maxBytes) {
      AppAlert.warning('La imagen supera los 2 MB.');
      return;
    }

    if (!mounted) return;

    setState(() => _picked = image);

    widget.onChanged(
      MultipartFile.fromBytes(await image.readAsBytes(), filename: image.name),
    );
  }

  void _clear() {
    setState(() => _picked = null);
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagen',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.colorTextoSecundario,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _preview(),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      style: ButtonThemes.secondary().copyWith(
                        minimumSize: WidgetStateProperty.all(const Size(0, 44)),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      onPressed: widget.enabled
                          ? () async {
                              final isMobile =
                                  Theme.of(context).platform !=
                                      TargetPlatform.macOS &&
                                  Theme.of(context).platform !=
                                      TargetPlatform.windows &&
                                  Theme.of(context).platform !=
                                      TargetPlatform.linux;
                              if (isMobile) {
                                // simple approach: allow both if mobile
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (context) => SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                          title: const Text('Tomar foto'),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _pickFromCamera();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.photo_library_outlined,
                                          ),
                                          title: const Text('Galería'),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            _pickFromGallery();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                await _pickFromGallery();
                              }
                            }
                          : null,
                      icon: const Icon(Icons.photo_library_outlined, size: 20),
                      label: Text(
                        _picked == null ? 'Elegir imagen' : 'Cambiar',
                      ),
                    ),
                  ),

                  if (_picked != null) ...[
                    const SizedBox(height: 8),

                    TextButton.icon(
                      onPressed: widget.enabled ? _clear : null,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Descartar imagen'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        minimumSize: const Size(0, 44),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  Text(
                    'JPG, PNG o WEBP de hasta 2 MB.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.colorTextoSecundario,
                    ),
                  ),

                  if (widget.errorText != null) ...[
                    const SizedBox(height: 6),

                    Text(
                      widget.errorText!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _preview() {
    final picked = _picked;
    final url = picked == null ? widget.imageUrl : null;

    if (picked == null && url == null) {
      return Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          color: AppColors.colorFondo,
          border: Border.all(color: AppColors.colorOutlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.image_outlined,
          size: 28,
          color: AppColors.colorTextoSecundario,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 112,
        height: 112,
        child: picked != null
            ? Image.file(File(picked.path), fit: BoxFit.cover)
            : Image.network(
                url!,
                fit: BoxFit.cover,
                // La URL firmada caduca; el producto se ve igual, sin foto.
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.colorSuperficie,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 28,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
              ),
      ),
    );
  }
}
