/// What the offline core can and cannot do (UC-02, FR-DA-14).
///
/// The core exports every route the API has, but it does not implement all of
/// them: some need a native domain it does not have yet (transfer legs, billing
/// cycles, installment splitting, file parsers, reports). Those always answer
/// `FORTUNA_STATUS_NOT_IMPLEMENTED` (`501`), and `fortuna_capabilities` lists
/// them under `notImplemented` with the reason.
///
/// The application reads that list once, when offline mode starts, so a screen
/// can say "not available offline, and why" before the user fills in a form
/// whose submission was always going to be refused. The `501` itself is still
/// handled where it arrives (`FailureKind.unavailableOffline`), because a core
/// that does not publish the list, or a call made before it was read, must not
/// read as a broken installation.
///
/// Online nothing here applies: there is no dispatcher, so nothing is ever
/// reported unavailable and the HTTP transport behaves as it always did.
///
/// No `dart:ffi` here: the call goes through [CoreDispatcher] (`IR-13`).
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../bindings/core_dispatcher.dart';
import 'api_client.dart';

/// One route the core exports but does not implement, and the core's reason.
@immutable
class NotImplementedRoute {
  const NotImplementedRoute({
    required this.method,
    required this.path,
    required this.reason,
    this.symbol = '',
  });

  /// The HTTP method, upper case.
  final String method;

  /// The route template, e.g. `/api/statements/{id}/close`.
  final String path;

  /// Why the core does not do this, as the core words it.
  final String reason;

  /// The exported symbol that answers `501`.
  final String symbol;

  @override
  bool operator ==(Object other) =>
      other is NotImplementedRoute &&
      other.method == method &&
      other.path == path &&
      other.reason == reason &&
      other.symbol == symbol;

  @override
  int get hashCode => Object.hash(method, path, reason, symbol);

  @override
  String toString() => '$method $path: $reason';
}

/// The part of `fortuna_capabilities` the interface acts on.
@immutable
class CoreCapabilities {
  const CoreCapabilities({this.notImplemented = const []});

  /// Reads the `DataOutput` envelope `fortuna_capabilities` answers with.
  ///
  /// Tolerant by design: a core that predates `notImplemented`, or an entry
  /// missing a field, yields fewer known gaps rather than an exception — the
  /// `501` is still handled where it arrives.
  factory CoreCapabilities.fromEnvelope(Object? envelope) {
    final data = envelope is Map ? envelope['data'] : null;
    final entries = data is Map ? data['notImplemented'] : null;
    if (entries is! List) return none;

    return CoreCapabilities(
      notImplemented: [
        for (final entry in entries)
          if (entry is Map &&
              entry['method'] is String &&
              entry['path'] is String)
            NotImplementedRoute(
              method: (entry['method'] as String).toUpperCase(),
              path: entry['path'] as String,
              reason: entry['reason'] is String
                  ? entry['reason'] as String
                  : '',
              symbol: entry['symbol'] is String
                  ? entry['symbol'] as String
                  : '',
            ),
      ],
    );
  }

  /// Nothing is known to be unavailable: the HTTP transport, or a core whose
  /// capabilities could not be read.
  static const none = CoreCapabilities();

  final List<NotImplementedRoute> notImplemented;

  /// The entry for [method] [path], or `null` where the core implements it.
  NotImplementedRoute? find(String method, String path) {
    final wanted = method.toUpperCase();
    for (final route in notImplemented) {
      if (route.method == wanted && route.path == path) return route;
    }
    return null;
  }

  /// Why [feature] cannot be used offline, or `null` where it can.
  ///
  /// A feature is unavailable when any route it depends on is: a screen that
  /// can read but not write, or write but not read, is not one to offer.
  String? reasonFor(OfflineFeature feature) {
    for (final (method, path) in feature.routes) {
      final route = find(method, path);
      if (route != null) {
        return route.reason.isEmpty
            ? '${route.method} ${route.path} is not available offline.'
            : route.reason;
      }
    }
    return null;
  }
}

/// The entry points the interface offers that depend on a route the core may
/// not implement, each with the routes it needs.
///
/// Named for what the user sees, not for the route, because that is what the
/// screens ask about.
enum OfflineFeature {
  /// UC-32: uploading a workbook or a PDF statement.
  fileImport([('POST', '/api/imports/excel'), ('POST', '/api/imports/pdf')]),

  /// UC-33 AF-03: retrying a failed import.
  importRetry([('POST', '/api/import-jobs/{id}/retry')]),

  /// UC-39: exporting a data set (the transactions table).
  dataSetExport([('POST', '/api/exports')]),

  /// UC-36, UC-37: charts and their drill-down.
  insight([
    ('GET', '/api/reports/aggregate'),
    ('GET', '/api/reports/drill-down'),
  ]),

  /// UC-38: net position, cash-flow projection and committed obligations.
  projections([
    ('GET', '/api/reports/net-position'),
    ('GET', '/api/projections/cash-flow'),
    ('GET', '/api/projections/commitments'),
  ]),

  /// UC-21: recording a transfer.
  transfers([('POST', '/api/transfers')]),

  /// UC-22: recording an installment purchase.
  installmentPurchases([('POST', '/api/installment-plans')]),

  /// UC-16: a card's billing cycles and one statement.
  cardStatements([
    ('GET', '/api/credit-cards/{id}/statements'),
    ('GET', '/api/statements/{id}'),
  ]),

  /// UC-16: closing and settling a statement.
  statementActions([
    ('POST', '/api/statements/{id}/close'),
    ('POST', '/api/statements/{id}/settle'),
  ]),

  /// UC-23: generating due recurring occurrences.
  recurringMaterialization([
    ('POST', '/api/recurring-transactions/materialize'),
  ]),

  /// UC-28: what a budget's period has consumed.
  budgetConsumption([('GET', '/api/budgets/{id}/consumption')]),

  /// UC-29: how far a goal has got.
  goalProgress([('GET', '/api/goals/{id}/progress')]),

  /// UC-24: reconciling a transaction.
  reconciliation([('POST', '/api/transactions/{id}/reconcile')]);

  const OfflineFeature(this.routes);

  /// The `(method, path template)` pairs the feature needs.
  final List<(String, String)> routes;
}

/// The symbol the core describes itself through.
const capabilitiesSymbol = 'fortuna_capabilities';

/// Asks the core what it does not implement.
///
/// Never throws: a core that cannot answer is reported as
/// [CoreCapabilities.none], and each call then states its own `501` where one
/// arrives.
Future<CoreCapabilities> readCoreCapabilities(CoreDispatcher dispatcher) async {
  try {
    final response = await dispatcher.call(capabilitiesSymbol, '{}');
    if (response.status != 200 || response.body.isEmpty) {
      return CoreCapabilities.none;
    }
    return CoreCapabilities.fromEnvelope(jsonDecode(response.body));
  } on Object {
    return CoreCapabilities.none;
  }
}

/// The core's capabilities, read once per dispatcher — that is, once per
/// offline start. [CoreCapabilities.none] on every other transport.
final coreCapabilitiesProvider = FutureProvider<CoreCapabilities>((ref) async {
  final dispatcher = ref.watch(coreDispatcherProvider);
  if (dispatcher == null) return CoreCapabilities.none;
  return readCoreCapabilities(dispatcher);
});

/// Why [OfflineFeature] is not available in this installation, or `null`
/// where it is.
///
/// `null` online, and `null` while the capabilities are still being read: an
/// entry point is never hidden on a guess, and a `501` that arrives anyway is
/// shown with its reason.
final offlineUnavailableProvider = Provider.family<String?, OfflineFeature>(
  (ref, feature) =>
      ref.watch(coreCapabilitiesProvider).value?.reasonFor(feature),
);
