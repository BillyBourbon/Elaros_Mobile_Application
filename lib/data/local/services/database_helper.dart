import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/heart_rate.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('heart_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // This creates the table if it doesn't exist
    await db.execute('''
      CREATE TABLE HeartRate (
        id INTEGER PRIMARY KEY,
        time TEXT NOT NULL,
        value INTEGER NOT NULL
      )
    ''');
  }

  // Fetch all heart rate records
  Future<List<HeartRate>> getAllHeartRates() async {
    final db = await instance.database;
    final result = await db.query('HeartRate', orderBy: 'time DESC');

    return result.map((json) => HeartRate.fromMap(json)).toList();
  }
}
