import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

enum EntryType { payment, income }

class _AddEntryPageState extends State<AddEntryPage> {
  DateTime selectedDate = DateTime.now();
  final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final payToController = TextEditingController();
  final categoryController = TextEditingController();
  final notesController = TextEditingController();
  final amountController = TextEditingController();

  // Default to payment entry
  EntryType? _entryType = EntryType.payment;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    dateController.dispose();
    payToController.dispose();
    categoryController.dispose();
    notesController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _getText() {
    if (kDebugMode) {
      print("Date " + dateController.text);
      print("Paid to " + payToController.text);
      print("Category " + categoryController.text);
      print("Notes " + notesController.text);
      print("Amount " + amountController.text);
      String payType = _entryType == EntryType.payment ? "payment" : "income";
      print("Is " + payType);
    }

  }

  final ButtonStyle roundSquareStyle = OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))));

  @override
  Widget build(BuildContext context) {
    const double spaceBetweenInput = 16.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        title: const Text(
          "Add Entry",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              readOnly: true,
              controller: dateController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            const SizedBox(
              height: spaceBetweenInput,
            ),
            TextField(
              controller: payToController,
              decoration: InputDecoration(
                labelText: "Paid To",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(
              height: spaceBetweenInput,
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(
              height: spaceBetweenInput,
            ),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(
              height: spaceBetweenInput,
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "\$ Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(
              height: spaceBetweenInput,
            ),
            ListTile(
              title: const Text('Payment'),
              leading: Radio<EntryType>(
                value: EntryType.payment,
                groupValue: _entryType,
                onChanged: (EntryType? value) {
                  setState(() {
                    _entryType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Income'),
              leading: Radio<EntryType>(
                value: EntryType.income,
                groupValue: _entryType,
                onChanged: (EntryType? value) {
                  setState(() {
                    _entryType = value;
                  });
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top:42, bottom: 16),
                child: OutlinedButton(
                    style: roundSquareStyle,
                    onPressed: () {_getText();},
                    child:
                        const Text("Submit", style: TextStyle(fontSize: 32)))),
          ],
        ),
      )),
    );
  }
}
