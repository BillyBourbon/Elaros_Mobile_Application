import 'package:sqflite/sqflite.dart';
import 'package:elaros_mobile_app/utils/database/db.dart' as app_db;
import '../model/heart_rate.dart';

/// Convenience wrapper that delegates to the app-level DatabaseHelper
/// (which loads the pre-populated health_lite.db from assets).
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database => app_db.DatabaseHelper.database;

  Future<List<HeartRate>> getAllHeartRates() async {
    final db = await database;
    final result = await db.query('HeartRate', orderBy: 'timestamp DESC');
    return result.map((row) => HeartRate.fromMap(row)).toList();
  }
}
