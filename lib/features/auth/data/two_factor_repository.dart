/// Managing two-factor authentication (UC-10).
///
/// Every call here is made with a session in hand — this is account settings,
/// not sign-in. The challenge flow that *uses* a second factor is `UC-04`.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Which second factors an account uses.
enum TwoFactorMethod {
  app('app', 'Authenticator app'),
  email('email', 'Email');

  const TwoFactorMethod(this.wireName, this.label);

  /// What the API calls it.
  final String wireName;

  /// What the user is shown.
  final String label;
}

/// The account's current two-factor configuration.
@immutable
class TwoFactorStatus {
  const TwoFactorStatus({
    required this.isActive,
    required this.appEnabled,
    required this.emailEnabled,
    required this.remainingRecoveryCodes,
  });

  final bool isActive;
  final bool appEnabled;
  final bool emailEnabled;
  final int remainingRecoveryCodes;

  List<TwoFactorMethod> get methods => [
    if (appEnabled) TwoFactorMethod.app,
    if (emailEnabled) TwoFactorMethod.email,
  ];
}

/// A setup that has been started and not yet confirmed.
@immutable
class TwoFactorSetup {
  const TwoFactorSetup({required this.otpAuthUri, required this.emailCodeSent});

  /// The `otpauth://` URI an authenticator scans. Null where only email was
  /// chosen.
  final String? otpAuthUri;

  /// Whether the API sent an emailed code as part of the setup.
  final bool emailCodeSent;

  /// The shared secret, as text.
  ///
  /// `FR-SE-13` asks for the secret alongside the scannable code, because a
  /// user on the same device as their authenticator — or one who simply cannot
  /// scan — has no other way to proceed. It is read out of the URI rather than
  /// asked for separately, since the URI already carries it.
  String? get sharedSecret {
    final uri = otpAuthUri;
    if (uri == null || uri.isEmpty) return null;

    final secret = Uri.tryParse(uri)?.queryParameters['secret'];
    return (secret == null || secret.isEmpty) ? null : secret;
  }
}

abstract interface class TwoFactorRepository {
  Future<Result<TwoFactorStatus>> status();

  /// Starts a setup for [methods] (`FR-SE-12`).
  Future<Result<TwoFactorSetup>> enable(List<TwoFactorMethod> methods);

  /// Confirms a pending setup, returning the recovery codes (`FR-SE-14`).
  Future<Result<List<String>>> confirm({String? appCode, String? emailCode});

  /// Turns two-factor off (`FR-SE-15`).
  Future<Result<void>> disable({
    required String password,
    String? code,
    String? recoveryCode,
  });

  /// Replaces the recovery codes (`FR-SE-15`).
  Future<Result<List<String>>> regenerateRecoveryCodes({
    String? code,
    String? recoveryCode,
  });
}

class HttpTwoFactorRepository implements TwoFactorRepository {
  HttpTwoFactorRepository(this._client);

  factory HttpTwoFactorRepository.fromDio(Dio dio) =>
      HttpTwoFactorRepository(AuthClient(dio));

  final AuthClient _client;

  @override
  Future<Result<TwoFactorStatus>> status() async {
    try {
      final output = (await _client.getApiAuth2fa()).data;

      return Success(
        TwoFactorStatus(
          isActive: output?.isActive ?? false,
          appEnabled: output?.appEnabled ?? false,
          emailEnabled: output?.emailEnabled ?? false,
          remainingRecoveryCodes: output?.remainingRecoveryCodes ?? 0,
        ),
      );
    } on DioException catch (exception) {
      // AF-05 arrives here: an account that signs in with Google cannot hold a
      // second factor, and the API says so. Presented rather than second-
      // guessed, so the screen never offers a setup that will be refused.
      return failureFromDioException<TwoFactorStatus>(exception);
    }
  }

  @override
  Future<Result<TwoFactorSetup>> enable(List<TwoFactorMethod> methods) async {
    try {
      final output = (await _client.postApiAuth2faEnable(
        body: EnableTwoFactorThroughApiCommand(
          methods: [for (final method in methods) method.wireName],
        ),
      )).data;

      return Success(
        TwoFactorSetup(
          otpAuthUri: output?.otpAuthUri,
          emailCodeSent: output?.emailCodeSent ?? false,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<TwoFactorSetup>(exception);
    }
  }

  @override
  Future<Result<List<String>>> confirm({
    String? appCode,
    String? emailCode,
  }) async {
    try {
      final output = (await _client.postApiAuth2faConfirm(
        body: ConfirmTwoFactorThroughApiCommand(
          appCode: appCode,
          emailCode: emailCode,
        ),
      )).data;

      // A confirmation the API did not mark enabled has not enabled anything,
      // and reporting success on it would leave the user believing they are
      // protected when they are not.
      if (!(output?.enabled ?? false)) {
        return const Failure(
          message: 'The setup was not confirmed. Try the code again.',
          kind: FailureKind.invalidInput,
        );
      }

      return Success(output?.recoveryCodes ?? const <String>[]);
    } on DioException catch (exception) {
      // AF-01: a wrong or expired code leaves the setup pending, which is what
      // the API does — nothing here cancels it.
      return failureFromDioException<List<String>>(exception);
    }
  }

  @override
  Future<Result<void>> disable({
    required String password,
    String? code,
    String? recoveryCode,
  }) async {
    try {
      await _client.postApiAuth2faDisable(
        body: DisableTwoFactorThroughApiCommand(
          password: password,
          code: code,
          recoveryCode: recoveryCode,
        ),
      );

      return const Success(null);
    } on DioException catch (exception) {
      // AF-03 and AF-04: a wrong password, a wrong second factor and nothing
      // to disable all carry the API's own message, and this client does not
      // tell the first two apart.
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<List<String>>> regenerateRecoveryCodes({
    String? code,
    String? recoveryCode,
  }) async {
    try {
      final output = (await _client.postApiAuth2faRecoveryCodesRegenerate(
        body: RegenerateRecoveryCodesThroughApiCommand(
          code: code,
          recoveryCode: recoveryCode,
        ),
      )).data;

      final codes = output?.recoveryCodes ?? const <String>[];

      // As in UC-08: nothing replaced means nothing lost, and saying otherwise
      // would leave the user believing their codes were dead.
      if (codes.isEmpty) {
        return const Failure(
          message:
              'No new recovery codes were issued. Your existing codes are '
              'still valid.',
          kind: FailureKind.serverError,
        );
      }

      return Success(codes);
    } on DioException catch (exception) {
      return failureFromDioException<List<String>>(exception);
    }
  }
}

final twoFactorRepositoryProvider = Provider<TwoFactorRepository>(
  (ref) => HttpTwoFactorRepository.fromDio(ref.watch(dioProvider)),
);
