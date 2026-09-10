/// Erasing the account (UC-44).
///
/// The one operation in this application that cannot be undone by anybody, on
/// either side. Everything about how it is presented follows from that.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What the erasure destroyed.
@immutable
class ErasureReport {
  const ErasureReport({required this.erased, required this.revokedConnections});

  /// How many of each kind of record went, as the API counted them.
  ///
  /// Reported rather than summarized: step 6 asks the system to say what was
  /// erased, and a single total would not.
  final Map<String, int> erased;

  final int revokedConnections;

  int get totalRecords =>
      erased.values.fold(0, (running, count) => running + count);
}

abstract interface class ErasureRepository {
  /// Erases the account. [confirmation] must be exactly what the API demands.
  Future<Result<ErasureReport>> erase(String confirmation);
}

class HttpErasureRepository implements ErasureRepository {
  HttpErasureRepository(this._client);

  factory HttpErasureRepository.fromDio(Dio dio) =>
      HttpErasureRepository(MeClient(dio));

  final MeClient _client;

  /// What the API requires, exactly.
  ///
  /// Case-sensitive on the API's side, so it is sent verbatim rather than
  /// normalized here — a client that helpfully upper-cased a user's "erase"
  /// would be completing a confirmation the user did not actually give.
  static const requiredConfirmation = 'ERASE';

  @override
  Future<Result<ErasureReport>> erase(String confirmation) async {
    try {
      final output = (await _client.postApiMeErasure(
        body: EraseUserCommand(confirmation: confirmation),
      )).data;

      if (output == null) {
        // AF-02's shape: the API either erased everything or nothing. An
        // answer this client cannot read is not evidence that anything went.
        return const Failure(
          message:
              'The instance did not report what was erased. Nothing has been '
              'confirmed as removed; sign in again to see where you stand.',
          kind: FailureKind.serverError,
        );
      }

      return Success(
        ErasureReport(
          erased: {
            for (final entry
                in (output.erased ?? const <String, int>{}).entries)
              entry.key: entry.value,
          },
          revokedConnections: output.revokedConnections ?? 0,
        ),
      );
    } on DioException catch (exception) {
      // AF-02 and AF-03. The API rolls an erasure back entirely rather than
      // leaving it half-done, so a failure here means the account is intact —
      // and that is what the caller tells the user.
      return failureFromDioException<ErasureReport>(exception);
    }
  }
}

final erasureRepositoryProvider = Provider<ErasureRepository>(
  (ref) => HttpErasureRepository.fromDio(ref.watch(dioProvider)),
);
