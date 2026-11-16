import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/network/paging.dart';

void main() {
  group('readEveryPage', () {
    test('Given a list the API serves in three pages '
        'When every page is read '
        'Then each page is asked for once, in order, at the largest size, and '
        'the items come back in the order served', () async {
      final asked = <(int, int)>[];

      final items = await readEveryPage<String>((pageNumber, pageSize) async {
        asked.add((pageNumber, pageSize));
        return (items: ['p$pageNumber-a', 'p$pageNumber-b'], totalPages: 3);
      });

      expect(asked, [(1, 100), (2, 100), (3, 100)]);
      expect(items, ['p1-a', 'p1-b', 'p2-a', 'p2-b', 'p3-a', 'p3-b']);
    });

    test('Given a list that fits on one page '
        'When every page is read '
        'Then only the first page is asked for', () async {
      final asked = <int>[];

      final items = await readEveryPage<String>((pageNumber, _) async {
        asked.add(pageNumber);
        return (items: ['only'], totalPages: 1);
      });

      expect(asked, [1]);
      expect(items, ['only']);
    });

    test('Given an answer that does not say how many pages there are '
        'When every page is read '
        'Then the first page is taken as the whole list', () async {
      final asked = <int>[];

      final items = await readEveryPage<String>((pageNumber, _) async {
        asked.add(pageNumber);
        return (items: ['a', 'b'], totalPages: null);
      });

      expect(asked, [1]);
      expect(items, ['a', 'b']);
    });

    test(
      'Given a page that comes back empty before the last '
      'When every page is read '
      'Then reading stops there rather than asking for nothing again',
      () async {
        final asked = <int>[];

        final items = await readEveryPage<String>((pageNumber, _) async {
          asked.add(pageNumber);
          return (
            items: pageNumber == 1 ? ['a'] : const <String>[],
            totalPages: 5,
          );
        });

        expect(asked, [1, 2]);
        expect(items, ['a']);
      },
    );

    test('Given an API that always claims another page '
        'When every page is read '
        'Then reading stops at the bound rather than never ending', () async {
      var asked = 0;

      final items = await readEveryPage<int>((pageNumber, _) async {
        asked++;
        return (items: [pageNumber], totalPages: 1 << 30);
      });

      expect(asked, maximumPagesRead);
      expect(items, hasLength(maximumPagesRead));
    });

    test('Given a page that fails '
        'When every page is read '
        'Then the failure is not swallowed into a shorter list', () async {
      final read = readEveryPage<String>((pageNumber, _) async {
        if (pageNumber == 2) throw StateError('page 2 failed');
        return (items: ['a'], totalPages: 3);
      });

      await expectLater(read, throwsStateError);
    });
  });
}
