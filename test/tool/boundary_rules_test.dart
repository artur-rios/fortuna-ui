import 'package:flutter_test/flutter_test.dart';

import '../../tool/boundary_rules.dart';

void main() {
  group('IR-13 — dart:ffi is confined to the bindings layer', () {
    test('Given a file outside the bindings layer that imports dart:ffi '
        'When the boundaries are checked '
        'Then it is reported', () {
      final violations = checkBoundaries([
        const SourceFile(
          'lib/features/transactions/state/transactions_controller.dart',
          "import 'dart:ffi';\n\nvoid main() {}\n",
        ),
      ]);

      expect(violations, hasLength(1));
      expect(violations.single.rule, 'IR-13');
      expect(violations.single.line, 1);
    });

    test('Given the bindings layer itself importing dart:ffi '
        'When the boundaries are checked '
        'Then it is allowed — that is the one place it belongs', () {
      final violations = checkBoundaries([
        const SourceFile(
          'lib/core/bindings/core_isolate.dart',
          "import 'dart:ffi';\n",
        ),
      ]);

      expect(violations, isEmpty);
    });

    test(
      'Given dart:ffi named only inside a comment '
      'When the boundaries are checked '
      'Then it is not reported — prose about the rule is not a breach of it',
      () {
        final violations = checkBoundaries([
          const SourceFile(
            'lib/core/network/api_client.dart',
            "// This layer never imports 'dart:ffi'.\n",
          ),
        ]);

        expect(violations, isEmpty);
      },
    );
  });

  group('IR-14 — money never passes through a floating-point type', () {
    test('Given a money-touching file that calls toDouble '
        'When the boundaries are checked '
        'Then it is reported', () {
      final violations = checkBoundaries([
        const SourceFile(
          'lib/features/insight/ui/spending_chart.dart',
          "import '../../../core/format/money.dart';\n"
              'double y(Money m) => m.amount.toDouble();\n',
        ),
      ]);

      expect(violations, hasLength(1));
      expect(violations.single.rule, 'IR-14');
      expect(violations.single.line, 2);
    });

    test('Given a money-touching file that parses a double '
        'When the boundaries are checked '
        'Then it is reported', () {
      final violations = checkBoundaries([
        const SourceFile(
          'lib/features/transactions/validation/amount_validator.dart',
          "import 'package:decimal/decimal.dart';\n"
              "final value = double.parse('1.10');\n",
        ),
      ]);

      expect(violations, hasLength(1));
      expect(violations.single.rule, 'IR-14');
    });

    test('Given a file with no money in it that uses a double '
        'When the boundaries are checked '
        'Then it is left alone — an animation curve is rightly a double', () {
      final violations = checkBoundaries([
        const SourceFile(
          'lib/shared/widgets/fade_in.dart',
          'final opacity = 0.5;\n'
              'final progress = double.parse(raw);\n',
        ),
      ]);

      expect(violations, isEmpty);
    });

    test(
      'Given the money type itself gaining a double conversion '
      'When the boundaries are checked '
      'Then it is reported — this is the change that must never pass review',
      () {
        final violations = checkBoundaries([
          const SourceFile(
            'lib/core/format/money.dart',
            'double get asDouble => amount.toDouble();\n',
          ),
        ]);

        expect(violations, hasLength(1));
        expect(violations.single.rule, 'IR-14');
      },
    );
  });

  group('The real source tree', () {
    test('Given no violations '
        'When the boundaries are checked '
        'Then nothing is reported', () {
      expect(checkBoundaries(const []), isEmpty);
    });
  });
}
