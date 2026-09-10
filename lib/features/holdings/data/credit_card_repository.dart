/// Credit cards (UC-15).
///
/// Every figure here — the limit, what is used, what is left, what is over —
/// is the API's. `FR-HO-05` says display them as reported, and the temptation
/// this file resists is computing `available` as `limit - used`: those two are
/// not always the difference the API means, because a card can carry an
/// overage the arithmetic would hide.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// One of the user's credit cards.
@immutable
class CreditCard {
  const CreditCard({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.creditLimit,
    required this.usedAmount,
    required this.availableAmount,
    required this.overageAmount,
    required this.closingDay,
    required this.dueDay,
    this.issuer,
    this.lastFourDigits,
  });

  final String id;
  final String name;
  final String currencyCode;

  /// All four as the API reported them, never derived from one another.
  final Money creditLimit;
  final Money usedAmount;
  final Money availableAmount;

  /// What is spent beyond the limit. Its own figure precisely because it is
  /// not visible in the other three.
  final Money overageAmount;

  final int closingDay;
  final int dueDay;
  final String? issuer;
  final String? lastFourDigits;

  bool get isOverLimit => overageAmount.isPositive;
}

abstract interface class CreditCardRepository {
  Future<Result<List<CreditCard>>> list();
  Future<Result<CreditCard>> read(String id);

  Future<Result<void>> create({
    required String name,
    required String currencyCode,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
    String? lastFourDigits,
  });

  Future<Result<void>> update({
    required String id,
    required String name,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
  });

  Future<Result<void>> delete(String id);
}

class HttpCreditCardRepository implements CreditCardRepository {
  HttpCreditCardRepository(this._client);

  factory HttpCreditCardRepository.fromDio(Dio dio) =>
      HttpCreditCardRepository(CreditCardsClient(dio));

  final CreditCardsClient _client;

  @override
  Future<Result<List<CreditCard>>> list() async {
    try {
      final page = await _client.getApiCreditCards();

      return Success([
        for (final card in page.data ?? const <CreditCardOutput>[]) _from(card),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<CreditCard>>(exception);
    }
  }

  @override
  Future<Result<CreditCard>> read(String id) async {
    try {
      final output = (await _client.getApiCreditCardsId(id: id)).data;

      // AF-04: not found and not yours are the same answer.
      if (output == null) {
        return const Failure(
          message: 'That card was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      return failureFromDioException<CreditCard>(exception);
    }
  }

  @override
  Future<Result<void>> create({
    required String name,
    required String currencyCode,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
    String? lastFourDigits,
  }) async {
    try {
      await _client.postApiCreditCards(
        body: CreateCreditCardCommand(
          name: name,
          currencyCode: currencyCode,
          // The string as typed. Never parsed to a number on the way out.
          creditLimit: creditLimit,
          closingDay: closingDay,
          dueDay: dueDay,
          issuer: issuer,
          lastFourDigits: lastFourDigits,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-02 and AF-03: the day combination and a duplicate name are both the
      // API's rules to state.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    required String creditLimit,
    required int closingDay,
    required int dueDay,
    String? issuer,
  }) async {
    try {
      await _client.putApiCreditCardsId(
        id: id,
        body: UpdateCreditCardCommand(
          name: name,
          creditLimit: creditLimit,
          closingDay: closingDay,
          dueDay: dueDay,
          issuer: issuer,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _client.deleteApiCreditCardsId(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      // AF-05: still-referenced, in the API's words.
      return failureFromDioException<void>(exception);
    }
  }

  static CreditCard _from(CreditCardOutput output) {
    final currency = output.currencyCode ?? '';

    Money money(String? amount) => Money.parse(amount ?? '0', currency);

    return CreditCard(
      id: output.id ?? '',
      name: output.name ?? '',
      currencyCode: currency,
      creditLimit: money(output.creditLimit),
      usedAmount: money(output.usedAmount),
      // Taken from the API rather than computed from the other two, so an
      // overage cannot be hidden by arithmetic that looks reasonable.
      availableAmount: money(output.availableAmount),
      overageAmount: money(output.overageAmount),
      closingDay: output.closingDay ?? 1,
      dueDay: output.dueDay ?? 1,
      issuer: output.issuer,
      lastFourDigits: output.lastFourDigits,
    );
  }
}

final creditCardRepositoryProvider = Provider<CreditCardRepository>(
  (ref) => HttpCreditCardRepository.fromDio(ref.watch(dioProvider)),
);
