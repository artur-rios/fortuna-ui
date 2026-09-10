import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/holdings/data/investment_repository.dart';
import 'package:fortuna_ui/features/holdings/state/investment_providers.dart';
import 'package:fortuna_ui/features/holdings/ui/investment_screen.dart';
import 'package:fortuna_ui/features/holdings/ui/investments_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

import 'accounts_test.dart' show FakeCurrencies;

class FakeInvestments implements InvestmentRepository {
  FakeInvestments({
    this.onList,
    this.onRead,
    this.onCreate,
    this.onUpdate,
    this.onDelete,
  });

  Result<List<Investment>> Function()? onList;
  Result<Investment> Function(String id)? onRead;
  Result<void> Function()? onCreate;
  Result<void> Function()? onUpdate;
  Result<void> Function()? onDelete;

  final List<Map<String, Object?>> created = [];
  final List<Map<String, Object?>> updated = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<Investment>>> list() async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<Investment>> read(String id) async =>
      onRead?.call(id) ?? Success(investment());

  @override
  Future<Result<void>> create({
    required String instrument,
    required String currencyCode,
    required InvestmentType type,
    String? institution,
  }) async {
    created.add({
      'instrument': instrument,
      'currencyCode': currencyCode,
      'type': type,
      'institution': institution,
    });
    return onCreate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String instrument,
    required InvestmentType type,
    String? institution,
  }) async {
    updated.add({
      'id': id,
      'instrument': instrument,
      'type': type,
      'institution': institution,
    });
    return onUpdate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return onDelete?.call() ?? const Success(null);
  }
}

/// Answers only when the test lets it, so the loading state is observable.
class SlowInvestments extends FakeInvestments {
  SlowInvestments(this._pending);

  final Future<Result<List<Investment>>> _pending;

  @override
  Future<Result<List<Investment>>> list() => _pending;
}

Investment investment({
  String id = 'i1',
  String instrument = 'Treasury 2030',
  String position = '15000.00',
  InvestmentType type = InvestmentType.fixedIncome,
  String? institution = 'A Bank',
  String? valuation,
  DateTime? valuationDate,
  bool isIndependentlyValued = false,
}) => Investment(
  id: id,
  instrument: instrument,
  currencyCode: 'BRL',
  type: type,
  position: Money.parse(position, 'BRL'),
  isIndependentlyValued: isIndependentlyValued,
  institution: institution,
  latestValuation: valuation == null
      ? null
      : RecordedValuation(
          value: Money.parse(valuation, 'BRL'),
          asOf: valuationDate,
        ),
);

ProviderContainer containerWith(FakeInvestments fake) {
  final container = ProviderContainer(
    overrides: [
      investmentRepositoryProvider.overrideWithValue(fake),
      currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _pump(
  WidgetTester tester,
  Widget screen,
  FakeInvestments fake,
) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        investmentRepositoryProvider.overrideWithValue(fake),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: MaterialApp(home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpInvestments(WidgetTester tester, FakeInvestments fake) =>
    _pump(tester, const InvestmentsScreen(), fake);

Future<void> pumpInvestment(WidgetTester tester, FakeInvestments fake) =>
    _pump(tester, const InvestmentScreen(investmentId: 'i1'), fake);

void main() {
  group('InvestmentType', () {
    test('Given the numbers the contract specifies '
        'When they are mapped '
        'Then each becomes its own type', () {
      expect(InvestmentType.fixedIncome.wire, 1);
      expect(InvestmentType.equity.wire, 2);
      expect(InvestmentType.fund.wire, 3);
      expect(InvestmentType.other.wire, 4);
    });

    test('Given a type the client does not recognize '
        'When it is mapped '
        'Then it reads as other rather than failing', () {
      expect(InvestmentType.from(null), InvestmentType.other);
    });
  });

  group('Investment', () {
    test('Given an investment with no recorded valuation '
        'When it is asked '
        'Then it reports the absence rather than a zero (AF-05)', () {
      final none = investment();

      expect(none.hasNoValuation, isTrue);
      expect(none.latestValuation, isNull);
    });

    test('Given an investment with a recorded valuation '
        'When it is asked '
        'Then the valuation and its date are both held', () {
      final valued = investment(
        valuation: '16250.75',
        valuationDate: DateTime(2026, 8, 31),
      );

      expect(valued.hasNoValuation, isFalse);
      expect(valued.latestValuation!.value.amount, Decimal.parse('16250.75'));
      expect(valued.latestValuation!.asOf, DateTime(2026, 8, 31));
    });

    test('Given a position a double would not represent exactly '
        'When it is held and re-serialized '
        'Then it survives the round trip unchanged', () {
      final held = investment(position: '1234567.89');

      expect(held.position.amount, Decimal.parse('1234567.89'));
      expect(held.position.asApiString, '1234567.89');
    });

    test('Given a position with more decimals than the currency shows '
        'When it is held '
        'Then the held value keeps every digit', () {
      final held = investment(position: '100.005');

      expect(held.position.amount, Decimal.parse('100.005'));
    });
  });

  group('InvestmentRules', () {
    test('Given an instrument name '
        'When it is checked '
        'Then only presence is required (AF-01)', () {
      expect(InvestmentRules.isPresent('Treasury 2030'), isTrue);
      expect(InvestmentRules.isPresent('  '), isFalse);
      expect(InvestmentRules.isPresent(''), isFalse);
    });
  });

  group('investmentsProvider', () {
    test('Given several investments '
        'When they are read '
        'Then they are sorted by instrument, case-insensitively', () async {
      final fake = FakeInvestments(
        onList: () => Success([
          investment(id: 'b', instrument: 'zeta fund'),
          investment(id: 'a', instrument: 'Alpha bond'),
        ]),
      );

      final list = await containerWith(fake).read(investmentsProvider.future);

      expect(list.map((i) => i.instrument), ['Alpha bond', 'zeta fund']);
    });

    test('Given the list cannot be read '
        'When it is requested '
        "Then the API's reason surfaces", () async {
      final fake = FakeInvestments(
        onList: () => const Failure(
          message: 'Investments could not be read.',
          kind: FailureKind.serverError,
        ),
      );

      await expectLater(
        containerWith(fake).read(investmentsProvider.future),
        throwsA(
          isA<InvestmentsUnavailable>().having(
            (e) => e.message,
            'message',
            'Investments could not be read.',
          ),
        ),
      );
    });
  });

  group('investmentProvider', () {
    test('Given an investment that does not exist '
        'When it is read '
        "Then the API's not-found reason surfaces (AF-03)", () async {
      final fake = FakeInvestments(
        onRead: (_) => const Failure(
          message: 'That investment was not found.',
          kind: FailureKind.notFound,
        ),
      );

      await expectLater(
        containerWith(fake).read(investmentProvider('i1').future),
        throwsA(
          isA<InvestmentsUnavailable>().having(
            (e) => e.message,
            'message',
            'That investment was not found.',
          ),
        ),
      );
    });
  });

  group('InvestmentActions', () {
    test(
      'Given a new investment '
      'When it is created '
      'Then the instrument, currency and type reach the repository',
      () async {
        final fake = FakeInvestments();

        await containerWith(fake)
            .read(investmentActionsProvider)
            .create(
              instrument: 'Treasury 2030',
              currencyCode: 'BRL',
              type: InvestmentType.fixedIncome,
              institution: 'A Bank',
            );

        expect(fake.created.single['instrument'], 'Treasury 2030');
        expect(fake.created.single['currencyCode'], 'BRL');
        expect(fake.created.single['type'], InvestmentType.fixedIncome);
      },
    );

    test('Given a name that duplicates another '
        'When the API refuses '
        'Then its reason is carried back unchanged (AF-02)', () async {
      final fake = FakeInvestments(
        onCreate: () => const Failure(
          message: 'You already hold an investment called Treasury 2030.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(investmentActionsProvider)
          .create(
            instrument: 'Treasury 2030',
            currencyCode: 'BRL',
            type: InvestmentType.fixedIncome,
          );

      expect(
        result,
        const Failure<void>(
          message: 'You already hold an investment called Treasury 2030.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given deletion is refused because movements reference it '
        'When it is attempted '
        "Then the API's reason is carried back (AF-04)", () async {
      final fake = FakeInvestments(
        onDelete: () => const Failure(
          message: 'This investment still has movements recorded against it.',
          kind: FailureKind.conflict,
        ),
      );

      final result = await containerWith(fake)
          .read(investmentActionsProvider)
          .delete('i1');

      expect(
        result,
        const Failure<void>(
          message: 'This investment still has movements recorded against it.',
          kind: FailureKind.conflict,
        ),
      );
      expect(fake.deleted, ['i1']);
    });
  });

  group('InvestmentsScreen', () {
    testWidgets('Given the list is still loading '
        'When the screen is built '
        'Then a progress indicator is shown', (tester) async {
      final pending = Completer<Result<List<Investment>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            investmentRepositoryProvider.overrideWithValue(
              SlowInvestments(pending.future),
            ),
            currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
            preferencesStoreProvider.overrideWithValue(
              InMemoryPreferencesStore(),
            ),
          ],
          child: const MaterialApp(home: InvestmentsScreen()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      pending.complete(const Success([]));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('investments.empty')), findsOneWidget);
    });

    testWidgets('Given no investments '
        'When the screen settles '
        'Then an empty state offers creation (AF-06)', (tester) async {
      await pumpInvestments(
        tester,
        FakeInvestments(onList: () => const Success([])),
      );

      expect(find.byKey(const Key('investments.empty')), findsOneWidget);
      expect(find.byKey(const Key('investments.emptyAdd')), findsOneWidget);
    });

    testWidgets('Given the list cannot be read '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state', (
      tester,
    ) async {
      var attempts = 0;
      final fake = FakeInvestments(
        onList: () {
          attempts++;
          return const Failure(
            message: 'Investments could not be read.',
            kind: FailureKind.serverError,
          );
        },
      );

      await pumpInvestments(tester, fake);

      expect(find.byKey(const Key('investments.empty')), findsNothing);
      expect(find.text('Investments could not be read.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('investments.retry')));
      await tester.pumpAndSettle();

      expect(attempts, 2);
    });

    testWidgets('Given an investment '
        'When it is listed '
        'Then its position is shown as the API reported it (FR-HO-12)', (
      tester,
    ) async {
      await pumpInvestments(
        tester,
        FakeInvestments(
          onList: () => Success([investment(position: '15000.00')]),
        ),
      );

      expect(find.byKey(const Key('investments.position.i1')), findsOneWidget);
      expect(find.textContaining('15,000.00'), findsOneWidget);
    });

    testWidgets('Given an investment with no valuation '
        'When it is listed '
        'Then the row says so rather than implying the position is a value '
        '(AF-05)', (tester) async {
      await pumpInvestments(
        tester,
        FakeInvestments(onList: () => Success([investment()])),
      );

      expect(
        find.byKey(const Key('investments.noValuation.i1')),
        findsOneWidget,
      );
    });

    testWidgets('Given an investment that has been valued '
        'When it is listed '
        'Then no absent-valuation note is shown', (tester) async {
      await pumpInvestments(
        tester,
        FakeInvestments(
          onList: () => Success([investment(valuation: '16250.75')]),
        ),
      );

      expect(find.byKey(const Key('investments.noValuation.i1')), findsNothing);
    });
  });

  group('InvestmentScreen', () {
    testWidgets('Given an investment '
        'When it is opened '
        'Then its position is shown', (tester) async {
      await pumpInvestment(
        tester,
        FakeInvestments(
          onRead: (_) => Success(investment(position: '15000.00')),
        ),
      );

      expect(find.byKey(const Key('investment.position')), findsOneWidget);
      expect(find.textContaining('15,000.00'), findsWidgets);
    });

    testWidgets('Given no valuation has been recorded '
        'When the investment is opened '
        'Then it states the absence and says it does not price instruments '
        '(AF-05, FR-HO-12)', (tester) async {
      await pumpInvestment(
        tester,
        FakeInvestments(onRead: (_) => Success(investment())),
      );

      expect(find.byKey(const Key('investment.noValuation')), findsOneWidget);
      expect(find.byKey(const Key('investment.valuation')), findsNothing);
      expect(find.textContaining('does not price instruments'), findsOneWidget);
    });

    testWidgets('Given a recorded valuation '
        'When the investment is opened '
        'Then the valuation and its date are shown', (tester) async {
      await pumpInvestment(
        tester,
        FakeInvestments(
          onRead: (_) => Success(
            investment(
              valuation: '16250.75',
              valuationDate: DateTime(2026, 8, 31),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('investment.valuation')), findsOneWidget);
      expect(find.byKey(const Key('investment.noValuation')), findsNothing);
      expect(find.textContaining('16,250.75'), findsWidgets);
      expect(find.textContaining('Recorded for'), findsOneWidget);
    });

    testWidgets('Given the investment does not exist '
        'When the screen settles '
        'Then it is presented as not found (AF-03)', (tester) async {
      await pumpInvestment(
        tester,
        FakeInvestments(
          onRead: (_) => const Failure(
            message: 'That investment was not found.',
            kind: FailureKind.notFound,
          ),
        ),
      );

      expect(find.text('That investment was not found.'), findsOneWidget);
      expect(find.byKey(const Key('investment.edit')), findsNothing);
    });
  });

  group('InvestmentEditor', () {
    testWidgets('Given no instrument is given '
        'When creation is attempted '
        'Then it is rejected in the form and nothing is sent (AF-01)', (
      tester,
    ) async {
      final fake = FakeInvestments(onList: () => const Success([]));

      await pumpInvestments(tester, fake);
      await tester.tap(find.byKey(const Key('investments.emptyAdd')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('investmentEditor.save')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('investmentEditor.error')), findsOneWidget);
      expect(find.text('Name the instrument.'), findsOneWidget);
      expect(fake.created, isEmpty);
    });

    testWidgets('Given an instrument but no currency '
        'When creation is attempted '
        'Then it is rejected in the form (AF-01)', (tester) async {
      final fake = FakeInvestments(onList: () => const Success([]));

      await pumpInvestments(tester, fake);
      await tester.tap(find.byKey(const Key('investments.emptyAdd')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('investmentEditor.instrument')),
        'Treasury 2030',
      );
      await tester.tap(find.byKey(const Key('investmentEditor.save')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Choose the currency'), findsOneWidget);
      expect(fake.created, isEmpty);
    });

    testWidgets('Given a complete form '
        'When it is submitted '
        'Then the investment is created', (tester) async {
      final fake = FakeInvestments(onList: () => const Success([]));

      await pumpInvestments(tester, fake);
      await tester.tap(find.byKey(const Key('investments.emptyAdd')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('investmentEditor.instrument')),
        'Treasury 2030',
      );
      await tester.tap(find.byKey(const Key('investmentEditor.currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BRL').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('investmentEditor.save')));
      await tester.pumpAndSettle();

      expect(fake.created.single['instrument'], 'Treasury 2030');
      expect(fake.created.single['currencyCode'], 'BRL');
    });

    testWidgets('Given the API refuses a duplicate name '
        'When creation is submitted '
        "Then the API's reason is shown in the form (AF-02)", (tester) async {
      final fake = FakeInvestments(
        onList: () => const Success([]),
        onCreate: () => const Failure(
          message: 'You already hold an investment called Treasury 2030.',
          kind: FailureKind.conflict,
        ),
      );

      await pumpInvestments(tester, fake);
      await tester.tap(find.byKey(const Key('investments.emptyAdd')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('investmentEditor.instrument')),
        'Treasury 2030',
      );
      await tester.tap(find.byKey(const Key('investmentEditor.currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BRL').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('investmentEditor.save')));
      await tester.pumpAndSettle();

      expect(
        find.text('You already hold an investment called Treasury 2030.'),
        findsOneWidget,
      );
    });

    testWidgets('Given an existing investment '
        'When it is edited '
        'Then the currency is not offered for change', (tester) async {
      await pumpInvestment(
        tester,
        FakeInvestments(onRead: (_) => Success(investment())),
      );

      await tester.tap(find.byKey(const Key('investment.edit')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('investmentEditor.instrument')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('investmentEditor.currency')), findsNothing);
    });

    testWidgets('Given deletion is refused because movements reference it '
        'When it is attempted from the editor '
        "Then the API's reason is shown (AF-04)", (tester) async {
      await pumpInvestment(
        tester,
        FakeInvestments(
          onRead: (_) => Success(investment()),
          onDelete: () => const Failure(
            message: 'This investment still has movements recorded against it.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('investment.edit')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('investmentEditor.delete')));
      await tester.pumpAndSettle();

      expect(
        find.text('This investment still has movements recorded against it.'),
        findsOneWidget,
      );
    });
  });
}
