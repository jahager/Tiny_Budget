import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiny_budget/entry_chart.dart';

import 'budget_theme.dart';
import 'entry_db.dart';
import 'line_chart.dart';

class ViewSummaryPage extends StatefulWidget {
  const ViewSummaryPage({super.key});

  @override
  State<ViewSummaryPage> createState() => _ViewSummaryPageState();
}

class _ViewSummaryPageState extends State<ViewSummaryPage> {
  late List<Entry> entries = [];

  DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6 * 30)),
      end: DateTime.now());

  late TextEditingController dateController = TextEditingController(
      text:
          '${DateFormat('MM/dd/yyyy').format(selectedDateRange.start)} - ${DateFormat('MM/dd/yyyy').format(selectedDateRange.end)}');

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    dateController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    entries = await LocalDatabase.getEntriesByDateRange(
        selectedDateRange.start, selectedDateRange.end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
          title: const OutlineText(
            "Budget Summary",
            withGradient: true,
            fontSize: 32,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Date Range",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    readOnly: true,
                    controller: dateController,
                    onTap: () async {
                      DateTimeRange? pickedDate = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDateRange = pickedDate;
                          dateController.text =
                              '${DateFormat('MM/dd/yyyy').format(pickedDate.start)} - ${DateFormat('MM/dd/yyyy').format(pickedDate.end)}';
                          _updateData();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 170,
              width: double.infinity,
              child: ListView(children: [
                const Center(
                    child: OutlineText("Spending", withGradient: true)),
                FutureBuilder<List<Entry>>(
                  future: LocalDatabase.getEntriesByDateRange(
                      selectedDateRange.start, selectedDateRange.end),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        null != snapshot.data &&
                        snapshot.data!.isNotEmpty) {
                      return Column(children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: PieChartByCategory(
                            entries: snapshot.data!,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CategoryLegend(entries: snapshot.data!)
                      ]);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (null == snapshot.data ||
                        snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                              "No Budget Entries for ${dateController.text}"));
                    } else {
                      return Container();
                    }
                  },
                ),
                const Center(
                    child: OutlineText(
                  "Budgets",
                  withGradient: true,
                )),
                FutureBuilder<Set<String>>(
                    future: LocalDatabase.getCategories(),
                    builder: (context, categories) {
                      if (categories.hasData) {
                        List<Widget> graphs = [];

                        for (String category in categories.data!) {
                          graphs.add(Row(
                            children: [
                              OutlineText(
                                category,
                                fontSize: 24,
                              ),
                            ],
                          ));
                          graphs.add(FutureBuilder<List<Entry>>(
                              future: LocalDatabase.recallEntries(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return LineChartCatEntries(
                                    entries: snapshot.data!,
                                    dateRange: selectedDateRange,
                                    category: category,
                                  );
                                } else {
                                  return Container();
                                }
                              }));
                        }
                        return Column(
                          children: graphs,
                        );
                      } else {
                        return Container();
                      }
                    }),
              ]),
            ),
          ]),
        ));
  }
}
