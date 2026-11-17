import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/network/explicit_nulls.dart';

void main() {
  group('withExplicitNulls', () {
    test('Given an update that leaves nullable keys out '
        'When it is shaped for the wire '
        'Then each of them travels as null, beside what it carries', () {
      expect(
        withExplicitNulls('PUT', '/api/categories/produce', {
          'name': 'Produce',
        }),
        {'name': 'Produce', 'parentId': null},
      );
    });

    test('Given an update that carries a value for a nullable key '
        'When it is shaped for the wire '
        'Then the value is kept', () {
      expect(
        withExplicitNulls('PUT', '/api/transactions/t1', {
          'description': 'Weekly shop',
          'tags': ['food'],
        }),
        {
          'counterparty': null,
          'creditCardId': null,
          'currencyCode': null,
          'description': 'Weekly shop',
          'financialAccountId': null,
          'ownerId': null,
          'tags': ['food'],
        },
      );
    });

    test(
      'Given a create, a nested route or an encoded body '
      'When it is shaped for the wire '
      'Then it is left as it is: only an update merges into a stored record',
      () {
        const create = {'name': 'Food'};
        expect(withExplicitNulls('POST', '/api/categories', create), create);
        expect(
          withExplicitNulls('PUT', '/api/categories/c1/reassign', create),
          create,
        );
        expect(withExplicitNulls('PUT', '/api/categories/c1', '{}'), '{}');
        expect(withExplicitNulls('PUT', '/api/categories/c1', null), isNull);
      },
    );

    test('Given the published contract '
        'When its updates are read '
        'Then the explicit-null keys are exactly every optional nullable '
        'property of every PUT body', () {
      final contract = jsonDecode(
        File('api/fortuna.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final schemas =
          (contract['components'] as Map<String, dynamic>)['schemas']
              as Map<String, dynamic>;

      bool nullable(Map<dynamic, dynamic> property) => switch (property) {
        {'type': final List<dynamic> types} => types.contains('null'),
        {'anyOf': final List<dynamic> branches} => branches.any(
          (branch) => (branch as Map)['type'] == 'null',
        ),
        _ => false,
      };

      final declared = <String, Set<String>>{};
      for (final MapEntry(key: path, value: operations)
          in (contract['paths'] as Map<String, dynamic>).entries) {
        final put = (operations as Map)['put'] as Map?;
        if (put == null) continue;
        final content =
            (put['requestBody'] as Map)['content'] as Map<String, dynamic>;
        final ref =
            ((content['application/json'] as Map)['schema'] as Map)[r'$ref']
                as String;
        final schema = schemas[ref.split('/').last] as Map<String, dynamic>;
        final required = {...?(schema['required'] as List?)};
        declared[path] = {
          for (final MapEntry(:key, :value)
              in (schema['properties'] as Map<String, dynamic>).entries)
            if (!required.contains(key) && nullable(value as Map)) key,
        };
      }

      expect(declared, explicitNullRequestFields);
    });
  });
}
