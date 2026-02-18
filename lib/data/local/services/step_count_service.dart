import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';
import 'package:sqflite/sqflite.dart';

class StepCountService {
  static final StepCountService _instance = StepCountService._internal();
  factory StepCountService() => _instance;
  StepCountService._internal({Database? database}) {
    if (database != null) _database = database;
  }

  factory StepCountService.forTest(Database db) {
    return StepCountService._internal(database: db);
  }

  static Database? _database;
  static final String _tableName = 'StepCount';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  // GETs
  Future<List<Map<String, dynamic>>> getStepCountByDayLastNDays(
    int days,
  ) async {
    final db = await database;

    const String query = '''
      SELECT 
        strftime('%Y-%m-%d', unixepoch(sc.timestamp), 'unixepoch', 'utc') AS day, 
        SUM(sc.steps) AS total_steps
      FROM StepCount sc
      WHERE
        sc.timestamp >= ?
      GROUP BY 
        day
      ORDER BY 
        day ASC;
    ''';

    final List<Map<String, dynamic>> stepCountList = await db.rawQuery(query, [
      clock.now().subtract(Duration(days: days)).toIso8601String(),
    ]);

    return stepCountList;
  }
}
