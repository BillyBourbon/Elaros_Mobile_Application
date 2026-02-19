import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:elaros_mobile_app/data/local/services/heart_rate_service.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late HeartRateService heartRateService;
  late Database testDb;

  setUp(() async {
    testDb = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE HeartRate (
            id INTEGER,
            timestamp TEXT NOT NULL,
            value INTEGER NOT NULL
          )
        ''');
        },
      ),
    );

    heartRateService = HeartRateService.forTest(testDb);

    var data = [
      {
        'id': 1,
        'timestamp': DateTime.now()
            .subtract(Duration(days: 1))
            .toIso8601String(),
        'value': 70,
      },
      {
        'id': 1,
        'timestamp': DateTime.now()
            .subtract(Duration(hours: 2))
            .toIso8601String(),
        'value': 85,
      },
      {
        'id': 1,
        'timestamp': DateTime.now()
            .subtract(Duration(hours: 5))
            .toIso8601String(),
        'value': 78,
      },
    ];

    for (var item in data) {
      await testDb.insert('HeartRate', item);
    }
  });

  tearDown(() async {
    await testDb.close();
    await databaseFactory.deleteDatabase(inMemoryDatabasePath);
  });

  test('getHeartRateLastNDays returns correct entries', () async {
    final results = await heartRateService.getHeartRateLastNDays(1);

    expect(results.length, 2);

    final values = results.map((e) => e['value']).toList();
    expect(values, containsAll([85, 78]));
  });

  test('getHeartRateLastNHours returns correct entries', () async {
    final results = await heartRateService.getHeartRateLastNHours(3);
    expect(results.length, 1);
    expect(results.first['value'], 85);
  });

  test('getHeartRateBetweenDates returns correct entries', () async {
    final start = DateTime.now().subtract(Duration(hours: 6));
    final end = DateTime.now();
    final results = await heartRateService.getHeartRateBetweenDates(start, end);
    expect(results.length, 2);

    final values = results.map((e) => e['value']).toList();
    expect(values, containsAll([85, 78]));
  });
}
