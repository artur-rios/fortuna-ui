/// The API contract this build was generated against (UC-01 AF-05).
///
/// The generated client is only correct for the contract it was produced from,
/// so an instance speaking a different one is an incompatibility to report at
/// setup rather than a series of confusing failures in unrelated screens
/// later.
///
/// [version] is not read from the contract at run time — there is nothing to
/// read it from, because `api/fortuna.json` is a build-time input rather than a
/// shipped asset. It is instead asserted against that file by
/// `test/core/config/api_contract_test.dart`, so taking a new contract without
/// updating this constant fails the suite rather than reaching a user.
library;

import 'package:meta/meta.dart';

/// What this build knows how to talk to.
abstract final class ApiContract {
  /// The `info.version` of `api/fortuna.json`, as the API also reports it from
  /// the anonymous health check.
  static const version = 'v1';

  /// Whether [reported] is a contract this build can work against.
  ///
  /// An absent or empty version is **not** treated as compatible. An instance
  /// that will not say what it speaks is one this client cannot verify, and
  /// guessing in the optimistic direction is how `AF-05` turns back into the
  /// unrelated failure it exists to prevent.
  static bool accepts(String? reported) =>
      reported != null && reported.trim() == version;
}

/// What an instance said about itself, and whether this build can work with it.
@immutable
class ContractCompatibility {
  const ContractCompatibility({required this.reported});

  /// The contract version the instance reported, or `null` when it named none.
  final String? reported;

  bool get isCompatible => ApiContract.accepts(reported);

  /// What the instance called itself, for a message that names both sides.
  String get reportedOrUnknown {
    final trimmed = reported?.trim() ?? '';
    return trimmed.isEmpty ? 'nothing' : trimmed;
  }

  String get expected => ApiContract.version;
}
