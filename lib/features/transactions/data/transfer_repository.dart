/// Transfers (UC-21).
///
/// A transfer is one thing, not two transactions (`FR-MM-08`). That is the
/// claim this whole file exists to keep true: money the user moves between
/// their own accounts is neither income nor spending, and counting it as
/// either would inflate both totals by the same amount and make every
/// derived figure wrong in a way that looks plausible.
///
/// The API applies both sides or neither, and returns one record describing
/// both. `AF-05` follows from that directly: there is no half-transfer for
/// this client to report, because there is no half-transfer to have.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// A recorded transfer, as the API stored it.
@immutable
class Transfer {
  const Transfer({
    required this.id,
    required this.occurredOn,
    required this.originAccountId,
    required this.outboundAmount,
    required this.inboundAmount,
    this.destinationAccountId,
    this.appliedRate,
    this.rateDate,
  });

  final String id;
  final DateTime occurredOn;

  final String originAccountId;
  final String? destinationAccountId;

  /// What left the origin, and what arrived at the destination.
  ///
  /// Two figures rather than one because they are not always the same number:
  /// where the accounts hold different currencies the API converts, and
  /// `AF-03` requires that conversion be presented as the API performed it.
  /// Collapsing them into one amount would hide the conversion entirely.
  final Money outboundAmount;
  final Money inboundAmount;

  /// The rate the API used, as a string. Not a [Money]: a rate is not an
  /// amount and has no currency of its own.
  final String? appliedRate;

  final DateTime? rateDate;

  /// Whether the two sides are denominated differently, which is what makes
  /// the rate worth showing.
  bool get wasConverted =>
      outboundAmount.currencyCode != inboundAmount.currencyCode;
}

abstract interface class TransferRepository {
  /// Records a transfer and returns what the API stored (`UC-21` step 4).
  Future<Result<Transfer>> record({
    required String originAccountId,
    required String destinationAccountId,
    required String amount,
    required DateTime occurredOn,
  });
}

class HttpTransferRepository implements TransferRepository {
  HttpTransferRepository(this._client);

  factory HttpTransferRepository.fromDio(Dio dio) =>
      HttpTransferRepository(TransfersClient(dio));

  final TransfersClient _client;

  @override
  Future<Result<Transfer>> record({
    required String originAccountId,
    required String destinationAccountId,
    required String amount,
    required DateTime occurredOn,
  }) async {
    try {
      final response = await _client.postApiTransfers(
        body: RecordTransferCommand(
          originFinancialAccountId: originAccountId,
          destinationFinancialAccountId: destinationAccountId,
          // The exact decimal, serialized. Never a number on the wire.
          amount: amount,
          occurredOn: occurredOn,
        ),
      );

      final output = response.data;

      // AF-05: the API answered without the transfer it claims to have made.
      // Reporting success here would be reporting a transfer nobody can show.
      if (output == null) {
        return const Failure(
          message: 'The instance did not confirm the transfer.',
          kind: FailureKind.serverError,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      // AF-03 and AF-04 both arrive here: a currency pair the instance will
      // not convert is refused in its own words, and an account that is not
      // the user's reads as not found. Nothing is converted locally.
      return failureFromDioException<Transfer>(exception);
    }
  }

  static Transfer _from(RecordTransferCommandOutput output) => Transfer(
    id: output.id ?? '',
    occurredOn: output.occurredOn ?? DateTime(1970),
    originAccountId: output.originFinancialAccountId ?? '',
    destinationAccountId: output.destinationFinancialAccountId,
    outboundAmount: Money.parse(
      output.outboundAmount ?? '0',
      output.outboundCurrencyCode ?? '',
    ),
    inboundAmount: Money.parse(
      output.inboundAmount ?? '0',
      output.inboundCurrencyCode ?? '',
    ),
    appliedRate: output.appliedRate,
    rateDate: output.rateDate,
  );
}

final transferRepositoryProvider = Provider<TransferRepository>(
  (ref) => HttpTransferRepository.fromDio(ref.watch(dioProvider)),
);
