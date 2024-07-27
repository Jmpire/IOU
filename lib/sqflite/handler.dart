import 'package:projectx/sqflite/create_database.dart';
import 'package:projectx/views/add.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = "iou.db";
  static const int _databaseVersion = 1;

  static String table = Add.title == 'Add OUMe' ? 'UOMe' : 'IOU';
  static const String columnId = '_id';
  static const String columnName = 'name';
  static const String columnContact = 'contact';
  static const String columnEmail = 'email';
  static const String columnDescription = 'description';
  static const String columnAmount = 'amount';
  static const String columnStartDate = 'start_date';
  static const String columnDeadline = 'deadline';
  static const String columnNotes = 'notes';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database instance
  late Database _database;

  // Initialize database
  Future<void> initDatabase() async {
    _database = await _initDatabase();
  }

  // Get database instance
  Database get database {
    return _database;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onOpen: (db) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tablesCreated', true);
      _createTables(db, 'IOU');
      _createTables(db, 'UOMe');
    });
  }

  // Create tables
  Future<void> _createTables(Database db, String table) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnContact INTEGER,
        $columnEmail TEXT,
        $columnDescription TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnStartDate TEXT NOT NULL,
        $columnDeadline TEXT,
        $columnNotes TEXT
      )
    ''');
  }
}

// insert data
void insert(
    String table,
    String name,
    int contact,
    String email,
    String description,
    double amount,
    String startdate,
    String deadline,
    String notes) async {
  final db = await openMyDatabase();
  await db.insert(
    table,
    {
      '_id': email,
      'name': name,
      'contact': contact,
      'email': email,
      'description': description,
      'amount': amount,
      'start_date': startdate,
      'deadline': deadline,
      'notes': notes
    },
  );
}

// update
void update(String table) async {
  final db = await openMyDatabase();
  await db.update(
    table,
    {
      'column1': 'new_value1',
      'column2': 43,
    },
    where: '_id = ?',
    whereArgs: [1],
  );
}

// delete
void delete(String table, String email) async {
  final db = await openMyDatabase();
  await db.delete(
    table,
    where: '_id = ?',
    whereArgs: [email],
  );
}


