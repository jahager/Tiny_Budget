import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'entry_db.dart';

class ViewEntriesPage extends StatefulWidget {
  const ViewEntriesPage({super.key});

  @override
  State<ViewEntriesPage> createState() => _ViewEntriesPageState();
}

class _ViewEntriesPageState extends State<ViewEntriesPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        title: const Text(
          "View Entries",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
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
                    print(pickedDate);
                    setState(() {
                      selectedDateRange = pickedDate;
                      dateController.text =
                          DateFormat('MM/dd/yyyy').format(pickedDate.start) +
                              ' - ' +
                              DateFormat('MM/dd/yyyy').format(pickedDate.end);
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.primary,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 200,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height - 200,
                    child: FutureBuilder<List<Entry>>(
                      future: LocalDatabase.getEntriesByDateRange(selectedDateRange.start, selectedDateRange.end),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Entry> entries = snapshot.data!;
                          return SingleChildScrollView( // To make table scrollable if needed
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 8.0,
                              columnSpacing: 8.0,
                              columns: const [
                                DataColumn(label: Text("Delete")),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Paid To')),
                                DataColumn(label: Text('Category')),
                                DataColumn(label: Text('Notes')),
                                DataColumn(label: Text('Type')),
                              ],
                              rows: entries.map((entry) {
                                return DataRow(cells: [
                                  DataCell(IconButton(
                                      onPressed: () {
                                        Widget okButton =
                                        OutlinedButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            LocalDatabase.deleteEntry(
                                                entry);
                                            setState(() {});
                                            Navigator.pop(context);
                                            // Handle OK button press the dialog with a value (true for OK)
                                          },
                                        );

                                        Widget cancelButton =
                                        OutlinedButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Handle Cancel button press // Close the dialog with a value (false for Cancel)
                                          },
                                        );

                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Confirm Delete:"),
                                              content: Text(
                                                  entry.toString()),
                                              actions: [
                                                okButton,
                                                cancelButton,
                                              ],
                                            );
                                          },
                                        );

                                        //
                                      },
                                      icon: Icon(Icons.delete))),
                                  DataCell(Text(entry.getDate())),
                                  DataCell(Text("\$${entry.amount.toStringAsFixed(2)}")),
                                  DataCell(Text(entry.paidTo)),
                                  DataCell(Text(entry.category)),
                                  DataCell(Text(entry.notes)),
                                  DataCell(Text(entry.getType())),
                                ]);
                              }).toList(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  );
                },
                itemCount: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
