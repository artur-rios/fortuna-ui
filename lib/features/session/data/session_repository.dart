/// Verifying a stored session against the API (UC-11).
///
/// The repository seam `FR-DA-01` requires: the controller above calls this
/// interface and never learns which transport answered. Today there is one
/// implementation, over HTTP; the FFI one arrives with the core library.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What a verified session tells the interface about its owner.
///
/// Deliberately small. The role and subject come from the token's claims; this
/// carries what the API's profile adds, which is what a screen can actually
/// display.
class VerifiedProfile {
  const VerifiedProfile({this.displayName, this.displayCurrency});

  final String? displayName;

  /// The display currency the user last chose, as the API holds it. Read at
  /// restore so the preference survives a reinstall, rather than living only in
  /// this device's preferences.
  final String? displayCurrency;
}

abstract interface class SessionRepository {
  /// Asks the API whether the token the client holds is still good.
  ///
  /// The token is attached by the configured client's interceptor
  /// (`FR-DA-12`), never passed here and never placed in a URL.
  Future<Result<VerifiedProfile>> verifyCurrentToken();
}

class HttpSessionRepository implements SessionRepository {
  HttpSessionRepository(this._client);

  /// Built from the shared `dio` instance, so it carries the bearer
  /// interceptor and the timeouts like every other call.
  factory HttpSessionRepository.fromDio(Dio dio) =>
      HttpSessionRepository(MeClient(dio));

  final MeClient _client;

  @override
  Future<Result<VerifiedProfile>> verifyCurrentToken() async {
    try {
      final response = await _client.getApiMe();
      final profile = response.data;

      if (profile == null) {
        // The API answered but named no profile. Treated as a rejection rather
        // than admitted on an empty body: UC-11 AF-02 is explicit that the user
        // is never admitted on a token the API has not confirmed.
        return const Failure(
          message: 'The instance did not confirm this session.',
          kind: FailureKind.unauthenticated,
        );
      }

      return Success(
        VerifiedProfile(
          displayName: profile.displayName,
          displayCurrency: profile.displayCurrency,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<VerifiedProfile>(exception);
    }
  }
}

/// The repository the application uses, built on the shared client.
///
/// Overridden in tests with a fake, which is the seam `FR-DA-01` exists for.
final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => HttpSessionRepository.fromDio(ref.watch(dioProvider)),
);
