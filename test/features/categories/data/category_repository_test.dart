import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';

import '../../../support/api_stub.dart';

const _unreachable = Failure<void>(
  message: 'The instance could not be reached.',
  kind: FailureKind.unreachable,
);

void main() {
  group('HttpCategoryRepository.readTree', () {
    test('Given a nested tree '
        'When it is read '
        'Then it is fetched without deleted categories or counts and kept in '
        "the API's own shape (UC-26 main flow)", () async {
      final stub = ApiStub.data({
        'canSeedDefaults': false,
        'categories': [
          {
            'id': 'food',
            'name': 'Food',
            'isDeleted': false,
            'children': [
              {
                'id': 'produce',
                'name': 'Produce',
                'parentId': 'food',
                'isDeleted': true,
                'children': [
                  {'id': 'fruit', 'name': 'Fruit', 'parentId': 'produce'},
                ],
              },
            ],
          },
          {'id': 'rent', 'name': 'Rent', 'children': <Object?>[]},
        ],
      });

      final result = await HttpCategoryRepository.fromDio(stub.dio).readTree();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/categories');
      expect(stub.request.queryParameters, {
        'includeDeleted': false,
        'includeUsageCounts': false,
      });
      final tree = result.valueOrNull!;
      expect(tree.canSeedDefaults, isFalse);
      expect(tree.isEmpty, isFalse);
      expect(tree.roots.map((c) => c.id), ['food', 'rent']);
      final food = tree.roots.first;
      expect(food.name, 'Food');
      expect(food.parentId, isNull);
      expect(food.isDeleted, isFalse);
      final produce = food.children.single;
      expect(produce.id, 'produce');
      expect(produce.name, 'Produce');
      expect(produce.parentId, 'food');
      expect(produce.isDeleted, isTrue);
      final fruit = produce.children.single;
      expect(fruit.id, 'fruit');
      expect(fruit.parentId, 'produce');
      expect(fruit.children, isEmpty);
      expect(tree.all.map((c) => c.id), ['food', 'produce', 'fruit', 'rent']);
    });

    test('Given a category with every optional field missing '
        'When the tree is read '
        'Then it is kept with empty gaps rather than dropped', () async {
      final stub = ApiStub.data({
        'categories': [<String, Object?>{}],
      });

      final result = await HttpCategoryRepository.fromDio(stub.dio).readTree();

      final category = result.valueOrNull!.roots.single;
      expect(category.id, '');
      expect(category.name, '');
      expect(category.parentId, isNull);
      expect(category.isDeleted, isFalse);
      expect(category.children, isEmpty);
      expect(result.valueOrNull!.canSeedDefaults, isFalse);
    });

    test('Given no categories yet and an instance that can seed some '
        'When the tree is read '
        'Then it is empty and offers the seed (UC-26 AF-06)', () async {
      final stub = ApiStub.data({
        'canSeedDefaults': true,
        'categories': <Object?>[],
      });

      final result = await HttpCategoryRepository.fromDio(stub.dio).readTree();

      final tree = result.valueOrNull!;
      expect(tree.isEmpty, isTrue);
      expect(tree.canSeedDefaults, isTrue);
    });

    test('Given an answer with no data '
        'When the tree is read '
        'Then it is empty and offers no seed', () async {
      final stub = ApiStub.data(null);

      final result = await HttpCategoryRepository.fromDio(stub.dio).readTree();

      final tree = result.valueOrNull!;
      expect(tree.isEmpty, isTrue);
      expect(tree.canSeedDefaults, isFalse);
    });

    test('Given the API refuses the request '
        'When the tree is read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(401, ['The session has expired.']));

      final result = await HttpCategoryRepository.fromDio(stub.dio).readTree();

      expect(
        result,
        const Failure<CategoryTree>(
          message: 'The session has expired.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the tree is read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCategoryRepository.fromDio(stub.dio).readTree();

      expect(
        result,
        const Failure<CategoryTree>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCategoryRepository.create', () {
    test('Given a top-level category '
        'When it is created '
        'Then its name is posted with no parent', () async {
      final stub = ApiStub.data({'id': 'food'}, status: 201);

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .create(name: 'Food');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/categories');
      expect(stub.body, {'name': 'Food'});
    });

    test('Given a category beneath another '
        'When it is created '
        'Then the parent is sent', () async {
      final stub = ApiStub.data({'id': 'produce'}, status: 201);

      await HttpCategoryRepository.fromDio(stub.dio)
          .create(name: 'Produce', parentId: 'food');

      expect(stub.body, {'name': 'Produce', 'parentId': 'food'});
    });

    test('Given the API refuses the name '
        'When the category is created '
        "Then the API's reason is the failure (UC-26 AF-01)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A category with that name already exists.']),
      );

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .create(name: 'Food');

      expect(
        result,
        const Failure<void>(
          message: 'A category with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a category is created '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .create(name: 'Food');

      expect(result, _unreachable);
    });
  });

  group('HttpCategoryRepository.update', () {
    test('Given an edited category '
        'When it is saved '
        'Then its name and parent are put to its own address', () async {
      final stub = ApiStub.data({'id': 'produce'});

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .update(id: 'produce', name: 'Fresh produce', parentId: 'food');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/categories/produce');
      expect(stub.body, {'name': 'Fresh produce', 'parentId': 'food'});
    });

    test('Given a category moved to the top level '
        'When it is saved '
        'Then no parent is sent', () async {
      final stub = ApiStub.data({'id': 'produce'});

      await HttpCategoryRepository.fromDio(stub.dio)
          .update(id: 'produce', name: 'Produce');

      expect(stub.body, {'name': 'Produce', 'parentId': null});
    });

    test('Given the API refuses a parent that would make a cycle '
        'When the category is saved '
        "Then the API's reason is the failure (UC-26 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['A category cannot be its own ancestor.']),
      );

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .update(id: 'food', name: 'Food', parentId: 'produce');

      expect(
        result,
        const Failure<void>(
          message: 'A category cannot be its own ancestor.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given a category that does not exist '
        'When it is saved '
        'Then it is not found (UC-26 AF-05)', () async {
      final stub = ApiStub((_) => refusal(404, ['Category not found.']));

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .update(id: 'gone', name: 'Gone');

      expect(
        result,
        const Failure<void>(
          message: 'Category not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpCategoryRepository.delete', () {
    test('Given a category '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'rent'});

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .delete('rent');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/categories/rent');
    });

    test('Given a category transactions still use '
        'When it is deleted '
        "Then the API's reason is the failure (UC-26 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Transactions still use this category.']),
      );

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .delete('food');

      expect(
        result,
        const Failure<void>(
          message: 'Transactions still use this category.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a category is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .delete('rent');

      expect(result, _unreachable);
    });
  });

  group('HttpCategoryRepository.reassign', () {
    test('Given a category to be removed '
        'When its transactions are moved '
        "Then the target is posted to the category's reassign address, its "
        'descendants included by default (UC-26 AF-03)', () async {
      final stub = ApiStub.data({'reassignedCount': 4});

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .reassign(fromId: 'food', toId: 'groceries');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/categories/food/reassign');
      expect(stub.body, {
        'includeDescendants': true,
        'targetCategoryId': 'groceries',
      });
    });

    test('Given only the category itself is to be moved '
        'When its transactions are moved '
        'Then the descendants are left out', () async {
      final stub = ApiStub.data(<String, Object?>{});

      await HttpCategoryRepository.fromDio(
        stub.dio,
      ).reassign(fromId: 'food', toId: 'groceries', includeDescendants: false);

      expect(stub.body, {
        'includeDescendants': false,
        'targetCategoryId': 'groceries',
      });
    });

    test('Given a target that does not exist '
        'When the transactions are moved '
        'Then it is not found', () async {
      final stub = ApiStub(
        (_) => refusal(404, ['The target category was not found.']),
      );

      final result = await HttpCategoryRepository.fromDio(stub.dio)
          .reassign(fromId: 'food', toId: 'gone');

      expect(
        result,
        const Failure<void>(
          message: 'The target category was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });
}
