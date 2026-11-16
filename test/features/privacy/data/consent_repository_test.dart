import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/privacy/data/consent_repository.dart';

import '../../../support/api_stub.dart';

void main() {
  group('HttpConsentRepository.list', () {
    test('Given a current consent and one never given '
        'When the consents are listed '
        'Then each is mapped with its versions', () async {
      final stub = ApiStub.data({
        'consents': [
          {
            'purpose': 'open-banking',
            'currentVersion': 'v3',
            'grantedVersion': 'v3',
            'grantedAt': '2026-09-01T10:00:00Z',
            'isCurrent': true,
          },
          {'purpose': 'external-processing', 'currentVersion': 'v1'},
        ],
      });

      final result = await HttpConsentRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/me/consents');
      final [granted, never] = result.valueOrNull!;
      expect(granted.purpose, 'open-banking');
      expect(granted.currentVersion, 'v3');
      expect(granted.grantedVersion, 'v3');
      expect(granted.grantedAt, DateTime.utc(2026, 9, 1, 10));
      expect(granted.isCurrent, isTrue);
      expect(granted.permits, isTrue);
      expect(never.purpose, 'external-processing');
      expect(never.currentVersion, 'v1');
      expect(never.grantedVersion, isNull);
      expect(never.grantedAt, isNull);
      expect(never.isCurrent, isFalse);
      expect(never.permits, isFalse);
    });

    test(
      'Given a consent granted where the API will not say whether it is current '
      'When the consents are listed '
      'Then it reads as not current and does not permit (UC-42 AF-01)',
      () async {
        final stub = ApiStub.data({
          'consents': [
            {
              'purpose': 'open-banking',
              'grantedAt': '2026-09-01T10:00:00Z',
              'isCurrent': null,
            },
          ],
        });

        final consent = (await HttpConsentRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!.single;

        expect(consent.isCurrent, isFalse);
        expect(consent.isOutdated, isTrue);
        expect(consent.permits, isFalse);
      },
    );

    test('Given a consent with every field missing '
        'When it is listed '
        'Then its purpose reads as empty rather than failing', () async {
      final stub = ApiStub.data({
        'consents': [<String, Object?>{}],
      });

      final consent = (await HttpConsentRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(consent.purpose, '');
      expect(consent.currentVersion, isNull);
      expect(consent.isGranted, isFalse);
    });

    test('Given an answer with no data, or no consents in it '
        'When the consents are listed '
        'Then there are none', () async {
      final noData = ApiStub.data(null);
      final noConsents = ApiStub.data(<String, Object?>{});

      final first = await HttpConsentRepository.fromDio(noData.dio).list();
      final second = await HttpConsentRepository.fromDio(noConsents.dio).list();

      expect(first.valueOrNull, isEmpty);
      expect(second.valueOrNull, isEmpty);
    });

    test('Given the API cannot supply the list '
        'When the consents are listed '
        'Then it is a failure, not an empty list (UC-42 AF-06)', () async {
      final stub = ApiStub(
        (_) => refusal(500, ['Consents could not be read.']),
      );

      final result = await HttpConsentRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Consent>>(
          message: 'Consents could not be read.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the consents are listed '
        'Then it is a failure saying so (UC-42 AF-06)', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpConsentRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Consent>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpConsentRepository.grant', () {
    test('Given a disclosure the user agrees to '
        'When the consent is granted '
        'Then the purpose and version are posted (FR-PR-01)', () async {
      final stub = ApiStub.data({'purpose': 'open-banking'});

      final result = await HttpConsentRepository.fromDio(stub.dio)
          .grant(purpose: 'open-banking', version: 'v3');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/me/consents');
      expect(stub.body, {'purpose': 'open-banking', 'version': 'v3'});
    });

    test('Given a version that is no longer current '
        'When the consent is granted '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The version is not the current disclosure.']),
      );

      final result = await HttpConsentRepository.fromDio(stub.dio)
          .grant(purpose: 'open-banking', version: 'v2');

      expect(
        result,
        const Failure<void>(
          message: 'The version is not the current disclosure.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a consent is granted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpConsentRepository.fromDio(stub.dio)
          .grant(purpose: 'open-banking', version: 'v3');

      expect((result as Failure<void>).kind, FailureKind.unreachable);
    });
  });

  group('HttpConsentRepository.withdraw', () {
    test('Given a consent '
        'When it is withdrawn '
        'Then the delete goes to its purpose (FR-PR-04)', () async {
      final stub = ApiStub.data({'purpose': 'open-banking'});

      final result = await HttpConsentRepository.fromDio(stub.dio)
          .withdraw('open-banking');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/me/consents/open-banking');
    });

    test('Given a consent never given '
        'When it is withdrawn '
        "Then the API's not-found is the failure (UC-42 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(404, ['No consent was given for that purpose.']),
      );

      final result = await HttpConsentRepository.fromDio(stub.dio)
          .withdraw('open-banking');

      expect(
        result,
        const Failure<void>(
          message: 'No consent was given for that purpose.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a consent is withdrawn '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpConsentRepository.fromDio(stub.dio)
          .withdraw('open-banking');

      expect((result as Failure<void>).kind, FailureKind.unreachable);
    });
  });

  group('Consent.label', () {
    test('Given each spelling of the purposes this build recognizes '
        'When they are labelled '
        'Then hyphens, underscores, run-together words and case all match', () {
      String label(String purpose) =>
          Consent(purpose: purpose, currentVersion: 'v1').label;

      expect(label('open-banking'), 'Open banking connections');
      expect(label('OPEN_BANKING'), 'Open banking connections');
      expect(label('OpenBanking'), 'Open banking connections');
      expect(label('external-processing'), 'Processing by external services');
      expect(label('External_Processing'), 'Processing by external services');
      expect(label('externalprocessing'), 'Processing by external services');
    });
  });
}
