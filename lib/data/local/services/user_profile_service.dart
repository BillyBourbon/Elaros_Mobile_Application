import 'package:elaros_mobile_app/data/local/model/user_profile_model.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';
import 'package:sqflite/sqflite.dart';

class UserProfileService {
  int defaultUserId = 1;
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal({Database? database}) {
    if (database != null) _database = database;
  }

  factory UserProfileService.forTest(Database db) {
    return UserProfileService._internal(database: db);
  }

  static Database? _database;
  static final String _tableName = 'UserProfile';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  // GETs
  Future<List<Map<String, dynamic>>> getUserProfile() async {
    final db = await database;

    const String query = '''
      SELECT 
        name, 
        age, 
        gender, 
        height, 
        weight, 
        profile_image_url, 
        medical_condition
      FROM UserProfile
      WHERE
        id = ?;
    ''';

    final List<Map<String, dynamic>> userProfileList = await db.rawQuery(
      query,
      [defaultUserId],
    );
    return userProfileList;
  }

  // POSTs
  Future<void> insertUserProfile(UserProfileModel userProfile) async {
    final db = await database;

    const String query = '''  
      INSERT OR REPLACE INTO UserProfile (
        id,
        name, 
        age, 
        gender, 
        height, 
        weight, 
        profile_image_url, 
        medical_condition
      ) VALUES (
        ?,
        ?, 
        ?, 
        ?, 
        ?, 
        ?, 
        ?, 
        ?
      );
    ''';

    await db.rawInsert(query, [
      defaultUserId,
      userProfile.name,
      userProfile.age,
      userProfile.gender,
      userProfile.height,
      userProfile.weight,
      userProfile.profileImageUrl,
      userProfile.medicalCondition,
    ]);
  }

  // DELETEs

  // UPDATEs
  Future<void> updateUserProfile(UserProfileModel userProfile) async {
    final db = await database;

    const String query = '''  
      UPDATE UserProfile SET
        name = ?,
        age = ?,
        gender = ?,
        height = ?,
        weight = ?,
        profile_image_url = ?,
        medical_condition = ?
      WHERE
        id = ?;
    ''';

    await db.rawUpdate(query, [
      userProfile.name,
      userProfile.age,
      userProfile.gender,
      userProfile.height,
      userProfile.weight,
      userProfile.profileImageUrl,
      userProfile.medicalCondition,
      defaultUserId,
    ]);
  }
}
