import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/session/session.dart';
import 'package:fortuna_ui/core/session/token_claims.dart';

/// Builds a token whose payload is [payload]. The signature is deliberately
/// nonsense: the client never verifies it, and a test that supplied a real one
/// would imply otherwise.
String tokenWith(Map<String, dynamic> payload) {
  String segment(Map<String, dynamic> value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');

  return '${segment({'alg': 'HS256', 'typ': 'JWT'})}'
      '.${segment(payload)}'
      '.not-a-real-signature';
}

void main() {
  group('TokenClaims', () {
    test('Given a token for a user '
        'When its claims are read '
        'Then the subject and the account owner role are resolved', () {
      final claims = TokenClaims.tryParse(
        tokenWith({'id': 'subject-1', 'role': 3}),
      );

      expect(claims, isNotNull);
      expect(claims!.subject, 'subject-1');
      expect(claims.role, Role.accountOwner);
      expect(claims.isLocal, isFalse);
    });

    test('Given a token for either kind of administrator '
        'When its claims are read '
        'Then both resolve to the instance administrator role', () {
      for (final roleId in [1, 2]) {
        final claims = TokenClaims.tryParse(
          tokenWith({'id': 'subject-1', 'role': roleId}),
        );

        expect(
          claims?.role,
          Role.instanceAdministrator,
          reason: 'role $roleId should administer, not own records',
        );
      }
    });

    test('Given a role claim sent as a string '
        'When its claims are read '
        'Then it is still resolved', () {
      expect(
        TokenClaims.tryParse(tokenWith({'id': 's', 'role': '3'}))?.role,
        Role.accountOwner,
      );
    });

    test('Given a token naming a role this instance does not recognize '
        'When its claims are read '
        'Then it is rejected rather than guessed (UC-11 AF-05)', () {
      for (final roleId in [0, 4, 99, -1]) {
        expect(
          TokenClaims.tryParse(tokenWith({'id': 's', 'role': roleId})),
          isNull,
          reason: 'role $roleId is unknown and must not be admitted',
        );
      }
    });

    test('Given a token with no role or no subject '
        'When its claims are read '
        'Then it is rejected', () {
      expect(TokenClaims.tryParse(tokenWith({'id': 's'})), isNull);
      expect(TokenClaims.tryParse(tokenWith({'role': 3})), isNull);
      expect(TokenClaims.tryParse(tokenWith({'id': '', 'role': 3})), isNull);
    });

    test('Given something that is not a token at all '
        'When its claims are read '
        'Then it is rejected without throwing', () {
      for (final value in ['', 'not.a.token', 'onlyonesegment', 'a.b']) {
        expect(TokenClaims.tryParse(value), isNull, reason: '"$value"');
      }
    });

    test('Given a token whose payload is not valid base64 or not an object '
        'When its claims are read '
        'Then it is rejected without throwing', () {
      expect(TokenClaims.tryParse('header.!!!!.signature'), isNull);
      expect(
        TokenClaims.tryParse(
          'header.${base64Url.encode(utf8.encode('[1,2,3]')).replaceAll('=', '')}.sig',
        ),
        isNull,
      );
    });

    test('Given a local desktop identity '
        'When its claims are read '
        'Then it is reported as local', () {
      expect(
        TokenClaims.tryParse(
          tokenWith({'id': 's', 'role': 3, 'fortuna_local': true}),
        )?.isLocal,
        isTrue,
      );
      expect(
        TokenClaims.tryParse(
          tokenWith({'id': 's', 'role': 3, 'fortuna_local': 'True'}),
        )?.isLocal,
        isTrue,
      );
    });

    test(
      'Given a token carrying an expiry '
      'When it is in the past '
      'Then it reports as expired — advisory only, the API still decides',
      () {
        final past = DateTime.now().toUtc().subtract(const Duration(hours: 1));
        final future = DateTime.now().toUtc().add(const Duration(hours: 1));

        expect(
          TokenClaims.tryParse(
            tokenWith({
              'id': 's',
              'role': 3,
              'exp': past.millisecondsSinceEpoch ~/ 1000,
            }),
          )?.hasExpired,
          isTrue,
        );
        expect(
          TokenClaims.tryParse(
            tokenWith({
              'id': 's',
              'role': 3,
              'exp': future.millisecondsSinceEpoch ~/ 1000,
            }),
          )?.hasExpired,
          isFalse,
        );
      },
    );

    test('Given a token with no expiry claim '
        'When it is checked '
        'Then it does not claim to have expired', () {
      expect(
        TokenClaims.tryParse(tokenWith({'id': 's', 'role': 3}))?.hasExpired,
        isFalse,
      );
    });
  });
}
