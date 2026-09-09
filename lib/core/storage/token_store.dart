/// Token storage (IR-07, FR-SE-16, BR-16).
///
/// The session token is written **here and nowhere else**. Not in preferences,
/// not in a URL, not in application state that outlives the session. Every
/// other location is readable by something that should not read it.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Reads and writes the session token.
///
/// An interface rather than a concrete class so that tests substitute an
/// in-memory fake and never touch the platform's keychain.
abstract interface class TokenStore {
  /// The stored token, or `null` when none is stored.
  Future<String?> read();

  /// Stores [token], replacing any previous one.
  Future<void> write(String token);

  /// Removes the token. Called on sign-out and whenever a token is rejected
  /// (`FR-SE-19`, `FR-SE-21`).
  Future<void> clear();
}

/// The platform-backed implementation: Keystore on Android, DPAPI on Windows,
/// libsecret on Linux, and WebCrypto-encrypted local storage on the web.
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'fortuna.session.token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// An in-memory [TokenStore] for tests. Never used in production code.
class InMemoryTokenStore implements TokenStore {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}
