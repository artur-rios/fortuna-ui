/// Installment purchases (UC-22).
///
/// The rule this file exists to protect is `AF-04`: **the installments are
/// the API's and are shown exactly as it generated them.**
///
/// A total rarely divides evenly by its count, so one installment — usually
/// the first — carries the remainder. A client that "corrected" this into
/// even amounts would produce a set that does not sum to the purchase, and
/// the user would be reconciling against a card statement that disagrees with
/// the application for reasons nothing on screen explains. So nothing here
/// divides, rounds, or redistributes anything.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// One charge of a plan, as the API generated it.
@immutable
class Installment {
  const Installment({
    required this.number,
    required this.transactionId,
    required this.amount,
    required this.occurredOn,
  });

  /// Its position in the plan, one-based, as the API numbered it.
  final int number;

  final String transactionId;

  /// The API's figure. Never computed from the total and the count.
  final Money amount;

  final DateTime occurredOn;
}

/// A purchase split across future charges.
@immutable
class InstallmentPlan {
  const InstallmentPlan({
    required this.id,
    required this.creditCardId,
    required this.totalAmount,
    required this.installmentCount,
    required this.purchasedOn,
    required this.installments,
  });

  final String id;
  final String creditCardId;

  /// What was purchased, as the API recorded it.
  final Money totalAmount;

  final int installmentCount;
  final DateTime purchasedOn;

  /// The generated charges, in the order the API returned them.
  final List<Installment> installments;

  /// Whether the installments differ from one another (`AF-04`).
  ///
  /// Asked so the interface can *explain* the difference, never so it can
  /// remove it. A user who expected an even split needs to know why the first
  /// charge is larger; hiding the fact would leave them to discover it on a
  /// statement.
  bool get isUneven {
    if (installments.length < 2) return false;

    final first = installments.first.amount.amount;
    return installments.any((each) => each.amount.amount != first);
  }
}

abstract interface class InstallmentRepository {
  /// Records a plan and returns it with the installments the API generated
  /// (`UC-22` steps 4 and 5).
  Future<Result<InstallmentPlan>> record({
    required String creditCardId,
    required String categoryId,
    required String totalAmount,
    required int installmentCount,
    required DateTime purchasedOn,
    required String currencyCode,
    String? counterparty,
  });
}

class HttpInstallmentRepository implements InstallmentRepository {
  HttpInstallmentRepository(this._client);

  factory HttpInstallmentRepository.fromDio(Dio dio) =>
      HttpInstallmentRepository(InstallmentPlansClient(dio));

  final InstallmentPlansClient _client;

  @override
  Future<Result<InstallmentPlan>> record({
    required String creditCardId,
    required String categoryId,
    required String totalAmount,
    required int installmentCount,
    required DateTime purchasedOn,
    required String currencyCode,
    String? counterparty,
  }) async {
    try {
      final response = await _client.postApiInstallmentPlans(
        body: RecordInstallmentPlanCommand(
          creditCardId: creditCardId,
          categoryId: categoryId,
          // The string as typed. The split is the API's to perform.
          totalAmount: totalAmount,
          installmentCount: installmentCount,
          purchasedOn: purchasedOn,
          currencyCode: currencyCode,
          counterparty: counterparty,
        ),
      );

      final output = response.data;

      // The plan was not returned, so there are no installments to show. Step
      // 5 cannot be satisfied, and claiming success would promise a screen
      // this client cannot draw.
      if (output == null) {
        return const Failure(
          message: 'The instance did not confirm the plan.',
          kind: FailureKind.serverError,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      // AF-03 and AF-05: a rule this client does not enforce, and a card that
      // is not the user's, both in the API's own words.
      return failureFromDioException<InstallmentPlan>(exception);
    }
  }

  static InstallmentPlan _from(RecordInstallmentPlanCommandOutput output) {
    final currency = output.currencyCode ?? '';

    return InstallmentPlan(
      id: output.id ?? '',
      creditCardId: output.creditCardId ?? '',
      totalAmount: Money.parse(output.totalAmount ?? '0', currency),
      installmentCount: output.installmentCount ?? 0,
      purchasedOn: output.purchasedOn ?? DateTime(1970),
      installments: [
        for (final installment
            in output.installments ?? const <InstallmentCommandOutput>[])
          Installment(
            number: installment.number ?? 0,
            transactionId: installment.transactionId ?? '',
            // AF-04: read, never derived. This is the line that keeps the
            // remainder the API assigned exactly where it put it.
            amount: Money.parse(
              installment.amount ?? '0',
              installment.currencyCode ?? currency,
            ),
            occurredOn: installment.occurredOn ?? DateTime(1970),
          ),
      ],
    );
  }
}

final installmentRepositoryProvider = Provider<InstallmentRepository>(
  (ref) => HttpInstallmentRepository.fromDio(ref.watch(dioProvider)),
);
