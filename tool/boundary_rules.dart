/// The two boundary rules, as data (IR-13, IR-14).
///
/// Separated from `check_boundaries.dart` so they can be tested against
/// fixtures rather than only against the real source tree — a checker nobody
/// has watched fail is a checker nobody knows works.
///
/// These are enforced by a build step rather than by a custom analyzer plugin.
/// A plugin would report them in the IDE, which is nicer, but it is a great deal
/// of machinery for two rules; this runs in CI, fails the build, and is fifty
/// lines. Worth revisiting if the rule set grows.
library;

/// One violation, with enough detail to fix it without re-running anything.
class BoundaryViolation {
  const BoundaryViolation({
    required this.rule,
    required this.path,
    required this.line,
    required this.source,
    required this.explanation,
  });

  /// The requirement this breaks, e.g. `IR-13`.
  final String rule;
  final String path;

  /// One-based, as an editor counts.
  final int line;

  /// The offending line, trimmed.
  final String source;
  final String explanation;

  @override
  String toString() => '$path:$line  [$rule]\n    $source\n    $explanation';
}

/// A source file to check: its repository-relative path and its contents.
class SourceFile {
  const SourceFile(this.path, this.contents);

  final String path;
  final String contents;
}

/// The directory that may import `dart:ffi`. Everything else may not.
const bindingsDirectory = 'lib/core/bindings/';

/// The file that defines the money type. It may not mention `double` at all.
const moneyFile = 'lib/core/format/money.dart';

/// Applies both rules to [files], returning every violation found.
List<BoundaryViolation> checkBoundaries(Iterable<SourceFile> files) {
  final violations = <BoundaryViolation>[];

  for (final file in files) {
    final normalized = file.path.replaceAll(r'\', '/');
    final lines = file.contents.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      if (trimmed.startsWith('//') || trimmed.startsWith('///')) continue;

      // IR-13 — dart:ffi is confined to the bindings layer.
      if (_importsFfi(trimmed) && !normalized.startsWith(bindingsDirectory)) {
        violations.add(
          BoundaryViolation(
            rule: 'IR-13',
            path: normalized,
            line: i + 1,
            source: trimmed,
            explanation:
                "dart:ffi belongs only under '$bindingsDirectory'. Everything "
                'above the data layer calls a repository, so that the FFI and '
                'HTTP transports stay interchangeable (BR-35).',
          ),
        );
      }

      // IR-14 — no monetary value is converted to or from a floating-point type.
      final floatUse = _floatingPointUse(trimmed);
      if (floatUse != null && _touchesMoney(normalized, file.contents)) {
        violations.add(
          BoundaryViolation(
            rule: 'IR-14',
            path: normalized,
            line: i + 1,
            source: trimmed,
            explanation:
                "'$floatUse' puts a monetary value through binary floating "
                'point. Money is an exact decimal end to end (BR-06); if this '
                'is a chart coordinate, derive it at the drawing layer and '
                'never read it back as a value (FR-CH-08).',
          ),
        );
      }
    }
  }

  return violations;
}

bool _importsFfi(String line) =>
    RegExp(r'''^import\s+['"]dart:ffi['"]''').hasMatch(line) ||
    RegExp(r'''^export\s+['"]dart:ffi['"]''').hasMatch(line);

/// The floating-point conversion on [line], or `null`.
String? _floatingPointUse(String line) {
  const patterns = [
    '.toDouble()',
    'double.parse(',
    'double.tryParse(',
    'as double',
  ];
  for (final pattern in patterns) {
    if (line.contains(pattern)) return pattern;
  }
  return null;
}

/// Whether this file is close enough to money for a float to be a defect.
///
/// The money type itself always counts; other files count when they actually
/// reference money or decimals. A float in a file with no monetary value in it
/// is not this rule's business — animation curves and layout fractions are
/// doubles, and rightly so.
bool _touchesMoney(String path, String contents) =>
    path == moneyFile ||
    contents.contains('package:decimal/decimal.dart') ||
    contents.contains('format/money.dart') ||
    contents.contains('Money(') ||
    contents.contains('Money.');
