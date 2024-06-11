import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'budget_theme.dart';
import 'entry_db.dart';

class SpendingPieChart extends StatelessWidget {
  final List<Entry> entries;

  const SpendingPieChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    // Group the entries by category and sum the amounts
    Map<String, double> categoryAmounts = {};
    for (Entry entry in entries) {
      if (!categoryAmounts.containsKey(entry.category)) {
        categoryAmounts[entry.category] = 0.0;
      }

      if (entry.type) {
        categoryAmounts[entry.category] = entry.amount + categoryAmounts[entry.category]!;
      }
    }

    final totalSpend = categoryAmounts.values.toList().reduce((a, b) => a + b);

    // Create a list of PieChartSectionData objects
    List<PieChartSectionData> pieChartSections = [];
    for (String category in categoryAmounts.keys) {
      pieChartSections.add(
        PieChartSectionData(
            value: categoryAmounts[category],
            color: getComplementaryColors(
                Theme.of(context).colorScheme.primary,
                categoryAmounts
                    .length)[categoryAmounts.keys.toList().indexOf(category)],
            radius: 100,
            title:
                "${(categoryAmounts[category]! / totalSpend * 100).toInt()}% ${category.toString()}",
            titlePositionPercentageOffset: 0.75,
            titleStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            showTitle: true),
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

  const CategoryLegend({super.key, required this.entries});
  Row _buildRow(String key, double value, Color color) {
    return Row(
      children: [
        OutlineText(
          key,
          fontSize: 32,
          color: [color],
          outlineWidth: 2.5,
        ),
        const Spacer(),
        OutlineText("\$ ${value.toStringAsFixed(2)}",
            fontSize: 32,
            color: [color],
            outlineWidth: 2.5), // Convert double value to string
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

      if (entry.type) {
        categoryAmounts[entry.category] = entry.amount + categoryAmounts[entry.category]!;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: categoryAmounts.entries
            .map((entry) => _buildRow(
                entry.key,
                entry.value,
                getComplementaryColors(Theme.of(context).colorScheme.primary,
                        categoryAmounts.length)[
                    categoryAmounts.keys.toList().indexOf(entry.key)]))
            .toList(),
      ),
    );
  }
}

List<Color> getComplementaryColors(Color color, int count) {
  HSVColor hsvColor = HSVColor.fromColor(color);

  List<Color> colors = [];
  colors.add(hsvColor.toColor());

  for (int i = 1; i < count; i++) {
    double complementaryHue = (hsvColor.hue + 180 ~/ (count - 1)) % 360;
    hsvColor = HSVColor.fromAHSV(hsvColor.alpha, complementaryHue,
        hsvColor.saturation, hsvColor.saturation);
    colors.add(hsvColor.toColor());
  }
  return colors;
}
