import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Tasks.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'my_database.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskName TEXT,
      time TEXT
    )
  ''');
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final Database db = await database;
    return db.query('tasks');
  }

  Future<int> insertTask(Task task) async {
    final Database db = await database;
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
