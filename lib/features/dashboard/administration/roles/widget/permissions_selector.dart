import 'package:flutter/material.dart';

// Model
import '../model/permission.model.dart';

// Themes
import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class PermissionsSelector extends StatelessWidget {
  final List<PermissionGroup> groups;
  final List<String> selected;
  final bool loading;
  final String? error;
  final ValueChanged<List<String>> onChanged;

  const PermissionsSelector({
    super.key,
    required this.groups,
    required this.selected,
    this.loading = false,
    this.error,
    required this.onChanged,
  });

  int get _totalCount =>
      groups.fold(0, (total, group) => total + group.permissions.length);

  List<String> get _allIds => [
    for (final group in groups)
      for (final permission in group.permissions) permission.id,
  ];

  bool get _allSelected => _totalCount > 0 && selected.length >= _totalCount;

  bool _isGroupSelected(PermissionGroup group) {
    if (group.permissions.isEmpty) return false;

    return group.permissions.every(
      (permission) => selected.contains(permission.id),
    );
  }

  List<String> _togglePermission(String id) {
    if (selected.contains(id)) {
      return selected.where((item) => item != id).toList();
    }

    return [...selected, id];
  }

  List<String> _toggleGroup(PermissionGroup group) {
    final ids = group.permissions.map((permission) => permission.id).toSet();

    if (_isGroupSelected(group)) {
      return selected.where((id) => !ids.contains(id)).toList();
    }

    final result = [...selected];

    for (final id in ids) {
      if (!result.contains(id)) {
        result.add(id);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),

        if (error != null && error!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            error!,
            style: const TextStyle(fontSize: 12, color: AppColors.error),
          ),
        ],

        if (groups.isNotEmpty && !loading) ...[
          const SizedBox(height: 4),
          _selectAllButton(),
        ],

        const SizedBox(height: 8),

        if (loading && groups.isEmpty)
          _loadingSkeleton()
        else if (groups.isEmpty)
          _emptyState()
        else
          _permissionsList(),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          'Permisos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.colorTexto,
          ),
        ),
        const Spacer(),
        Text(
          ' ${selected.length} / $_totalCount',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.colorTextoSecundario,
          ),
        ),
      ],
    );
  }

  Widget _selectAllButton() {
    return TextButton.icon(
      onPressed: () {
        onChanged(_allSelected ? const [] : _allIds);
      },
      icon: Icon(_allSelected ? Icons.remove_done : Icons.done_all, size: 17),
      label: Text(_allSelected ? 'Deseleccionar todo' : 'Seleccionar todo'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.colorPrimario,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _permissionsList() {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 4),
      child: Column(
        children: [
          for (var index = 0; index < groups.length; index++)
            _group(groups[index], first: index == 0),
        ],
      ),
    );
  }

  Widget _group(PermissionGroup group, {required bool first}) {
    final groupSelected = _isGroupSelected(group);

    return Container(
      padding: EdgeInsets.only(top: first ? 4 : 14, bottom: 8),
      decoration: BoxDecoration(
        border: first
            ? null
            : const Border(
                top: BorderSide(
                  color: AppColors.colorOutlineVariant,
                  width: 0.7,
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _groupHeader(group, groupSelected: groupSelected),

          const SizedBox(height: 4),

          for (final permission in group.permissions)
            _permissionRow(permission),
        ],
      ),
    );
  }

  Widget _groupHeader(PermissionGroup group, {required bool groupSelected}) {
    return InkWell(
      onTap: () => onChanged(_toggleGroup(group)),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Checkbox(
                value: groupSelected,
                activeColor: AppColors.colorPrimario,
                onChanged: (_) {
                  onChanged(_toggleGroup(group));
                },
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                group.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorTexto,
                ),
              ),
            ),
            Text(
              '${group.permissions.where((p) => selected.contains(p.id)).length}/${group.permissions.length}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.colorTextoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _permissionRow(Permission permission) {
    final isSelected = selected.contains(permission.id);

    return InkWell(
      onTap: () {
        onChanged(_togglePermission(permission.id));
      },
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.only(left: 36, right: 8, top: 4, bottom: 4),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Checkbox(
                value: isSelected,
                activeColor: AppColors.colorPrimario,
                onChanged: (_) {
                  onChanged(_togglePermission(permission.id));
                },
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                permission.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.colorTexto
                      : AppColors.colorTextoSecundario,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'No hay permisos disponibles',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.colorTextoSecundario,
          ),
        ),
      ),
    );
  }

  Widget _loadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 3; i++) ...[
            Container(
              width: 150,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.colorSuperficieAlta,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            for (var j = 0; j < 3; j++)
              Padding(
                padding: const EdgeInsets.only(left: 36, bottom: 4),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.colorSuperficieAlta.withValues(
                      alpha: 0.65,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
