/// Calendar dates on the wire (FR-DA-03, FR-MM-01).
///
/// The API types every date a request body carries — when a transaction
/// occurred, when a budget period starts, when a goal is due — as a calendar
/// date: OpenAPI `format: date`, a .NET `DateOnly`, which accepts exactly
/// `yyyy-MM-dd` and refuses anything with a time in it.
///
/// The generated client types such a property as the `String` the contract
/// carries, so the date the user picked is written in that shape by
/// [wireDate] where a request is built, and read back by [dateFromWire] —
/// the same local-midnight `DateTime` the rest of the application has always
/// worked with. A calendar date is never converted between zones: the day
/// kept is the day the `DateTime` itself holds.
///
/// [normalizeDateOnlyFields] is the older guard, kept for request bodies
/// built by hand as maps (the generated client sends its bodies already
/// encoded), so a `DateTime` written there with `toIso8601String()` —
/// `2026-10-09T00:00:00.000`, which the API rejects as unbindable — is still
/// put back into the contract's shape on the way out, for both transports at
/// once.
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

/// [date] as the contract writes a calendar date: `yyyy-MM-dd`.
///
/// The day kept is the one [date] itself holds — the day the user picked —
/// not that day converted to another zone.
String wireDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// [wireDate] for an optional date.
String? wireDateOrNull(DateTime? date) => date == null ? null : wireDate(date);

/// The calendar date the contract carries in [value], as midnight of that
/// day in the local zone, or `null` where there is none.
///
/// What the 1.x client produced for a `format: date` property, and what the
/// application's day arithmetic, grouping and formatting are written
/// against. A value that is not a date fails here as it failed there, with a
/// `FormatException` the repositories report as an unreadable answer.
DateTime? dateFromWire(String? value) =>
    value == null ? null : DateTime.parse(value);

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
