import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/planning/data/goal_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> goalOutput({
  Map<String, Object?>? progress,
  Object? accounts,
  Object? investments,
}) => {
  'id': 'g1',
  'name': 'New laptop',
  'targetAmount': '5000.00',
  'currencyCode': 'BRL',
  'targetDate': '2027-03-01T00:00:00.000',
  'accounts': ?accounts,
  'investments': ?investments,
  'currentProgress': ?progress,
};

void main() {
  group('HttpGoalRepository.list', () {
    test(
      'Given goals with their progress '
      'When they are listed '
      "Then each is mapped with the API's own figures (UC-29 main flow)",
      () async {
        final stub = ApiStub.data({
          'goals': [
            goalOutput(
              accounts: [
                {'id': 'a1', 'name': 'Checking'},
              ],
              investments: [
                {'id': 'i1', 'name': 'Treasury'},
              ],
              progress: {
                'currentAmount': '1250.50',
                'remaining': '3749.50',
                'proportionReached': '0.2501',
                'isReached': false,
              },
            ),
          ],
        });

        final result = await HttpGoalRepository.fromDio(stub.dio).list();

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/goals');
        final goal = result.valueOrNull!.single;
        expect(goal.id, 'g1');
        expect(goal.name, 'New laptop');
        expect(goal.targetAmount.amount, Decimal.parse('5000'));
        expect(goal.targetAmount.currencyCode, 'BRL');
        expect(goal.targetDate, DateTime(2027, 3));
        expect(goal.accountNames, ['Checking']);
        expect(goal.investmentNames, ['Treasury']);
        expect(goal.accountIds, ['a1']);
        expect(goal.investmentIds, ['i1']);
        expect(goal.progress!.currentAmount!.amount, Decimal.parse('1250.50'));
        expect(goal.progress!.remaining!.amount, Decimal.parse('3749.50'));
        expect(goal.progress!.proportionReached, Decimal.parse('0.2501'));
        expect(goal.progress!.proportionPermille, 250);
        expect(goal.isReached, isFalse);
        expect(goal.hasNoProgress, isFalse);
      },
    );

    test(
      'Given a goal the API sent no progress for '
      'When it is listed '
      'Then its progress stays absent rather than zero (UC-29 AF-03)',
      () async {
        final stub = ApiStub.data({
          'goals': [
            goalOutput(progress: {'isReached': null}),
          ],
        });

        final goal = (await HttpGoalRepository.fromDio(
          stub.dio,
        ).list()).valueOrNull!.single;

        expect(goal.progress!.currentAmount, isNull);
        expect(goal.progress!.remaining, isNull);
        expect(goal.progress!.proportionReached, isNull);
        expect(goal.progress!.proportionPermille, isNull);
        expect(goal.hasNoProgress, isTrue);
        expect(goal.isReached, isFalse);
      },
    );

    test('Given a goal with every optional field missing '
        'When it is listed '
        'Then the gaps read as empty rather than failing', () async {
      final stub = ApiStub.data({
        'goals': [<String, Object?>{}],
      });

      final goal = (await HttpGoalRepository.fromDio(
        stub.dio,
      ).list()).valueOrNull!.single;

      expect(goal.id, '');
      expect(goal.name, '');
      expect(goal.targetAmount.amount, Decimal.zero);
      expect(goal.targetDate, DateTime(1970));
      expect(goal.accountNames, isEmpty);
      expect(goal.investmentNames, isEmpty);
      expect(goal.progress, isNull);
      expect(goal.hasNoProgress, isTrue);
    });

    test('Given an answer with no data '
        'When the goals are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpGoalRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an instance that cannot be reached '
        'When the goals are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpGoalRepository.fromDio(stub.dio).list();

      expect(result, isA<Failure<List<Goal>>>());
      expect((result as Failure).kind, FailureKind.unreachable);
    });
  });

  group('HttpGoalRepository.read', () {
    test('Given a goal that exists '
        'When it is read '
        'Then it is fetched by its id and mapped', () async {
      final stub = ApiStub.data(goalOutput());

      final result = await HttpGoalRepository.fromDio(stub.dio).read('g1');

      expect(stub.request.path, '/api/goals/g1');
      expect(result.valueOrNull!.name, 'New laptop');
    });

    test('Given an answer with no data '
        'When a goal is read '
        'Then it is not found (UC-29 AF-05)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpGoalRepository.fromDio(stub.dio).read('g1');

      expect(
        result,
        const Failure<Goal>(
          message: 'That goal was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When a goal is read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(404, ['Goal not found.']));

      final result = await HttpGoalRepository.fromDio(stub.dio).read('g1');

      expect(
        result,
        const Failure<Goal>(
          message: 'Goal not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpGoalRepository.create', () {
    test(
      'Given a goal drawing on nothing in particular '
      'When it is created '
      'Then the amount is sent as typed and empty links are left out',
      () async {
        final stub = ApiStub.data({'id': 'g1'}, status: 201);

        final result = await HttpGoalRepository.fromDio(stub.dio).create(
          name: 'New laptop',
          targetAmount: '5000.00',
          currencyCode: 'BRL',
          targetDate: DateTime(2027, 3),
        );

        expect(result, const Success<void>(null));
        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/goals');
        expect(stub.body, {
          'accountIds': null,
          'currencyCode': 'BRL',
          'investmentIds': null,
          'name': 'New laptop',
          'targetAmount': '5000.00',
          'targetDate': '2027-03-01T00:00:00.000',
        });
      },
    );

    test('Given a goal drawing on accounts and investments '
        'When it is created '
        'Then their ids are sent', () async {
      final stub = ApiStub.data({'id': 'g1'}, status: 201);

      await HttpGoalRepository.fromDio(stub.dio).create(
        name: 'New laptop',
        targetAmount: '5000.00',
        currencyCode: 'BRL',
        targetDate: DateTime(2027, 3),
        accountIds: ['a1'],
        investmentIds: ['i1', 'i2'],
      );

      final body = stub.body! as Map<String, Object?>;
      expect(body['accountIds'], ['a1']);
      expect(body['investmentIds'], ['i1', 'i2']);
    });

    test('Given the API refuses the goal '
        'When it is created '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['A goal with that name already exists.']),
      );

      final result = await HttpGoalRepository.fromDio(stub.dio).create(
        name: 'New laptop',
        targetAmount: '5000.00',
        currencyCode: 'BRL',
        targetDate: DateTime(2027, 3),
      );

      expect(
        result,
        const Failure<void>(
          message: 'A goal with that name already exists.',
          kind: FailureKind.conflict,
        ),
      );
    });
  });

  group('HttpGoalRepository.update', () {
    test('Given an edited goal '
        'When it is saved '
        'Then it is put to its own address with every field', () async {
      final stub = ApiStub.data({'id': 'g1'});

      final result = await HttpGoalRepository.fromDio(stub.dio).update(
        id: 'g1',
        name: 'Faster laptop',
        targetAmount: '6000',
        currencyCode: 'BRL',
        targetDate: DateTime(2027, 6),
        accountIds: ['a1'],
      );

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'PUT');
      expect(stub.request.path, '/api/goals/g1');
      expect(stub.body, {
        'accountIds': ['a1'],
        'currencyCode': 'BRL',
        'investmentIds': null,
        'name': 'Faster laptop',
        'targetAmount': '6000',
        'targetDate': '2027-06-01T00:00:00.000',
      });
    });

    test('Given the API refuses the edit '
        'When it is saved '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(400, ['The target must be positive.']),
      );

      final result = await HttpGoalRepository.fromDio(stub.dio).update(
        id: 'g1',
        name: 'Faster laptop',
        targetAmount: '0',
        currencyCode: 'BRL',
        targetDate: DateTime(2027, 6),
      );

      expect(
        result,
        const Failure<void>(
          message: 'The target must be positive.',
          kind: FailureKind.invalidInput,
        ),
      );
    });
  });

  group('HttpGoalRepository.delete', () {
    test('Given a goal '
        'When it is deleted '
        'Then the delete goes to its own address', () async {
      final stub = ApiStub.data({'id': 'g1'});

      final result = await HttpGoalRepository.fromDio(stub.dio).delete('g1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'DELETE');
      expect(stub.request.path, '/api/goals/g1');
    });

    test('Given an instance that cannot be reached '
        'When a goal is deleted '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpGoalRepository.fromDio(stub.dio).delete('g1');

      expect(
        result,
        const Failure<void>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
