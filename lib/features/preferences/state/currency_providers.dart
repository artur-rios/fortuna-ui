/// The supported-currency list, cached for the session (UC-13, BR-32, BR-33).
///
/// Reference data: small, slow-changing, and held **in memory only**. It is
/// dropped when the session ends, which is what the teardown registration below
/// is for — nothing about one user survives into the next session.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/currency_repository.dart';

/// The supported currencies, or a failure.
///
/// `AF-03`: a failure here does not change the user's choice. The current
/// display currency stands and the interface reports that the list is
/// unavailable, rather than clearing a preference because a request failed.
final supportedCurrenciesProvider = FutureProvider<List<SupportedCurrency>>((
  ref,
) async {
  ref.read(sessionTeardownProvider).register('currencies', () async {
    ref.invalidateSelf();
  });

  final result = await ref.read(currencyRepositoryProvider).listSupported();

  return switch (result) {
    Success<List<SupportedCurrency>>(:final value) => value,
    Failure<List<SupportedCurrency>>(:final message) =>
      throw CurrencyListUnavailable(message),
  };
});

/// Raised when the instance cannot supply the currency list (`AF-03`).
class CurrencyListUnavailable implements Exception {
  const CurrencyListUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Minor-unit precision per currency, for formatting.
///
/// Empty until the list has loaded, which is not a problem: the formatter falls
/// back to the library's own table, and corrects itself once the API's answer
/// arrives.
final minorUnitDigitsProvider = Provider<Map<String, int>>((ref) {
  final currencies = ref.watch(supportedCurrenciesProvider);

  return currencies.maybeWhen(
    data: (list) => {
      for (final currency in list) currency.code: currency.minorUnitDigits,
    },
    orElse: () => const <String, int>{},
  );
});
