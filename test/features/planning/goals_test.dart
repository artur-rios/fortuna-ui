import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/format/money_parser.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/planning/data/goal_repository.dart';
import 'package:fortuna_ui/features/planning/state/goal_providers.dart';
import 'package:fortuna_ui/features/planning/ui/goals_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import '../holdings/accounts_test.dart' show FakeCurrencies;

class FakeGoals implements GoalRepository {
  FakeGoals({this.onList, this.onCreate, this.onUpdate, this.onDelete});

  Result<List<Goal>> Function()? onList;
  Result<void> Function()? onCreate;
  Result<void> Function()? onUpdate;
  Result<void> Function()? onDelete;

  final List<Map<String, Object?>> created = [];
  final List<Map<String, Object?>> updated = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<Goal>>> list() async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<Goal>> read(String id) async => const Failure(
    message: 'That goal was not found.',
    kind: FailureKind.notFound,
  );

  @override
  Future<Result<void>> create({
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds = const [],
    List<String> investmentIds = const [],
  }) async {
    created.add({
      'name': name,
      'targetAmount': targetAmount,
      'currencyCode': currencyCode,
      'targetDate': targetDate,
    });
    return onCreate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    required String targetAmount,
    required String currencyCode,
    required DateTime targetDate,
    List<String> accountIds = const [],
    List<String> investmentIds = const [],
  }) async {
    updated.add({'id': id, 'name': name, 'targetAmount': targetAmount});
    return onUpdate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return onDelete?.call() ?? const Success(null);
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowGoals extends FakeGoals {
  SlowGoals(this._pending);

  final Future<Result<List<Goal>>> _pending;

  @override
  Future<Result<List<Goal>>> list() => _pending;
}

Goal goal({
  String id = 'g1',
  String name = 'New laptop',
  String target = '5000.00',
  String? saved = '1250.00',
  String? remaining = '3750.00',
  String? proportion = '0.25',
  bool? isReached = false,
  DateTime? targetDate,
  bool withProgress = true,
  List<String> accountNames = const [],
}) => Goal(
  id: id,
  name: name,
  targetAmount: Money.parse(target, 'BRL'),
  targetDate: targetDate ?? DateTime(2027),
  accountNames: accountNames,
  investmentNames: const [],
  progress: withProgress
      ? GoalProgress(
          currentAmount: saved == null ? null : Money.parse(saved, 'BRL'),
          remaining: remaining == null ? null : Money.parse(remaining, 'BRL'),
          proportionReached: proportion == null
              ? null
              : Decimal.parse(proportion),
          isReached: isReached,
        )
      : null,
);

ProviderContainer containerWith(FakeGoals fake) {
  final container = ProviderContainer(
    overrides: [
      goalRepositoryProvider.overrideWithValue(fake),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpGoals(WidgetTester tester, FakeGoals fake) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        goalRepositoryProvider.overrideWithValue(fake),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: GoalsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final parser = MoneyParser('en_US');
  final now = DateTime(2026, 9, 11, 12);

  group('GoalProgress', () {
    test('Given progress the API computed '
        'When it is read '
        "Then every figure is the API's, not derived (FR-OR-09)", () {
      final tracked = goal(
        target: '5000.00',
        saved: '1250.00',
        // Deliberately not 5000 - 1250: the API's figure stands.
        remaining: '3700.00',
      );

      expect(tracked.progress!.currentAmount!.amount, Decimal.parse('1250.00'));
      expect(tracked.progress!.remaining!.amount, Decimal.parse('3700.00'));
    });

    test('Given a proportion '
        'When it is asked for as thousandths '
        'Then it is an exact integer, with no float in the conversion', () {
      expect(goal(proportion: '0.25').progress!.proportionPermille, 250);
      expect(goal(proportion: '0').progress!.proportionPermille, 0);
      expect(goal(proportion: '1').progress!.proportionPermille, 1000);
      // Overshot goals keep their real proportion; the clamp is for drawing.
      expect(goal(proportion: '1.5').progress!.proportionPermille, 1500);
    });

    test('Given a proportion with more precision than a bar can show '
        'When it is asked for as thousandths '
        'Then it rounds once, exactly', () {
      expect(goal(proportion: '0.3333').progress!.proportionPermille, 333);
      expect(goal(proportion: '0.6666').progress!.proportionPermille, 667);
    });

    test('Given no proportion '
        'When it is asked '
        'Then there are no thousandths either', () {
      expect(goal(proportion: null).progress!.proportionPermille, isNull);
    });

    test('Given the API reports the goal reached '
        'When it is asked '
        'Then its verdict is used rather than a local comparison', () {
      expect(goal(isReached: true).isReached, isTrue);
    });

    test('Given savings above the target but no verdict from the API '
        'When it is asked '
        'Then nothing is concluded locally', () {
      final unclear = goal(
        target: '5000.00',
        saved: '6000.00',
        isReached: null,
      );

      expect(unclear.isReached, isFalse);
    });

    test('Given no progress at all '
        'When it is asked '
        'Then the absence is reported rather than a zero (AF-03)', () {
      expect(goal(withProgress: false).hasNoProgress, isTrue);
      expect(goal(saved: null, remaining: null).hasNoProgress, isTrue);
      expect(goal().hasNoProgress, isFalse);
    });
  });

  group('Goal.hasElapsed', () {
    test('Given a target date in the future '
        'When it is asked '
        'Then it has not elapsed', () {
      expect(
        goal(targetDate: DateTime(2026, 12)).hasElapsed(now: now),
        isFalse,
      );
    });

    test('Given a target date today '
        'When it is asked '
        'Then it has not elapsed merely because the morning has', () {
      expect(
        goal(targetDate: DateTime(2026, 9, 11)).hasElapsed(now: now),
        isFalse,
      );
    });

    test('Given a target date in the past '
        'When it is asked '
        'Then it has elapsed (AF-04)', () {
      expect(
        goal(targetDate: DateTime(2026, 9, 10)).hasElapsed(now: now),
        isTrue,
      );
    });
  });

  group('GoalRules.validate', () {
    GoalProblem? validate({
      String name = 'New laptop',
      String amountText = '5000.00',
      DateTime? targetDate,
    }) => GoalRules.validate(
      name: name,
      amountText: amountText,
      targetDate: targetDate ?? DateTime(2026, 12),
      now: now,
      isReadableAmount: (text) => parser.parse(text) != null,
      isPositiveAmount: parser.isPositive,
    );

    test('Given a complete, valid entry '
        'When it is validated '
        'Then nothing is refused', () {
      expect(validate(), isNull);
    });

    test('Given no name '
        'When it is validated '
        'Then it is refused', () {
      expect(validate(name: '  '), GoalProblem.missingName);
    });

    test('Given an amount that is not greater than zero '
        'When it is validated '
        'Then it is refused (AF-01)', () {
      expect(validate(amountText: '0'), GoalProblem.amountNotPositive);
      expect(validate(amountText: '-5'), GoalProblem.amountNotPositive);
    });

    test('Given an amount that is not a number '
        'When it is validated '
        'Then it is refused as unreadable (AF-01)', () {
      expect(validate(amountText: 'abc'), GoalProblem.amountUnreadable);
    });

    test('Given a target date today or in the past '
        'When it is validated '
        'Then it is refused (AF-02)', () {
      expect(
        validate(targetDate: DateTime(2026, 9, 11)),
        GoalProblem.targetDateNotInFuture,
      );
      expect(
        validate(targetDate: DateTime(2026, 9, 10)),
        GoalProblem.targetDateNotInFuture,
      );
    });

    test('Given tomorrow '
        'When it is validated '
        'Then it is accepted, since that is a future to reach', () {
      expect(validate(targetDate: DateTime(2026, 9, 12)), isNull);
    });

    test('Given no target date '
        'When it is validated '
        'Then the date is refused as missing', () {
      expect(
        GoalRules.validate(
          name: 'New laptop',
          amountText: '5000.00',
          targetDate: null,
          now: now,
          isReadableAmount: (text) => parser.parse(text) != null,
          isPositiveAmount: parser.isPositive,
        ),
        GoalProblem.missingTargetDate,
      );
    });

    test('Given every problem '
        'When its message is read '
        'Then none is empty', () {
      for (final problem in GoalProblem.values) {
        expect(problem.message, isNotEmpty);
      }
    });
  });

  group('goalsProvider', () {
    test('Given the list cannot be read '
        'When it is requested '
        "Then the API's reason surfaces", () async {
      final fake = FakeGoals(
        onList: () => const Failure(
          message: 'Goals could not be read.',
          kind: FailureKind.serverError,
        ),
      );

      await expectLater(
        containerWith(fake).read(goalsProvider.future),
        throwsA(
          isA<GoalsUnavailable>().having(
            (e) => e.message,
            'message',
            'Goals could not be read.',
          ),
        ),
      );
    });
  });

  group('GoalActions', () {
    test('Given a new goal '
        'When it is created '
        'Then the exact amount reaches the repository as a string', () async {
      final fake = FakeGoals();

      await containerWith(fake)
          .read(goalActionsProvider)
          .create(
            name: 'New laptop',
            targetAmount: '1234567.89',
            currencyCode: 'BRL',
            targetDate: DateTime(2027),
          );

      expect(fake.created.single['targetAmount'], '1234567.89');
      expect(fake.created.single['name'], 'New laptop');
    });

    test('Given a goal '
        'When it is deleted '
        'Then the deletion reaches the repository', () async {
      final fake = FakeGoals();

      await containerWith(fake).read(goalActionsProvider).delete('g1');

      expect(fake.deleted, ['g1']);
    });
  });

  group('GoalsScreen', () {
    testWidgets('Given the goals are still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<Goal>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalRepositoryProvider.overrideWithValue(SlowGoals(pending.future)),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: GoalsScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(const Success([]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('goals.empty')), findsOneWidget);
    });

    testWidgets('Given no goals '
        'When the screen settles '
        'Then an empty state offers creation (AF-06)', (tester) async {
      await pumpGoals(tester, FakeGoals(onList: () => const Success([])));

      expect(find.byKey(const Key('goals.empty')), findsOneWidget);
      expect(find.byKey(const Key('goals.emptyAdd')), findsOneWidget);
    });

    testWidgets('Given the list cannot be read '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state', (
      tester,
    ) async {
      var attempts = 0;
      final fake = FakeGoals(
        onList: () {
          attempts++;
          return const Failure(
            message: 'Goals could not be read.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpGoals(tester, fake);

      expect(find.byKey(const Key('goals.empty')), findsNothing);
      expect(find.text('Goals could not be read.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('goals.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given a goal with progress '
        'When it is listed '
        'Then saved, remaining and the target are all shown (step 5)', (
      tester,
    ) async {
      await pumpGoals(tester, FakeGoals(onList: () => Success([goal()])));

      expect(find.byKey(const Key('goals.saved.g1')), findsOneWidget);
      expect(find.byKey(const Key('goals.remaining.g1')), findsOneWidget);
      expect(find.byKey(const Key('goals.target.g1')), findsOneWidget);
      expect(find.byKey(const Key('goals.bar.g1')), findsOneWidget);
      expect(find.textContaining('1,250.00'), findsOneWidget);
    });

    testWidgets('Given the proportion the API computed '
        'When the bar is drawn '
        'Then it draws that proportion', (tester) async {
      await pumpGoals(
        tester,
        FakeGoals(onList: () => Success([goal(proportion: '0.25')])),
      );

      final bar = tester.widget<LinearProgressIndicator>(
        find.byKey(const Key('goals.bar.g1')),
      );
      expect(bar.value, 0.25);
    });

    testWidgets('Given a goal overshot past its target '
        'When the bar is drawn '
        'Then it is clamped rather than drawn past its end', (tester) async {
      await pumpGoals(
        tester,
        FakeGoals(
          onList: () => Success([goal(proportion: '1.5', isReached: true)]),
        ),
      );

      final bar = tester.widget<LinearProgressIndicator>(
        find.byKey(const Key('goals.bar.g1')),
      );
      expect(bar.value, 1.0);
    });

    testWidgets('Given progress cannot be obtained '
        'When the goal is listed '
        'Then it is shown without it and the failure is reported (AF-03)', (
      tester,
    ) async {
      await pumpGoals(
        tester,
        FakeGoals(onList: () => Success([goal(withProgress: false)])),
      );

      expect(find.byKey(const Key('goals.noProgress.g1')), findsOneWidget);
      expect(find.byKey(const Key('goals.saved.g1')), findsNothing);
      expect(find.byKey(const Key('goals.bar.g1')), findsNothing);
      // The target is still shown — the goal itself is not in doubt.
      expect(find.byKey(const Key('goals.target.g1')), findsOneWidget);
    });

    testWidgets('Given the target date has passed '
        'When the goal is listed '
        'Then it is shown as elapsed with the progress it reached, not '
        'removed (AF-04)', (tester) async {
      await pumpGoals(
        tester,
        FakeGoals(onList: () => Success([goal(targetDate: DateTime(2020))])),
      );

      expect(find.byKey(const Key('goals.item.g1')), findsOneWidget);
      expect(find.byKey(const Key('goals.elapsed.g1')), findsOneWidget);
      expect(find.textContaining('how far it got'), findsOneWidget);
      // The progress it reached is still there.
      expect(find.byKey(const Key('goals.saved.g1')), findsOneWidget);
    });

    testWidgets('Given an elapsed goal that was reached '
        'When it is listed '
        'Then it says the target was met', (tester) async {
      await pumpGoals(
        tester,
        FakeGoals(
          onList: () =>
              Success([goal(targetDate: DateTime(2020), isReached: true)]),
        ),
      );

      expect(find.textContaining('the target was met'), findsOneWidget);
      expect(find.byKey(const Key('goals.reached.g1')), findsOneWidget);
    });

    testWidgets('Given a goal still in the future '
        'When it is listed '
        'Then it is not marked elapsed', (tester) async {
      await pumpGoals(
        tester,
        FakeGoals(onList: () => Success([goal(targetDate: DateTime(2099))])),
      );

      expect(find.byKey(const Key('goals.elapsed.g1')), findsNothing);
    });
  });

  group('GoalEditor', () {
    Future<void> openEditor(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('goals.emptyAdd')));
      await tester.pumpAndSettle();
    }

    Future<void> chooseTargetDate(WidgetTester tester) async {
      await tester.tap(find.byKey(const Key('goalEditor.targetDate')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    }

    testWidgets('Given an amount of zero '
        'When it is submitted '
        'Then it is refused in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = FakeGoals(onList: () => const Success([]));

      await pumpGoals(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('goalEditor.name')),
        'New laptop',
      );
      await tester.enterText(find.byKey(const Key('goalEditor.amount')), '0');
      await tester.tap(find.byKey(const Key('goalEditor.save')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('goalEditor.error')), findsOneWidget);
      expect(find.text(GoalProblem.amountNotPositive.message), findsOneWidget);
      expect(fake.created, isEmpty);
    });

    testWidgets('Given no name '
        'When it is submitted '
        'Then it is refused in the form', (tester) async {
      final fake = FakeGoals(onList: () => const Success([]));

      await pumpGoals(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('goalEditor.amount')),
        '5000.00',
      );
      await tester.tap(find.byKey(const Key('goalEditor.save')));
      await tester.pumpAndSettle();

      expect(find.text(GoalProblem.missingName.message), findsOneWidget);
      expect(fake.created, isEmpty);
    });

    testWidgets('Given no target date is chosen '
        'When it is submitted '
        'Then it is refused in the form (AF-02)', (tester) async {
      final fake = FakeGoals(onList: () => const Success([]));

      await pumpGoals(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('goalEditor.name')),
        'New laptop',
      );
      await tester.enterText(
        find.byKey(const Key('goalEditor.amount')),
        '5000.00',
      );
      await tester.tap(find.byKey(const Key('goalEditor.save')));
      await tester.pumpAndSettle();

      expect(find.text(GoalProblem.missingTargetDate.message), findsOneWidget);
      expect(fake.created, isEmpty);
    });

    testWidgets('Given a complete form '
        'When it is submitted '
        'Then the goal is created with the typed amount', (tester) async {
      final fake = FakeGoals(onList: () => const Success([]));

      await pumpGoals(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('goalEditor.name')),
        'New laptop',
      );
      await tester.enterText(
        find.byKey(const Key('goalEditor.amount')),
        '5000.00',
      );
      await tester.tap(find.byKey(const Key('goalEditor.currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BRL').last);
      await tester.pumpAndSettle();
      await chooseTargetDate(tester);
      await tester.tap(find.byKey(const Key('goalEditor.save')));
      await tester.pumpAndSettle();

      expect(fake.created.single['targetAmount'], '5000');
      expect(fake.created.single['name'], 'New laptop');
      expect(fake.created.single['currencyCode'], 'BRL');
    });

    testWidgets('Given an existing goal '
        'When it is opened for editing '
        'Then its values are present and the currency is fixed', (
      tester,
    ) async {
      await pumpGoals(tester, FakeGoals(onList: () => Success([goal()])));

      await tester.tap(find.byKey(const Key('goals.item.g1')));
      await tester.pumpAndSettle();

      expect(find.text('New laptop'), findsWidgets);
      expect(find.byKey(const Key('goalEditor.currency')), findsNothing);
    });

    testWidgets('Given the API refuses the goal '
        'When it is submitted '
        "Then the API's reason is shown in the form", (tester) async {
      final fake = FakeGoals(
        onList: () => const Success([]),
        onCreate: () => const Failure(
          message: 'A goal with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );

      await pumpGoals(tester, fake);
      await openEditor(tester);
      await tester.enterText(
        find.byKey(const Key('goalEditor.name')),
        'New laptop',
      );
      await tester.enterText(
        find.byKey(const Key('goalEditor.amount')),
        '5000.00',
      );
      await tester.tap(find.byKey(const Key('goalEditor.currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BRL').last);
      await tester.pumpAndSettle();
      await chooseTargetDate(tester);
      await tester.tap(find.byKey(const Key('goalEditor.save')));
      await tester.pumpAndSettle();

      expect(
        find.text('A goal with that name already exists.'),
        findsOneWidget,
      );
    });
  });
}
