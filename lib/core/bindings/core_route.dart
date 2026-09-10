/// Matching an HTTP request to the core symbol that serves it (UC-02).
///
/// The offline core mirrors the API's routes one for one, so an operation that
/// goes out as `GET /api/accounts/8f3e…` over HTTP goes to
/// `fortuna_api_accounts_by_id_get` in process, carrying `{"id": "8f3e…"}` as
/// its route values. This file is the matching; the table it matches against is
/// generated from the header (`fortuna_routes.dart`).
///
/// Kept free of `dart:ffi` on purpose. Resolving a route is ordinary string
/// work, and it is tested as such — the boundary rule in `IR-13` is about the
/// calls, not about knowing their names.
library;

import 'package:meta/meta.dart';

import 'fortuna_routes.dart';

/// One route the core serves, as the published header declares it.
@immutable
class CoreRoute {
  const CoreRoute(this.method, this.template, this.symbol);

  /// The HTTP method, upper case.
  final String method;

  /// The route as a template, e.g. `/api/transactions/{id}/tags/{tagId}`.
  final String template;

  /// The C symbol that serves it.
  final String symbol;

  /// The template split into segments, for matching.
  List<String> get segments => _split(template);

  @override
  String toString() => '$method $template → $symbol';
}

/// A request matched to the symbol that will serve it.
@immutable
class ResolvedRoute {
  const ResolvedRoute({required this.symbol, required this.values});

  final String symbol;

  /// The values the template's placeholders captured, e.g. `{'id': '8f3e…'}`.
  final Map<String, String> values;
}

List<String> _split(String path) {
  final withoutQuery = path.split('?').first;
  return [
    for (final segment in withoutQuery.split('/'))
      if (segment.isNotEmpty) segment,
  ];
}

/// Finds the core symbol serving [method] [path], or `null` where the core does
/// not export that route.
///
/// A `null` is not an error here — it is how "the core deliberately does not do
/// this offline" reaches the caller, which turns it into a clear refusal rather
/// than a crash. Heimdall's auth routes, Pluggy's connections and hosted
/// consent are all absent by design.
///
/// A literal segment always wins over a placeholder, so `/api/accounts/{id}`
/// and a hypothetical `/api/accounts/summary` cannot be confused for one
/// another regardless of which the generator listed first.
ResolvedRoute? resolveCoreRoute(
  String method, //
  String path, {
  List<CoreRoute> routes = coreRoutes,
}) {
  final wanted = method.toUpperCase();
  final actual = _split(path);

  ResolvedRoute? best;
  var bestLiterals = -1;

  for (final route in routes) {
    if (route.method != wanted) continue;

    final template = route.segments;
    if (template.length != actual.length) continue;

    final values = <String, String>{};
    var literals = 0;
    var matched = true;

    for (var i = 0; i < template.length; i++) {
      final expected = template[i];

      if (expected.startsWith('{') && expected.endsWith('}')) {
        values[expected.substring(1, expected.length - 1)] =
            Uri.decodeComponent(actual[i]);
        continue;
      }

      if (expected != actual[i]) {
        matched = false;
        break;
      }
      literals++;
    }

    if (matched && literals > bestLiterals) {
      best = ResolvedRoute(symbol: route.symbol, values: values);
      bestLiterals = literals;
    }
  }

  return best;
}
