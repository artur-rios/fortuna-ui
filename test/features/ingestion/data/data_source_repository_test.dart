import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/ingestion/data/data_source_repository.dart';

import '../../../support/api_stub.dart';

void main() {
  group('HttpDataSourceRepository.list', () {
    test(
      'Given a network source and a file source '
      'When the sources are listed '
      "Then each is mapped with the API's own availability (UC-30 step 1)",
      () async {
        final stub = ApiStub.data({
          'sources': [
            {
              'name': 'pluggy',
              'displayName': 'Open banking',
              'kind': 1,
              'isAvailable': false,
              'isNetworkBacked': true,
              'unavailableReason': 'Not available offline.',
              'requiredInputs': ['institution', 'itemId'],
              'supportedFormats': <String>[],
            },
            {
              'name': 'excel',
              'displayName': 'Spreadsheet',
              'kind': 2,
              'isAvailable': true,
              'isNetworkBacked': false,
            },
          ],
        });

        final result = await HttpDataSourceRepository.fromDio(stub.dio).list();

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/data-sources');
        final [network, file] = result.valueOrNull!;
        expect(network.name, 'pluggy');
        expect(network.displayName, 'Open banking');
        expect(network.kind, SourceKind.network);
        expect(network.isAvailable, isFalse);
        expect(network.isNetworkBacked, isTrue);
        expect(network.unavailableReason, 'Not available offline.');
        expect(network.requiredInputs, ['institution', 'itemId']);
        expect(file.name, 'excel');
        expect(file.kind, SourceKind.file);
        expect(file.isAvailable, isTrue);
        expect(file.isNetworkBacked, isFalse);
        expect(file.unavailableReason, isNull);
        expect(file.requiredInputs, isEmpty);
      },
    );

    test('Given a kind this build does not recognize, or none '
        'When the sources are listed '
        'Then the source is taken as a network one', () async {
      final stub = ApiStub.data({
        'sources': [
          {'name': 'a', 'kind': 7},
          {'name': 'b'},
        ],
      });

      final result = await HttpDataSourceRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull!.map((s) => s.kind), [
        SourceKind.network,
        SourceKind.network,
      ]);
    });

    test('Given a source with no display name '
        'When it is listed '
        'Then it is shown by its name', () async {
      final stub = ApiStub.data({
        'sources': [
          {'name': 'pluggy'},
        ],
      });

      final source = (await HttpDataSourceRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(source.displayName, 'pluggy');
    });

    test('Given a source with every optional field missing '
        'When it is listed '
        'Then it reads as empty and unavailable rather than failing', () async {
      final stub = ApiStub.data({
        'sources': [<String, Object?>{}],
      });

      final source = (await HttpDataSourceRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(source.name, '');
      expect(source.displayName, '');
      expect(source.kind, SourceKind.network);
      expect(source.isAvailable, isFalse);
      expect(source.isNetworkBacked, isFalse);
      expect(source.unavailableReason, isNull);
      expect(source.requiredInputs, isEmpty);
    });

    test('Given an answer with no data, or no sources in it '
        'When the sources are listed '
        'Then there are none', () async {
      final noData = ApiStub.data(null);
      final noSources = ApiStub.data(<String, Object?>{});

      final first = await HttpDataSourceRepository.fromDio(noData.dio).list();
      final second = await HttpDataSourceRepository.fromDio(noSources.dio)
          .list();

      expect(first.valueOrNull, isEmpty);
      expect(second.valueOrNull, isEmpty);
    });

    test('Given the API refuses '
        'When the sources are listed '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(500, ['Sources are unavailable.']));

      final result = await HttpDataSourceRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<DataSource>>(
          message: 'Sources are unavailable.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the sources are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpDataSourceRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<DataSource>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
