import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/data/local/model/user_goals_model.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';
import 'package:sqflite/sqflite.dart';

class UserGoalsService {
  static final UserGoalsService _instance = UserGoalsService._internal();
  factory UserGoalsService() => _instance;
  UserGoalsService._internal({Database? database}) {
    if (database != null) _database = database;
  }

  factory UserGoalsService.forTest(Database db) {
    return UserGoalsService._internal(database: db);
  }

  static Database? _database;
  static final String _tableName = 'UserGoals';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  // GETs
  Future<List<Map<String, dynamic>>> getUserGoals({String? goalName}) async {
    final db = await database;

    final String query = (goalName != null)
        ? '''
      SELECT 
        goalName, 
        dataSource, 
        goalValue
      FROM UserGoals
      WHERE
        userId = ?;
    '''
        : '''
      SELECT 
        goalName, 
        dataSource, 
        goalValue
      FROM UserGoals
      WHERE
        userId = ?
        AND goalName = ?;
        ''';

    final List<dynamic> queryParams = [defaultUserId];

    if (goalName != null) {
      queryParams.add(goalName);
    }

    final List<Map<String, dynamic>> userGoalList = await db.rawQuery(
      query,
      queryParams,
    );

    return userGoalList;
  }

  // POSTs
  Future<void> insertUserGoal(UserGoalModel userGoal) async {
    final db = await database;

    const String query = '''  
      INSERT OR REPLACE INTO UserGoals (
        userId,
        goalName, 
        dataSource, 
        goalValue
      ) VALUES (
        ?,
        ?, 
        ?, 
        ?
      );
    ''';

    await db.rawInsert(query, [
      defaultUserId,
      userGoal.goalName,
      userGoal.dataSource,
      userGoal.goalValue,
    ]);
  }

  // DELETEs
  Future<void> deleteUserGoal(UserGoalModel userGoal) async {
    final db = await database;

    const String query = '''  
      DELETE FROM UserGoals
      WHERE
        userId = ?
        AND goalName = ?
    ''';

    await db.rawDelete(query, [defaultUserId, userGoal.goalName]);
  }

  // UPDATEs
  Future<void> updateUserGoal(UserGoalModel userGoal) async {
    final db = await database;

    const String query = '''  
      UPDATE UserGoals SET
        goalName = ?,
        dataSource = ?,
        goalValue = ?
      WHERE
        userId = ?
        AND goalName = ?;
    ''';

    await db.rawUpdate(query, [
      userGoal.goalName,
      userGoal.dataSource,
      userGoal.goalValue,
      defaultUserId,
      userGoal.goalName,
    ]);
  }
}
