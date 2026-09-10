/// Asks a candidate instance who it is, before anything is persisted (UC-01).
///
/// Deliberately does **not** use the application's shared `dio` (`IR-08`): that
/// one is built from the *resolved* instance, and at setup time there is no
/// resolved instance — that is the whole point of the screen. A candidate
/// address gets a client of its own, which is discarded with the answer.
///
/// The endpoint is the anonymous health check, so the probe works before there
/// is a session, which is the only time it runs.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/config/api_contract.dart';
import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// What an instance said about itself.
@immutable
class InstanceIdentity {
  const InstanceIdentity({
    required this.contractVersion,
    required this.service,
  });

  /// The contract the instance speaks, or `null` if it named none.
  final String? contractVersion;

  /// What the instance calls itself. Shown so a user who has pointed the
  /// application at the wrong service can see that they have.
  final String? service;

  ContractCompatibility get compatibility =>
      ContractCompatibility(reported: contractVersion);
}

/// Reads a candidate instance's identity.
abstract interface class InstanceProbe {
  /// Probes [address], which the caller has already validated as well-formed.
  ///
  /// A [Failure] means the instance could not be reached or did not answer —
  /// `AF-02`. A [Success] carrying an incompatible identity is `AF-05`: the
  /// instance answered perfectly well, and is the wrong instance.
  Future<Result<InstanceIdentity>> probe(String address);
}

class HttpInstanceProbe implements InstanceProbe {
  const HttpInstanceProbe({this.buildClient = _defaultClient});

  /// How a client for a candidate address is made. Injected so tests drive the
  /// probe without a network.
  final Dio Function(String address) buildClient;

  static Dio _defaultClient(String address) => Dio(
    BaseOptions(
      baseUrl: address,
      // Shorter than the application's own timeouts, deliberately: this runs
      // while somebody watches a spinner on a form, and an address that is
      // wrong is far more common here than one that is merely slow.
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: const {'Accept': 'application/json'},
    ),
  );

  @override
  Future<Result<InstanceIdentity>> probe(String address) async {
    final dio = buildClient(address);

    try {
      final output = await HealthCheckClient(dio).getHealthcheck();

      return Success(
        InstanceIdentity(
          contractVersion: output.contractVersion,
          service: output.service,
        ),
      );
    } on DioException catch (exception) {
      // Something answered and the answer could not be read as a liveness
      // report. Dio reports that as `unknown`, wrapping the decoding error —
      // connection problems have types of their own — and it must not be
      // called unreachable: that would send the user to look at their network
      // instead of at the address they typed.
      if (exception.type == DioExceptionType.unknown) {
        return _notAFortunaInstance(exception.error ?? exception.message);
      }

      return failureFromDioException<InstanceIdentity>(exception);
    } on Object catch (error) {
      return _notAFortunaInstance(error);
    } finally {
      dio.close(force: true);
    }
  }
}

Failure<InstanceIdentity> _notAFortunaInstance(Object? cause) =>
    Failure<InstanceIdentity>(
      message: 'The address answered, but not as a Fortuna instance ($cause).',
      kind: FailureKind.serverError,
    );

final instanceProbeProvider = Provider<InstanceProbe>(
  (ref) => const HttpInstanceProbe(),
);
