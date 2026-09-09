import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/categories/data/category_repository.dart';
import 'package:fortuna_ui/features/categories/ui/categories_screen.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository({
    this.tree = const Success(CategoryTree(roots: [])),
    this.onWrite,
  });

  Result<CategoryTree> tree;

  /// The failure every write returns, or null for success.
  Failure<void>? Function()? onWrite;

  final List<String> calls = [];

  @override
  Future<Result<CategoryTree>> readTree() async => tree;

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
  });
}
