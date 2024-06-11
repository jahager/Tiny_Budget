import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Entry {
  int id;
  DateTime date;
  String paidTo;
  String category;
  String notes;
  double amount;
  bool type;

  Entry(
      this.date, this.paidTo, this.category, this.notes, this.amount, this.type,
      [this.id = 0]);

  String getDate() {
    return DateFormat('yyyy-MM-dd').format(date).toString();
  }

  int getDateAsInt() {
      return date.millisecondsSinceEpoch;
  }

  String getType() {
    return type ? "Payment" : "Budget";
  }

  @override
  String toString() {
    return "${DateFormat('yyyy-MM-dd').format(date)}, To:$paidTo, Cat:$category, \$$amount";
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    bool type;
    if (json['type'].runtimeType == int) {
      // Convert the integer to a boolean
      type = json['type'] == 1;
    } else {
      // Cast the value to a boolean
      type = json['type'] as bool;
    }
    return Entry(
        DateTime.parse(json['date']),
        json['paidTo'] as String,
        json['category'] as String,
        json['notes'] as String,
        json['amount'] as double,
        type,
        json['id'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'paidTo': paidTo,
      'category': category,
      'notes': notes,
      'amount': amount,
      'type': type,
      'id': id
    };
  }
}

class LocalDatabase {
  // Database name
  static const String databaseName = 'entries.db';

  // Table name
  static const String entriesTable = 'entries';

  // Initialize the database
  static Future<Database> initializeDatabase() async {
    // Get the path to the database file
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);

    // Open the database
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the entries table
        await db.execute('''
          CREATE TABLE $entriesTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            paidTo TEXT,
            category TEXT,
            notes TEXT,
            amount REAL,
            type BOOL
          )
        ''');
      },
    );

    // Return the database
    return database;
  }

  // Save a list of entries to the local database
  static Future<void> saveEntries(List<Entry> entries) async {
    // Get the database
    Database database = await initializeDatabase();

    // Insert each entry into the database
    for (Entry entry in entries) {
      await database.insert(
        entriesTable,
        entry.toJson()..remove("id"),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Recall the list of entries from the local database
  static Future<List<Entry>> recallEntries() async {
    // Get the database
    Database database = await initializeDatabase();

    // Query the entries table
    List<Map<String, dynamic>> entriesJson = await database.query(entriesTable);

    // Convert the JSON maps to Entry objects
    List<Entry> entries =
        entriesJson.map((entryJson) => Entry.fromJson(entryJson)).toList();

    // Return the list of entries
    return entries;
  }

  // Get set of Categories
  static Future<List<String>> getCategories() async{
    // Get the database
    Database database = await initializeDatabase();

    const String sql = 'SELECT DISTINCT category FROM entries';
    final List<Map<String, dynamic>> maps = await database.rawQuery(sql);
    return maps.map((map) => map['category'] as String).toList();
  }

  // Get Paid To list of names
  static Future<List<String>> getPaidTo() async{
    // Get the database
    Database database = await initializeDatabase();

    const String sql = 'SELECT DISTINCT paidTo FROM entries';
    final List<Map<String, dynamic>> maps = await database.rawQuery(sql);
    return maps.map((map) => map['paidTo'] as String).toList();
  }

  static Future<List<Entry>> getEntriesByDateRange(
      DateTime startDate, DateTime endDate) async {
    // Get the database
    Database database = await initializeDatabase();

    // Query the database for entries within the date range
    List<Map<String, dynamic>> entries = await database.query(
      entriesTable,
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    // Convert the entries to Entry objects
    List<Entry> entryList =
        entries.map((entry) => Entry.fromJson(entry)).toList();

    // Return the list of entries
    return entryList;
  }

  static Future<List<Entry>> getSpendingByDateRange(
      DateTime startDate, DateTime endDate) async {
    // Get the database
    Database database = await initializeDatabase();

    // Query the database for entries within the date range
    List<Map<String, dynamic>> entries = await database.query(
      entriesTable,
      where: 'date >= ? AND date <= ? AND type == 1',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    // Convert the entries to Entry objects
    List<Entry> entryList =
    entries.map((entry) => Entry.fromJson(entry)).toList();

    // Return the list of entries
    return entryList;
  }

  static Future<void> deleteEntry(Entry entry) async {
    final db = await initializeDatabase();
    await db.delete(
      'entries',
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }
}
