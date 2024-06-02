import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewSummaryPage extends StatefulWidget {
  const ViewSummaryPage({super.key});

  @override
  State<ViewSummaryPage> createState() => _ViewSummaryPageState();
}

class _ViewSummaryPageState extends State<ViewSummaryPage> {

  DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6* 30)),
      end: DateTime.now());

  late TextEditingController dateController= TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(selectedDateRange.start) +
          ' - ' +
          DateFormat('MM/dd/yyyy').format(selectedDateRange.end));

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
            "View Summary",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                    dateController.text = DateFormat('MM/dd/yyyy').format(pickedDate.start) +
                        ' - ' +
                        DateFormat('MM/dd/yyyy').format(pickedDate.end);
                  });
                }
              },
            ),
              ]
          ),
        )
    );
  }
}
