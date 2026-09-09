import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';

void main() {
  group('Result', () {
    test('Given a success '
        'When it is inspected '
        'Then it carries its value and reports success', () {
      const result = Success<int>(42);

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 42);
    });

    test('Given a failure '
        'When it is inspected '
        "Then it carries the API's reason and no value", () {
      const result = Failure<int>(
        message: 'A category with that name already exists.',
        kind: FailureKind.conflict,
      );

      expect(result.isSuccess, isFalse);
      expect(result.valueOrNull, isNull);
      expect(result.message, 'A category with that name already exists.');
      expect(result.kind, FailureKind.conflict);
    });

    test('Given a success '
        'When it is mapped '
        'Then the value is transformed', () {
      expect(const Success<int>(2).map((v) => v * 3).valueOrNull, 6);
    });

    test('Given a failure '
        'When it is mapped '
        'Then the reason is carried through untouched, not swallowed', () {
      const failure = Failure<int>(
        message: 'Not found.',
        kind: FailureKind.notFound,
      );

      final mapped = failure.map((v) => v * 3);

      expect(mapped, isA<Failure<int>>());
      expect((mapped as Failure<int>).message, 'Not found.');
      expect(mapped.kind, FailureKind.notFound);
    });

    test('Given a result '
        'When it is switched on '
        'Then the two cases are exhaustive without a default', () {
      String describe(Result<int> result) => switch (result) {
        Success<int>(:final value) => 'ok $value',
        Failure<int>(:final message) => 'no: $message',
      };

      expect(describe(const Success(1)), 'ok 1');
      expect(
        describe(
          const Failure(message: 'refused', kind: FailureKind.forbidden),
        ),
        'no: refused',
      );
    });
  });
}
