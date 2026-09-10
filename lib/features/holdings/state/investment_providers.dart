/// Investment state (UC-17).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/investment_repository.dart';

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

/// What the form checks before anything is submitted (`AF-01`).
///
/// Deliberately only presence. Whether an instrument name duplicates another
/// is the API's judgement (`AF-02`), and a client that guessed at it would
/// refuse names the API would have accepted.
abstract final class InvestmentRules {
  static bool isPresent(String value) => value.trim().isNotEmpty;
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
