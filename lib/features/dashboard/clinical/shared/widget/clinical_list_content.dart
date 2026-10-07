import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/clinical_section.dart';
import 'clinical_notice.dart';
import 'clinical_heading.dart';
import 'clinical_list_filters.dart';
import 'clinical_table_actions.dart';

import 'package:medimaya_app/shared/utils/permissions.dart';
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';
import 'package:medimaya_app/shared/ui/themes/button_themes.dart';
import 'package:medimaya_app/shared/ui/widget/common/app_badge.dart';
import 'package:medimaya_app/shared/ui/widget/common/data_table.dart';

class ClinicalListContent extends StatefulWidget {
  const ClinicalListContent({
    super.key,
    required this.section,
    this.allowCreate = true,
  });
  final ClinicalSection section;
  final bool allowCreate;

  @override
  State<ClinicalListContent> createState() => _ClinicalListContentState();
}

class _ClinicalListContentState extends State<ClinicalListContent> {
  final _searchController = TextEditingController();
  final Map<int, bool> _activeChanges = {};
  String _search = '';
  String _filter = 'all';
  String _category = '';

  bool _isActive(int index) =>
      _activeChanges[index] ??
      widget.section.examples[index]['Disponibilidad'] == 'Activo';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final filterField = section.filterField;
    final categories = filterField == null
        ? <String>[]
        : section.fields
              .firstWhere((field) => field.label == filterField)
              .options;
    final matches = section.examples.asMap().entries.where((entry) {
      final matchesState =
          _filter == 'all' || (_filter == 'active') == _isActive(entry.key);
      final matchesCategory =
          _category.isEmpty || entry.value[filterField] == _category;
      return matchesState &&
          matchesCategory &&
          entry.value.entries
              .where((field) => field.key != 'Disponibilidad')
              .any((field) => field.value.toLowerCase().contains(_search));
    }).toList();
    return LayoutBuilder(
      builder: (context, box) => ListView(
        children: [
          const ClinicalNotice(),
          const SizedBox(height: 16),
          ClinicalHeading(
            title: section.title,
            description: section.description,
            action:
                widget.allowCreate && hasPermission('${section.slug}:create')
                ? ElevatedButton.icon(
                    style: ButtonThemes.primary(),
                    onPressed: () => context.go('${section.path}/create'),
                    icon: const Icon(Icons.add, size: 20),
                    label: Text('Crear ${section.singular}'),
                  )
                : null,
          ),
          const SizedBox(height: 24),
          ClinicalListFilters(
            searchController: _searchController,
            searchHint:
                'Buscar por ${section.tableFields.take(2).join(' o ').toLowerCase()}',
            onSearch: (value) =>
                setState(() => _search = value.trim().toLowerCase()),
            filter: _filter,
            onFilter: (value) => setState(() => _filter = value),
            category: _category,
            onCategory: (value) => setState(() => _category = value),
            filterField: filterField,
            categories: categories,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${matches.length} de ${section.examples.length} registros de ejemplo',
              ),
              TextButton(
                onPressed: () => setState(() {
                  _searchController.clear();
                  _search = '';
                  _filter = 'all';
                  _category = '';
                }),
                child: const Text('Limpiar filtros'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (box.maxWidth < 720) ...[
            const Text(
              'Desliza la tabla para ver todas las columnas.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.colorTextoSecundario,
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            height: matches.isEmpty
                ? 240
                : (112 + matches.length * 56).clamp(240, 560).toDouble(),
            child: AppDataTable(
              columns: [
                if (box.maxWidth < 720)
                  const TableColumn(key: 'actions', label: 'Acciones'),
                for (final field in section.tableFields)
                  TableColumn(key: field, label: field),
                const TableColumn(key: 'active', label: 'Activo / Inactivo'),
                if (box.maxWidth >= 720)
                  const TableColumn(key: 'actions', label: 'Acciones'),
              ],
              rows: [
                for (final entry in matches)
                  {
                    for (final field in section.tableFields)
                      field: Tooltip(
                        message: entry.value[field] ?? 'No registrado',
                        child: SizedBox(
                          width: field == section.tableFields.first ? 200 : 180,
                          child: Text(
                            entry.value[field] ?? '—',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              fontWeight: field == section.tableFields.first
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    'active': AppBadge(
                      label: _isActive(entry.key) ? 'Activo' : 'Inactivo',
                      color: _isActive(entry.key)
                          ? AppColors.exito
                          : AppColors.colorOutlineVariant,
                    ),
                    'actions': ClinicalTableActions(
                      section: section,
                      index: entry.key,
                      active: _isActive(entry.key),
                      onChanged: (value) =>
                          setState(() => _activeChanges[entry.key] = value),
                    ),
                  },
              ],
              emptyText: 'No hay ejemplos que coincidan con la búsqueda.',
              emptyIcon: Icons.search_off,
            ),
          ),
        ],
      ),
    );
  }
}
