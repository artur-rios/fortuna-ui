/// Financial account state (UC-14).
///
/// The balance is a provider of its own, per account, for one reason: `AF-07`
/// asks that a balance which cannot be read leave the account visible without
/// one. Folding the balance into the account would make a single unreadable
/// balance hide the whole list.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/account_repository.dart';

/// The user's accounts, sorted by name so the list does not reorder itself on
/// every read.
///
/// `FR-HO-13`: this is the only source of accounts anywhere in the
/// application, and the API scopes it to the signed-in user — so a selection
/// built on it cannot offer somebody else's account.
final accountsProvider = FutureProvider<List<FinancialAccount>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('accounts', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(accountRepositoryProvider).list();

    return switch (result) {
      Success<List<FinancialAccount>>(:final value) =>
        value.toList()..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        ),
      Failure<List<FinancialAccount>>(:final message) =>
        throw AccountsUnavailable(message),
    };
  },
);

/// Accounts a user may still choose — the deleted ones are not offered.
final selectableAccountsProvider = Provider<AsyncValue<List<FinancialAccount>>>(
  (ref) => ref
      .watch(accountsProvider)
      .whenData(
        (accounts) => [
          for (final account in accounts)
            if (!account.isDeleted) account,
        ],
      ),
);

/// One account's balance, as the API reports it (`FR-HO-02`).
final accountBalanceProvider = FutureProvider.family<AccountBalance, String>(
  retry: (retryCount, error) => null,
  (ref, id) async {
    final result = await ref.read(accountRepositoryProvider).balance(id);

    return switch (result) {
      Success<AccountBalance>(:final value) => value,
      // AF-07: thrown so the screen can show the account without a balance and
      // report the failure, rather than showing a zero nobody computed.
      Failure<AccountBalance>(:final message) => throw BalanceUnavailable(
        message,
      ),
    };
  },
);

class AccountsUnavailable implements Exception {
  const AccountsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

class BalanceUnavailable implements Exception {
  const BalanceUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Changes to the account set, re-reading the list after a confirmed change.
class AccountActions {
  const AccountActions(this._ref);

  final Ref _ref;

  Future<Result<void>> create({
    required String name,
    required AccountType type,
    required String currencyCode,
    required String openingBalance,
    String? institution,
  }) => _afterChange(
    () => _ref
        .read(accountRepositoryProvider)
        .create(
          name: name,
          type: type,
          currencyCode: currencyCode,
          openingBalance: openingBalance,
          institution: institution,
        ),
  );

  Future<Result<void>> update({
    required String id,
    required String name,
    required AccountType type,
    String? institution,
  }) => _afterChange(
    () => _ref
        .read(accountRepositoryProvider)
        .update(id: id, name: name, type: type, institution: institution),
  );

  Future<Result<void>> delete(String id) =>
      _afterChange(() => _ref.read(accountRepositoryProvider).delete(id));

  /// Re-reads only where the API confirmed the change (`FR-DA-13`).
  Future<Result<void>> _afterChange(
    Future<Result<void>> Function() call,
  ) async {
    final result = await call();
    if (result.isSuccess) _ref.invalidate(accountsProvider);
    return result;
  }
}

final accountActionsProvider = Provider<AccountActions>(AccountActions.new);
