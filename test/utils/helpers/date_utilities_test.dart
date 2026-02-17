import 'package:flutter_test/flutter_test.dart';
import 'package:elaros_mobile_app/utils/helpers/date_utilities.dart';

void main() {
  group('DateUtilities.getTimeString', () {
    test('returns hour and minute', () {
      final date = DateTime(2026, 2, 16, 14, 30);

      final result = DateUtilities.getTimeString(date);

      expect(result, '14:30');
    });

    test('does pad single digit values', () {
      final date = DateTime(2026, 2, 16, 4, 5);

      final result = DateUtilities.getTimeString(date);

      expect(result, '04:05');
    });
  });

  group('DateUtilities.getDateString', () {
    test('returns dd-mm-yyyy', () {
      final date = DateTime(2026, 2, 16);

      final result = DateUtilities.getDateString(date);

      expect(result, '16-02-2026');
    });
  });

  group('DateUtilities.getDateTimeString', () {
    test('combines date and time', () {
      final date = DateTime(2026, 2, 16, 12, 00);

      final result = DateUtilities.getDateTimeString(date);

      expect(result, '16-02-2026 12:00');
    });
  });

  group('DateUtilities.getDateTimeFromString', () {
    test('parses full date time string', () {
      final result = DateUtilities.getDateTimeFromString('16-02-2026 12:00');

      expect(result.year, 2026);
      expect(result.month, 2);
      expect(result.day, 16);
      expect(result.hour, 12);
      expect(result.minute, 00);
    });

    test('parses date only and defaults time to midnight', () {
      final result = DateUtilities.getDateTimeFromString('16-02-2026');

      expect(result.year, 2026);
      expect(result.month, 2);
      expect(result.day, 16);
      expect(result.hour, 0);
      expect(result.minute, 0);
    });

    test('throws when format is invalid (too many parts)', () {
      expect(
        () => DateUtilities.getDateTimeFromString('10-05-2026 12:30 extra'),
        throwsException,
      );
    });

    test('throws when date format is invalid', () {
      expect(
        () => DateUtilities.getDateTimeFromString('invalid-date'),
        throwsException,
      );
    });

    test('throws when time format is invalid', () {
      expect(
        () => DateUtilities.getDateTimeFromString('10-05-2026 invalid'),
        throwsException,
      );
    });
  });
}
