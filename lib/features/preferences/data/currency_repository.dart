/// The currencies the instance supports (UC-13, FR-PS-07).
///
/// The list is reference data — small, slow-changing, and the only kind of data
/// this application caches. It is held in memory for the session and cleared
/// when the session ends.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// A currency the instance will accept.
@immutable
class SupportedCurrency {
  const SupportedCurrency({
    required this.code,
    required this.name,
    required this.minorUnitDigits,
  });

  /// The ISO 4217 code.
  final String code;

  final String name;

  /// How many decimal places this currency has.
  ///
  /// Taken from the API rather than guessed by the formatting library: the API
  /// is the authority on the currencies it accepts, and `FR-PS-06` says
  /// rounding is to "the currency's **own** minor-unit precision". A library's
  /// table and an instance's list can disagree, and when they do the instance
  /// is right.
  final int minorUnitDigits;
}

abstract interface class CurrencyRepository {
  Future<Result<List<SupportedCurrency>>> listSupported();
}

class HttpCurrencyRepository implements CurrencyRepository {
  HttpCurrencyRepository(this._client);

  factory HttpCurrencyRepository.fromDio(Dio dio) =>
      HttpCurrencyRepository(CurrenciesClient(dio));

  final CurrenciesClient _client;

  @override
  Future<Result<List<SupportedCurrency>>> listSupported() async {
    try {
      final response = await _client.getApiCurrencies();
      final currencies = response.data?.currencies ?? const [];

      return Success([
        for (final currency in currencies)
          if (currency.code case final String code)
            SupportedCurrency(
              code: code,
              name: currency.name ?? code,
              // Two where the instance omits it: the ISO default for most
              // currencies, and better than dropping the currency entirely.
              minorUnitDigits: currency.minorUnitDigits ?? 2,
            ),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<SupportedCurrency>>(exception);
    }
  }
}

final currencyRepositoryProvider = Provider<CurrencyRepository>(
  (ref) => HttpCurrencyRepository.fromDio(ref.watch(dioProvider)),
);
