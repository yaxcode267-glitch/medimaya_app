import 'package:flutter/material.dart';

/// Fila de acciones de un formulario (Cancelar / Guardar).
///
/// En pantallas estrechas los botones se apilan a ancho completo para que las
/// etiquetas largas no se corten.
class FormActions extends StatelessWidget {
  const FormActions({
    super.key,
    required this.cancel,
    required this.save,
    this.saveFlex = 2,
  });

  final Widget cancel;
  final Widget save;
  final int saveFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= 420) {
          return Row(
            children: [
              Expanded(child: cancel),
              const SizedBox(width: 12),
              Expanded(flex: saveFlex, child: save),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [cancel, const SizedBox(height: 12), save],
        );
      },
    );
  }
}
