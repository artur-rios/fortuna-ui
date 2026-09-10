/// Investment state (UC-17).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/investment_repository.dart';
import 'account_providers.dart';

/// The user's investments, sorted by instrument.
///
/// `FR-HO-13`: the only source of investments anywhere, scoped by the API to
/// the signed-in user.
final investmentsProvider = FutureProvider<List<Investment>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('investments', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(investmentRepositoryProvider).list();

    return switch (result) {
      Success<List<Investment>>(:final value) =>
        value.toList()..sort(
          (a, b) =>
              a.instrument.toLowerCase().compareTo(b.instrument.toLowerCase()),
        ),
      Failure<List<Investment>>(:final message) => throw InvestmentsUnavailable(
        message,
      ),
    };
  },
);

/// One investment and its position (`UC-17` step 4).
final investmentProvider = FutureProvider.family<Investment, String>(
  retry: (retryCount, error) => null,
  (ref, id) async {
    final result = await ref.read(investmentRepositoryProvider).read(id);

    return switch (result) {
      Success<Investment>(:final value) => value,
      // AF-03 arrives here as the API's own not-found message.
      Failure<Investment>(:final message) => throw InvestmentsUnavailable(
        message,
      ),
    };
  },
);

class InvestmentsUnavailable implements Exception {
  const InvestmentsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The valuations recorded against one investment (`UC-18`).
final investmentValuationsProvider =
    FutureProvider.family<List<RecordedValuation>, String>(
      retry: (retryCount, error) => null,
      (ref, investmentId) async {
        final result = await ref
            .read(investmentRepositoryProvider)
            .valuations(investmentId);

        return switch (result) {
          Success<List<RecordedValuation>>(:final value) => value,
          Failure<List<RecordedValuation>>(:final message) =>
            throw InvestmentsUnavailable(message),
        };
      },
    );

/// What the form checks before anything is submitted (`AF-01`).
///
/// Deliberately only presence. Whether an instrument name duplicates another
/// is the API's judgement (`AF-02`), and a client that guessed at it would
/// refuse names the API would have accepted.
abstract final class InvestmentRules {
  static bool isPresent(String value) => value.trim().isNotEmpty;

  /// Whether [amount] reads as greater than zero (`UC-18` step 3, `AF-01`).
  ///
  /// Read as text, never parsed to a number — the same approach
  /// `CreditCardRules.isPositiveAmount` takes, and for the same reason:
  /// validating money through a `double` is exactly what `IR-14` forbids.
  static bool isPositiveAmount(String amount) {
    final trimmed = amount.trim();

    if (trimmed.isEmpty || trimmed.startsWith('-')) return false;
    return RegExp('[1-9]').hasMatch(trimmed);
  }

  /// Whether [date] is on or before [now] (`UC-18` step 3, `AF-02`).
  ///
  /// [now] is passed in rather than read from the clock so the rule is a pure
  /// function that a test can pin. Compared by day, not by instant: a
  /// valuation recorded for today is not in the future because the afternoon
  /// has not arrived yet.
  static bool isNotInFuture(DateTime date, {required DateTime now}) {
    final day = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);

    return !day.isAfter(today);
  }
}

/// Changes to the investment set, re-reading the list after a confirmed change.
class InvestmentActions {
  const InvestmentActions(this._ref);

  final Ref _ref;

  Future<Result<void>> create({
    required String instrument,
    required String currencyCode,
    required InvestmentType type,
    String? institution,
  }) => _afterChange(
    () => _ref
        .read(investmentRepositoryProvider)
        .create(
          instrument: instrument,
          currencyCode: currencyCode,
          type: type,
          institution: institution,
        ),
  );

  Future<Result<void>> update({
    required String id,
    required String instrument,
    required InvestmentType type,
    String? institution,
  }) => _afterChange(
    () => _ref
        .read(investmentRepositoryProvider)
        .update(
          id: id,
          instrument: instrument,
          type: type,
          institution: institution,
        ),
    id: id,
  );

  Future<Result<void>> delete(String id) => _afterChange(
    () => _ref.read(investmentRepositoryProvider).delete(id),
    id: id,
  );

  /// Records a movement and re-reads the position it changed (`UC-18` step 5).
  Future<Result<void>> recordMovement({
    required String investmentId,
    required MovementType type,
    required String amount,
    required DateTime occurredOn,
    String? financialAccountId,
  }) async {
    final result = await _afterChange(
      () => _ref
          .read(investmentRepositoryProvider)
          .recordMovement(
            investmentId: investmentId,
            type: type,
            amount: amount,
            occurredOn: occurredOn,
            financialAccountId: financialAccountId,
          ),
      id: investmentId,
    );

    // A movement funded from an account moved money out of it, so the balance
    // read before this is now stale.
    if (result.isSuccess && financialAccountId != null) {
      _ref.invalidate(accountBalanceProvider(financialAccountId));
    }

    return result;
  }

  /// Records a valuation and re-reads what it changed.
  Future<Result<void>> recordValuation({
    required String investmentId,
    required String value,
    required DateTime valuedOn,
  }) async {
    final result = await _afterChange(
      () => _ref
          .read(investmentRepositoryProvider)
          .recordValuation(
            investmentId: investmentId,
            value: value,
            valuedOn: valuedOn,
          ),
      id: investmentId,
    );

    if (result.isSuccess) {
      _ref.invalidate(investmentValuationsProvider(investmentId));
    }

    return result;
  }

  Future<Result<void>> _afterChange(
    Future<Result<void>> Function() call, {
    String? id,
  }) async {
    final result = await call();

    if (result.isSuccess) {
      _ref.invalidate(investmentsProvider);
      if (id != null) _ref.invalidate(investmentProvider(id));
    }

    return result;
  }
}

final investmentActionsProvider = Provider<InvestmentActions>(
  InvestmentActions.new,
);
