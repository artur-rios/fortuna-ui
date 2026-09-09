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

const headerPath = 'native/include/fortuna_ffi.h';

Future<void> main() async {
  final header = File(headerPath);

  if (!header.existsSync()) {
    stderr
      ..writeln('Cannot generate bindings: $headerPath does not exist.\n')
      ..writeln('The header is published by the Fortuna core and vendored here')
      ..writeln('verbatim. It is blocked on:')
      ..writeln('  artur-rios/fortuna-api#156 — the C ABI and its header')
      ..writeln('  artur-rios/fortuna-api#157 — the offline operation surface')
      ..writeln('  artur-rios/fortuna-api#155 — the SQLite provider\n')
      ..writeln(
        'Until then this installation is HTTP-only, which is what every',
      )
      ..writeln('target except desktop offline mode uses anyway.');
    exit(1);
  }

  await _run('dart', ['run', 'ffigen', '--config', 'ffigen.yaml']);
  await _run('dart', ['format', 'lib/core/bindings']);

  stdout.writeln('\nBindings generated from $headerPath.');
  stdout.writeln('Do not hand-edit lib/core/bindings — regenerate.');
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
