import 'package:elaros_mobile_app/data/local/model/intensities_states_model.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';
import 'package:sqflite/sqflite.dart';

class IntensitiesStatesService {
  static final IntensitiesStatesService _instance =
      IntensitiesStatesService._internal();
  factory IntensitiesStatesService() => _instance;
  IntensitiesStatesService._internal({Database? database}) {
    if (database != null) _database = database;
  }

  factory IntensitiesStatesService.forTest(Database db) {
    return IntensitiesStatesService._internal(database: db);
  }

  static Database? _database;
  static final String _tableName = 'IntensitiesStates';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  // GETs
  Future<List<IntensityStatesModel>> getIntensityStates() async {
    final db = await database;

    final List<Map<String, dynamic>> intensityStatesList = await db.rawQuery('''
      SELECT 
        id, 
        value
      FROM $_tableName
      ''');

    return intensityStatesList
        .map((e) => IntensityStatesModel.fromMap(e))
        .toList();
  }
}
