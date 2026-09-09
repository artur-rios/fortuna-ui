import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/session/session_teardown.dart';

void main() {
  group('SessionTeardown', () {
    test('Given several registrations '
        'When the session ends '
        'Then every one of them runs', () async {
      final teardown = SessionTeardown();
      final ran = <String>[];

      teardown
        ..register('categories', () async => ran.add('categories'))
        ..register('accounts', () async => ran.add('accounts'));

      await teardown.runAll();

      expect(ran, containsAll(['categories', 'accounts']));
    });

    test('Given one registration that throws '
        'When the session ends '
        'Then the others still run and the failure is reported', () async {
      // One feature failing to clear its own cache must not leave the rest of
      // the application holding the previous user's data.
      final teardown = SessionTeardown();
      final ran = <String>[];

      teardown
        ..register('broken', () async => throw StateError('nope'))
        ..register('accounts', () async => ran.add('accounts'));

      final failures = await teardown.runAll();

      expect(ran, ['accounts']);
      expect(failures, hasLength(1));
    });

    test('Given a name registered twice '
        'When the session ends '
        'Then only the latest registration runs, not both', () async {
      final teardown = SessionTeardown();
      var count = 0;

      teardown
        ..register('accounts', () async => count++)
        ..register('accounts', () async => count++);

      await teardown.runAll();

      expect(count, 1);
      expect(teardown.registered, ['accounts']);
    });

    test('Given a registration that is removed '
        'When the session ends '
        'Then it does not run', () async {
      final teardown = SessionTeardown();
      var ran = false;

      teardown
        ..register('accounts', () async => ran = true)
        ..unregister('accounts');

      await teardown.runAll();

      expect(ran, isFalse);
      expect(teardown.registered, isEmpty);
    });

    test('Given nothing registered '
        'When the session ends '
        'Then it completes without complaint', () async {
      expect(await SessionTeardown().runAll(), isEmpty);
    });
  });
}
