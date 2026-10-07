import 'package:flutter/material.dart';
import 'package:medimaya_app/shared/ui/widget/common/filter_tabs.dart';
import 'package:medimaya_app/shared/ui/widget/forms/input_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_form.dart';
import 'package:medimaya_app/shared/ui/widget/forms/select_option.dart';

class ClinicalListFilters extends StatelessWidget {
  const ClinicalListFilters({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.filter,
    required this.onFilter,
    required this.category,
    required this.onCategory,
    required this.categories,
    required this.searchHint,
    this.filterField,
  });
  final TextEditingController searchController;
  final ValueChanged<String> onSearch, onFilter, onCategory;
  final String filter, category, searchHint;
  final String? filterField;
  final List<String> categories;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final search = AppInput(
        name: 'Buscar',
        hint: searchHint,
        controller: searchController,
        prefixIcon: const Icon(Icons.search, size: 20),
        onChanged: onSearch,
      );
      final status = AppFilterTabs(
        filter: filter,
        options: const [
          FilterOption(value: 'all', label: 'Todos'),
          FilterOption(value: 'active', label: 'Activos'),
          FilterOption(value: 'inactive', label: 'Inactivos'),
        ],
        onChanged: onFilter,
      );
      final categorySelect = filterField == null
          ? null
          : AppSelect(
              key: ValueKey(category),
              name: filterField!,
              value: category,
              options: [
                const SelectOption(value: '', label: 'Todos'),
                for (final value in categories)
                  SelectOption(value: value, label: value),
              ],
              onChanged: onCategory,
            );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (box.maxWidth >= 800)
            Row(
              children: [
                Expanded(child: search),
                if (categorySelect != null) ...[
                  const SizedBox(width: 16),
                  Expanded(child: categorySelect),
                ],
                const SizedBox(width: 16),
                SizedBox(width: 300, child: status),
              ],
            )
          else ...[
            search,
            const SizedBox(height: 16),
            status,
            if (categorySelect != null) ...[
              const SizedBox(height: 16),
              categorySelect,
            ],
          ],
        ],
      );
    },
  );
}
