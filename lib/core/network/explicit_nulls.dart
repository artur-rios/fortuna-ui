/// The explicit nulls of an update.
///
/// An update is a `PUT` of the whole record, and the two transports read a
/// key the body leaves out differently. The online API binds it as null, the
/// same as a key sent as null. The offline core merges the body into the
/// record it stores (`fortuna-core`, `update_with`), so a key left out keeps
/// the stored value there, and only an explicit null clears it: a description
/// emptied, a counterparty or a parent category removed, a transaction moved
/// from an account to a card.
///
/// The 1.x client wrote every key of every body, nulls included. The 2.x one
/// leaves a null out (`swagger_parser.yaml` says why it is not asked to do
/// otherwise), so every `PUT` body is given back, here, the explicit nulls the
/// contract allows it — on the way out, for both transports at once, as
/// `date_only_fields.dart` does for calendar dates.
library;

/// Every optional nullable property of each `PUT` body the contract declares,
/// by the route's path template.
///
/// Kept in step with `api/fortuna.json` by a test that reads the document, so
/// taking a new API version that adds a property to an update, or a new
/// update, fails the build here rather than leaving that property uncleared
/// offline.
const explicitNullRequestFields = <String, Set<String>>{
  '/api/accounts/{id}': {
    'currencyCode',
    'institution',
    'name',
    'openingBalance',
    'ownerId',
  },
  '/api/budgets/{id}': {'categoryIds', 'currencyCode'},
  '/api/categories/{id}': {'name', 'parentId'},
  '/api/counterparties/{id}': {'name'},
  '/api/credit-cards/{id}': {'currencyCode', 'issuer', 'name'},
  '/api/goals/{id}': {'accountIds', 'currencyCode', 'investmentIds', 'name'},
  '/api/investments/{id}': {'currencyCode', 'institution', 'instrument'},
  '/api/recurring-transactions/{id}': {
    'counterparty',
    'creditCardId',
    'description',
    'endsOn',
    'financialAccountId',
    'ownerId',
  },
  '/api/tags/{id}': {'name'},
  '/api/transactions/{id}': {
    'counterparty',
    'creditCardId',
    'currencyCode',
    'description',
    'financialAccountId',
    'ownerId',
    'tags',
  },
};

final _routes = [
  for (final MapEntry(key: template, value: fields)
      in explicitNullRequestFields.entries)
    (pattern: _patternOf(template), fields: fields),
];

final _pathParameter = RegExp(r'\{[^}]+\}');

/// [template] as a pattern its concrete paths match: `/api/tags/{id}` matches
/// `/api/tags/` followed by one path segment.
RegExp _patternOf(String template) {
  final literals = template.split(_pathParameter).map(RegExp.escape);
  return RegExp('^${literals.join('[^/]+')}\$');
}

/// [body] with every [explicitNullRequestFields] key of the route it is sent
/// to that it leaves out written as null, when it is a `PUT` body; otherwise
/// [body] untouched.
///
/// [path] is the route as the generated clients write it
/// (`/api/transactions/3f…`), relative to the base address. A key [body]
/// already carries keeps its value.
Object? withExplicitNulls(String method, String path, Object? body) {
  if (method.toUpperCase() != 'PUT' || body is! Map<String, dynamic>) {
    return body;
  }
  for (final route in _routes) {
    if (route.pattern.hasMatch(path)) {
      return <String, dynamic>{
        for (final field in route.fields) field: null,
        ...body,
      };
    }
  }
  return body;
}
