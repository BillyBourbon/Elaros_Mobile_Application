import 'package:elaros_mobile_app/data/local/model/grouped_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestHealthDataService
    extends BaseHealthDataService<Map<String, dynamic>> {
  final Database _db;

  TestHealthDataService(this._db)
    : super(tableName: 'test_data', timeColumn: 'time', valueColumn: 'value');

  @override
  Future<Database> get database async => _db;

  @override
  Map<String, dynamic> fromRawMap(Map<String, dynamic> map) => map;
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('BaseHealthDataService.getGroupedDataByHour', () {
    late Database db;
    late TestHealthDataService service;

    setUp(() async {
      db = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE test_data (
                time TEXT NOT NULL,
                value REAL NOT NULL
              )
            ''');
          },
        ),
      );

      service = TestHealthDataService(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('fills missing hours for a one day range', () async {
      final start = DateTime(2026, 4, 22);
      final end = start.add(const Duration(days: 1));

      await db.insert('test_data', {
        'time': DateTime(2026, 4, 22, 1, 5).toIso8601String(),
        'value': 50,
      });
      await db.insert('test_data', {
        'time': DateTime(2026, 4, 22, 1, 45).toIso8601String(),
        'value': 70,
      });
      await db.insert('test_data', {
        'time': DateTime(2026, 4, 22, 13, 15).toIso8601String(),
        'value': 90,
      });

      final results = await service.getGroupedDataByHour(start, end);

      expect(results, hasLength(24));
      expect(results.first.time, start);
      expect(results.last.time, DateTime(2026, 4, 22, 23));

      final oneAmBucket = results[1];
      expectGroupedModel(
        oneAmBucket,
        time: DateTime(2026, 4, 22, 1),
        entries: 2,
        total: 120,
        first: 50,
        last: 70,
        maximum: 70,
        minimum: 50,
        average: 60,
        median: 60,
      );

      expectGroupedModel(
        results[0],
        time: DateTime(2026, 4, 22),
        entries: 0,
        total: 0,
        first: 0,
        last: 0,
        maximum: 0,
        minimum: 0,
        average: 0,
        median: 0,
      );

      expectGroupedModel(
        results[13],
        time: DateTime(2026, 4, 22, 13),
        entries: 1,
        total: 90,
        first: 90,
        last: 90,
        maximum: 90,
        minimum: 90,
        average: 90,
        median: 90,
      );
    });

    test('uses an exclusive end boundary for seven day ranges', () async {
      final start = DateTime(2026, 4, 1);
      final end = start.add(const Duration(days: 7));

      await db.insert('test_data', {
        'time': DateTime(2026, 4, 1, 2, 15).toIso8601String(),
        'value': 10,
      });
      await db.insert('test_data', {
        'time': DateTime(2026, 4, 7, 23, 30).toIso8601String(),
        'value': 25,
      });
      await db.insert('test_data', {
        'time': end.toIso8601String(),
        'value': 999,
      });

      final results = await service.getGroupedDataByHour(start, end);

      expect(results, hasLength(168));
      expect(results.first.time, start);
      expect(results.last.time, DateTime(2026, 4, 7, 23));
      expect(results.where((group) => group.time == end), isEmpty);

      expect(results[2].entries, 1);
      expect(results[2].total, 10);
      expect(results.last.entries, 1);
      expect(results.last.total, 25);
    });
  });
}

void expectGroupedModel(
  GroupedModel actual, {
  required DateTime time,
  required int entries,
  required double total,
  required double first,
  required double last,
  required double maximum,
  required double minimum,
  required double average,
  required double median,
}) {
  expect(actual.time, time);
  expect(actual.entries, entries);
  expect(actual.total, total);
  expect(actual.first, first);
  expect(actual.last, last);
  expect(actual.maximum, maximum);
  expect(actual.minimum, minimum);
  expect(actual.average, average);
  expect(actual.median, median);
}
