/// Financial accounts (UC-14).
///
/// The first place money reaches a screen, so the rule that governs everything
/// below: **an amount is a decimal string from the API to the widget, and
/// nothing in between turns it into a number**. `Money.parse` takes the string
/// the API sent and holds it as a `Decimal`; no `double` appears on the path
/// (`BR-05`, `BR-06`, `FR-DA-11`, `IR-14`).
///
/// The balance is asked for, never derived. `FR-HO-02` is explicit that this
/// client does not compute one, which is why a balance that cannot be read is
/// simply absent rather than replaced by a sum of something.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/format/money.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What kind of holding an account is.
///
/// Mapped from the contract's numbers rather than the generated names: the
/// contract carries `x-enum-varnames: [Checking, Savings, Cash, Other]`, but
/// swagger_parser does not read that extension, so the generated enum is
/// positional. The numbers are what the contract actually specifies.
enum AccountType {
  checking(1, 'Checking'),
  savings(2, 'Savings'),
  cash(3, 'Cash'),
  other(4, 'Other');

  const AccountType(this.wire, this.label);

  final int wire;
  final String label;

  static AccountType from(FinancialAccountType? type) => switch (type?.json) {
    1 => AccountType.checking,
    2 => AccountType.savings,
    3 => AccountType.cash,
    _ => AccountType.other,
  };

  FinancialAccountType get asApi => FinancialAccountType.fromJson(wire);
}

/// One of the user's financial accounts.
@immutable
class FinancialAccount {
  const FinancialAccount({
    required this.id,
    required this.name,
    required this.type,
    required this.currencyCode,
    required this.openingBalance,
    this.institution,
    this.isDeleted = false,
  });

  final String id;
  final String name;
  final AccountType type;

  /// Fixed after creation (`FR-HO-03`, `AF-03`).
  final String currencyCode;

  final Money openingBalance;
  final String? institution;
  final bool isDeleted;
}

/// A balance, exactly as the API reported it.
@immutable
class AccountBalance {
  const AccountBalance({required this.balance, required this.asOf});

  final Money balance;

  /// When the API says it was true. Shown, because a balance without a moment
  /// attached invites the reader to assume it is current.
  final DateTime? asOf;
}

abstract interface class AccountRepository {
  Future<Result<List<FinancialAccount>>> list();
  Future<Result<FinancialAccount>> read(String id);

  /// The balance the API computes (`FR-HO-02`).
  Future<Result<AccountBalance>> balance(String id);

  Future<Result<void>> create({
    required String name,
    required AccountType type,
    required String currencyCode,
    required String openingBalance,
    String? institution,
  });

  /// Updates the editable fields. The currency is not among them.
  Future<Result<void>> update({
    required String id,
    required String name,
    required AccountType type,
    String? institution,
  });

  Future<Result<void>> delete(String id);
}

class HttpAccountRepository implements AccountRepository {
  HttpAccountRepository(this._client);

  factory HttpAccountRepository.fromDio(Dio dio) =>
      HttpAccountRepository(AccountsClient(dio));

  final AccountsClient _client;

  @override
  Future<Result<List<FinancialAccount>>> list() async {
    try {
      final page = await _client.getApiAccounts();

      return Success([
        for (final account in page.data ?? const <FinancialAccountOutput>[])
          _from(account),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<FinancialAccount>>(exception);
    }
  }

  @override
  Future<Result<FinancialAccount>> read(String id) async {
    try {
      final output = (await _client.getApiAccountsId(id: id)).data;

      // AF-04: an account that does not exist and one belonging to somebody
      // else are the same answer, and this client keeps them that way.
      if (output == null) {
        return const Failure(
          message: 'That account was not found.',
          kind: FailureKind.notFound,
        );
      }

      return Success(_from(output));
    } on DioException catch (exception) {
      return failureFromDioException<FinancialAccount>(exception);
    }
  }

  @override
  Future<Result<AccountBalance>> balance(String id) async {
    try {
      final output = (await _client.getApiAccountsIdBalance(id: id)).data;

      if (output == null || output.balance == null) {
        // AF-07. No balance is reported rather than one being invented; the
        // caller shows the account without it.
        return const Failure(
          message: 'The balance could not be read.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        AccountBalance(
          // The decimal string the API sent, parsed exactly.
          balance: Money.parse(output.balance!, output.currencyCode ?? ''),
          asOf: output.asOf,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<AccountBalance>(exception);
    }
  }

  @override
  Future<Result<void>> create({
    required String name,
    required AccountType type,
    required String currencyCode,
    required String openingBalance,
    String? institution,
  }) async {
    try {
      await _client.postApiAccounts(
        body: CreateFinancialAccountCommand(
          name: name,
          accountType: type.asApi,
          currencyCode: currencyCode,
          // Sent as the string it already is. Formatting it through anything
          // numeric here is exactly how BR-05 gets broken.
          openingBalance: openingBalance,
          institution: institution,
        ),
      );
      return const Success(null);
    } on DioException catch (exception) {
      // AF-02: a duplicate name is the API's rule, in the API's words.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    required AccountType type,
    String? institution,
  }) async {
    try {
      await _client.putApiAccountsId(
        id: id,
        body: UpdateFinancialAccountCommand(
          name: name,
          accountType: type.asApi,
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
      await _client.deleteApiAccountsId(id: id);
      return const Success(null);
    } on DioException catch (exception) {
      // AF-05: records still referencing the account are the API's reason to
      // give, and it knows about references this client cannot see.
      return failureFromDioException<void>(exception);
    }
  }

  static FinancialAccount _from(FinancialAccountOutput output) =>
      FinancialAccount(
        id: output.id ?? '',
        name: output.name ?? '',
        type: AccountType.from(output.accountType),
        currencyCode: output.currencyCode ?? '',
        openingBalance: Money.parse(
          output.openingBalance ?? '0',
          output.currencyCode ?? '',
        ),
        institution: output.institution,
        isDeleted: output.isDeleted ?? false,
      );
}

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => HttpAccountRepository.fromDio(ref.watch(dioProvider)),
);
