import 'package:flutter/material.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

/// Miniatura del producto en las filas del listado.
///
/// El bucket es privado, así que el backend manda una URL firmada que caduca en
/// `AWS_TEMPORARY_URL_MINUTES`: la imagen se descarga tal cual con
/// `Image.network`, porque el bucket rechaza peticiones sin firma.
///
/// Un producto sin imagen, o cuya firma ya venció, muestra el icono de
/// placeholder en vez del espacio en blanco o la excepción de red.
class ProductThumb extends StatelessWidget {
  const ProductThumb({super.key, this.url, this.size = 40});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.colorSuperficie,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 18,
          color: AppColors.colorTextoSecundario,
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // El color de fondo también es lo que se ve mientras descarga.
        color: AppColors.colorSuperficie,
        border: Border.all(color: AppColors.colorOutlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url!.isEmpty
          ? placeholder
          : Image.network(
              url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}
