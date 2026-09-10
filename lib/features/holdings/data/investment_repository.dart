/// Investments (UC-17).
///
/// The rule that shapes this whole file is `FR-HO-12`: **this client never
/// prices an instrument.** It shows what was contributed, what was withdrawn,
/// and what the user recorded as a valuation — and where no valuation exists
/// it says so (`AF-05`) instead of showing a number nobody supplied.
///
/// That is why [Investment.latestValuation] is nullable rather than defaulting
/// to zero, and why nothing here multiplies a quantity by a price. A plausible
/// figure the user did not record is worse than an absent one: an absent figure
/// prompts them to record a valuation, and an invented figure they act on.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart'
    hide InvestmentMovementType, InvestmentType;
import 'package:fortuna_api_client/export.dart'
    as api
    show InvestmentMovementType, InvestmentType;
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What kind of holding an investment is.
///
/// Mapped from the contract's numbers rather than the generated names, for the
/// reason `AccountType` gives: the contract carries
/// `x-enum-varnames: [FixedIncome, Equity, Fund, Other]`, but swagger_parser
/// does not read that extension, so the generated enum is positional.
enum InvestmentType {
  fixedIncome(1, 'Fixed income'),
  equity(2, 'Equity'),
  fund(3, 'Fund'),
  other(4, 'Other');

  const InvestmentType(this.wire, this.label);

  final int wire;
  final String label;

  static InvestmentType from(api.InvestmentType? type) => switch (type?.json) {
    1 => InvestmentType.fixedIncome,
    2 => InvestmentType.equity,
    3 => InvestmentType.fund,
    _ => InvestmentType.other,
  };

  api.InvestmentType get asApi => api.InvestmentType.fromJson(wire);
}

/// A valuation the user recorded, with the date it was true.
@immutable
class RecordedValuation {
  const RecordedValuation({required this.value, required this.asOf});

  final Money value;

  /// Shown alongside the value, because a valuation without its date invites
  /// the reader to assume it is current.
  final DateTime? asOf;
}

/// What kind of movement was recorded against an investment (`UC-18`).
///
/// Mapped from the contract's numbers for the reason [InvestmentType] gives.
enum MovementType {
  contribution(1, 'Contribution'),
  withdrawal(2, 'Withdrawal'),
  yieldEarned(3, 'Yield'),
  fee(4, 'Fee');

  const MovementType(this.wire, this.label);

  final int wire;
  final String label;

  api.InvestmentMovementType get asApi =>
      api.InvestmentMovementType.fromJson(wire);
}

/// One of the user's investments.
@immutable
class Investment {
  const Investment({
    required this.id,
    required this.instrument,
    required this.currencyCode,
    required this.type,
    required this.position,
    required this.isIndependentlyValued,
    this.institution,
    this.latestValuation,
  });

  final String id;
  final String instrument;
  final String currencyCode;
  final InvestmentType type;

  /// The position as the API reports it (`FR-HO-12`). Read, never computed.
  final Money position;

  /// Whether this holding is valued by recorded valuations rather than by its
  /// contributions alone.
  final bool isIndependentlyValued;

  final String? institution;

  /// `null` where nothing has been recorded — which `AF-05` requires be said
  /// rather than filled in.
  final RecordedValuation? latestValuation;

  /// `AF-05`: the position is known from movements, but no valuation exists.
  bool get hasNoValuation => latestValuation == null;
}

abstract interface class InvestmentRepository {
  Future<Result<List<Investment>>> list();
  Future<Result<Investment>> read(String id);

  Future<Result<void>> create({
    required String instrument,
    required String currencyCode,
    required InvestmentType type,
    String? institution,
  });

  Future<Result<void>> update({
    required String id,
    required String instrument,
    required InvestmentType type,
    String? institution,
  });

  Future<Result<void>> delete(String id);

  /// The valuations recorded against an investment, most recent first
  /// (`FR-HO-11`).
  Future<Result<List<RecordedValuation>>> valuations(String investmentId);

  /// Records a contribution, withdrawal, yield or fee (`UC-18`).
  Future<Result<void>> recordMovement({
    required String investmentId,
    required MovementType type,
    required String amount,
    required DateTime occurredOn,
    String? financialAccountId,
  });

  /// Records what the investment was worth on a date (`UC-18`).
  Future<Result<void>> recordValuation({
    required String investmentId,
    required String value,
    required DateTime valuedOn,
  });
}

class HttpInvestmentRepository implements InvestmentRepository {
  HttpInvestmentRepository(this._client);

  factory HttpInvestmentRepository.fromDio(Dio dio) =>
      HttpInvestmentRepository(InvestmentsClient(dio));

  final InvestmentsClient _client;

  @override
  Future<Result<List<Investment>>> list() async {
    try {
      final page = await _client.getApiInvestments();

      return Success([
        for (final investment in page.data ?? const <InvestmentOutput>[])
          _from(investment),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<Investment>>(exception);
    }
  }

  @override
  Future<Result<Investment>> read(String id) async {
    try {
      final output = (await _client.getApiInvestmentsId(id: id)).data;

      // AF-03: not found and not yours are deliberately the same answer.
      if (output == null) {
        return const Failure(
          message: 'That investment was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      return failureFromDioException<Investment>(exception);
    }
  }

  @override
  Future<Result<void>> create({
    required String instrument,
    required String currencyCode,
    required InvestmentType type,
    String? institution,
  }) async {
    try {
      await _client.postApiInvestments(
        body: CreateInvestmentCommand(
          instrument: instrument,
          currencyCode: currencyCode,
          investmentType: type.asApi,
          institution: institution,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-02: a duplicate name is the API's rule to state.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String instrument,
    required InvestmentType type,
    String? institution,
  }) async {
    try {
      await _client.putApiInvestmentsId(
        id: id,
        body: UpdateInvestmentCommand(
          instrument: instrument,
          investmentType: type.asApi,
          institution: institution,
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
      await _client.deleteApiInvestmentsId(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      // AF-04: still-referenced by movements, in the API's words.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<List<RecordedValuation>>> valuations(
    String investmentId,
  ) async {
    try {
      final page = await _client.getApiInvestmentsIdValuations(
        id: investmentId,
        sortBy: 'valuedOn',
        descending: true,
      );

      return Success([
        for (final valuation
            in page.data ?? const <InvestmentValuationOutput>[])
          RecordedValuation(
            value: Money.parse(
              valuation.value ?? '0',
              valuation.currencyCode ?? '',
            ),
            asOf: valuation.valuedOn,
          ),
      ]);
    } on DioException catch (exception) {
      // AF-04.
      return failureFromDioException<List<RecordedValuation>>(exception);
    }
  }

  @override
  Future<Result<void>> recordMovement({
    required String investmentId,
    required MovementType type,
    required String amount,
    required DateTime occurredOn,
    String? financialAccountId,
  }) async {
    try {
      await _client.postApiInvestmentsIdMovements(
        id: investmentId,
        body: RecordInvestmentMovementCommand(
          id: investmentId,
          movementType: type.asApi,
          // The string as typed. Never parsed to a number on the way out.
          amount: amount,
          occurredOn: occurredOn,
          financialAccountId: financialAccountId,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-05: a currency mismatch is the API's refusal to state, and nothing
      // is converted here to make the amounts agree.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> recordValuation({
    required String investmentId,
    required String value,
    required DateTime valuedOn,
  }) async {
    try {
      await _client.postApiInvestmentsIdValuations(
        id: investmentId,
        body: RecordInvestmentValuationCommand(
          id: investmentId,
          value: value,
          valuedOn: valuedOn,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-03: whether a second valuation on one date is refused or replaces
      // the first is the API's rule, and its answer is what reaches the user.
      return failureFromDioException<void>(exception);
    }
  }

  static Investment _from(InvestmentOutput output) {
    final currency = output.currencyCode ?? '';
    final valuation = output.latestValuationValue;

    return Investment(
      id: output.id ?? '',
      instrument: output.instrument ?? '',
      currencyCode: currency,
      type: InvestmentType.from(output.investmentType),
      position: Money.parse(output.position ?? '0', currency),
      isIndependentlyValued: output.isIndependentlyValued ?? false,
      institution: output.institution,
      // AF-05 hinges on this staying null. A missing valuation is not zero,
      // and turning it into one here would put an invented figure on screen
      // that the user would have no way to recognize as invented.
      latestValuation: valuation == null
          ? null
          : RecordedValuation(
              value: Money.parse(valuation, currency),
              asOf: output.latestValuationDate,
            ),
    );
  }
}

final investmentRepositoryProvider = Provider<InvestmentRepository>(
  (ref) => HttpInvestmentRepository.fromDio(ref.watch(dioProvider)),
);
