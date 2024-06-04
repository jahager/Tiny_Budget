import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'entry_db.dart';

class PieChartByCategory extends StatelessWidget {
  final List<Entry> entries;

  const PieChartByCategory({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group the entries by category and sum the amounts
    Map<String, double> categoryAmounts = {};
    for (Entry entry in entries) {
      if (!categoryAmounts.containsKey(entry.category)) {
        categoryAmounts[entry.category] = 0.0;
      }

      categoryAmounts[entry.category] = sum(entry.amount, categoryAmounts[entry.category]);
    }

    // Create a list of PieChartSectionData objects
    List<PieChartSectionData> pieChartSections = [];
    for (String category in categoryAmounts.keys) {
      pieChartSections.add(
        PieChartSectionData(
          value: categoryAmounts[category],
          color: Colors.primaries[(categoryAmounts.keys.toList().indexOf(category) % Colors.primaries.length)],
          radius: 100,
          title: "${category.toString()}: ${categoryAmounts[category]}",
          titleStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),

          showTitle: true
        ),
      );
    }

    // Create the PieChart widget
    return PieChart(
      PieChartData(
        sections: pieChartSections,
        centerSpaceRadius: 2,
      ),

    );
  }
}

class CategoryLegend extends StatelessWidget {
  final List<Entry> entries;

  const CategoryLegend({Key? key, required this.entries}) : super(key: key);

  Row _buildRow(String key, double value) {
    return Row(
      children: [
        Text(key, style: TextStyle(fontSize: 32),),
        Spacer(),
        Text("\$ ${value.toStringAsFixed(2)}", style: TextStyle(fontSize: 32),), // Convert double value to string
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    Map<String, double> categoryAmounts = {};
    for (Entry entry in entries) {
      if (!categoryAmounts.containsKey(entry.category)) {
        categoryAmounts[entry.category] = 0.0;
      }

      categoryAmounts[entry.category] = sum(entry.amount, categoryAmounts[entry.category]);
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(16.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: categoryAmounts.entries.map((entry) => _buildRow(entry.key, entry.value)).toList(),
        ),
      ),
    );
  }
}


double sum(a, b) {
  return a + b;
}
