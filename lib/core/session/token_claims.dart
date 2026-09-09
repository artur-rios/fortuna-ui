/// Reads the claims out of the session token (FR-SE-18, UC-11 AF-05).
///
/// **This does not verify the token, and must never be mistaken for doing so.**
/// The signature is checked by the API, which holds the key; this client has no
/// key and no business having one. The claims are read for one purpose only:
/// deciding what to *show*. Every action is still refused or permitted by the
/// API, which is what `FR-AD-07` means by hiding a control never being the
/// protection.
///
/// The vocabulary is the one the API's own identity mapper writes:
///
/// | Claim | Meaning |
/// | --- | --- |
/// | `id` | The subject — an opaque reference, never displayed as an identity |
/// | `role` | A **numeric** role id: 1 system admin, 2 scope admin, 3 user |
/// | `fortuna_local` | Present when this is a desktop local identity |
/// | `name` | An optional display name |
/// | `exp` | Expiry, seconds since the epoch |
library;

import 'dart:convert';

import 'package:meta/meta.dart';

import 'session.dart';

/// The claims carried by a session token, as far as the client cares.
@immutable
class TokenClaims {
  const TokenClaims({
    required this.subject,
    required this.role,
    required this.isLocal,
    this.displayName,
    this.expiresAt,
  });

  /// Parses [token] without verifying it.
  ///
  /// Returns `null` for anything that is not a well-formed token carrying a
  /// subject and a role this instance recognizes — which covers a malformed
  /// token, a truncated one, and `AF-05`'s token naming an unknown role. In
  /// every case the caller discards it and the user signs in again, so the
  /// three do not need telling apart.
  static TokenClaims? tryParse(String token) {
    final segments = token.split('.');
    if (segments.length != 3) return null;

    final Map<String, dynamic> payload;
    try {
      final normalized = base64Url.normalize(segments[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final parsed = jsonDecode(decoded);
      if (parsed is! Map<String, dynamic>) return null;
      payload = parsed;
    } on FormatException {
      return null;
    }

    final subject = payload['id'];
    if (subject is! String || subject.isEmpty) return null;

    final role = _roleFrom(payload['role']);
    if (role == null) return null;

    final expiry = payload['exp'];

    return TokenClaims(
      subject: subject,
      role: role,
      isLocal: _isLocal(payload['fortuna_local']),
      displayName: payload['name'] is String ? payload['name'] as String : null,
      expiresAt: expiry is int
          ? DateTime.fromMillisecondsSinceEpoch(expiry * 1000, isUtc: true)
          : null,
    );
  }

  final String subject;
  final Role role;

  /// Whether this is a desktop local identity rather than one the identity
  /// provider issued.
  final bool isLocal;

  final String? displayName;
  final DateTime? expiresAt;

  /// Whether the token has already expired by the client's clock.
  ///
  /// Advisory only: the API decides, and a client whose clock is wrong must not
  /// be able to grant itself a session by being optimistic — which is why a
  /// token that looks unexpired is still verified before it is trusted.
  bool get hasExpired =>
      expiresAt != null && DateTime.now().toUtc().isAfter(expiresAt!);

  /// Maps the API's numeric role id onto the two roles this client has.
  ///
  /// The API's own vocabulary has three: a system administrator and a scope
  /// administrator both administer, and neither may read a user's financial
  /// records — so both land on [Role.instanceAdministrator]. Anything else is
  /// unrecognized, and `AF-05` discards the token rather than guessing.
  static Role? _roleFrom(Object? raw) {
    final id = switch (raw) {
      final int value => value,
      final String value => int.tryParse(value),
      _ => null,
    };

    return switch (id) {
      1 || 2 => Role.instanceAdministrator,
      3 => Role.accountOwner,
      _ => null,
    };
  }

  static bool _isLocal(Object? raw) => switch (raw) {
    final bool value => value,
    final String value => value.toLowerCase() == 'true',
    _ => false,
  };
}
