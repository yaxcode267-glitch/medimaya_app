import 'package:flutter/material.dart';

// Widgets
import 'confirm_dialog.dart';

Future<bool> confirmToggleState({
  required BuildContext context,
  required bool active,
  required String itemName,
  required String itemLabel,
  required Future<void> Function() onActivate,
  required Future<void> Function() onDeactivate,
  bool wasDeleted = false,
}) async {
  final willActivate = !active;
  final isRestore = willActivate && wasDeleted;

  final confirmed = await AppConfirm.show(
    context: context,
    title: switch (isRestore) {
      true => 'Restaurar $itemLabel',
      false when willActivate => 'Activar $itemLabel',
      false => 'Desactivar $itemLabel',
    },
    message: switch (isRestore) {
      true => '¿Seguro que deseas restaurar "$itemName"?',
      false when willActivate => '¿Seguro que deseas activar "$itemName"?',
      false => '¿Seguro que deseas desactivar "$itemName"?',
    },
    confirmText: switch (isRestore) {
      true => 'Restaurar',
      false when willActivate => 'Activar',
      false => 'Desactivar',
    },
    tone: willActivate ? ConfirmTone.warning : ConfirmTone.danger,
  );

  if (confirmed != true || !context.mounted) return false;

  await (willActivate ? onActivate() : onDeactivate());
  return true;
}
