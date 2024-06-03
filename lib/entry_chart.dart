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
          titleStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),

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

double sum(a, b) {
  return a + b;
}
