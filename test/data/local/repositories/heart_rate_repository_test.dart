import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elaros_mobile_app/data/local/model/heart_rate_model.dart';
import 'package:elaros_mobile_app/data/local/services/heart_rate_service.dart';
import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';

@GenerateMocks([HeartRateService])
import 'heart_rate_repository_test.mocks.dart';

void main() {
  late MockHeartRateService mockService;
  late HeartRateRepository repository;

  setUp(() {
    mockService = MockHeartRateService();
    repository = HeartRateRepository.forTest(mockService);
  });

  group('HeartRateRepository Tests', () {
    final testDate = DateTime.now();

    final mockData = [
      {'id': 1, 'date': testDate.toIso8601String(), 'value': 72.5},
      {
        'id': 1,
        'date': testDate.subtract(const Duration(hours: 1)).toIso8601String(),
        'value': 75.0,
      },
    ];

    test('getHeartRateBetweenDates returns list of HeartRateModel', () async {
      when(
        mockService.getHeartRateBetweenDates(any, any),
      ).thenAnswer((_) async => mockData);

      final result = await repository.getHeartRateBetweenDates(
        testDate.subtract(const Duration(hours: 2)),
        testDate,
      );

      expect(result.length, 2);
      expect(result.first, isA<HeartRateModel>());
      expect(result.first.value, 72.5);
      verify(
        mockService.getHeartRateBetweenDates(any, any),
      ).called(1);
    });

    test('getHeartRateLastNDays returns list of HeartRateModel', () async {
      when(
        mockService.getHeartRateLastNDays(any),
      ).thenAnswer((_) async => mockData);

      final result = await repository.getHeartRateLastNDays(3);

      expect(result.length, 2);
      expect(result.first.id, 1);
      verify(mockService.getHeartRateLastNDays(3)).called(1);
    });

    test('getHeartRateLastNHours returns list of HeartRateModel', () async {
      when(
        mockService.getHeartRateLastNHours(any),
      ).thenAnswer((_) async => mockData);

      final result = await repository.getHeartRateLastNHours(5);

      expect(result.length, 2);
      expect(result[1].value, 75.0);
      verify(mockService.getHeartRateLastNHours(5)).called(1);
    });
  });
}