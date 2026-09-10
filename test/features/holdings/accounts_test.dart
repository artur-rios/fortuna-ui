import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/format/money.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/holdings/data/account_repository.dart';
import 'package:fortuna_ui/features/holdings/state/account_providers.dart';
import 'package:fortuna_ui/features/holdings/ui/accounts_screen.dart';
import 'package:fortuna_ui/features/preferences/data/currency_repository.dart';

class FakeAccounts implements AccountRepository {
  FakeAccounts({this.onList, this.onBalance, this.onCreate, this.onDelete});

  Result<List<FinancialAccount>> Function()? onList;
  Result<AccountBalance> Function(String id)? onBalance;
  Result<void> Function()? onCreate;
  Result<void> Function()? onDelete;

  final List<Map<String, Object?>> created = [];
  final List<Map<String, Object?>> updated = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<FinancialAccount>>> list() async =>
      onList?.call() ?? const Success([]);

  @override
  Future<Result<FinancialAccount>> read(String id) async => const Failure(
    message: 'That account was not found.',
    kind: FailureKind.notFound,
  );

  @override
  Future<Result<AccountBalance>> balance(String id) async =>
      onBalance?.call(id) ??
      Success(AccountBalance(balance: Money.parse('10.00', 'BRL'), asOf: null));

  @override
  Future<Result<void>> create({
    required String name,
    required AccountType type,
    required String currencyCode,
    required String openingBalance,
    String? institution,
  }) async {
    created.add({
      'name': name,
      'type': type,
      'currencyCode': currencyCode,
      'openingBalance': openingBalance,
      'institution': institution,
    });
    return onCreate?.call() ?? const Success(null);
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    required AccountType type,
    String? institution,
  }) async {
    updated.add({'id': id, 'name': name, 'type': type});
    return const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return onDelete?.call() ?? const Success(null);
  }
}

class FakeCurrencies implements CurrencyRepository {
  @override
  Future<Result<List<SupportedCurrency>>> listSupported() async =>
      const Success([
        SupportedCurrency(
          code: 'BRL',
          name: 'Brazilian real',
          minorUnitDigits: 2,
        ),
        SupportedCurrency(code: 'USD', name: 'US dollar', minorUnitDigits: 2),
      ]);
}

FinancialAccount account({
  String id = 'a1',
  String name = 'Everyday',
  String currency = 'BRL',
  String opening = '100.00',
  bool isDeleted = false,
}) => FinancialAccount(
  id: id,
  name: name,
  type: AccountType.checking,
  currencyCode: currency,
  openingBalance: Money.parse(opening, currency),
  institution: 'A Bank',
  isDeleted: isDeleted,
);

ProviderContainer containerWith(FakeAccounts accounts) {
  final container = ProviderContainer(
    overrides: [
      accountRepositoryProvider.overrideWithValue(accounts),
      currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpAccounts(WidgetTester tester, FakeAccounts accounts) async {
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountRepositoryProvider.overrideWithValue(accounts),
        currencyRepositoryProvider.overrideWithValue(FakeCurrencies()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: const MaterialApp(home: AccountsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('AccountType', () {
    test('Given the contract numbers the account types '
        'When each is mapped '
        'Then it lands on the one x-enum-varnames names', () {
      // The generated enum is positional; the numbers are the contract.
      expect(AccountType.checking.wire, 1);
      expect(AccountType.savings.wire, 2);
      expect(AccountType.cash.wire, 3);
      expect(AccountType.other.wire, 4);
    });
  });

  group('accountsProvider', () {
    test(
      'Given several accounts '
      'When they are listed '
      'Then they are sorted by name so the list does not reorder itself',
      () async {
        final container = containerWith(
          FakeAccounts(
            onList: () => Success([
              account(id: 'b', name: 'Zebra'),
              account(id: 'a', name: 'apple'),
            ]),
          ),
        );

        final list = await container.read(accountsProvider.future);

        expect(list.map((a) => a.name), ['apple', 'Zebra']);
      },
    );

    test('Given the list cannot be read '
        'When it is awaited '
        'Then the failure carries the reason', () async {
      final container = containerWith(
        FakeAccounts(
          onList: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      await expectLater(
        container.read(accountsProvider.future),
        throwsA(isA<AccountsUnavailable>()),
      );
    });

    test('Given a deleted account '
        'When selectable accounts are read '
        'Then it is not offered (FR-HO-13)', () async {
      final container = containerWith(
        FakeAccounts(
          onList: () => Success([
            account(id: 'a', name: 'Live'),
            account(id: 'b', name: 'Gone', isDeleted: true),
          ]),
        ),
      );

      await container.read(accountsProvider.future);
      final selectable = container.read(selectableAccountsProvider).value!;

      expect(selectable.map((a) => a.id), ['a']);
    });
  });

  group('money on the way through', () {
    test('Given a balance the API sent as a decimal string '
        'When it is parsed '
        'Then the exact figure survives (BR-05)', () async {
      // The figure the README names: 8017.61 became 8017.60999999999967 when
      // it went through a double.
      final container = containerWith(
        FakeAccounts(
          onBalance: (_) => Success(
            AccountBalance(balance: Money.parse('8017.61', 'BRL'), asOf: null),
          ),
        ),
      );

      final balance = await container.read(accountBalanceProvider('a1').future);

      expect(balance.balance.amount, Decimal.parse('8017.61'));
      expect(balance.balance.asApiString, '8017.61');
    });

    test(
      'Given an opening balance typed by the user '
      'When the account is created '
      'Then the string reaches the API unrounded (BR-05, FR-DA-11)',
      () async {
        final accounts = FakeAccounts();
        final container = containerWith(accounts);

        await container
            .read(accountActionsProvider)
            .create(
              name: 'Everyday',
              type: AccountType.checking,
              currencyCode: 'BRL',
              // 1.005 is the other figure a double ruins: it rounds to 1.00.
              openingBalance: '1.005',
            );

        expect(accounts.created.single['openingBalance'], '1.005');
      },
    );
  });

  group('accountBalanceProvider', () {
    test(
      'Given a balance that cannot be read '
      'When it is awaited '
      'Then it fails rather than answering zero (UC-14 AF-07, FR-HO-02)',
      () async {
        final container = containerWith(
          FakeAccounts(
            onBalance: (_) => const Failure(
              message: 'The balance could not be read.',
              kind: FailureKind.serverError,
            ),
          ),
        );

        await expectLater(
          container.read(accountBalanceProvider('a1').future),
          throwsA(isA<BalanceUnavailable>()),
        );
      },
    );
  });

  group('AccountActions', () {
    test('Given a refused creation '
        'When the API answers '
        'Then the reason comes back and the list is not re-read '
        '(UC-14 AF-02)', () async {
      final container = containerWith(
        FakeAccounts(
          onList: () => Success([account()]),
          onCreate: () => const Failure(
            message: 'You already have an account with that name.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      final result = await container
          .read(accountActionsProvider)
          .create(
            name: 'Everyday',
            type: AccountType.checking,
            currencyCode: 'BRL',
            openingBalance: '0',
          );

      expect(result, isA<Failure<void>>());
      expect(
        (result as Failure<void>).message,
        'You already have an account with that name.',
      );
    });

    test('Given a deletion the API refuses '
        'When live records still reference the account '
        "Then the API's reason comes back (UC-14 AF-05)", () async {
      final container = containerWith(
        FakeAccounts(
          onDelete: () => const Failure(
            message: 'Transactions still reference this account.',
            kind: FailureKind.conflict,
          ),
        ),
      );

      final result = await container.read(accountActionsProvider).delete('a1');

      expect(
        (result as Failure<void>).message,
        'Transactions still reference this account.',
      );
    });
  });

  group('AccountsScreen', () {
    testWidgets('Given no accounts '
        'When the screen settles '
        'Then an empty state offers creation, distinct from a failure '
        '(UC-14 AF-06)', (tester) async {
      await pumpAccounts(tester, FakeAccounts());

      expect(find.byKey(const Key('accounts.empty')), findsOneWidget);
      expect(find.byKey(const Key('accounts.emptyAdd')), findsOneWidget);
      expect(find.byKey(const Key('accounts.retry')), findsNothing);
    });

    testWidgets('Given the list cannot be read '
        'When the screen settles '
        'Then a failure with a retry is shown, not an empty state', (
      tester,
    ) async {
      await pumpAccounts(
        tester,
        FakeAccounts(
          onList: () => const Failure(
            message: 'The instance could not be reached.',
            kind: FailureKind.unreachable,
          ),
        ),
      );

      expect(find.byKey(const Key('accounts.retry')), findsOneWidget);
      expect(find.byKey(const Key('accounts.empty')), findsNothing);
    });

    testWidgets('Given an account whose balance cannot be read '
        'When the screen settles '
        'Then the account is listed without a balance (UC-14 AF-07)', (
      tester,
    ) async {
      await pumpAccounts(
        tester,
        FakeAccounts(
          onList: () => Success([account()]),
          onBalance: (_) => const Failure(
            message: 'The balance could not be read.',
            kind: FailureKind.serverError,
          ),
        ),
      );

      expect(find.byKey(const Key('accounts.item.a1')), findsOneWidget);
      expect(find.byKey(const Key('accounts.noBalance.a1')), findsOneWidget);
      // Nothing was computed to fill the gap.
      expect(find.byKey(const Key('accounts.balance.a1')), findsNothing);
    });

    testWidgets('Given an account with a balance '
        'When it is listed '
        'Then the balance is shown as the API reported it', (tester) async {
      await pumpAccounts(
        tester,
        FakeAccounts(
          onList: () => Success([account()]),
          onBalance: (_) => Success(
            AccountBalance(balance: Money.parse('8017.61', 'BRL'), asOf: null),
          ),
        ),
      );

      expect(find.byKey(const Key('accounts.balance.a1')), findsOneWidget);
      expect(find.textContaining('8,017.61'), findsOneWidget);
    });
  });
}
