import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/labels/data/label_repository.dart';
import 'package:fortuna_ui/features/labels/ui/labels_screen.dart';

class FakeLabelRepository implements LabelRepository {
  FakeLabelRepository(
    this.kind, {
    this.labels = const Success([]),
    this.onWrite,
  });

  @override
  final LabelKind kind;

  Result<List<Label>> labels;
  Failure<void>? Function()? onWrite;
  final List<String> calls = [];

  @override
  Future<Result<List<Label>>> list() async => labels;

  Future<Result<void>> _write(String call) async {
    calls.add(call);
    return onWrite?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> create(String name) => _write('create:$name');

  @override
  Future<Result<void>> rename({required String id, required String name}) =>
      _write('rename:$id:$name');

  @override
  Future<Result<void>> delete(String id) => _write('delete:$id');
}

const _tags = Success([
  Label(id: 'zebra', name: 'Zebra'),
  Label(id: 'apple', name: 'apple'),
]);

Future<Map<LabelKind, FakeLabelRepository>> pumpLabels(
  WidgetTester tester, {
  Result<List<Label>> tags = _tags,
  Result<List<Label>> counterparties = const Success([]),
  Failure<void>? Function()? onWrite,
}) async {
  tester.view.physicalSize = const Size(1000, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final repositories = {
    LabelKind.tag: FakeLabelRepository(
      LabelKind.tag,
      labels: tags,
      onWrite: onWrite,
    ),
    LabelKind.counterparty: FakeLabelRepository(
      LabelKind.counterparty,
      labels: counterparties,
      onWrite: onWrite,
    ),
  };

  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      labelRepositoryProvider.overrideWith((ref, kind) => repositories[kind]!),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: LabelsScreen()),
    ),
  );
  await tester.pumpAndSettle();

  return repositories;
}

void main() {
  group('LabelsScreen', () {
    testWidgets('Given tags exist '
        'When the screen settles '
        'Then they are listed, sorted case-insensitively (UC-27 main flow)', (
      tester,
    ) async {
      await pumpLabels(tester);

      expect(find.text('apple'), findsOneWidget);
      expect(find.text('Zebra'), findsOneWidget);

      // "apple" before "Zebra": a case-sensitive sort would invert these,
      // and a list that reorders by capitalisation reads as random.
      final apple = tester.getTopLeft(find.text('apple')).dy;
      final zebra = tester.getTopLeft(find.text('Zebra')).dy;
      expect(apple, lessThan(zebra));
    });

    testWidgets('Given no counterparties '
        'When that tab is opened '
        'Then an empty state explains what they are and offers creation '
        '(UC-27 AF-04)', (tester) async {
      await pumpLabels(tester);

      await tester.tap(find.text('Counterparties'));
      await tester.pumpAndSettle();

      expect(find.text('No counterparties yet'), findsOneWidget);
      expect(find.textContaining('who was on the other side'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Create the first counterparty'),
        findsOneWidget,
      );
    });

    testWidgets('Given the list cannot be read '
        'When the screen settles '
        'Then the reason is shown with a retry', (tester) async {
      await pumpLabels(
        tester,
        tags: const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('Given the new-tag form '
        'When it is submitted empty '
        'Then it is rejected in the form and nothing is sent (UC-27 AF-01)', (
      tester,
    ) async {
      final repositories = await pumpLabels(tester);

      await tester.tap(find.widgetWithText(FloatingActionButton, 'New tag'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(find.text('A tag needs a name.'), findsOneWidget);
      expect(repositories[LabelKind.tag]!.calls, isEmpty);
    });

    testWidgets('Given a name '
        'When the tag is created '
        'Then it is submitted and the dialog closes', (tester) async {
      final repositories = await pumpLabels(tester);

      await tester.tap(find.widgetWithText(FloatingActionButton, 'New tag'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Groceries');
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(repositories[LabelKind.tag]!.calls, ['create:Groceries']);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Given the API refuses a duplicate name '
        'When the form is submitted '
        "Then the API's reason is shown and the entry is kept (UC-27 AF-01)", (
      tester,
    ) async {
      await pumpLabels(
        tester,
        onWrite: () => const Failure(
          message: 'A tag with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );

      await tester.tap(find.widgetWithText(FloatingActionButton, 'New tag'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Zebra');
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(find.text('A tag with that name already exists.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
      'Given deletion is refused because transactions reference the tag '
      'When it is confirmed '
      "Then the API's reason is presented (UC-27 AF-02)",
      (tester) async {
        await pumpLabels(
          tester,
          onWrite: () => const Failure(
            message: 'Transactions still carry this tag.',
            kind: FailureKind.conflict,
          ),
        );

        await tester.tap(find.byTooltip('Delete Zebra'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
        await tester.pumpAndSettle();

        expect(find.text('Transactions still carry this tag.'), findsOneWidget);
      },
    );

    testWidgets('Given the target no longer exists '
        'When deletion is confirmed '
        "Then the API's not-found reason is presented (UC-27 AF-03)", (
      tester,
    ) async {
      await pumpLabels(
        tester,
        onWrite: () => const Failure(
          message: 'That tag no longer exists.',
          kind: FailureKind.notFound,
        ),
      );

      await tester.tap(find.byTooltip('Delete Zebra'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.text('That tag no longer exists.'), findsOneWidget);
    });

    testWidgets('Given a rename '
        'When it is submitted '
        'Then the existing name is offered and the change is sent', (
      tester,
    ) async {
      final repositories = await pumpLabels(tester);

      await tester.tap(find.byTooltip('Rename Zebra'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Zebra'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Zebra Ltd');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(repositories[LabelKind.tag]!.calls, ['rename:zebra:Zebra Ltd']);
    });

    testWidgets('Given the tag tab '
        'When a counterparty is created from its own tab '
        'Then it goes to the counterparty repository, not the tag one', (
      tester,
    ) async {
      final repositories = await pumpLabels(tester);

      await tester.tap(find.text('Counterparties'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(FilledButton, 'Create the first counterparty'),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Baker Street Cafe');
      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(repositories[LabelKind.counterparty]!.calls, [
        'create:Baker Street Cafe',
      ]);
      expect(repositories[LabelKind.tag]!.calls, isEmpty);
    });
  });
}
