import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiny_budget/entry_chart.dart';

import 'budget_theme.dart';
import 'entry_db.dart';

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
    print(entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
          title: const Text(
            "View Summary",
            style: TextStyle(fontWeight: FontWeight.bold),
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IntrinsicHeight(
                    child: OutlinedButton(
                        style: roundSquareStyle,
                        onPressed: () {
                          _updateData();
                        },
                        child:
                            const Text("Get", style: TextStyle(fontSize: 16))),
                  ),
                ),
              ],
            ),
            SizedBox( height: 8,),
            Flexible(
                fit: FlexFit.loose,
                child: FutureBuilder<List<Entry>>(
                  future: LocalDatabase.getEntriesByDateRange(
                      selectedDateRange.start, selectedDateRange.end),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: PieChartByCategory(
                            entries: snapshot.data!,
                          ),
                        ),
                        Text("Hello listview")
                      ]);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )),
          ]),
        ));
  }
}
