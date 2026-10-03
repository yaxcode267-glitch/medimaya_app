import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import 'app_empty_state.dart';

class TableColumn {
  final String key;
  final String label;
  final TextAlign align;

  const TableColumn({
    required this.key,
    required this.label,
    this.align = TextAlign.left,
  });
}

class AppDataTable extends StatefulWidget {
  final List<TableColumn> columns;
  final List<Map<String, dynamic>> rows;
  final bool loading;
  final bool striped;
  final String emptyText;
  final IconData? emptyIcon;
  final Future<void> Function()? reload;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.loading = false,
    this.striped = true,
    this.emptyText = 'Sin datos para mostrar',
    this.emptyIcon,
    this.reload,
  });

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  final _verticalController = ScrollController();
  final _horizontalController = ScrollController();

  Alignment _align(TextAlign align) {
    return switch (align) {
      TextAlign.center => Alignment.center,
      TextAlign.right => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };
  }

  Widget _emptyState() {
    return AppEmptyState(message: widget.emptyText, icon: widget.emptyIcon);
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.columns;
    final rows = widget.rows;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorFondo,
        border: Border.all(color: AppColors.colorOutlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: widget.loading
                ? const Center(child: CircularProgressIndicator())
                : rows.isEmpty
                ? Center(child: _emptyState())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Scrollbar(
                        thumbVisibility: true,
                        controller: _verticalController,
                        child: SingleChildScrollView(
                          controller: _verticalController,
                          scrollDirection: Axis.vertical,
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: _horizontalController,
                            notificationPredicate: (notification) =>
                                notification.depth == 1,
                            child: SingleChildScrollView(
                              controller: _horizontalController,
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                ),
                                child: DataTable(
                                  headingRowHeight: 56,
                                  dataRowMinHeight: 56,
                                  dataRowMaxHeight: 56,
                                  columnSpacing: 32,
                                  horizontalMargin: 20,
                                  showBottomBorder: true,
                                  headingRowColor: WidgetStateProperty.all(
                                    AppColors.colorPrimario,
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: AppColors.colorSuperficieAlta,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  dataTextStyle: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.colorTexto,
                                  ),
                                  columns: [
                                    for (final column in columns)
                                      DataColumn(
                                        label: Align(
                                          alignment: _align(column.align),
                                          child: Text(column.label),
                                        ),
                                      ),
                                  ],
                                  rows: [
                                    for (var i = 0; i < rows.length; i++)
                                      DataRow(
                                        color: widget.striped && i.isOdd
                                            ? WidgetStateProperty.all(
                                                AppColors.colorFondoBajo,
                                              )
                                            : null,
                                        cells: [
                                          for (final column in columns)
                                            DataCell(
                                              Align(
                                                alignment: _align(column.align),
                                                child:
                                                    rows[i][column.key]
                                                        is Widget
                                                    ? rows[i][column.key]
                                                    : Text(
                                                        rows[i][column.key]
                                                                ?.toString() ??
                                                            '—',
                                                      ),
                                              ),
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.reload != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: widget.loading ? null : widget.reload,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Recargar'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
