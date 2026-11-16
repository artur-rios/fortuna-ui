import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:mocktail/mocktail.dart';

/// The platform's secure storage, without its platform channel.
class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

const _tokenKey = 'fortuna.session.token';

void main() {
  group('SecureTokenStore', () {
    late _MockSecureStorage storage;

    setUp(() => storage = _MockSecureStorage());

    test('Given a token in secure storage '
        'When it is read '
        'Then it comes from the one session-token entry (IR-07)', () async {
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'a-token');

      final token = await SecureTokenStore(storage).read();

      expect(token, 'a-token');
      verify(() => storage.read(key: _tokenKey)).called(1);
    });

    test('Given nothing in secure storage '
        'When the token is read '
        'Then there is none', () async {
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      expect(await SecureTokenStore(storage).read(), isNull);
    });

    test('Given a new token '
        'When it is written '
        'Then it replaces the session-token entry in secure storage and goes '
        'nowhere else (FR-SE-16)', () async {
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await SecureTokenStore(storage).write('a-token');

      verify(() => storage.write(key: _tokenKey, value: 'a-token')).called(1);
      verifyNoMoreInteractions(storage);
    });

    test('Given a stored token '
        'When the store is cleared '
        'Then the session-token entry is deleted (FR-SE-21)', () async {
      when(() => storage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await SecureTokenStore(storage).clear();

      verify(() => storage.delete(key: _tokenKey)).called(1);
    });
  });
}
