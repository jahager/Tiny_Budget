import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'budget_theme.dart';
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

  bool sortAscending = true;
  int sortColumnIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        title: const OutlineText(
          "Budget Items",
          withGradient: true,
          fontSize: 32,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
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
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2),
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
                      future: LocalDatabase.getEntriesByDateRange(
                          selectedDateRange.start, selectedDateRange.end),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (sortColumnIndex) {
                            case 1:
                              if (sortAscending) {
                                snapshot.data!
                                    .sort((a, b) => a.date.compareTo(b.date));
                              } else {
                                snapshot.data!
                                    .sort((b, a) => a.date.compareTo(b.date));
                              }
                              break;
                            case 2:
                              if (sortAscending) {
                                snapshot.data!.sort(
                                    (a, b) => a.amount.compareTo(b.amount));
                              } else {
                                snapshot.data!.sort(
                                    (b, a) => a.amount.compareTo(b.amount));
                              }
                              break;
                            case 3:
                              if (sortAscending) {
                                snapshot.data!.sort(
                                    (a, b) => a.paidTo.compareTo(b.paidTo));
                              } else {
                                snapshot.data!.sort(
                                    (b, a) => a.paidTo.compareTo(b.paidTo));
                              }
                              break;
                            case 4:
                              if (sortAscending) {
                                snapshot.data!.sort(
                                    (a, b) => a.category.compareTo(b.category));
                              } else {
                                snapshot.data!.sort(
                                    (b, a) => a.category.compareTo(b.category));
                              }
                              break;
                            case 5:
                              if (sortAscending) {
                                snapshot.data!
                                    .sort((a, b) => a.notes.compareTo(b.notes));
                              } else {
                                snapshot.data!
                                    .sort((b, a) => a.notes.compareTo(b.notes));
                              }
                              break;
                            case 6:
                              if (sortAscending) {
                                snapshot.data!.sort((a, b) => a.type ? 1 : -1);
                              } else {
                                snapshot.data!.sort((a, b) => a.type ? -1 : 1);
                              }
                              break;
                          }

                          List<Entry> entries = snapshot.data!;
                          return SingleChildScrollView(
                            // To make table scrollable if needed
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              sortAscending: sortAscending,
                              sortColumnIndex: sortColumnIndex,
                              horizontalMargin: 8.0,
                              columnSpacing: 8.0,
                              columns: [
                                const DataColumn(label: Text("Delete")),
                                DataColumn(
                                    label: const Text('Date'),
                                    onSort: (colIndex, ascending) {
                                      setState(() {
                                        sortColumnIndex = 1;
                                        sortAscending = !sortAscending;
                                      });
                                    }),
                                DataColumn(
                                    label: const Text('Amount'),
                                    onSort: (colIndex, ascending) {
                                      setState(() {
                                        sortColumnIndex = 2;
                                        sortAscending = !sortAscending;
                                      });
                                    }),
                                DataColumn(
                                    label: const Text('Paid To'),
                                    onSort: (colIndex, ascending) {
                                      setState(() {
                                        sortColumnIndex = 3;
                                        sortAscending = !sortAscending;
                                      });
                                    }),
                                DataColumn(
                                    label: const Text('Category'),
                                    onSort: (colIndex, ascending) {
                                      setState(() {
                                        sortColumnIndex = 4;
                                        sortAscending = !sortAscending;
                                      });
                                    }),
                                DataColumn(
                                    label: const Text('Notes'),
                                    onSort: (colIndex, ascending) {
                                      setState(() {
                                        sortColumnIndex = 5;
                                        sortAscending = !sortAscending;
                                      });
                                    }),
                                DataColumn(
                                    label: const Text('Type'),
                                    onSort: (colIndex, ascending) {
                                      setState(() {
                                        sortColumnIndex = 6;
                                        sortAscending = !sortAscending;
                                      });
                                    }),
                              ],
                              rows: entries.map((entry) {
                                return DataRow(cells: [
                                  DataCell(IconButton(
                                      onPressed: () {
                                        Widget okButton = OutlinedButton(
                                          child: const Text("Delete"),
                                          onPressed: () {
                                            LocalDatabase.deleteEntry(entry);
                                            setState(() {});
                                            Navigator.pop(context);
                                            // Handle OK button press the dialog with a value (true for OK)
                                          },
                                        );

                                        Widget cancelButton = OutlinedButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Handle Cancel button press // Close the dialog with a value (false for Cancel)
                                          },
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Confirm Delete:"),
                                              content: Text(entry.toString()),
                                              actions: [
                                                okButton,
                                                cancelButton,
                                              ],
                                            );
                                          },
                                        );

                                        //
                                      },
                                      icon: const Icon(Icons.delete))),
                                  DataCell(Text(entry.getDate())),
                                  DataCell(Text(
                                      "\$${entry.amount.toStringAsFixed(2)}")),
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
