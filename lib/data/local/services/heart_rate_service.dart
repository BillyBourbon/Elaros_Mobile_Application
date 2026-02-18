import 'package:clock/clock.dart';
import 'package:sqflite/sqflite.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';

class HeartRateService {
  static final HeartRateService _instance = HeartRateService._internal();
  factory HeartRateService() => _instance;
  HeartRateService._internal({Database? database}) {
    if (database != null) _database = database;
  }

  factory HeartRateService.forTest(Database db) {
    return HeartRateService._internal(database: db);
  }

  static Database? _database;
  static final String _tableName = 'HeartRate';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  // GETs

  /// Get all heart rate data from the database bewteen the given dates (inclusive)
  Future<List<Map<String, dynamic>>> getHeartRateBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;

    final List<Map<String, dynamic>> heartRateList = await db.query(
      _tableName,
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return heartRateList;
  }

  /// Get all heart rate data from the database bewteen the current date and [days] ago
  Future<List<Map<String, dynamic>>> getHeartRateLastNDays(int days) async {
    final db = await database;

    final List<Map<String, dynamic>> heartRateList = await db.query(
      _tableName,
      where: 'timestamp >= ?',
      whereArgs: [clock.now().subtract(Duration(days: days)).toIso8601String()],
    );

    return heartRateList;
  }

  /// Get all heart rate data from the database bewteen the current date and [hours] ago
  Future<List<Map<String, dynamic>>> getHeartRateLastNHours(int hours) async {
    final db = await database;

    final List<Map<String, dynamic>> heartRateList = await db.query(
      _tableName,
      where: 'timestamp >= ?',
      whereArgs: [
        clock.now().subtract(Duration(hours: hours)).toIso8601String(),
      ],
    );

    return heartRateList;
  }
}
