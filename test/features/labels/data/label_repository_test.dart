import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/network/api_client.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/labels/data/label_repository.dart';

import '../../../support/api_stub.dart';

const _unreachable = 'The instance could not be reached.';

void main() {
  group('HttpTagRepository.kind', () {
    test('Given the tag repository '
        'When its kind is asked '
        'Then it serves tags', () {
      final stub = ApiStub();

      final kind = HttpTagRepository.fromDio(stub.dio).kind;

      expect(kind, LabelKind.tag);
    });
  });

  group('HttpTagRepository.list', () {
    test('Given more tags than one page holds '
        'When they are listed '
        'Then every page is read and the list is whole (UC-27)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return pagedList(
          'tags',
          [
            {'id': 'p$page', 'name': 'tag $page'},
          ],
          pageNumber: page,
          totalPages: 2,
        );
      });

      final result = await HttpTagRepository.fromDio(stub.dio).list();

      expect(
        [
          for (final request in stub.requests)
            request.queryParameters['pageNumber'],
        ],
        [1, 2],
      );
      expect([for (final item in result.valueOrNull!) item.id], ['p1', 'p2']);
    });

    test("Given the user's tags "
        'When they are listed '
        'Then they are fetched without deleted ones, from the first page, and '
        'each is mapped (UC-27 main flow)', () async {
      final stub = ApiStub.data({
        'tags': [
          {'id': 't1', 'name': 'groceries', 'isDeleted': false},
          {'id': 't2', 'name': 'travel', 'isDeleted': true},
        ],
        'pageNumber': 1,
        'pageSize': 100,
        'totalItems': 2,
        'totalPages': 1,
      });

      final result = await HttpTagRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/tags');
      expect(stub.request.queryParameters, {
        'includeDeleted': false,
        'pageNumber': 1,
        'pageSize': 100,
      });
      expect(
        [
          for (final tag in result.valueOrNull!)
            (tag.id, tag.name, tag.isDeleted),
        ],
        [('t1', 'groceries', false), ('t2', 'travel', true)],
      );
    });

    test('Given a tag with every optional field missing '
        'When it is listed '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data({
        'tags': [<String, Object?>{}],
      });

      final result = await HttpTagRepository.fromDio(stub.dio).list();

      final tag = result.valueOrNull!.single;
      expect(tag.id, '');
      expect(tag.name, '');
      expect(tag.isDeleted, isFalse);
    });

    test('Given an answer with no data or no list '
        'When the tags are listed '
        'Then there are none (UC-27 AF-04)', () async {
      for (final data in [null, <String, Object?>{}]) {
        final stub = ApiStub.data(data);

        final result = await HttpTagRepository.fromDio(stub.dio).list();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      }
    });

    test('Given the API refuses the request '
        'When the tags are listed '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(401, ['The session has expired.']));

      final result = await HttpTagRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Label>>(
          message: 'The session has expired.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the tags are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTagRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Label>>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTagRepository.create', () {
    test('Given a name '
        'When a tag is created '
        'Then the name is posted', () async {
      final stub = ApiStub.data({'id': 't1'}, status: 201);

      final result = await HttpTagRepository.fromDio(stub.dio)
          .create('groceries');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/tags');
      expect(stub.body, {'name': 'groceries'});
    });

    test('Given a name that is already taken '
        'When a tag is created '
        "Then the API's reason is the failure (UC-27 AF-01)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A tag with that name already exists.']),
      );

      final result = await HttpTagRepository.fromDio(stub.dio)
          .create('groceries');

      expect(
        result,
        const Failure<void>(
          message: 'A tag with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a tag is created '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTagRepository.fromDio(stub.dio)
          .create('groceries');

      expect(
        result,
        const Failure<void>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpTagRepository.rename', () {
    test('Given a new name '
        'When a tag is renamed '
        'Then the name is put to its own address', () async {
      final stub = ApiStub.data({'id': 't1'});

      final result = await HttpTagRepository.fromDio(stub.dio)
          .rename(id: 't1', name: 'food');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/tags/t1');
      expect(stub.body, {'name': 'food'});
    });

    test('Given a tag that does not exist or is not the user\'s '
        'When it is renamed '
        'Then it is not found (UC-27 AF-03)', () async {
      final stub = ApiStub((_) => refusal(404, ['Tag not found.']));

      final result = await HttpTagRepository.fromDio(stub.dio)
          .rename(id: 'gone', name: 'food');

      expect(
        result,
        const Failure<void>(
          message: 'Tag not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an empty name '
        'When a tag is renamed '
        "Then the API's reason is the failure (UC-27 AF-01)", () async {
      final stub = ApiStub((_) => refusal(400, ['The name is required.']));

      final result = await HttpTagRepository.fromDio(stub.dio)
          .rename(id: 't1', name: '');

      expect(
        result,
        const Failure<void>(
          message: 'The name is required.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('HttpTagRepository.delete', () {
    test('Given a tag '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 't1'});

      final result = await HttpTagRepository.fromDio(stub.dio).delete('t1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/tags/t1');
    });

    test('Given a tag transactions still carry '
        'When it is deleted '
        "Then the API's reason is the failure (UC-27 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Transactions still carry this tag.']),
      );

      final result = await HttpTagRepository.fromDio(stub.dio).delete('t1');

      expect(
        result,
        const Failure<void>(
          message: 'Transactions still carry this tag.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a tag is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpTagRepository.fromDio(stub.dio).delete('t1');

      expect(
        result,
        const Failure<void>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCounterpartyRepository.kind', () {
    test('Given the counterparty repository '
        'When its kind is asked '
        'Then it serves counterparties', () {
      final stub = ApiStub();

      final kind = HttpCounterpartyRepository.fromDio(stub.dio).kind;

      expect(kind, LabelKind.counterparty);
    });
  });

  group('HttpCounterpartyRepository.list', () {
    test('Given more counterparties than one page holds '
        'When they are listed '
        'Then every page is read and the list is whole (UC-27)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return pagedList(
          'counterparties',
          [
            {'id': 'p$page', 'name': 'payee $page'},
          ],
          pageNumber: page,
          totalPages: 2,
        );
      });

      final result = await HttpCounterpartyRepository.fromDio(stub.dio).list();

      expect(
        [
          for (final request in stub.requests)
            request.queryParameters['pageNumber'],
        ],
        [1, 2],
      );
      expect([for (final item in result.valueOrNull!) item.id], ['p1', 'p2']);
    });

    test("Given the user's counterparties "
        'When they are listed '
        'Then they are fetched without deleted ones, from the first page, and '
        'each is mapped (UC-27 main flow)', () async {
      final stub = ApiStub.data({
        'counterparties': [
          {'id': 'c1', 'name': 'Bakery', 'isDeleted': false},
          {'id': 'c2', 'name': 'Employer', 'isDeleted': true},
        ],
        'pageNumber': 1,
        'pageSize': 100,
        'totalItems': 2,
        'totalPages': 1,
      });

      final result = await HttpCounterpartyRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/counterparties');
      expect(stub.request.queryParameters, {
        'includeDeleted': false,
        'pageNumber': 1,
        'pageSize': 100,
      });
      expect(
        [
          for (final counterparty in result.valueOrNull!)
            (counterparty.id, counterparty.name, counterparty.isDeleted),
        ],
        [('c1', 'Bakery', false), ('c2', 'Employer', true)],
      );
    });

    test('Given a counterparty with every optional field missing '
        'When it is listed '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data({
        'counterparties': [<String, Object?>{}],
      });

      final result = await HttpCounterpartyRepository.fromDio(stub.dio).list();

      final counterparty = result.valueOrNull!.single;
      expect(counterparty.id, '');
      expect(counterparty.name, '');
      expect(counterparty.isDeleted, isFalse);
    });

    test('Given an answer with no data or no list '
        'When the counterparties are listed '
        'Then there are none (UC-27 AF-04)', () async {
      for (final data in [null, <String, Object?>{}]) {
        final stub = ApiStub.data(data);

        final result = await HttpCounterpartyRepository.fromDio(stub.dio)
            .list();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      }
    });

    test('Given the API refuses the request '
        'When the counterparties are listed '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(401, ['The session has expired.']));

      final result = await HttpCounterpartyRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Label>>(
          message: 'The session has expired.',
          kind: FailureKind.unauthenticated,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the counterparties are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCounterpartyRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<Label>>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCounterpartyRepository.create', () {
    test('Given a name '
        'When a counterparty is created '
        'Then the name is posted', () async {
      final stub = ApiStub.data({'id': 'c1'}, status: 201);

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .create('Bakery');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/counterparties');
      expect(stub.body, {'name': 'Bakery'});
    });

    test('Given a name that is already taken '
        'When a counterparty is created '
        "Then the API's reason is the failure (UC-27 AF-01)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A counterparty with that name already exists.']),
      );

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .create('Bakery');

      expect(
        result,
        const Failure<void>(
          message: 'A counterparty with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a counterparty is created '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .create('Bakery');

      expect(
        result,
        const Failure<void>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCounterpartyRepository.rename', () {
    test('Given a new name '
        'When a counterparty is renamed '
        'Then the name is put to its own address', () async {
      final stub = ApiStub.data({'id': 'c1'});

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .rename(id: 'c1', name: 'Corner bakery');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/counterparties/c1');
      expect(stub.body, {'name': 'Corner bakery'});
    });

    test("Given a counterparty that does not exist or is not the user's "
        'When it is renamed '
        'Then it is not found (UC-27 AF-03)', () async {
      final stub = ApiStub((_) => refusal(404, ['Counterparty not found.']));

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .rename(id: 'gone', name: 'Corner bakery');

      expect(
        result,
        const Failure<void>(
          message: 'Counterparty not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a counterparty is renamed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .rename(id: 'c1', name: 'Corner bakery');

      expect(
        result,
        const Failure<void>(
          message: _unreachable,
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpCounterpartyRepository.delete', () {
    test('Given a counterparty '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'c1'});

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .delete('c1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/counterparties/c1');
    });

    test('Given a counterparty transactions still carry '
        'When it is deleted '
        "Then the API's reason is the failure (UC-27 AF-02)", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Transactions still carry this counterparty.']),
      );

      final result = await HttpCounterpartyRepository.fromDio(stub.dio)
          .delete('c1');

      expect(
        result,
        const Failure<void>(
          message: 'Transactions still carry this counterparty.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('labelRepositoryProvider', () {
    test(
      'Given each kind '
      'When its repository is asked for '
      'Then the one serving that kind is built on the shared client',
      () async {
        final stub = ApiStub.data({'counterparties': <Object?>[]});
        final container = ProviderContainer(
          overrides: [dioProvider.overrideWithValue(stub.dio)],
        );
        addTearDown(container.dispose);

        final tags = container.read(labelRepositoryProvider(LabelKind.tag));
        final counterparties = container.read(
          labelRepositoryProvider(LabelKind.counterparty),
        );
        await counterparties.list();

        expect(tags, isA<HttpTagRepository>());
        expect(tags.kind, LabelKind.tag);
        expect(counterparties, isA<HttpCounterpartyRepository>());
        expect(counterparties.kind, LabelKind.counterparty);
        expect(stub.request.path, '/api/counterparties');
      },
    );
  });
}
