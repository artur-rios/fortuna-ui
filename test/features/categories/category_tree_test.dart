import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';

/// food ─ groceries ─ produce
///      └ dining
/// travel
const _tree = CategoryTree(
  roots: [
    Category(
      id: 'food',
      name: 'Food',
      children: [
        Category(
          id: 'groceries',
          name: 'Groceries',
          parentId: 'food',
          children: [
            Category(
              id: 'produce',
              name: 'Produce',
              parentId: 'groceries',
              children: [],
            ),
          ],
        ),
        Category(id: 'dining', name: 'Dining', parentId: 'food', children: []),
      ],
    ),
    Category(id: 'travel', name: 'Travel', children: []),
  ],
);

void main() {
  group('CategoryTree', () {
    test('Given a nested tree '
        'When every category is listed '
        'Then categories at every depth are included', () {
      expect(
        _tree.all.map((category) => category.id),
        containsAll(['food', 'groceries', 'produce', 'dining', 'travel']),
      );
      expect(_tree.all, hasLength(5));
    });

    test('Given a category id '
        'When it is looked up '
        'Then it is found at any depth, and an unknown id is null', () {
      expect(_tree.find('produce')?.name, 'Produce');
      expect(_tree.find('nowhere'), isNull);
    });

    test('Given a category with descendants '
        'When its valid parents are computed '
        'Then neither itself nor any descendant is offered (UC-26 AF-02)', () {
      final food = _tree.find('food')!;

      final valid = _tree.validParentsFor(food).map((c) => c.id);

      // Parenting Food to Groceries — or to itself — would make a cycle.
      expect(valid, isNot(contains('food')));
      expect(valid, isNot(contains('groceries')));
      expect(valid, isNot(contains('produce')));
      expect(valid, isNot(contains('dining')));
      // Travel is unrelated and perfectly valid.
      expect(valid, contains('travel'));
    });

    test('Given a leaf category '
        'When its valid parents are computed '
        'Then everything except itself is offered', () {
      final valid = _tree
          .validParentsFor(_tree.find('produce'))
          .map((c) => c.id);

      expect(valid, isNot(contains('produce')));
      expect(valid, containsAll(['food', 'groceries', 'dining', 'travel']));
    });

    test('Given a new category '
        'When its valid parents are computed '
        'Then every existing category is offered', () {
      expect(_tree.validParentsFor(null), hasLength(5));
    });

    test('Given an empty tree '
        'When it is inspected '
        'Then it reports empty and offers no parents (UC-26 AF-06)', () {
      const empty = CategoryTree(roots: []);

      expect(empty.isEmpty, isTrue);
      expect(empty.validParentsFor(null), isEmpty);
    });

    test('Given a category '
        'When its own subtree is walked '
        'Then it includes itself and everything beneath it', () {
      expect(_tree.find('food')!.selfAndDescendants.map((c) => c.id), [
        'food',
        'groceries',
        'produce',
        'dining',
      ]);
    });
  });
}
