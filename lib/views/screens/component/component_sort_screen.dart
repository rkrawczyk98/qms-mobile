import 'package:flutter/material.dart';

class ComponentSortScreen extends StatefulWidget {
  final String? initialSortColumn;
  final String initialSortOrder;

  const ComponentSortScreen({
    this.initialSortColumn,
    this.initialSortOrder = 'ASC',
    super.key,
  });

  @override
  State<ComponentSortScreen> createState() => _ComponentSortScreenState();
}

class _ComponentSortScreenState extends State<ComponentSortScreen> {
  late String? sortColumn;
  late String sortOrder;

  @override
  void initState() {
    super.initState();
    sortColumn = widget.initialSortColumn;
    sortOrder = widget.initialSortOrder;
  }

  void _applySort() {
    Navigator.pop(context, {'column': sortColumn, 'order': sortOrder});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sort Components'),
        actions: [
          TextButton(
            onPressed: _applySort,
            child: const Text(
              'Apply',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: sortColumn,
              items: const [
                DropdownMenuItem(value: 'nameOne', child: Text('Name One')),
                DropdownMenuItem(
                    value: 'creationDate', child: Text('Creation Date')),
                DropdownMenuItem(
                    value: 'statusName', child: Text('Status Name')),
              ],
              onChanged: (value) => setState(() => sortColumn = value),
            ),
            DropdownButton<String>(
              value: sortOrder,
              items: const [
                DropdownMenuItem(value: 'ASC', child: Text('Ascending')),
                DropdownMenuItem(value: 'DESC', child: Text('Descending')),
              ],
              onChanged: (value) => setState(() => sortOrder = value!),
            ),
          ],
        ),
      ),
    );
  }
}
