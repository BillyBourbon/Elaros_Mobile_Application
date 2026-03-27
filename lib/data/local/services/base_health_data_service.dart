import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/grouped_model.dart';
import 'package:elaros_mobile_app/utils/database/db.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseHealthDataService<RawModel> {
  // db infomation
  final String tableName;
  final String timeColumn;
  final String valueColumn;

  BaseHealthDataService({
    required this.tableName,
    required this.timeColumn,
    required this.valueColumn,
  });

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.openDatabaseFromAssets();
    return _database!;
  }

  RawModel fromRawMap(Map<String, dynamic> map);

  /// GETs

  /// Get the latest entry from the database
  /// Returns raw data entry
  Future<RawModel?> getLatestEntry() async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT 
        $timeColumn as time,
        $valueColumn as value
      FROM $tableName
      ORDER BY $timeColumn DESC
      LIMIT 1
      ''', []);

    if (results.isEmpty) return null;

    return fromRawMap(results.first);
  }

  /// Get all data from the database bewteen the given dates (inclusive)
  /// Returns raw data entries
  Future<List<RawModel>> getRawData(DateTime start, DateTime? end) async {
    end ??= clock.now();

    final db = await database;

    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT 
        $timeColumn as time,
        $valueColumn as value
      FROM $tableName
      WHERE $timeColumn BETWEEN ? AND ?
      ORDER BY $timeColumn ASC
      ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return results.map((map) => fromRawMap(map)).toList();
  }

  /// Get all data from the database bewteen the given dates (inclusive)
  /// Grouped by minute
  Future<List<GroupedModel>> getRawDataGroupedByMinute(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();

    final db = await database;

    final String query =
        '''
      WITH minutely AS (
        SELECT
          strftime('%Y-%m-%d %H:%M', $timeColumn) AS time,
          $timeColumn AS timestamp,
          $valueColumn AS value
        FROM $tableName
        WHERE $timeColumn BETWEEN ? AND ?
      ),
      ranked AS (
        SELECT
          time,
          timestamp,
          value,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp ASC) AS rn_asc,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp DESC) AS rn_desc,
          COUNT(*) OVER (PARTITION BY time) AS cnt
        FROM minutely
      )
      SELECT
        time,
        COUNT(*) AS entries,
        SUM(value) AS total,
        MAX(CASE WHEN rn_asc = 1 THEN value END) AS first,
        MAX(CASE WHEN rn_desc = 1 THEN value END) AS last,
        MAX(value) AS maximum,
        MIN(value) AS minimum,
        AVG(value) AS average,
        AVG(CASE 
              WHEN rn_asc IN ((cnt + 1)/2, (cnt + 2)/2)
              THEN value 
            END) AS median
      FROM ranked
      GROUP BY time
      ORDER BY time DESC;
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, [
      start.toIso8601String(),
      end.toIso8601String(),
    ]);

    return results.map((map) => GroupedModel.fromMap(map)).toList();
  }

  /// Get all data from the database bewteen the given dates (inclusive)
  /// Grouped by hour
  Future<List<GroupedModel>> getGroupedDataByHour(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();

    final db = await database;

    final String query =
        '''
      WITH hourly AS (
        SELECT
          strftime('%Y-%m-%d %H:00', $timeColumn) AS time,
          $timeColumn AS timestamp,
          $valueColumn AS value
        FROM $tableName
        WHERE $timeColumn BETWEEN ? AND ?
      ),
      ranked AS (
        SELECT
          time,
          timestamp,
          value,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp ASC) AS rn_asc,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp DESC) AS rn_desc,
          COUNT(*) OVER (PARTITION BY time) AS cnt
        FROM hourly
      )
      SELECT
        time,
        COUNT(*) AS entries,
        SUM(value) AS total,
        MAX(CASE WHEN rn_asc = 1 THEN value END) AS first,
        MAX(CASE WHEN rn_desc = 1 THEN value END) AS last,
        MAX(value) AS maximum,
        MIN(value) AS minimum,
        AVG(value) AS average,
        AVG(CASE 
              WHEN rn_asc IN ((cnt + 1)/2, (cnt + 2)/2)
              THEN value 
            END) AS median
      FROM ranked
      GROUP BY time
      ORDER BY time DESC;
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, [
      start.toIso8601String(),
      end.toIso8601String(),
    ]);

    return results.map((map) => GroupedModel.fromMap(map)).toList();
  }

  /// Get all data from the database bewteen the given dates (inclusive)
  /// Grouped by day
  Future<List<GroupedModel>> getGroupedDataByDay(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();

    final db = await database;

    final String query =
        '''
      WITH dayly AS (
        SELECT
          strftime('%Y-%m-%d', $timeColumn) AS time,
          $timeColumn AS timestamp,
          $valueColumn AS value
        FROM $tableName
        WHERE $timeColumn BETWEEN ? AND ?
      ),
      ranked AS (
        SELECT
          time,
          timestamp,
          value,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp ASC) AS rn_asc,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp DESC) AS rn_desc,
          COUNT(*) OVER (PARTITION BY time) AS cnt
        FROM dayly
      )
      SELECT
        time,
        COUNT(*) AS entries,
        SUM(value) AS total,
        MAX(CASE WHEN rn_asc = 1 THEN value END) AS first,
        MAX(CASE WHEN rn_desc = 1 THEN value END) AS last,
        MAX(value) AS maximum,
        MIN(value) AS minimum,
        AVG(value) AS average,
        AVG(CASE 
              WHEN rn_asc IN ((cnt + 1)/2, (cnt + 2)/2)
              THEN value 
            END) AS median
      FROM ranked
      GROUP BY time
      ORDER BY time DESC;
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, [
      start.toIso8601String(),
      end.toIso8601String(),
    ]);

    return results.map((map) => GroupedModel.fromMap(map)).toList();
  }

  /// Get all data from the database bewteen the given dates (inclusive)
  /// Grouped by month
  Future<List<GroupedModel>> getGroupedDataByMonth(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();

    final db = await database;

    final String query =
        '''
      WITH monthly AS (
        SELECT
          strftime('%Y-%m', $timeColumn) AS time,
          $timeColumn AS timestamp,
          $valueColumn AS value
        FROM $tableName
        WHERE $timeColumn BETWEEN ? AND ?
      ),
      ranked AS (
        SELECT
          time,
          timestamp,
          value,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp ASC) AS rn_asc,
          ROW_NUMBER() OVER (PARTITION BY time ORDER BY timestamp DESC) AS rn_desc,
          COUNT(*) OVER (PARTITION BY time) AS cnt
        FROM monthly
      )
      SELECT
        time,
        COUNT(*) AS entries,
        SUM(value) AS total,
        MAX(CASE WHEN rn_asc = 1 THEN value END) AS first,
        MAX(CASE WHEN rn_desc = 1 THEN value END) AS last,
        MAX(value) AS maximum,
        MIN(value) AS minimum,
        AVG(value) AS average,
        AVG(CASE 
              WHEN rn_asc IN ((cnt + 1)/2, (cnt + 2)/2)
              THEN value 
            END) AS median
      FROM ranked
      GROUP BY time
      ORDER BY time DESC;
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, [
      start.toIso8601String(),
      end.toIso8601String(),
    ]);

    return results.map((map) => GroupedModel.fromMap(map)).toList();
  }
}
