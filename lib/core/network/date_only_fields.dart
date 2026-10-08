/// Calendar dates on the wire (FR-DA-03, FR-MM-01).
///
/// The API types every date a request body carries — when a transaction
/// occurred, when a budget period starts, when a goal is due — as a calendar
/// date: OpenAPI `format: date`, a .NET `DateOnly`, which accepts exactly
/// `yyyy-MM-dd` and refuses anything with a time in it.
///
/// The generated client cannot express that. `swagger_parser` maps `date` and
/// `date-time` alike to `DateTime`, and the generated `toJson` writes every
/// `DateTime` with `toIso8601String()` — `2026-10-09T00:00:00.000` — which the
/// API rejects as unbindable, so every command carrying a date failed before
/// it was even validated. The offline core stored the same string as given,
/// so the two transports did not even fail alike.
///
/// Since the generated code is never hand-edited (BR-36), the date is put back
/// into the contract's shape here, on the way out, for both transports at once.
library;

/// Every request-body property the contract declares as `format: date`.
///
/// Kept in step with `api/fortuna.json` by a test that reads the document, so
/// taking a new API version that adds a date field fails the build here rather
/// than in production. No request body declares a `date-time` property under
/// any of these names, which the same test also checks — that is what makes
/// rewriting by name safe.
const dateOnlyRequestFields = <String>{
  'endsOn',
  'figureDate',
  'occurredOn',
  'paymentDate',
  'periodEnd',
  'periodStart',
  'purchasedOn',
  'rateDate',
  'requestedDate',
  'startsOn',
  'targetDate',
  'valuedOn',
};

final _isoDateTime = RegExp(r'^(\d{4}-\d{2}-\d{2})T');

/// [body] with every [dateOnlyRequestFields] value reduced to `yyyy-MM-dd`.
///
/// The date kept is the one the `DateTime` itself held — the day the user
/// picked — not that day converted to another zone. Anything that is not a
/// map, a list or such a field passes through untouched.
Object? normalizeDateOnlyFields(Object? body) => switch (body) {
  // The shape every generated `toJson` produces, kept as that type so nothing
  // downstream that reads the body as a JSON object is surprised.
  Map<String, dynamic>() => <String, dynamic>{
    for (final entry in body.entries)
      entry.key: _normalizeField(entry.key, entry.value),
  },
  Map<dynamic, dynamic>() => {
    for (final entry in body.entries)
      entry.key: _normalizeField(entry.key, entry.value),
  },
  List<dynamic>() => [for (final item in body) normalizeDateOnlyFields(item)],
  _ => body,
};

Object? _normalizeField(Object? key, Object? value) =>
    dateOnlyRequestFields.contains(key)
    ? _dateOnly(value)
    : normalizeDateOnlyFields(value);

Object? _dateOnly(Object? value) {
  if (value is DateTime) {
    return _dateOnly(value.toIso8601String());
  }
  if (value is String) {
    return _isoDateTime.firstMatch(value)?.group(1) ?? value;
  }
  return value;
}
