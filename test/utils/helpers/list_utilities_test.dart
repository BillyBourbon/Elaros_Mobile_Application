import 'package:elaros_mobile_app/utils/helpers/list_utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListUtilities', () {
    test('takeEvenSpreadSample with empty list returns empty list', () {
      final result = ListUtilities.takeEvenSpreadSample<int>([], 10);
      expect(result, isEmpty);
    });

    test(
      'takeEvenSpreadSample(10) with single element returns list with one element',
      () {
        final result = ListUtilities.takeEvenSpreadSample<int>([1], 10);
        expect(result, hasLength(1));
        expect(result.first, 1);
      },
    );

    test(
      'takeEvenSpreadSample(2) with two elements returns list with two elements',
      () {
        final result = ListUtilities.takeEvenSpreadSample<int>([1, 2], 2);
        expect(result, hasLength(2));
        expect(result.first, 1);
        expect(result[1], 2);
      },
    );

    test(
      'takeEvenSpreadSample(2) with ten elements returns list with two elements',
      () {
        final result = ListUtilities.takeEvenSpreadSample<int>([
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
        ], 2);
        expect(result, hasLength(2));
        expect(result.first, 1);
        expect(result[1], 10);
      },
    );
  });
}
