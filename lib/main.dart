import 'package:flutter/material.dart';
import 'package:tiny_budget/add_entry_page.dart';
import 'package:tiny_budget/budget_theme.dart';
import 'package:tiny_budget/view_entries_page.dart';
import 'package:tiny_budget/view_summary_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiny Budget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tiny Budget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ButtonStyle roundSquareStyle = OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
        title: Center(
            child: OutlineText(
          widget.title,
          fontSize: 48,
          outlineWidth: 6,
          withGradient: true,
        )),
      ),
      body: Center(
        // 3 Buttons Add Entry, View Entries, View Summary
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              Expanded(
                  flex: 10,
                  child: OutlinedButton(
                      style: roundSquareStyle,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddEntryPage()));
                      },
                      child: const FittedBox(
                        fit: BoxFit.fill,
                        child: OutlineText(
                          "Add",
                          fontSize: 68,
                          outlineWidth: 4,
                        ),
                      ))),
              const Spacer(),
              Expanded(
                  flex: 10,
                  child: OutlinedButton(
                      style: roundSquareStyle,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewEntriesPage()));
                      },
                      child: const FittedBox(
                        fit: BoxFit.fitWidth,
                        child: OutlineText(
                          "View",
                          fontSize: 68,
                          outlineWidth: 4,
                        ),
                      ))),
              const Spacer(),
              Expanded(
                  flex: 10,
                  child: OutlinedButton(
                      style: roundSquareStyle,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewSummaryPage()));
                      },
                      child: const FittedBox(
                          fit: BoxFit.fill,
                          child: OutlineText(
                            "Summary",
                            fontSize: 68,
                            outlineWidth: 4,
                          )))),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
