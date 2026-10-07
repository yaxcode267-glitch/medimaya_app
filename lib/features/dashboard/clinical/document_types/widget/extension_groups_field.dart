import 'package:flutter/material.dart';

import '../model/extension_groups.dart';

import 'package:medimaya_app/shared/ui/themes/app_colors.dart';

class ExtensionGroupsField extends StatefulWidget {
  const ExtensionGroupsField({super.key, this.initialValue, this.onChanged});
  final String? initialValue;
  final ValueChanged<Set<String>>? onChanged;

  @override
  State<ExtensionGroupsField> createState() => _ExtensionGroupsFieldState();
}

class _ExtensionGroupsFieldState extends State<ExtensionGroupsField> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = (widget.initialValue ?? '')
        .split(',')
        .map((extension) => extension.trim().toLowerCase())
        .where((extension) => extension.isNotEmpty)
        .toSet();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Extensiones permitidas',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      const Text('Selecciona un grupo completo o formatos individuales.'),
      for (final group in documentExtensionGroups.entries) ...[
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.colorPrimario,
          title: Text(group.key),
          tristate: true,
          value: group.value.every(_selected.contains)
              ? true
              : group.value.any(_selected.contains)
              ? null
              : false,
          onChanged: (_) => setState(() {
            if (group.value.every(_selected.contains)) {
              _selected.removeAll(group.value);
            } else {
              _selected.addAll(group.value);
            }
            widget.onChanged?.call(Set.of(_selected));
          }),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final extension in group.value)
              FilterChip(
                label: Text(extension.toUpperCase()),
                selectedColor: AppColors.colorPrimarioContainer,
                selected: _selected.contains(extension),
                onSelected: (selected) => setState(() {
                  if (selected) {
                    _selected.add(extension);
                  } else {
                    _selected.remove(extension);
                  }
                  widget.onChanged?.call(Set.of(_selected));
                }),
              ),
          ],
        ),
      ],
      const SizedBox(height: 12),
      Text(
        _selected.isEmpty
            ? 'Ninguna extensión seleccionada'
            : 'Permitidas: ${_selected.join(', ')}',
      ),
    ],
  );
}
