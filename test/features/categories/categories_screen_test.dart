import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/session/session_teardown.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';
import 'package:fortuna_ui/features/categories/state/category_providers.dart';
import 'package:fortuna_ui/features/categories/ui/categories_screen.dart';
import 'package:material_ui/material_ui.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository({
    this.tree = const Success(CategoryTree(roots: [])),
    this.onWrite,
  });

  Result<CategoryTree> tree;

  /// The failure every write returns, or null for success.
  Failure<void>? Function()? onWrite;

  final List<String> calls = [];
  int reads = 0;

  @override
  Future<Result<CategoryTree>> readTree() async {
    reads++;
    return tree;
  }

  Future<Result<void>> _write(String name) async {
    calls.add(name);
    final failure = onWrite?.call();
    return failure ?? const Success(null);
  }

  @override
  Future<Result<void>> create({required String name, String? parentId}) =>
      _write('create:$name:${parentId ?? "-"}');

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    String? parentId,
  }) => _write('update:$id:$name:${parentId ?? "-"}');

  @override
  Future<Result<void>> delete(String id) => _write('delete:$id');

  @override
  Future<Result<void>> reassign({
    required String fromId,
    required String toId,
    bool includeDescendants = true,
  }) => _write('reassign:$fromId:$toId');
}

const _populated = Success(
  CategoryTree(
    roots: [
      Category(
        id: 'food',
        name: 'Food',
        children: [
          Category(
            id: 'dining',
            name: 'Dining',
            parentId: 'food',
            children: [],
          ),
        ],
      ),
      Category(id: 'travel', name: 'Travel', children: []),
    ],
  ),
);

ProviderContainer containerWith(FakeCategoryRepository repository) {
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      categoryRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Has Travel's deletion refused, then opens the reassignment it offers.
Future<void> openReassignment(
  WidgetTester tester,
  FakeCategoryRepository repository,
) async {
  repository.onWrite = () => const Failure(
    message: 'Transactions still reference this category.',
    kind: FailureKind.conflict,
  );
  await tester.tap(find.byTooltip('Delete Travel'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
  await tester.pumpAndSettle();
  repository.onWrite = null;
  await tester.tap(find.widgetWithText(TextButton, 'Reassign'));
  await tester.pumpAndSettle();
}

Future<FakeCategoryRepository> pumpCategories(
  WidgetTester tester, {
  Result<CategoryTree> tree = _populated,
  Failure<void>? Function()? onWrite,
}) async {
  tester.view.physicalSize = const Size(1200, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final repository = FakeCategoryRepository(tree: tree, onWrite: onWrite);
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      categoryRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: CategoriesScreen()),
    ),
  );
  await tester.pumpAndSettle();

  return repository;
}

void main() {
  group('CategoriesScreen', () {
    testWidgets('Given a tree '
        'When the screen settles '
        'Then categories are shown at every depth (UC-26 main flow)', (
      tester,
    ) async {
      await pumpCategories(tester);

      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Dining'), findsOneWidget);
      expect(find.text('Travel'), findsOneWidget);
    });

    testWidgets('Given no categories '
        'When the screen settles '
        'Then an empty state offers creation (UC-26 AF-06)', (tester) async {
      await pumpCategories(
        tester,
        tree: const Success(CategoryTree(roots: [])),
      );

      expect(find.text('No categories yet'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Create the first one'),
        findsOneWidget,
      );
    });

    testWidgets('Given the tree cannot be read '
        'When the screen settles '
        'Then the reason is shown with a retry', (tester) async {
      await pumpCategories(
        tester,
        tree: const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('Given the new-category form '
        'When it is submitted with no name '
        'Then it is rejected in the form and nothing is sent (UC-26 AF-01)', (
      tester,
    ) async {
      final repository = await pumpCategories(tester);

      await tester.tap(
        find.widgetWithText(FloatingActionButton, 'New category'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(find.text('A category needs a name.'), findsOneWidget);
      expect(repository.calls, isEmpty);
    });

    testWidgets('Given a valid name '
        'When the form is submitted '
        'Then the category is created and the dialog closes', (tester) async {
      final repository = await pumpCategories(tester);

      await tester.tap(
        find.widgetWithText(FloatingActionButton, 'New category'),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Utilities');
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(repository.calls, ['create:Utilities:-']);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Given the API refuses the name '
        'When the form is submitted '
        "Then the API's reason is shown and the dialog stays open "
        '(UC-26 AF-01)', (tester) async {
      await pumpCategories(
        tester,
        onWrite: () => const Failure(
          message: 'A category with that name already exists here.',
          kind: FailureKind.conflict,
        ),
      );

      await tester.tap(
        find.widgetWithText(FloatingActionButton, 'New category'),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Food');
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(
        find.text('A category with that name already exists here.'),
        findsOneWidget,
      );
      // Not reported as saved, and the entry is kept.
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Given a category being edited '
        'When its parent options are offered '
        'Then neither itself nor its descendants appear (UC-26 AF-02)', (
      tester,
    ) async {
      await pumpCategories(tester);

      await tester.tap(find.byTooltip('Edit Food'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();

      // The menu offers Travel, but neither Food nor its child Dining.
      expect(find.text('Travel').hitTestable(), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(DropdownMenuItem<String?>),
          matching: find.text('Dining'),
        ),
        findsNothing,
      );
    });

    testWidgets(
      'Given deletion is refused because transactions reference the category '
      'When it is confirmed '
      "Then the API's reason is shown and reassignment is offered "
      '(UC-26 AF-03)',
      (tester) async {
        await pumpCategories(
          tester,
          onWrite: () => const Failure(
            message: 'Transactions still reference this category.',
            kind: FailureKind.conflict,
          ),
        );

        await tester.tap(find.byTooltip('Delete Travel'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
        await tester.pumpAndSettle();

        expect(
          find.text('Transactions still reference this category.'),
          findsOneWidget,
        );
        expect(find.widgetWithText(TextButton, 'Reassign'), findsOneWidget);
      },
    );

    testWidgets('Given a deletion confirmation '
        'When it is cancelled '
        'Then nothing is deleted', (tester) async {
      final repository = await pumpCategories(tester);

      await tester.tap(find.byTooltip('Delete Travel'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(repository.calls, isEmpty);
    });
    testWidgets('Given a category being edited '
        'When it is renamed and saved '
        'Then the change is sent for that category and the dialog closes '
        '(UC-26 step 5)', (tester) async {
      final repository = await pumpCategories(tester);

      await tester.tap(find.byTooltip('Edit Dining'));
      await tester.pumpAndSettle();
      expect(find.text('Edit Dining'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), '  Restaurants  ');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(repository.calls, ['update:dining:Restaurants:food']);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Given the new-category form '
        'When a parent is chosen '
        'Then the category is created beneath it', (tester) async {
      final repository = await pumpCategories(tester);

      await tester.tap(
        find.widgetWithText(FloatingActionButton, 'New category'),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Groceries');
      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Food').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(repository.calls, ['create:Groceries:food']);
    });

    testWidgets('Given a name in the new-category form '
        'When it is submitted from the keyboard '
        'Then the category is created', (tester) async {
      final repository = await pumpCategories(tester);

      await tester.tap(
        find.widgetWithText(FloatingActionButton, 'New category'),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Utilities');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(repository.calls, ['create:Utilities:-']);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('showReassignDialog', () {
    testWidgets('Given reassignment out of a category '
        'When its targets are offered '
        'Then every other category is offered but not the category itself, '
        'and nothing can be moved before one is chosen (UC-26 AF-04)', (
      tester,
    ) async {
      final repository = await pumpCategories(tester);
      await openReassignment(tester, repository);

      expect(find.text('Move transactions out of Travel'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Move'))
            .onPressed,
        isNull,
      );

      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();

      final offered = tester
          .widgetList<DropdownMenuItem<String?>>(
            find.byType(DropdownMenuItem<String?>),
          )
          .map((item) => item.value)
          .toSet();
      expect(offered, {'food', 'dining'});
    });

    testWidgets('Given a target is chosen '
        'When the transactions are moved '
        'Then the move is sent, the dialog closes and the tree is re-read '
        '(UC-26 AF-03)', (tester) async {
      final repository = await pumpCategories(tester);
      await openReassignment(tester, repository);
      final readsBefore = repository.reads;

      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Food').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Move'));
      await tester.pumpAndSettle();

      expect(repository.calls.last, 'reassign:travel:food');
      expect(find.byType(AlertDialog), findsNothing);
      expect(repository.reads, greaterThan(readsBefore));
    });

    testWidgets('Given a target is chosen '
        'When the API refuses the move '
        'Then its reason is shown and the dialog stays open', (tester) async {
      final repository = await pumpCategories(tester);
      await openReassignment(tester, repository);
      repository.onWrite = () => const Failure(
        message: 'That category has been deleted.',
        kind: FailureKind.notFound,
      );

      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dining').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Move'));
      await tester.pumpAndSettle();

      expect(repository.calls.last, 'reassign:travel:dining');
      expect(find.text('That category has been deleted.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Move'))
            .onPressed,
        isNotNull,
      );
    });

    testWidgets('Given the reassignment dialog '
        'When it is cancelled '
        'Then nothing is moved', (tester) async {
      final repository = await pumpCategories(tester);
      await openReassignment(tester, repository);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(repository.calls, ['delete:travel']);
    });
  });

  group('categoryTreeProvider', () {
    test('Given the tree has been read '
        'When the session ends '
        'Then it is forgotten and read afresh (BR-32, BR-33)', () async {
      final repository = FakeCategoryRepository(tree: _populated);
      final container = containerWith(repository);
      final subscription = container.listen(categoryTreeProvider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(categoryTreeProvider.future);

      await container.read(sessionTeardownProvider).runAll();
      await container.read(categoryTreeProvider.future);

      expect(repository.reads, 2);
    });

    test('Given the tree cannot be read '
        'When it is read '
        "Then it fails with the repository's message", () async {
      final container = containerWith(
        FakeCategoryRepository(
          tree: const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );
      final subscription = container.listen(categoryTreeProvider, (_, _) {});
      addTearDown(subscription.close);

      await expectLater(
        container.read(categoryTreeProvider.future),
        throwsA(
          isA<CategoriesUnavailable>().having(
            (error) => error.toString(),
            'toString',
            'The instance could not be reached.',
          ),
        ),
      );
    });
  });

  group('CategoryActions', () {
    test('Given a change the API refuses '
        'When it is made '
        'Then the failure is returned and the tree is not re-read', () async {
      const refusal = Failure<void>(
        message: 'A category with that name already exists here.',
        kind: FailureKind.conflict,
      );
      final repository = FakeCategoryRepository(
        tree: _populated,
        onWrite: () => refusal,
      );
      final container = containerWith(repository);
      final subscription = container.listen(categoryTreeProvider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(categoryTreeProvider.future);

      final failure = await container
          .read(categoryActionsProvider)
          .update(id: 'travel', name: 'Food');
      await container.read(categoryTreeProvider.future);

      expect(failure, refusal);
      expect(repository.calls, ['update:travel:Food:-']);
      expect(repository.reads, 1);
    });

    test('Given a reassignment the API accepts '
        'When it is made '
        'Then nothing is returned and the tree is re-read', () async {
      final repository = FakeCategoryRepository(tree: _populated);
      final container = containerWith(repository);
      final subscription = container.listen(categoryTreeProvider, (_, _) {});
      addTearDown(subscription.close);
      await container.read(categoryTreeProvider.future);

      final failure = await container
          .read(categoryActionsProvider)
          .reassign(fromId: 'travel', toId: 'food');
      await container.read(categoryTreeProvider.future);

      expect(failure, isNull);
      expect(repository.calls, ['reassign:travel:food']);
      expect(repository.reads, 2);
    });
  });
}
