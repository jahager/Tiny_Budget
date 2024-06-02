import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewEntriesPage extends StatefulWidget {
  const ViewEntriesPage({super.key});

  @override
  State<ViewEntriesPage> createState() => _ViewEntriesPageState();
}

class _ViewEntriesPageState extends State<ViewEntriesPage> {

  DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6* 30)),
      end: DateTime.now());

  late TextEditingController dateController;


  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    dateController.dispose();
    super.dispose();
  }

  void _getText() {
    if (kDebugMode) {
      print("Date " + dateController.text);
    }

  }

  @override
  Widget build(BuildContext context) {

    String startDateString = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 6* 30)));
    String endDateString = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Concatenate the formatted dates into a single string.
    String dateRangeString = '$startDateString - $endDateString';
    var dateController = TextEditingController(
        text: dateRangeString);

    return Scaffold(
      body: ListView(
        children: [
          TextField(
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
                });
              }
            },
          ),
        ],
      )
    );
  }
}
