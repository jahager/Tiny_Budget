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
                border: Border.all(),
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 200,
                      child: FutureBuilder(
                        future: LocalDatabase.getEntriesByDateRange(
                            selectedDateRange.start, selectedDateRange.end),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final entries = snapshot.data!;
                            // HERE IS THE ACTUAL LIST OF ENTRIES DISPLAYED
                            return ListView(
                              children: entries
                                  .map((entry) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(entry.toString()),
                                          Spacer(),
                                          IconButton(
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
                                              icon: Icon(Icons.delete))
                                        ],
                                      ))
                                  .toList(),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
