import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import 'app_card.dart';

class AppAuditCard extends StatelessWidget {
  const AppAuditCard({
    super.key,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  final DateTime? createdAt, updatedAt, deletedAt;
  final String? createdBy, updatedBy, deletedBy;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Historial del registro',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, box) {
            final entries = [
              _AuditEntry(
                icon: Icons.person_add_outlined,
                label: 'Creación',
                actorLabel: 'Creado por',
                date: createdAt,
                actor: createdBy,
                empty: 'Fecha no disponible',
              ),
              _AuditEntry(
                icon: Icons.edit_outlined,
                label: 'Última actualización',
                actorLabel: 'Actualizado por',
                date: updatedAt,
                actor: updatedBy,
                empty: 'Sin actualizaciones registradas',
              ),
              _AuditEntry(
                icon: Icons.person_off_outlined,
                label: 'Eliminación / desactivación',
                actorLabel: 'Eliminado por',
                date: deletedAt,
                actor: deletedBy,
                empty: 'Sin desactivación registrada',
              ),
            ];
            final columns = box.maxWidth >= 840
                ? 3
                : box.maxWidth >= 560
                ? 2
                : 1;
            final width = (box.maxWidth - (columns - 1) * 24) / columns;
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                for (final entry in entries)
                  SizedBox(width: width, child: entry),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class _AuditEntry extends StatelessWidget {
  const _AuditEntry({
    required this.icon,
    required this.label,
    required this.actorLabel,
    required this.date,
    required this.actor,
    required this.empty,
  });
  final IconData icon;
  final String label, empty, actorLabel;
  final DateTime? date;
  final String? actor;

  @override
  Widget build(BuildContext context) {
    final local = date?.toLocal();
    final formatted = local == null
        ? empty
        : '${MaterialLocalizations.of(context).formatMediumDate(local)} · '
              '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(local), alwaysUse24HourFormat: true)}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.colorPrimario),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.colorTextoSecundario,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatted,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto,
                ),
              ),
              if (date != null || actor != null) ...[
                const SizedBox(height: 4),
                Text(
                  actor == null ? 'Autor no informado' : '$actorLabel $actor',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.colorTextoSecundario,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
