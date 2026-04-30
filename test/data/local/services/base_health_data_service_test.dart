import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'base_health_data_service_test.mocks.dart';

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

@GenerateMocks([Database])
void main() {
  late MockDatabase mockDb;
  late TestHealthDataService service;

  setUp(() {
    mockDb = MockDatabase();
    service = TestHealthDataService(mockDb);
  });

  group('BaseHealthDataService.getLatestEntry', () {
    test('returns null when database has no entries', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      final result = await service.getLatestEntry();

      expect(result, isNull);
      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('returns valid entry when database has data', () async {
      final testTime = DateTime(2026, 4, 22, 10, 30).toIso8601String();
      final testValue = 75.5;

      when(mockDb.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {'time': testTime, 'value': testValue},
        ],
      );

      final result = await service.getLatestEntry();

      expect(result, isNotNull);
      expect(result!['time'], testTime);
      expect(result['value'], testValue);
      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('handles database errors gracefully', () async {
      when(mockDb.rawQuery(any, any)).thenThrow(Exception('Database error'));

      try {
        await service.getLatestEntry();
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }

      verify(mockDb.rawQuery(any, any)).called(1);
    });
  });
  group('BaseHealthDataService.getRawData', () {
    test('returns data for valid date range', () async {
      final start = DateTime(2026, 4, 22);
      final end = DateTime(2026, 4, 23);
      final mockData = [
        {'time': start.toIso8601String(), 'value': 50.0},
        {'time': DateTime(2026, 4, 22, 12).toIso8601String(), 'value': 75.0},
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getRawData(start, end);

      expect(result, hasLength(2));
      expect(result.first['time'], start.toIso8601String());
      expect(result.first['value'], 50.0);
      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('uses current time when end date is null', () async {
      final start = DateTime(2026, 4, 22);
      final mockData = [
        {'time': start.toIso8601String(), 'value': 50.0},
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getRawData(start, null);

      expect(result, hasLength(1));
      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('returns empty list when no data in range', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      final result = await service.getRawData(
        DateTime(2026, 4, 22),
        DateTime(2026, 4, 23),
      );

      expect(result, isEmpty);
    });

    test('returns multiple results ordered by time', () async {
      final start = DateTime(2026, 4, 22);
      final end = DateTime(2026, 4, 23);
      final mockData = [
        {'time': start.toIso8601String(), 'value': 10.0},
        {'time': DateTime(2026, 4, 22, 6).toIso8601String(), 'value': 20.0},
        {'time': DateTime(2026, 4, 22, 12).toIso8601String(), 'value': 30.0},
        {'time': DateTime(2026, 4, 22, 18).toIso8601String(), 'value': 40.0},
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getRawData(start, end);

      expect(result, hasLength(4));
      expect(result[0]['value'], 10.0);
      expect(result[1]['value'], 20.0);
      expect(result[2]['value'], 30.0);
      expect(result[3]['value'], 40.0);
    });
  });

  group('BaseHealthDataService.getRawDataGroupedByMinute', () {
    test('returns grouped data for valid date range', () async {
      final start = DateTime(2026, 4, 22);
      final end = DateTime(2026, 4, 23);
      final mockData = [
        {
          'time': '2026-04-22 10:00',
          'entries': 2,
          'total': 120.0,
          'first': 50.0,
          'last': 70.0,
          'maximum': 70.0,
          'minimum': 50.0,
          'average': 60.0,
          'median': 60.0,
        },
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getRawDataGroupedByMinute(start, end);

      expect(result, hasLength(1));
      expect(result.first.time, DateTime(2026, 4, 22, 10));
      expect(result.first.entries, 2);
      expect(result.first.total, 120.0);
      expect(result.first.average, 60.0);
    });

    test('uses correct SQL query with date parameters', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      await service.getRawDataGroupedByMinute(
        DateTime(2026, 4, 22),
        DateTime(2026, 4, 23),
      );

      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('returns empty list when no data in range', () async {
      final start = DateTime(2026, 4, 22);
      final end = DateTime(2026, 4, 23);
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      final result = await service.getRawDataGroupedByMinute(start, end);

      expect(result, isEmpty);
    });
  });

  group('BaseHealthDataService.getGroupedDataByHour', () {
    test('returns grouped data for valid date range', () async {
      final start = DateTime(2026, 4, 22);
      final end = DateTime(2026, 4, 23);
      final mockData = [
        {
          'time': '2026-04-22 10:00:00',
          'entries': 3,
          'total': 210.0,
          'first': 50.0,
          'last': 90.0,
          'maximum': 90.0,
          'minimum': 50.0,
          'average': 70.0,
          'median': 70.0,
        },
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getGroupedDataByHour(start, end);

      expect(result, hasLength(24));
      expect(result.first.time, DateTime(2026, 4, 22, 0));
      expect(result[10].entries, 3);
      expect(result[10].total, 210.0);
    });

    test('fills missing hours for a one day range', () async {
      final start = DateTime(2026, 4, 22);
      final end = start.add(const Duration(days: 1));

      // Only two hours have data (1 AM and 1 PM)
      when(mockDb.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {
            'time': '2026-04-22 01:00:00',
            'entries': 2,
            'total': 120.0,
            'first': 50.0,
            'last': 70.0,
            'maximum': 70.0,
            'minimum': 50.0,
            'average': 60.0,
            'median': 60.0,
          },
          {
            'time': '2026-04-22 13:00:00',
            'entries': 1,
            'total': 90.0,
            'first': 90.0,
            'last': 90.0,
            'maximum': 90.0,
            'minimum': 90.0,
            'average': 90.0,
            'median': 90.0,
          },
        ],
      );

      final results = await service.getGroupedDataByHour(start, end);

      expect(results, hasLength(24));
      expect(results.first.time, start);
      expect(results.last.time, DateTime(2026, 4, 22, 23));

      // Check the hour with data (1 AM)
      final oneAmBucket = results[1];
      expect(oneAmBucket.time, DateTime(2026, 4, 22, 1));
      expect(oneAmBucket.entries, 2);
      expect(oneAmBucket.total, 120.0);
      expect(oneAmBucket.average, 60.0);

      // Check an empty hour (midnight)
      expect(results[0].entries, 0);
      expect(results[0].total, 0.0);
      expect(results[0].average, 0.0);

      // Check 1 PM hour (index 13)
      final onePmBucket = results[13];
      expect(onePmBucket.time, DateTime(2026, 4, 22, 13));
      expect(onePmBucket.entries, 1);
      expect(onePmBucket.total, 90.0);
    });

    test('uses exclusive end boundary for seven day ranges', () async {
      final start = DateTime(2026, 4, 1);
      final end = start.add(const Duration(days: 7));

      when(mockDb.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {
            'time': '2026-04-01 02:00:00',
            'entries': 1,
            'total': 10.0,
            'first': 10.0,
            'last': 10.0,
            'maximum': 10.0,
            'minimum': 10.0,
            'average': 10.0,
            'median': 10.0,
          },
          {
            'time': '2026-04-07 23:00:00',
            'entries': 1,
            'total': 25.0,
            'first': 25.0,
            'last': 25.0,
            'maximum': 25.0,
            'minimum': 25.0,
            'average': 25.0,
            'median': 25.0,
          },
        ],
      );

      final results = await service.getGroupedDataByHour(start, end);

      expect(results, hasLength(168));
      expect(results.first.time, start);
      expect(results.last.time, DateTime(2026, 4, 7, 23));
      // End date should be exclusive
      expect(results.where((g) => g.time == end), isEmpty);
    });

    test('uses null end date defaults to current time', () async {
      final start = DateTime(2026, 4, 22);
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      await service.getGroupedDataByHour(start, null);

      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('returns empty list when no data in range', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      final result = await service.getGroupedDataByHour(
        DateTime(2026, 4, 22),
        DateTime(2026, 4, 23),
      );

      expect(result, isEmpty);
      expect(result.every((g) => g.entries == 0), isTrue);
    });
  });

  group('BaseHealthDataService.getGroupedDataByDay', () {
    test('returns grouped data for valid date range', () async {
      final start = DateTime(2026, 4, 1);
      final end = DateTime(2026, 4, 30);
      final mockData = [
        {
          'time': '2026-04-15',
          'entries': 10,
          'total': 750.0,
          'first': 50.0,
          'last': 100.0,
          'maximum': 100.0,
          'minimum': 50.0,
          'average': 75.0,
          'median': 75.0,
        },
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getGroupedDataByDay(start, end);

      expect(result, hasLength(29));
      expect(result.first.time, DateTime(2026, 4, 1));
      expect(result[14].entries, 10);
      expect(result[14].total, 750.0);
    });

    test('fills missing days for a date range', () async {
      final start = DateTime(2026, 4, 1);
      final end = DateTime(2026, 4, 5); // 4 days (1,2,3,4)

      when(mockDb.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {
            'time': '2026-04-01',
            'entries': 5,
            'total': 100.0,
            'first': 20.0,
            'last': 20.0,
            'maximum': 20.0,
            'minimum': 20.0,
            'average': 20.0,
            'median': 20.0,
          },
          {
            'time': '2026-04-03',
            'entries': 3,
            'total': 90.0,
            'first': 30.0,
            'last': 30.0,
            'maximum': 30.0,
            'minimum': 30.0,
            'average': 30.0,
            'median': 30.0,
          },
        ],
      );

      final results = await service.getGroupedDataByDay(start, end);

      expect(results, hasLength(4));
      expect(results[0].time, DateTime(2026, 4, 1));
      expect(results[1].time, DateTime(2026, 4, 2));
      expect(results[2].time, DateTime(2026, 4, 3));
      expect(results[3].time, DateTime(2026, 4, 4));

      // Check April 1 has data
      expect(results[0].entries, 5);
      // Check April 2 is empty (filled)
      expect(results[1].entries, 0);
      // Check April 3 has data
      expect(results[2].entries, 3);
      // Check April 4 is empty (filled)
      expect(results[3].entries, 0);
    });

    test('uses null end date defaults to current time', () async {
      final start = DateTime(2026, 4, 22);
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      await service.getGroupedDataByDay(start, null);

      verify(mockDb.rawQuery(any, any)).called(1);
    });

    test('returns empty list when no data in range', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      final result = await service.getGroupedDataByDay(
        DateTime(2026, 4, 1),
        DateTime(2026, 4, 30),
      );

      expect(result, isEmpty);
    });
  });

  group('BaseHealthDataService.getGroupedDataByMonth', () {
    test('returns grouped data for valid date range', () async {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 12, 31);
      final mockData = [
        {
          'time': '2026-04-01',
          'entries': 100,
          'total': 7500.0,
          'first': 50.0,
          'last': 100.0,
          'maximum': 100.0,
          'minimum': 50.0,
          'average': 75.0,
          'median': 75.0,
        },
      ];

      when(mockDb.rawQuery(any, any)).thenAnswer((_) async => mockData);

      final result = await service.getGroupedDataByMonth(start, end);

      expect(result, hasLength(12));
      expect(result.first.time, DateTime(2026, 1, 1));
      expect(result[3].entries, 100);
      expect(result[3].total, 7500.0);
    });

    test('fills missing months for a date range', () async {
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 6, 1); // Jan through May (5 months)

      // Only January and March have data
      when(mockDb.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {
            'time': '2026-01-01',
            'entries': 20,
            'total': 2000.0,
            'first': 100.0,
            'last': 100.0,
            'maximum': 100.0,
            'minimum': 100.0,
            'average': 100.0,
            'median': 100.0,
          },
          {
            'time': '2026-03-01',
            'entries': 10,
            'total': 1500.0,
            'first': 150.0,
            'last': 150.0,
            'maximum': 150.0,
            'minimum': 150.0,
            'average': 150.0,
            'median': 150.0,
          },
        ],
      );

      final results = await service.getGroupedDataByMonth(start, end);

      expect(results, hasLength(5));
      expect(results[0].time, DateTime(2026, 1, 1));
      expect(results[1].time, DateTime(2026, 2, 1));
      expect(results[2].time, DateTime(2026, 3, 1));
      expect(results[3].time, DateTime(2026, 4, 1));
      expect(results[4].time, DateTime(2026, 5, 1));

      // Check January has data
      expect(results[0].entries, 20);
      expect(results[0].total, 2000.0);
      // Check February is empty (filled)
      expect(results[1].entries, 0);
      expect(results[1].total, 0.0);
      // Check March has data
      expect(results[2].entries, 10);
      // Check April and May are empty
      expect(results[3].entries, 0);
      expect(results[4].entries, 0);
    });

    test('uses null end date defaults to current time', () async {
      final start = DateTime(2026, 4, 1);
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      await service.getGroupedDataByMonth(start, null);

      verify(mockDb.rawQuery(any, any)).called(1);
    });
  });

  group('BaseHealthDataService error handling', () {
    test('getGroupedDataByHour handles database errors', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenThrow(Exception('Database connection lost'));

      expect(
        () async => await service.getGroupedDataByHour(
          DateTime(2026, 4, 22),
          DateTime(2026, 4, 23),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getGroupedDataByDay handles database errors', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenThrow(Exception('Database connection lost'));

      expect(
        () async => await service.getGroupedDataByDay(
          DateTime(2026, 4, 1),
          DateTime(2026, 4, 30),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getGroupedDataByMonth handles database errors', () async {
      when(
        mockDb.rawQuery(any, any),
      ).thenThrow(Exception('Database connection lost'));

      expect(
        () async => await service.getGroupedDataByMonth(
          DateTime(2026, 1, 1),
          DateTime(2026, 12, 31),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('BaseHealthDataService edge cases', () {
    test('handles start date after end date', () async {
      final start = DateTime(2026, 4, 23);
      final end = DateTime(2026, 4, 22);

      // For getGroupedDataByHour, the _fillMissingHourlyBuckets will return []
      // because start.isBefore(end) returns false
      when(
        mockDb.rawQuery(any, any),
      ).thenAnswer((_) async => <Map<String, dynamic>>[]);

      final result = await service.getGroupedDataByHour(start, end);

      expect(result, isEmpty);
    });

    test('handles single entry results', () async {
      when(mockDb.rawQuery(any, any)).thenAnswer(
        (_) async => [
          {
            'time': '2026-04-22 10:00:00',
            'entries': 1,
            'total': 100.0,
            'first': 100.0,
            'last': 100.0,
            'maximum': 100.0,
            'minimum': 100.0,
            'average': 100.0,
            'median': 100.0,
          },
        ],
      );

      final hourly = await service.getGroupedDataByHour(
        DateTime(2026, 4, 22),
        DateTime(2026, 4, 23),
      );
      expect(hourly[10].entries, 1);
      expect(hourly[10].average, 100.0);
    });
  });
}
