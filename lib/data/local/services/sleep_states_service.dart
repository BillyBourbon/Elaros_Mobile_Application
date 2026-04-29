import 'package:elaros_mobile_app/data/local/model/sleep_states_model.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';
import 'package:sqflite/sqflite.dart';

class SleepStatesService {
  static final SleepStatesService _instance = SleepStatesService._internal();
  factory SleepStatesService() => _instance;
  SleepStatesService._internal({Database? database}) {
    if (database != null) _database = database;
  }

  factory SleepStatesService.forTest(Database db) {
    return SleepStatesService._internal(database: db);
  }

  static Database? _database;
  static final String _tableName = 'SleepStates';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  // GETs
  Future<List<SleepStatesModel>> getSleepStates() async {
    final db = await database;

    final List<Map<String, dynamic>> intensityStatesList = await db.rawQuery('''
      SELECT 
        id, 
        value
      FROM $_tableName
      ''');

    return intensityStatesList.map((e) => SleepStatesModel.fromMap(e)).toList();
  }
}
