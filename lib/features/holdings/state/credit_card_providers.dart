/// Credit card state (UC-15).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/credit_card_repository.dart';

/// The user's cards, sorted by name.
///
/// `FR-HO-13`: the only source of cards anywhere, scoped by the API to the
/// signed-in user.
final creditCardsProvider = FutureProvider<List<CreditCard>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('creditCards', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(creditCardRepositoryProvider).list();

    return switch (result) {
      Success<List<CreditCard>>(:final value) =>
        value.toList()..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        ),
      Failure<List<CreditCard>>(:final message) => throw CreditCardsUnavailable(
        message,
      ),
    };
  },
);

class CreditCardsUnavailable implements Exception {
  const CreditCardsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// What the form checks before anything is submitted (`UC-15` step 3, `AF-01`).
///
/// Deliberately only the two rules the specification states — a limit above
/// zero and days within a month. Whether a particular closing and due day make
/// sense together is the API's judgement (`AF-02`), and guessing at it here
/// would refuse combinations the API would have accepted.
abstract final class CreditCardRules {
  static const dayRange = '1 to 31';

  /// Whether [day] could be a day of a month.
  static bool isDayInRange(int? day) => day != null && day >= 1 && day <= 31;

  /// Whether [limit] reads as an amount greater than zero.
  ///
  /// Read as text, never parsed to a number. This is the one validation in the
  /// application that looks at money, and doing it through a `double` is
  /// exactly what `IR-14` forbids — so "greater than zero" is asked as "is
  /// there a digit here that is not a zero, and is it not negative".
  static bool isPositiveAmount(String limit) {
    final trimmed = limit.trim();

    if (trimmed.isEmpty || trimmed.startsWith('-')) return false;
    return RegExp('[1-9]').hasMatch(trimmed);
  }
}

/// Changes to the card set, re-reading the list after a confirmed change.
class CreditCardActions {
  const CreditCardActions(this._ref);

  final Ref _ref;

  Future<Result<void>> create({
    required String name,
    required String currencyCode,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
    String? lastFourDigits,
  }) => _afterChange(
    () => _ref
        .read(creditCardRepositoryProvider)
        .create(
          name: name,
          currencyCode: currencyCode,
          creditLimit: creditLimit,
          closingDay: closingDay,
          dueDay: dueDay,
          issuer: issuer,
          lastFourDigits: lastFourDigits,
        ),
  );

  Future<Result<void>> update({
    required String id,
    required String name,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
  }) => _afterChange(
    () => _ref
        .read(creditCardRepositoryProvider)
        .update(
          id: id,
          name: name,
          creditLimit: creditLimit,
          closingDay: closingDay,
          dueDay: dueDay,
          issuer: issuer,
        ),
  );

  Future<Result<void>> delete(String id) =>
      _afterChange(() => _ref.read(creditCardRepositoryProvider).delete(id));

  Future<Result<void>> _afterChange(
    Future<Result<void>> Function() call,
  ) async {
    final result = await call();
    if (result.isSuccess) _ref.invalidate(creditCardsProvider);
    return result;
  }
}

final creditCardActionsProvider = Provider<CreditCardActions>(
  CreditCardActions.new,
);
