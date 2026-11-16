import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/app/routes.dart';

void main() {
  group('Routes path builders', () {
    test("Given a card's id "
        'When the path to its billing cycles is built '
        'Then it is the cycles route with the id in place (UC-16)', () {
      expect(Routes.statementsOf('card-1'), '/credit-cards/card-1/statements');
    });

    test('Given a card and one of its statements '
        'When the path to the statement is built '
        'Then it is nested under the card, so the guard protects it by '
        'prefix (UC-16)', () {
      final path = Routes.statementOf(
        creditCardId: 'card-1',
        statementId: 'st-9',
      );

      expect(path, '/credit-cards/card-1/statements/st-9');
      expect(path, startsWith(Routes.creditCards));
    });

    test('Given an id '
        'When the paths to one investment, one transaction and one import '
        "job's records are built "
        'Then each fills its route template', () {
      expect(Routes.investmentOf('inv-1'), '/investments/inv-1');
      expect(Routes.transactionOf('tx-1'), '/transactions/tx-1');
      expect(Routes.importRecordsOf('job-1'), '/imports/job-1/records');
    });

    test('Given each path builder '
        'When its result is compared with its route template '
        'Then only the parameters differ', () {
      final cases = {
        Routes.cardStatements: Routes.statementsOf(':id'),
        Routes.cardStatement: Routes.statementOf(
          creditCardId: ':id',
          statementId: ':statementId',
        ),
        Routes.investment: Routes.investmentOf(':id'),
        Routes.transaction: Routes.transactionOf(':id'),
        Routes.importRecords: Routes.importRecordsOf(':id'),
      };

      for (final MapEntry(key: template, value: built) in cases.entries) {
        expect(built, template);
      }
    });
  });
}
