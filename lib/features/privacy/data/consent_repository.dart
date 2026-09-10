/// Processing consents (UC-42).
///
/// A consent is a decision about a *purpose*, taken against a *version* of the
/// disclosure. Both halves matter: a consent granted against an older version
/// is not consent to the current one, which is what `FR-PR-05` is about.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// One consent, as the API holds it.
@immutable
class Consent {
  const Consent({
    required this.purpose,
    required this.currentVersion,
    this.grantedVersion,
    this.grantedAt,
    this.isCurrent = false,
  });

  /// What the consent is for, as the API names it.
  final String purpose;

  /// The version of the disclosure the API is asking about now.
  final String? currentVersion;

  /// The version the user agreed to, or `null` where they never did.
  final String? grantedVersion;

  final DateTime? grantedAt;

  /// Whether what was agreed to is what is currently being asked.
  final bool isCurrent;

  /// Whether a decision was ever recorded.
  bool get isGranted => grantedAt != null;

  /// `AF-01`: agreed to, but to something older.
  ///
  /// Deliberately not folded into [isGranted]. An outdated consent is not a
  /// weaker version of a current one — it is a decision about a different text,
  /// and it does not carry over.
  bool get isOutdated => isGranted && !isCurrent;

  /// Whether the feature this consent gates may proceed.
  ///
  /// The one question the rest of the application should ask. `FR-PR-02`: use
  /// of a feature never implies this, and an absent or outdated consent
  /// answers false.
  bool get permits => isGranted && isCurrent;

  /// A human label for the purpose, where this build recognizes it.
  ///
  /// An unknown purpose is shown as the API named it rather than hidden: a
  /// consent this client does not understand is still one the user gave.
  String get label => switch (purpose.toLowerCase().replaceAll('_', '-')) {
    'open-banking' || 'openbanking' => 'Open banking connections',
    'external-processing' ||
    'externalprocessing' => 'Processing by external services',
    _ => purpose,
  };
}

abstract interface class ConsentRepository {
  Future<Result<List<Consent>>> list();

  /// Records a decision for [purpose] against [version] (`FR-PR-01`).
  Future<Result<void>> grant({
    required String purpose,
    required String version,
  });

  /// Withdraws it (`FR-PR-04`).
  Future<Result<void>> withdraw(String purpose);
}

class HttpConsentRepository implements ConsentRepository {
  HttpConsentRepository(this._client);

  factory HttpConsentRepository.fromDio(Dio dio) =>
      HttpConsentRepository(MeClient(dio));

  final MeClient _client;

  @override
  Future<Result<List<Consent>>> list() async {
    try {
      final output = (await _client.getApiMeConsents()).data;

      return Success([
        for (final consent
            in output?.consents ?? const <ProcessingConsentStateOutput>[])
          Consent(
            purpose: consent.purpose ?? '',
            currentVersion: consent.currentVersion,
            grantedVersion: consent.grantedVersion,
            grantedAt: consent.grantedAt,
            // A nullable flag reads as "not current": an instance that will
            // not say is not one to assume agreement from.
            isCurrent: consent.isCurrent ?? false,
          ),
      ]);
    } on DioException catch (exception) {
      // AF-06. Reported rather than answered with an empty list, because an
      // empty list would read as "you have consented to nothing" — which is a
      // claim, and this is the absence of one.
      return failureFromDioException<List<Consent>>(exception);
    }
  }

  @override
  Future<Result<void>> grant({
    required String purpose,
    required String version,
  }) async {
    try {
      await _client.postApiMeConsents(
        body: GrantProcessingConsentCommand(purpose: purpose, version: version),
      );
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  @override
  Future<Result<void>> withdraw(String purpose) async {
    try {
      await _client.deleteApiMeConsentsPurpose(purpose: purpose);
      return const Success(null);
    } on DioException catch (exception) {
      // AF-03: withdrawing something never given is the API's not-found, shown
      // as the API worded it.
      return failureFromDioException<void>(exception);
    }
  }
}

final consentRepositoryProvider = Provider<ConsentRepository>(
  (ref) => HttpConsentRepository.fromDio(ref.watch(dioProvider)),
);
