import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'entry_db.dart';

class CategoryLineChart extends StatefulWidget {
  final List<Entry> entries;
  final DateTimeRange dateRange;
  final String category;
  const CategoryLineChart({super.key, required this.entries, required this.dateRange, required this.category});

  @override
  State<CategoryLineChart> createState() => _CategoryLineChartState();
}

class _CategoryLineChartState extends State<CategoryLineChart> {
  late List<Entry> entries;
  late DateTimeRange dateRange;
  late String category;
  List<FlSpot> coord = [];

  late double minX;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  @override
  void initState() {
    super.initState();
    entries = widget.entries;
    dateRange = widget.dateRange;
    category = widget.category;
    // Guarantee correct category
    entries = entries.where((item) => item.category == category).toList();
    // Sort by date
    entries.sort((a, b) => a.date.compareTo(b.date));
    minX = entries[0].getDateAsInt().toDouble();

    // Subtract payments and add Budget income
    if (entries[0].type){
      entries[0].amount *= -1;
    }
    for (var i = 1; i < entries.length; i++) {
      if (entries[i].type){
        entries[i].amount *= -1;
      }
      entries[i].amount += entries[i-1].amount;
    }

    // Set graph extents
    for (Entry entry in entries) {
      double date = entry.getDateAsInt().toDouble();
      double amount = entry.amount;
      if (date > maxX) {
        maxX = date;
      }
      if (date < minX) {
        minX = date;
      }
      if (amount > maxY) {
        maxY = amount;
      }
      if (amount < minY) {
        minY = amount;
      }
      coord.add(FlSpot(date, amount));
    }

    // Guarantee correct date range
    entries = entries.where((item) => dateRange.start.isBefore(item.date)).toList();
    
    // Add white space to top of graph
    maxY *= 1.3;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Theme.of(context).colorScheme.primaryFixedDim,
      Theme.of(context).colorScheme.primary,
    ];

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.black,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.black,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: coord,
                    isCurved: false,
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.63))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // X axis labels
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    text = Text(DateFormat('MM-dd').format(date), style: style);

    if (meta.min == meta.max || (value != meta.min && value != meta.max)) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        angle: 0.5,
        child: text,
      );
    } else {
      return Container();
    }
  }

  // Y axis labels
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    double third = meta.max > 0 ? meta.max / 3 : meta.min / 3;
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value % third.toInt() == 0) {
      text = "\$${value.toStringAsFixed(0)}";
    } else {
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
