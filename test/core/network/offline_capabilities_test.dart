import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/bindings/core_dispatcher.dart';
import 'package:fortuna_ui/core/network/api_client.dart';
import 'package:fortuna_ui/core/network/offline_capabilities.dart';

/// The core's reasons, as `fortuna_capabilities` words them.
const transfersReason =
    'Transfers are not implemented by the native core: it does not create the '
    'paired transaction legs, currency conversion and lifecycle cascade of a '
    'transfer.';
const reportsReason =
    'Reports and projections are not computed by the native core.';
const statementsReason =
    'Credit-card statements are not implemented by the native core: it does '
    'not assign charges to billing cycles, close or settle them.';
const importsReason =
    'File ingestion is not implemented by the native core: it has no workbook '
    'or PDF statement parser, so an offline import would not be processed.';
const exportsReason =
    'Data-set exports are not implemented by the native core; the personal '
    'data archive (POST /api/me/data-export) is available offline.';
const installmentsReason =
    'Installment plans are not implemented by the native core: it does not '
    'split a purchase into installments assigned to billing cycles.';
const planningReason =
    'Budget consumption and goal progress are not computed by the native core.';
const reconciliationReason =
    'Reconciliation needs imported records, which the native core does not '
    'create.';
const materializationReason =
    'Recurring occurrences are not materialized by the native core.';

Map<String, Object?> _entry(String method, String path, String reason) => {
  'symbol': 'fortuna_api_${path.hashCode}',
  'method': method,
  'path': path,
  'area': 'Area',
  'longRunning': false,
  'responseSchema': '',
  'reason': reason,
};

/// What `fortuna_capabilities` answers, shaped exactly as the core writes it:
/// the `DataOutput` envelope with `operations`, `notImplemented` and
/// `unavailable`.
String capabilitiesBody({bool withNotImplemented = true}) => jsonEncode({
  'data': {
    'operations': [
      {
        'symbol': 'fortuna_api_accounts_get',
        'method': 'GET',
        'path': '/api/accounts',
        'area': 'Accounts',
        'longRunning': false,
        'responseSchema': 'FinancialAccountListOutputDataOutput',
      },
    ],
    if (withNotImplemented)
      'notImplemented': [
        _entry('GET', '/api/budgets/{id}/consumption', planningReason),
        _entry('GET', '/api/credit-cards/{id}/statements', statementsReason),
        _entry('POST', '/api/exports', exportsReason),
        _entry('GET', '/api/goals/{id}/progress', planningReason),
        _entry('POST', '/api/import-jobs/{id}/retry', importsReason),
        _entry('POST', '/api/imports/excel', importsReason),
        _entry('POST', '/api/imports/pdf', importsReason),
        _entry('POST', '/api/installment-plans', installmentsReason),
        _entry('GET', '/api/projections/cash-flow', reportsReason),
        _entry('GET', '/api/projections/commitments', reportsReason),
        _entry(
          'POST',
          '/api/recurring-transactions/materialize',
          materializationReason,
        ),
        _entry('GET', '/api/reports/aggregate', reportsReason),
        _entry('GET', '/api/reports/drill-down', reportsReason),
        _entry('GET', '/api/reports/net-position', reportsReason),
        _entry('GET', '/api/statements/{id}', statementsReason),
        _entry('POST', '/api/statements/{id}/close', statementsReason),
        _entry('POST', '/api/statements/{id}/settle', statementsReason),
        _entry(
          'POST',
          '/api/transactions/{id}/reconcile',
          reconciliationReason,
        ),
        _entry('POST', '/api/transfers', transfersReason),
      ],
    'unavailable': [
      {
        'routes': 'POST /api/exchange-rates/sync',
        'reason':
            'External exchange-rate synchronization requires a network '
            'source.',
      },
    ],
  },
  'messages': ['Offline capabilities retrieved successfully.'],
  'errors': <String>[],
  'timestamp': '2026-10-08T12:00:00Z',
  'success': true,
});

/// The capabilities the offline widget tests run against.
final offlineCore = CoreCapabilities.fromEnvelope(
  jsonDecode(capabilitiesBody()),
);

class CountingDispatcher implements CoreDispatcher {
  CountingDispatcher(this.answer);

  CoreResponse Function() answer;
  final List<(String, String)> calls = [];

  @override
  Future<CoreResponse> initialize(String requestJson) async =>
      const CoreResponse(status: 200, body: '');

  @override
  Future<CoreResponse> call(String symbol, String requestJson) async {
    calls.add((symbol, requestJson));
    return answer();
  }

  @override
  Future<void> dispose() async {}
}

/// The routes the vendored header lists as exported but not implemented.
Set<String> headerNotImplementedRoutes() {
  final header = File('native/include/fortuna_core.h').readAsStringSync();
  final start = header.indexOf('Exported but not implemented offline');
  expect(start, isNot(-1), reason: 'The header no longer lists them.');
  final block = header.substring(start, header.indexOf('*/', start));

  return {
    for (final match in RegExp(
      r'^\s*\*\s+(GET|POST|PUT|PATCH|DELETE)\s+(/api/\S+)\s*$',
      multiLine: true,
    ).allMatches(block))
      '${match.group(1)} ${match.group(2)}',
  };
}

void main() {
  group('CoreCapabilities.fromEnvelope', () {
    test('Given what fortuna_capabilities answers '
        'When it is read '
        'Then every not-implemented route is known with the core reason', () {
      final capabilities = CoreCapabilities.fromEnvelope(
        jsonDecode(capabilitiesBody()),
      );

      expect(capabilities.notImplemented, hasLength(19));
      expect(
        capabilities.find('POST', '/api/transfers'),
        isA<NotImplementedRoute>()
            .having((route) => route.reason, 'reason', transfersReason)
            .having((route) => route.method, 'method', 'POST'),
      );
      expect(capabilities.find('GET', '/api/accounts'), isNull);
    });

    test('Given a core that predates notImplemented '
        'When its capabilities are read '
        'Then nothing is reported unavailable, rather than failing', () {
      final capabilities = CoreCapabilities.fromEnvelope(
        jsonDecode(capabilitiesBody(withNotImplemented: false)),
      );

      expect(capabilities.notImplemented, isEmpty);
      for (final feature in OfflineFeature.values) {
        expect(capabilities.reasonFor(feature), isNull);
      }
    });

    test('Given entries that are not what the core writes '
        'When they are read '
        'Then they are skipped, and a missing reason still says why', () {
      final capabilities = CoreCapabilities.fromEnvelope({
        'data': {
          'notImplemented': [
            'not an entry',
            {'method': 'POST'},
            {'method': 'post', 'path': '/api/transfers'},
          ],
        },
      });

      expect(capabilities.notImplemented, hasLength(1));
      expect(
        capabilities.reasonFor(OfflineFeature.transfers),
        'POST /api/transfers is not available offline.',
      );
    });

    test('Given anything but an envelope '
        'When it is read '
        'Then nothing is reported unavailable', () {
      expect(CoreCapabilities.fromEnvelope(null).notImplemented, isEmpty);
      expect(CoreCapabilities.fromEnvelope('text').notImplemented, isEmpty);
      expect(
        CoreCapabilities.fromEnvelope({'data': null}).notImplemented,
        isEmpty,
      );
    });
  });

  group('CoreCapabilities.reasonFor', () {
    test('Given a feature one of whose routes the core does not implement '
        'When its availability is asked '
        "Then the core's reason is the answer", () {
      expect(
        offlineCore.reasonFor(OfflineFeature.statementActions),
        statementsReason,
      );
      expect(offlineCore.reasonFor(OfflineFeature.insight), reportsReason);
      expect(offlineCore.reasonFor(OfflineFeature.fileImport), importsReason);
    });

    test('Given only some of a feature routes are not implemented '
        'When its availability is asked '
        'Then the feature is unavailable', () {
      const partial = CoreCapabilities(
        notImplemented: [
          NotImplementedRoute(
            method: 'GET',
            path: '/api/statements/{id}',
            reason: statementsReason,
          ),
        ],
      );

      expect(
        partial.reasonFor(OfflineFeature.cardStatements),
        statementsReason,
      );
      expect(partial.reasonFor(OfflineFeature.transfers), isNull);
    });
  });

  group('coreCapabilitiesProvider', () {
    test('Given the HTTP transport '
        'When the capabilities are read '
        'Then nothing is unavailable and no core is asked', () async {
      final container = ProviderContainer(
        overrides: [coreDispatcherProvider.overrideWithValue(null)],
      );
      addTearDown(container.dispose);

      expect(
        await container.read(coreCapabilitiesProvider.future),
        same(CoreCapabilities.none),
      );
      for (final feature in OfflineFeature.values) {
        expect(container.read(offlineUnavailableProvider(feature)), isNull);
      }
    });

    test('Given offline mode '
        'When the capabilities are read more than once '
        'Then the core is asked once, through fortuna_capabilities', () async {
      final dispatcher = CountingDispatcher(
        () => CoreResponse(status: 200, body: capabilitiesBody()),
      );
      final container = ProviderContainer(
        overrides: [coreDispatcherProvider.overrideWithValue(dispatcher)],
      );
      addTearDown(container.dispose);

      await container.read(coreCapabilitiesProvider.future);
      await container.read(coreCapabilitiesProvider.future);

      expect(dispatcher.calls, [(capabilitiesSymbol, '{}')]);
      expect(
        container.read(offlineUnavailableProvider(OfflineFeature.transfers)),
        transfersReason,
      );
      expect(
        container.read(
          offlineUnavailableProvider(OfflineFeature.budgetConsumption),
        ),
        planningReason,
      );
    });

    test('Given a core that refuses or cannot be reached '
        'When the capabilities are read '
        'Then nothing is reported unavailable and nothing throws', () async {
      for (final answer in <CoreResponse Function()>[
        () => const CoreResponse(status: 500, body: '{"success":false}'),
        () => const CoreResponse(status: 200, body: 'not json'),
        () => throw const CoreUnavailable('The core is gone.'),
      ]) {
        final container = ProviderContainer(
          overrides: [
            coreDispatcherProvider.overrideWithValue(
              CountingDispatcher(answer),
            ),
          ],
        );
        addTearDown(container.dispose);

        expect(
          (await container.read(coreCapabilitiesProvider.future))
              .notImplemented,
          isEmpty,
        );
      }
    });
  });

  group('The published contract', () {
    test('Given the vendored header '
        'When every route an offline feature depends on is checked '
        'Then each is one the header lists as not implemented', () {
      final listed = headerNotImplementedRoutes();

      expect(listed, hasLength(26));
      for (final feature in OfflineFeature.values) {
        for (final (method, path) in feature.routes) {
          expect(
            listed,
            contains('$method $path'),
            reason: '${feature.name} depends on $method $path',
          );
        }
      }
    });

    test('Given the vendored header '
        'When its not-implemented routes are checked '
        'Then each is either behind an offline feature or has no entry point '
        'in this application', () {
      // Routes the application never calls: there is no screen behind them,
      // so there is nothing to hide.
      const noEntryPoint = {
        'DELETE /api/installment-plans/{id}',
        'GET /api/installment-plans/{id}',
        'POST /api/installment-plans/{id}/restore',
        'DELETE /api/transfers/{id}',
        'GET /api/transfers/{id}',
        'POST /api/transfers/{id}/restore',
        'POST /api/reports/table',
      };
      final covered = {
        for (final feature in OfflineFeature.values)
          for (final (method, path) in feature.routes) '$method $path',
      };

      for (final route in headerNotImplementedRoutes()) {
        expect(
          covered.contains(route) || noEntryPoint.contains(route),
          isTrue,
          reason:
              '$route is not implemented offline, but no offline feature '
              'covers it. Add it to OfflineFeature, or to noEntryPoint if '
              'the application never calls it.',
        );
      }
    });
  });
}
