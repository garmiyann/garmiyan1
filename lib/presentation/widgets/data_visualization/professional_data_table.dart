import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Professional Data Table Widget
///
/// Enterprise-level data table component with sorting, filtering,
/// pagination, and professional styling capabilities.
class ProfessionalDataTable<T> extends StatefulWidget {
  final List<T> data;
  final List<DataTableColumn<T>> columns;
  final DataTableStyle style;
  final bool sortable;
  final bool filterable;
  final bool paginated;
  final int itemsPerPage;
  final Function(T)? onRowTap;
  final Widget? emptyStateWidget;
  final bool showRowNumbers;
  final bool alternateRowColors;

  const ProfessionalDataTable({
    super.key,
    required this.data,
    required this.columns,
    this.style = DataTableStyle.standard,
    this.sortable = true,
    this.filterable = false,
    this.paginated = false,
    this.itemsPerPage = 10,
    this.onRowTap,
    this.emptyStateWidget,
    this.showRowNumbers = false,
    this.alternateRowColors = true,
  });

  @override
  State<ProfessionalDataTable<T>> createState() =>
      _ProfessionalDataTableState<T>();
}

class _ProfessionalDataTableState<T> extends State<ProfessionalDataTable<T>> {
  List<T> _filteredData = [];
  String _sortColumnKey = '';
  bool _sortAscending = true;
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(widget.data);
  }

  @override
  void didUpdateWidget(ProfessionalDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _filteredData = List.from(widget.data);
      _applyCurrentFilter();
      _applyCurrentSort();
    }
  }

  void _applyCurrentFilter() {
    if (_searchController.text.isEmpty) {
      _filteredData = List.from(widget.data);
    } else {
      _filteredData = widget.data.where((item) {
        return widget.columns.any((column) {
          final value = column.value(item);
          return value.toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              );
        });
      }).toList();
    }
  }

  void _applyCurrentSort() {
    if (_sortColumnKey.isNotEmpty) {
      final column = widget.columns.firstWhere(
        (col) => col.key == _sortColumnKey,
      );
      _filteredData.sort((a, b) {
        final valueA = column.value(a);
        final valueB = column.value(b);

        int comparison;
        if (valueA is Comparable && valueB is Comparable) {
          comparison = valueA.compareTo(valueB);
        } else {
          comparison = valueA.toString().compareTo(valueB.toString());
        }

        return _sortAscending ? comparison : -comparison;
      });
    }
  }

  void _onSort(String columnKey) {
    setState(() {
      if (_sortColumnKey == columnKey) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnKey = columnKey;
        _sortAscending = true;
      }
      _applyCurrentSort();
    });
  }

  void _onSearch(String query) {
    setState(() {
      _applyCurrentFilter();
      _applyCurrentSort();
      _currentPage = 0;
    });
  }

  List<T> _getPaginatedData() {
    if (!widget.paginated) return _filteredData;

    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex =
        (startIndex + widget.itemsPerPage).clamp(0, _filteredData.length);

    return _filteredData.sublist(startIndex, endIndex);
  }

  int get _totalPages => widget.paginated
      ? (_filteredData.length / widget.itemsPerPage).ceil()
      : 1;

  @override
  Widget build(BuildContext context) {
    final displayData = _getPaginatedData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.filterable) _buildSearchBar(),
        Expanded(
          child: displayData.isEmpty
              ? _buildEmptyState()
              : _buildDataTable(displayData),
        ),
        if (widget.paginated && _totalPages > 1) _buildPagination(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.outline,
            width: 1,
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: 'Search data...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return widget.emptyStateWidget ??
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.table_chart_outlined,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: AppDimensions.spacingMedium),
              Text(
                'No data available',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildDataTable(List<T> data) {
    switch (widget.style) {
      case DataTableStyle.standard:
        return _buildStandardTable(data);
      case DataTableStyle.compact:
        return _buildCompactTable(data);
      case DataTableStyle.detailed:
        return _buildDetailedTable(data);
    }
  }

  Widget _buildStandardTable(List<T> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          sortColumnIndex: _sortColumnKey.isNotEmpty
              ? widget.columns.indexWhere((col) => col.key == _sortColumnKey)
              : null,
          sortAscending: _sortAscending,
          showCheckboxColumn: false,
          headingRowColor: WidgetStateProperty.all(
            AppColors.surface.withOpacity(0.8),
          ),
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          columns: [
            if (widget.showRowNumbers)
              const DataColumn(
                label: Text('#'),
                numeric: true,
              ),
            ...widget.columns.map((column) {
              return DataColumn(
                label: Text(
                  column.label,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onSort: widget.sortable && column.sortable
                    ? (_, __) => _onSort(column.key)
                    : null,
                numeric: column.numeric,
              );
            }),
          ],
          rows: data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEvenRow = index % 2 == 0;

            return DataRow(
              color: widget.alternateRowColors && !isEvenRow
                  ? WidgetStateProperty.all(
                      AppColors.surfaceVariant.withOpacity(0.3),
                    )
                  : null,
              onSelectChanged: widget.onRowTap != null
                  ? (_) => widget.onRowTap!(item)
                  : null,
              cells: [
                if (widget.showRowNumbers)
                  DataCell(
                    Text(
                      '${_currentPage * widget.itemsPerPage + index + 1}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ...widget.columns.map((column) {
                  final value = column.value(item);
                  return DataCell(
                    column.cellBuilder?.call(context, item, value) ??
                        Text(
                          value.toString(),
                          style: AppTextStyles.bodyMedium,
                        ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCompactTable(List<T> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMedium,
            vertical: AppDimensions.spacingSmall,
          ),
          child: ListTile(
            onTap:
                widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
            title: Text(
              widget.columns.first.value(item).toString(),
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: widget.columns.length > 1
                ? Text(
                    widget.columns[1].value(item).toString(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
            trailing: widget.columns.length > 2
                ? Text(
                    widget.columns.last.value(item).toString(),
                    style: AppTextStyles.bodySmall,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildDetailedTable(List<T> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.all(AppDimensions.spacingMedium),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          child: InkWell(
            onTap:
                widget.onRowTap != null ? () => widget.onRowTap!(item) : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.columns.map((column) {
                  final value = column.value(item);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingSmall,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            '${column.label}:',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                              column.cellBuilder?.call(context, item, value) ??
                                  Text(
                                    value.toString(),
                                    style: AppTextStyles.bodyMedium,
                                  ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${_currentPage * widget.itemsPerPage + 1}-'
            '${(_currentPage * widget.itemsPerPage + _getPaginatedData().length)}'
            ' of ${_filteredData.length}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_currentPage + 1} / $_totalPages',
                style: AppTextStyles.bodyMedium,
              ),
              IconButton(
                onPressed: _currentPage < _totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Data Table Column Configuration
class DataTableColumn<T> {
  final String key;
  final String label;
  final dynamic Function(T) value;
  final bool sortable;
  final bool numeric;
  final Widget Function(BuildContext, T, dynamic)? cellBuilder;

  const DataTableColumn({
    required this.key,
    required this.label,
    required this.value,
    this.sortable = true,
    this.numeric = false,
    this.cellBuilder,
  });
}

enum DataTableStyle { standard, compact, detailed }
