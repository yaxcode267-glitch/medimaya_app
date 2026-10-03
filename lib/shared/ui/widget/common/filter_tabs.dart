import 'package:flutter/material.dart';

// Themes
import '../../themes/app_colors.dart';

class FilterOption {
  final String value;
  final String label;
  final IconData? icon;

  const FilterOption({required this.value, required this.label, this.icon});
}

class AppFilterTabs extends StatelessWidget {
  final String filter;
  final List<FilterOption> options;
  final ValueChanged<String> onChanged;

  const AppFilterTabs({
    super.key,
    required this.filter,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        // En pantallas muy estrechas cada opción recibe poco ancho, así que se
        // compactan para que las etiquetas no se corten.
        final compact = box.maxWidth / options.length < 96;

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.colorFondo,
            border: Border.all(color: AppColors.colorOutlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              for (final option in options)
                Expanded(child: _option(option, compact: compact)),
            ],
          ),
        );
      },
    );
  }

  Widget _option(FilterOption option, {required bool compact}) {
    final selected = filter == option.value;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(option.value),
          borderRadius: BorderRadius.circular(8),
          hoverColor: selected
              ? Colors.transparent
              : AppColors.colorSuperficieAlta,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 6 : 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.colorPrimario : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    size: 16,
                    color: selected
                        ? Colors.white
                        : AppColors.colorTextoSecundario,
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: compact ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : AppColors.colorTextoSecundario,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
