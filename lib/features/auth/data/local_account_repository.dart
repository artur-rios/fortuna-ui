/// The desktop local account (UC-06, UC-07, UC-08).
///
/// Reached over whichever transport `UC-01` resolved — over HTTP against a
/// self-hosted instance, or in process across the FFI boundary in desktop
/// offline mode. Nothing here knows which: it is the same generated client
/// over the same `dio`, and `UC-02` decides what that `dio` talks to.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// A recovered local account: a session, and what is left of the codes.
@immutable
class RecoveredLocalAccount {
  const RecoveredLocalAccount({
    required this.token,
    required this.remainingRecoveryCodes,
  });

  final String token;

  /// How many codes are still unspent. Shown plainly, because a user who has
  /// just spent one deserves to know how close they are to having none
  /// (`UC-08` step 4, `AF-04`).
  final int remainingRecoveryCodes;
}

/// A local account that was just created, and the codes that are the only way
/// back into it.
@immutable
class CreatedLocalAccount {
  const CreatedLocalAccount({
    required this.displayName,
    required this.recoveryCodes,
    this.warning,
  });

  final String displayName;

  /// Shown exactly once. The core does not keep them in a retrievable form, so
  /// there is no second chance and the screen says so (`FR-SE-05`).
  final List<String> recoveryCodes;

  /// The core's own wording of what losing them means, where it sent one.
  /// Preferred over anything this client could invent (`FR-DA-14`).
  final String? warning;
}

abstract interface class LocalAccountRepository {
  /// Creates the local account this installation signs in as (`UC-06`).
  Future<Result<CreatedLocalAccount>> create({
    required String displayName,
    required String secret,
  });

  /// Authenticates against the local account (`UC-07`).
  Future<Result<String>> authenticate({
    required String name,
    required String secret,
  });

  /// Recovers the account with a recovery code, setting a new secret
  /// (`UC-08`).
  ///
  /// The code is spent by the core whether or not the rest of the flow
  /// finishes, which is why the count comes back with the session.
  Future<Result<RecoveredLocalAccount>> recover({
    required String name,
    required String recoveryCode,
    required String newSecret,
  });

  /// Issues a fresh set of recovery codes (`UC-08` step 6, `FR-SE-08`).
  ///
  /// The old codes stay valid until this succeeds, so a failure here costs
  /// nothing (`AF-05`).
  Future<Result<CreatedLocalAccount>> regenerateRecoveryCodes({
    required String secret,
  });
}

class HttpLocalAccountRepository implements LocalAccountRepository {
  HttpLocalAccountRepository(this._client);

  factory HttpLocalAccountRepository.fromDio(Dio dio) =>
      HttpLocalAccountRepository(LocalAccountsClient(dio));

  final LocalAccountsClient _client;

  @override
  Future<Result<CreatedLocalAccount>> create({
    required String displayName,
    required String secret,
  }) async {
    try {
      final response = await _client.postApiLocalAccounts(
        body: CreateLocalAccountCommand(
          displayName: displayName,
          secret: secret,
        ),
      );

      final output = response.data;
      final codes = output?.recoveryCodes ?? const <String>[];

      // AF-03, in its worst form: an account the core says it made but for
      // which it issued no way back. Reported as a failure rather than
      // presented as a success with an empty list, because a user who confirms
      // an empty code list has confirmed nothing.
      if (output == null || codes.isEmpty) {
        return const Failure(
          message:
              'The account was not created with recovery codes. Nothing has '
              'been set up; please try again.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        CreatedLocalAccount(
          displayName: output.displayName ?? displayName,
          recoveryCodes: codes,
          warning: output.recoveryWarning,
        ),
      );
    } on DioException catch (exception) {
      // AF-02, AF-03 and AF-05 all carry the core's own reason: an account that
      // already exists, a credential store that cannot be written, and local
      // accounts being disabled are the core's rules to state.
      return failureFromDioException<CreatedLocalAccount>(exception);
    }
  }

  @override
  Future<Result<String>> authenticate({
    required String name,
    required String secret,
  }) async {
    try {
      final response = await _client.postApiLocalAccountsAuthenticate(
        body: AuthenticateLocalAccountCommand(name: name, secret: secret),
      );

      final token = response.data?.token;
      if (token == null || token.isEmpty) {
        return const Failure(
          message: 'The core granted no session.',
          kind: FailureKind.unauthenticated,
        );
      }

      return Success(token);
    } on DioException catch (exception) {
      // `UC-07 AF-02`: the core answers an unknown name and a wrong secret with
      // the same message, and this client passes it through without looking —
      // the way to keep two things indistinguishable is to never tell them
      // apart.
      return failureFromDioException<String>(exception);
    }
  }

  @override
  Future<Result<RecoveredLocalAccount>> recover({
    required String name,
    required String recoveryCode,
    required String newSecret,
  }) async {
    try {
      final response = await _client.postApiLocalAccountsRecover(
        body: RecoverLocalAccountCommand(
          name: name,
          recoveryCode: recoveryCode,
          newSecret: newSecret,
        ),
      );

      final token = response.data?.token;
      if (token == null || token.isEmpty) {
        return const Failure(
          message: 'The core granted no session.',
          kind: FailureKind.unauthenticated,
        );
      }

      return Success(
        RecoveredLocalAccount(
          token: token,
          remainingRecoveryCodes: response.data?.remainingRecoveryCodes ?? 0,
        ),
      );
    } on DioException catch (exception) {
      // `UC-08 AF-01`, `AF-02` and `AF-03` all come back through here with the
      // core's own message. That a wrong code, a spent code and an account
      // that does not exist are indistinguishable is the point: otherwise this
      // screen becomes a way to discover which accounts exist.
      return failureFromDioException<RecoveredLocalAccount>(exception);
    }
  }

  @override
  Future<Result<CreatedLocalAccount>> regenerateRecoveryCodes({
    required String secret,
  }) async {
    try {
      final response = await _client
          .postApiLocalAccountsRecoveryCodesRegenerate(
            body: RegenerateLocalAccountRecoveryCodesCommand(secret: secret),
          );

      final codes = response.data?.recoveryCodes ?? const <String>[];

      // AF-05, in the form that matters: a regeneration that produced no codes
      // has not replaced anything, and reporting success would leave the user
      // believing their old codes are dead when they are not.
      if (codes.isEmpty) {
        return const Failure(
          message:
              'No new recovery codes were issued. Your existing codes are '
              'still valid.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        CreatedLocalAccount(
          displayName: '',
          recoveryCodes: codes,
          warning: response.data?.recoveryWarning,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<CreatedLocalAccount>(exception);
    }
  }
}

final localAccountRepositoryProvider = Provider<LocalAccountRepository>(
  (ref) => HttpLocalAccountRepository.fromDio(ref.watch(dioProvider)),
);
