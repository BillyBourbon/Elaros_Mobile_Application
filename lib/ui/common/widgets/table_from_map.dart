import 'package:flutter/material.dart';

class TableFromMap extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const TableFromMap({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data found'));
    }

    final columns = data.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
        rows: data.map((row) {
          return DataRow(
            cells: columns.map((col) {
              return DataCell(Text(row[col]?.toString() ?? ''));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
