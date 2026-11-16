import 'package:flutter_test/flutter_test.dart';

import '../../../tool/src/test_bundles.dart';

void main() {
  group('usesWidgetBinding', () {
    test('Given a testWidgets call '
        'When the source is checked '
        'Then it uses the widget binding', () {
      expect(usesWidgetBinding("testWidgets('a', (tester) async {});"), isTrue);
    });

    test('Given a helper that takes a WidgetTester '
        'When the source is checked '
        'Then it uses the widget binding', () {
      expect(
        usesWidgetBinding('Future<void> pump(WidgetTester tester) async {}'),
        isTrue,
      );
    });

    test('Given a binding that is ensured by hand '
        'When the source is checked '
        'Then it uses the widget binding', () {
      expect(
        usesWidgetBinding('TestWidgetsFlutterBinding.ensureInitialized();'),
        isTrue,
      );
    });

    test('Given only plain tests '
        'When the source is checked '
        'Then it does not use the widget binding, whatever a comment says', () {
      expect(
        usesWidgetBinding("test('a', () {}); // a widget test elsewhere"),
        isFalse,
      );
    });
  });

  group('testWeight', () {
    test('Given a widget file and a plain file of one size '
        'When they are weighed '
        'Then the widget file weighs the factor more', () {
      const widget = "testWidgets('a', (t) {});";
      final plain = "test('a', () {});".padRight(widget.length);

      expect(testWeight(plain), widget.length);
      expect(testWeight(widget), widget.length * widgetWeightFactor);
    });
  });

  group('planTestBundles', () {
    test('Given no bundles '
        'When the files are planned '
        'Then it is refused', () {
      expect(
        () => planTestBundles(const {'test/a_test.dart': 1}, 0),
        throwsArgumentError,
      );
    });

    test('Given no files '
        'When they are planned '
        'Then there are no bundles', () {
      expect(planTestBundles(const {}, 4), isEmpty);
    });

    test('Given fewer files than bundles '
        'When they are planned '
        'Then the empty bundles are dropped', () {
      expect(
        planTestBundles(const {
          'test/a_test.dart': 1,
          'test/b_test.dart': 2,
        }, 4),
        [
          ['test/b_test.dart'],
          ['test/a_test.dart'],
        ],
      );
    });

    test('Given files of mixed weight '
        'When they are planned '
        'Then the heaviest goes first onto the lightest bundle', () {
      final bundles = planTestBundles(const {
        'test/a_test.dart': 9,
        'test/b_test.dart': 5,
        'test/c_test.dart': 4,
        'test/d_test.dart': 3,
        'test/e_test.dart': 3,
      }, 2);

      // 9 + 3 against 5 + 4 + 3.
      expect(bundles, [
        ['test/a_test.dart', 'test/d_test.dart'],
        ['test/b_test.dart', 'test/c_test.dart', 'test/e_test.dart'],
      ]);
    });

    test(
      'Given files of equal weight '
      'When they are planned '
      'Then they are taken in path order, ties going to the lower bundle',
      () {
        expect(
          planTestBundles(const {
            'test/c_test.dart': 1,
            'test/a_test.dart': 1,
            'test/b_test.dart': 1,
          }, 2),
          [
            ['test/a_test.dart', 'test/c_test.dart'],
            ['test/b_test.dart'],
          ],
        );
      },
    );

    test('Given one bundle '
        'When the files are planned '
        'Then every file is in it, sorted by path', () {
      expect(
        planTestBundles(const {
          'test/b_test.dart': 7,
          'test/a_test.dart': 1,
        }, 1),
        [
          ['test/a_test.dart', 'test/b_test.dart'],
        ],
      );
    });
  });

  group('testBundleSource', () {
    test('Given two files '
        'When their bundle is written '
        'Then each runs in a group named after its path under test/', () {
      expect(
        testBundleSource(const [
          'test/app/a_test.dart',
          'test/core/b_test.dart',
        ], directory: 'build/test-bundles'),
        '// Written by tool/test_bundles.dart. Do not edit.\n'
        "import 'package:flutter_test/flutter_test.dart';\n"
        '\n'
        "import '../../test/app/a_test.dart' as t0;\n"
        "import '../../test/core/b_test.dart' as t1;\n"
        '\n'
        'void main() {\n'
        "  group('app/a_test.dart', t0.main);\n"
        "  group('core/b_test.dart', t1.main);\n"
        '}\n',
      );
    });

    test('Given a Windows directory '
        'When a bundle is written into it '
        'Then the imports are posix paths', () {
      expect(
        testBundleSource(const [
          'test/a_test.dart',
        ], directory: r'.\build\bundles\'),
        contains("import '../../test/a_test.dart' as t0;"),
      );
    });

    test('Given a path too long for one line '
        'When its bundle is written '
        'Then the import and the group are wrapped as dart format wraps them', () {
      const file =
          'test/features/transactions/a_much_longer_file_name_for_wrapping_test.dart';

      final source = testBundleSource(const [
        file,
      ], directory: 'build/test-bundles');

      expect(source, contains("import '../../$file'\n    as t0;\n"));
      expect(
        source,
        contains(
          '  group(\n'
          "    'features/transactions/a_much_longer_file_name_for_wrapping_test.dart',\n"
          '    t0.main,\n'
          '  );\n',
        ),
      );
    });

    test('Given a directory outside the repository '
        'When a bundle is written into it '
        'Then it is refused', () {
      expect(
        () => testBundleSource(const [
          'test/a_test.dart',
        ], directory: '../bundles'),
        throwsArgumentError,
      );
    });
  });

  group('posixPath', () {
    test('Given a path with backslashes '
        'When it is made posix '
        'Then it has forward slashes', () {
      expect(posixPath(r'test\core\a_test.dart'), 'test/core/a_test.dart');
    });
  });
}
