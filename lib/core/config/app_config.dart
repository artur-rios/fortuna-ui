/// Build-time configuration (IR-16, FR-CF-01).
///
/// Everything here arrives by `--dart-define`, which means it is compiled into
/// an artifact users can read. **No secret is ever configured this way** — the
/// values below are addresses and public identifiers. The session token is
/// obtained at run time and lives only in secure storage (`FR-SE-16`).
library;

import 'package:meta/meta.dart';

/// How this build reaches the Fortuna core (`FR-DA-02`).
enum Transport {
  /// Over HTTP, against a remote or self-hosted instance.
  http,

  /// In process, across the FFI boundary — desktop offline mode, Windows and
  /// Linux only.
  ffi,
}

/// The configuration this build was compiled with.
@immutable
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.googleClientId,
    required this.transport,
    required this.databasePath,
  });

  /// Reads the configuration from the values supplied at build time.
  ///
  /// An absent `FORTUNA_API_BASE_URL` reads as the empty string, which is not
  /// an error: it means this build names no default instance, and the
  /// application starts at the setup screen instead of failing (`UC-01`).
  factory AppConfig.fromEnvironment() => const AppConfig(
    apiBaseUrl: String.fromEnvironment('FORTUNA_API_BASE_URL'),
    googleClientId: String.fromEnvironment('FORTUNA_GOOGLE_CLIENT_ID'),
    transport: bool.fromEnvironment('FORTUNA_TRANSPORT_FFI')
        ? Transport.ffi
        : Transport.http,
    databasePath: String.fromEnvironment('FORTUNA_DB_PATH'),
  );

  /// The instance this build points at, or empty when it names none.
  final String apiBaseUrl;

  /// The Google client identifier. Public by nature; not a secret.
  final String googleClientId;

  /// Which transport this build was wired for.
  final Transport transport;

  /// Where the offline database lives, for an FFI build. Empty means "beside
  /// the executable", which is what makes the portable package portable.
  final String databasePath;

  /// Whether this build names a default instance.
  bool get hasDefaultInstance => apiBaseUrl.isNotEmpty;

  /// Whether Google sign-in can be offered (`AF-04` of `UC-05`).
  bool get supportsGoogleSignIn => googleClientId.isNotEmpty;

  /// Whether this build is wired for desktop offline mode.
  bool get isOffline => transport == Transport.ffi;
}
