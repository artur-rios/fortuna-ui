/// Fails the build when a boundary rule is broken (IR-13, IR-14).
///
/// Run by CI on every push and pull request:
///
/// ```bash
/// dart run tool/check_boundaries.dart
/// ```
///
/// Exits 0 when clean, 1 with an explanation per violation otherwise.
library;

import 'dart:io';

import 'boundary_rules.dart';

Future<void> main(List<String> arguments) async {
  final root = Directory(arguments.isEmpty ? 'lib' : arguments.first);

  if (!root.existsSync()) {
    stderr.writeln('No such directory: ${root.path}');
    exit(2);
  }

  final files = <SourceFile>[];
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;

    // Generated code is exempt: the bindings are produced from the core's
    // header and regenerated in CI (IR-12), which is a stronger guarantee than
    // this checker could give.
    if (entity.path.endsWith('_bindings.dart') ||
        entity.path.endsWith('.g.dart')) {
      continue;
    }

    files.add(SourceFile(entity.path, await entity.readAsString()));
  }

  final violations = checkBoundaries(files);

  if (violations.isEmpty) {
    stdout.writeln(
      'Boundaries clean: ${files.length} files checked against IR-13 and IR-14.',
    );
    return;
  }

  stderr.writeln('${violations.length} boundary violation(s):\n');
  for (final violation in violations) {
    stderr.writeln('$violation\n');
  }
  exit(1);
}
