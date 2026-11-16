import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/privacy/data/erasure_repository.dart';

import '../../../support/api_stub.dart';

void main() {
  group('HttpErasureRepository.erase', () {
    test(
      'Given the exact confirmation '
      'When the account is erased '
      'Then it is posted and what went is reported kind by kind (UC-44 step 6)',
      () async {
        final stub = ApiStub.data({
          'erased': {'transactions': 120, 'accounts': 3, 'consents': 2},
          'revokedConnections': 1,
          'irreversible': true,
        });

        final result = await HttpErasureRepository.fromDio(stub.dio)
            .erase(HttpErasureRepository.requiredConfirmation);

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/me/erasure');
        expect(stub.body, {'confirmation': 'ERASE'});
        final report = result.valueOrNull!;
        expect(report.erased, {
          'transactions': 120,
          'accounts': 3,
          'consents': 2,
        });
        expect(report.revokedConnections, 1);
        expect(report.totalRecords, 125);
      },
    );

    test('Given a confirmation in another case '
        'When the account is erased '
        'Then it is sent verbatim rather than normalized', () async {
      final stub = ApiStub.data({'erased': <String, int>{}});

      await HttpErasureRepository.fromDio(stub.dio).erase('erase');

      expect(stub.body, {'confirmation': 'erase'});
    });

    test('Given a report with nothing counted '
        'When the account is erased '
        'Then nothing is reported erased and no connection revoked', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final report = (await HttpErasureRepository.fromDio(
        stub.dio,
      ).erase('ERASE')).valueOrNull!;

      expect(report.erased, isEmpty);
      expect(report.revokedConnections, 0);
      expect(report.totalRecords, 0);
    });

    test('Given an answer with no data '
        'When the account is erased '
        'Then nothing is claimed as removed', () async {
      final stub = ApiStub.data(null);

      final result = await HttpErasureRepository.fromDio(stub.dio)
          .erase('ERASE');

      expect(
        result,
        const Failure<ErasureReport>(
          message:
              'The instance did not report what was erased. Nothing has been '
              'confirmed as removed; sign in again to see where you stand.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given the API refuses the confirmation '
        'When the account is erased '
        "Then the API's reason is the failure (UC-44 AF-03)", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The confirmation must be ERASE.']),
      );

      final result = await HttpErasureRepository.fromDio(stub.dio)
          .erase('erase');

      expect(
        result,
        const Failure<ErasureReport>(
          message: 'The confirmation must be ERASE.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given the erasure fails partway and is rolled back '
        'When the account is erased '
        "Then the API's reason is a server failure (UC-44 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(500, ['The erasure was rolled back.']),
      );

      final result = await HttpErasureRepository.fromDio(stub.dio)
          .erase('ERASE');

      expect(
        result,
        const Failure<ErasureReport>(
          message: 'The erasure was rolled back.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the account is erased '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpErasureRepository.fromDio(stub.dio)
          .erase('ERASE');

      expect(
        result,
        const Failure<ErasureReport>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
