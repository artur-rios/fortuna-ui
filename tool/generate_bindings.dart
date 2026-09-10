/// Generates the FFI bindings from the Fortuna core's C header (IR-10).
///
/// ```bash
/// dart run tool/generate_bindings.dart
/// ```
///
/// Refuses to run while the header is absent, with an explanation, rather than
/// emitting empty bindings that would compile and do nothing. An empty binding
/// layer is worse than a missing one: the first fails at run time in the
/// user's hands, the second fails here.
library;

import 'dart:io';

const headerPath = 'native/include/fortuna_core.h';

Future<void> main() async {
  final header = File(headerPath);

  if (!header.existsSync()) {
    stderr
      ..writeln('Cannot generate bindings: $headerPath does not exist.\n')
      ..writeln('The header is published by the Fortuna core and vendored here')
      ..writeln('verbatim. Copy it from fortuna-api:\n')
      ..writeln(
        '  cp ../fortuna-api/native/fortuna-core/include/fortuna_core.h \\',
      )
      ..writeln('     $headerPath\n')
      ..writeln(
        'Without it this installation is HTTP-only, which is what every',
      )
      ..writeln('target except desktop offline mode uses anyway.');
    exit(1);
  }

  await _run('dart', ['run', 'ffigen', '--config', 'ffigen.yaml']);
  _writeRouteTable(header.readAsStringSync());
  await _run('dart', ['format', 'lib/core/bindings']);

  stdout.writeln('\nBindings generated from $headerPath.');
  stdout.writeln('Route table generated from the same header.');
  stdout.writeln('Do not hand-edit lib/core/bindings — regenerate.');
}

/// Where the generated route table goes.
const routeTablePath = 'lib/core/bindings/fortuna_routes.dart';

/// One routed export, as the header declares it.
///
/// The header documents each generated export with the HTTP route it mirrors:
///
///     int fortuna_api_accounts_by_id_get(...); /* GET /api/accounts/{id} */
///
/// That comment is the only machine-readable link between a request the
/// application makes and the symbol that serves it offline, so the table is
/// derived from it rather than written by hand — a hand-written copy of 113
/// routes is a hand-written copy that goes stale.
final _routePattern = RegExp(
  r'^int\s+(fortuna_[a-z0-9_]+)\s*\([^)]*\)\s*;\s*/\*\s*'
  r'([A-Z]+)\s+(\S+)\s*\*/',
  multiLine: true,
);

void _writeRouteTable(String header) {
  final matches = _routePattern.allMatches(header).toList();

  if (matches.isEmpty) {
    stderr.writeln('No routed exports found in $headerPath — refusing to');
    stderr.writeln('write an empty route table, which would compile and');
    stderr.writeln('resolve nothing at run time.');
    exit(1);
  }

  final entries = [
    for (final match in matches)
      "  CoreRoute('${match.group(2)}', '${match.group(3)}', "
          "'${match.group(1)}'),",
  ]..sort();

  File(routeTablePath).writeAsStringSync('''
// GENERATED — DO NOT EDIT.
//
// Produced by `dart run tool/generate_bindings.dart` from the route comments in
// the Fortuna core's published C header. A route that is wrong here is a route
// that is wrong in the header: fix it at the source in fortuna-api and
// regenerate (BR-36, FR-DA-05).

import 'core_route.dart';

/// Every HTTP route the core serves offline, and the symbol that serves it.
///
/// Routes the core deliberately does not export — Heimdall's `/api/auth/**`,
/// Pluggy's connections, hosted consent, the HTTP host's own health checks —
/// are simply absent, which is what makes an offline call to one of them a
/// clean "not available offline" rather than a crash.
const coreRoutes = <CoreRoute>[
${entries.join('\n')}
];
''');

  stdout.writeln('Wrote \${matches.length} routes to \$routeTablePath.');
}

Future<void> _run(String executable, List<String> arguments) async {
  stdout.writeln('\$ $executable ${arguments.join(' ')}');

  final process = await Process.start(
    executable,
    arguments,
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );

  final code = await process.exitCode;
  if (code != 0) {
    stderr.writeln('\n$executable ${arguments.join(' ')} failed with $code.');
    exit(code);
  }
}
