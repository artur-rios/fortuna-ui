import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_route.dart';
import 'package:fortuna_ui/core/bindings/fortuna_routes.dart';

void main() {
  group('resolveCoreRoute', () {
    test('Given a route with no placeholders '
        'When it is resolved '
        'Then it finds the symbol that serves it (UC-02 main flow)', () {
      final resolved = resolveCoreRoute('GET', '/api/tags');

      expect(resolved, isNotNull);
      expect(resolved!.symbol, 'fortuna_api_tags_get');
      expect(resolved.values, isEmpty);
    });

    test('Given a route with a placeholder '
        'When it is resolved '
        'Then the placeholder captures the value the core needs', () {
      final resolved = resolveCoreRoute(
        'GET',
        '/api/accounts/8f3e1c4a-0000-4000-8000-000000000001',
      );

      expect(resolved!.symbol, 'fortuna_api_accounts_by_id_get');
      expect(resolved.values, {'id': '8f3e1c4a-0000-4000-8000-000000000001'});
    });

    test('Given a route with two placeholders '
        'When it is resolved '
        'Then both are captured under the names the header gives them', () {
      final resolved = resolveCoreRoute(
        'DELETE',
        '/api/transactions/11111111-1111-4111-8111-111111111111'
            '/tags/22222222-2222-4222-8222-222222222222',
      );

      expect(
        resolved!.symbol,
        'fortuna_api_transactions_by_id_tags_by_tag_id_delete',
      );
      expect(resolved.values['id'], '11111111-1111-4111-8111-111111111111');
      expect(resolved.values['tagId'], '22222222-2222-4222-8222-222222222222');
    });

    test('Given the same path under different methods '
        'When each is resolved '
        'Then each reaches its own symbol', () {
      expect(
        resolveCoreRoute('GET', '/api/transactions')!.symbol,
        'fortuna_api_transactions_get',
      );
      expect(
        resolveCoreRoute('POST', '/api/transactions')!.symbol,
        'fortuna_api_transactions_post',
      );
    });

    test('Given a method in lower case '
        'When it is resolved '
        'Then it matches anyway', () {
      expect(
        resolveCoreRoute('get', '/api/tags')!.symbol,
        'fortuna_api_tags_get',
      );
    });

    test('Given a path that ends in a slash or carries a query string '
        'When it is resolved '
        'Then neither confuses the match', () {
      expect(
        resolveCoreRoute('GET', '/api/tags/')!.symbol,
        'fortuna_api_tags_get',
      );
      expect(
        resolveCoreRoute('GET', '/api/tags?page=2')!.symbol,
        'fortuna_api_tags_get',
      );
    });

    test('Given a percent-encoded route value '
        'When it is resolved '
        'Then the core receives the decoded value', () {
      final resolved = resolveCoreRoute('GET', '/api/currencies/BR%2FL');

      expect(resolved!.values['code'], 'BR/L');
    });

    test('Given a literal segment that could also match a placeholder '
        'When it is resolved '
        'Then the literal route wins regardless of table order', () {
      const routes = [
        CoreRoute('GET', '/api/things/{id}', 'by_id'),
        CoreRoute('GET', '/api/things/summary', 'summary'),
      ];

      expect(
        resolveCoreRoute('GET', '/api/things/summary', routes: routes)!.symbol,
        'summary',
      );
      expect(
        resolveCoreRoute(
          'GET',
          '/api/things/summary',
          routes: routes.reversed.toList(),
        )!.symbol,
        'summary',
      );
      expect(
        resolveCoreRoute('GET', '/api/things/abc', routes: routes)!.symbol,
        'by_id',
      );
    });

    test('Given a route the core deliberately does not export '
        'When it is resolved '
        'Then nothing is found, rather than something wrong', () {
      // Heimdall's auth, Pluggy's connections and hosted consent are absent by
      // design — the header says so, and this is how the caller finds out.
      expect(resolveCoreRoute('POST', '/api/auth/login'), isNull);
      expect(resolveCoreRoute('GET', '/api/connections'), isNull);
      expect(resolveCoreRoute('GET', '/api/me/consents'), isNull);
      expect(resolveCoreRoute('GET', '/healthcheck'), isNull);
    });

    test('Given a path of the wrong length '
        'When it is resolved '
        'Then it does not match a shorter or longer template', () {
      expect(resolveCoreRoute('GET', '/api'), isNull);
      expect(resolveCoreRoute('GET', '/api/tags/a/b/c'), isNull);
    });
  });

  group('the generated route table', () {
    test('Given the vendored header '
        'When the table is compared with it '
        'Then every routed export the header declares is present '
        '(UC-02 AF-05)', () {
      final header = File('native/include/fortuna_core.h').readAsStringSync();

      final declared = RegExp(
        r'^int\s+(fortuna_[a-z0-9_]+)\s*\([^)]*\)\s*;\s*/\*\s*([A-Z]+)\s+(\S+)\s*\*/',
        multiLine: true,
      ).allMatches(header);

      expect(
        declared,
        isNotEmpty,
        reason: 'the header declares routed exports',
      );
      expect(coreRoutes.length, declared.length);

      final bySymbol = {for (final route in coreRoutes) route.symbol: route};
      for (final match in declared) {
        final route = bySymbol[match.group(1)];
        expect(
          route,
          isNotNull,
          reason: '${match.group(1)} missing from table',
        );
        expect(route!.method, match.group(2));
        expect(route.template, match.group(3));
      }
    });

    test('Given the generated table '
        'When it is inspected '
        'Then no two entries claim the same method and template', () {
      final seen = <String>{};

      for (final route in coreRoutes) {
        final key = '${route.method} ${route.template}';
        expect(seen.add(key), isTrue, reason: '$key appears twice');
      }
    });
  });
}
