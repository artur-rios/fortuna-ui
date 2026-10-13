# Self-Service Sign-Up — Design

**Date:** 2026-10-12
**Status:** Approved design, awaiting implementation plan
**Repositories:** heimdall-api, fortuna-api, fortuna-ui

## 1. Intent

A person new to a Fortuna instance can create an account from the sign-in screen without an
administrator, either with Google or with a name, email address and password.

Today the sign-in screen offers neither. Google sign-up exists (`UC-05`: a first Google sign-in
creates the account) but nothing on the screen says so, and credential sign-up does not exist in any
of the three services.

### Success criteria

1. The sign-in screen links to a sign-up screen in connected and self-hosted modes.
2. The sign-up screen offers "Continue with Google" where the build has a Google client configured,
   using the existing `UC-05` exchange unchanged.
3. The sign-up screen accepts name, email and password and, on success, tells the user to check their
   email and then sign in.
4. Whether an address is already registered cannot be learned from the sign-up response — not from its
   status, its body, or its timing — nor from signing in afterwards. No account exists, and so nothing can
   sign in, until the holder of the address follows the emailed link.
5. An instance that has not opened registration refuses it plainly.

### Out of scope

- Signing the user in automatically after a credential sign-up (ruled out by criterion 4).
- A public capabilities endpoint telling the client in advance whether registration is open
  (YAGNI: the 403 answers the same question at the moment it matters).
- CAPTCHA or other bot detection beyond the existing anonymous-auth rate limits.
- Desktop offline mode, which already creates its local account through `UC-06`.

## 2. Context

| Fact | Where |
| --- | --- |
| fortuna-api owns no Heimdall users or passwords; every `/api/auth/*` route forwards to Heimdall through `IHeimdallAuthGateway`, identifying Fortuna only by the configured scope GUID | `fortuna-api` `AuthController.cs`, `HeimdallAuthGateway.cs`, `FortunaOptions.cs` |
| Heimdall's only password-user creation is `POST /api/scopes/{scopeId}/persons`, ScopeAdmin/SystemAdmin only | `heimdall-api` `PersonController.cs`, `CreateUserCommandHandler.cs` |
| `CreateUserCommand` rules: name required, ≤ 200 chars; email required, valid; password required, ≥ 8 chars. Email unique per scope, case-insensitive, across password and Google users. Sends a verification email. Assigns `Roles.User`. Returns no token | `CreateUserCommandValidator.cs`, `CreateUserCommandHandler.cs` |
| Google sign-up is gated per scope by `Scope.GoogleSignInEnabled` (default `false`), toggled by `SetGoogleSignInCommandHandler` | `FR-GO-01` … `FR-GO-03` |
| Heimdall login hides account existence, including by verifying against a decoy hash (`AF-11a`) | `LoginCommandHandler.cs` |
| Heimdall password recovery keeps address-dependent work off the request path through a background queue, because a synchronous send made registered addresses measurably slower | `PasswordRecoveryProcessor.cs`, `PasswordRecoveryQueue.cs` |
| fortuna-api creates the Fortuna `UserProfile` on the first authenticated request, not during sign-in | `UserProfileProvisioningMiddleware.cs`, `EfUserProfileStore.cs` |
| fortuna-ui shows the API's message for every sign-in rejection without distinguishing causes the API made indistinguishable | `FR-SE-23` |

## 3. Decisions

| Decision | Chosen | Rejected, and why |
| --- | --- | --- |
| Who creates the Heimdall user | Heimdall gains anonymous self-registration, gated per scope | fortuna-api holding a ScopeAdmin credential: an anonymous endpoint backed by a privileged secret to store and rotate, with a larger blast radius on leak |
| Response to a sign-up | Always `202` with one fixed message; no session | Immediate sign-in: forces a distinguishable "already registered" answer |
| Default for the new flag | `false` — existing scopes stay closed | `true`: silently opens every existing scope |
| A closed scope | `403` with a plain message | Disguising it as `202`: it reveals nothing about any address, and a user waiting for an email that will never come is worse |
| When the account comes into existence | When the emailed link is followed: registration writes a *pending* row, confirmation creates a verified `User` (amended 2026-10-12 after the final review of the Heimdall branch) | Creating an unverified `User` at registration: Heimdall's login issues a token regardless of `EmailVerified`, so register-then-sign-in revealed whether an address was taken, and anyone could hold a usable account on someone else's unused address. Refusing unverified sign-in instead: touches UC-11, and leaves the real owner of a squatted address holding an account with the squatter's password |

## 4. heimdall-api

**Proposed use case:** `UC-47: Register a Password User` (next free number). **Proposed requirements:**
a new `FR-SR` (self-registration) group.

### 4.1 Domain and data

- `Scope.SelfRegistrationEnabled : bool`, mapped with `HasDefaultValue(false)` in `ScopeDbMap`, added by
  a new migration.
- Exposed on `ScopeOutput`, `CreateScopeCommandOutput`, `UpdateScopeCommandOutput` alongside
  `GoogleSignInEnabled`.

### 4.2 Toggling the flag

`PUT /api/scopes/{id}/self-registration` with `SetSelfRegistrationCommand { Enabled: bool? }` — a copy of
`SetGoogleSignInCommand` and its handler: SystemAdmin, or a ScopeAdmin owning the scope; returns the
updated scope; audited.

### 4.3 Registering

`POST /api/auth/register` — `[AllowAnonymous]`, `[EnableRateLimiting(Startup.AuthEndpointRateLimitPolicy)]`.

**Request** `RegisterCommand { Name, Email, Password, ScopeId }`.

**Validation** (`RegisterCommandValidator`): the `CreateUserCommand` rules for name, email and password,
plus `ScopeId` required. The rules are shared, not copied, so the two cannot drift.

**Off the request path.** This follows the existing `UC-12` password-recovery pattern
(`IPasswordRecoveryQueue` → `PasswordRecoveryQueue` bounded `Channel` → `PasswordRecoveryDispatcher` →
`PasswordRecoveryProcessor`, one DI scope per item). Anything whose cost depends on whether the address is
taken — the lookup, the insert, the email — runs after the caller has their answer, so the request path
does identical work for every address.

**Handler** (`RegisterCommandHandler`) — the request path:

1. Load the scope. Missing, deleted, or `SelfRegistrationEnabled == false` → **403** with
   *"This instance is not accepting new accounts."* This depends only on the scope, never on the address.
2. Normalize the email (trim; comparisons case-insensitive, as `CreateUserCommandHandler` does).
3. Hash and salt the password. The plaintext never enters the queue.
4. Enqueue `RegistrationRequest { ScopeId, Name, Email, PasswordHash, PasswordSalt }` on
   `IRegistrationQueue`.
5. Answer **202** with
   *"If this address can be registered, we've sent it an email. Follow it, then sign in."*

**Processor** (`RegistrationProcessor`, run by `RegistrationDispatcher`) — after the response:

- **Address free:** write a `PendingRegistration` (scope, name, email, the queued hash and salt, the
  SHA-256 of a fresh 48-character token, an expiry of `EmailVerificationOptions.TokenLifetime`) and mail the
  token through `IEmailVerificationSender` — the same link a verification email carries. **No `Person` is
  created**, so signing in before confirming answers exactly as a wrong password does (UC-11 AF-11a).
  Several pending rows may exist for one address; each is independent until one is confirmed.
- **Address taken** (live password person or Google user in this scope): create nothing; send the new
  *registration-attempt* email to the existing owner — unless the holder's processing is restricted, or the
  Google holder is logically deleted (it could not sign in to act on the notice).
- Failures are logged with fixed, address-free messages; the caller already has their answer.

### 4.3a Confirming

`POST /api/auth/verify-email` (UC-14) is unchanged on the wire. When the presented token matches no
`EmailVerificationToken`, the handler looks for a `PendingRegistration` with that token hash:

1. None → `TokenInvalid` (as today). Expired → `TokenExpired`.
2. Claim it by deleting the row; if another request already deleted it → `TokenAlreadyUsed`.
3. The scope must still exist and be open, and the address must still be free (live person or Google user
   in the scope) → otherwise `TokenInvalid`.
4. Create the `User`: `Roles.User`, **`EmailVerified = true`**, the pending hash and salt, membership,
   legal basis (NFR-23). A unique violation (two instances confirming one address) → `TokenInvalid`.
5. Delete every other pending row for that scope and address, then answer `EmailVerifiedSuccessfully`.

Expired pending rows are removed by the existing `PurgeExpiredTokens` pass, with the same grace period.

Residual risk, documented in the Threat Model: someone who registers another person's free address chooses
the password; if that person follows a link they never asked for, the account they create has a password
they do not know. The email says plainly that ignoring it creates nothing.

**Registration-attempt email.** New template. Says someone tried to create an account with this address
on this instance; if it was them, sign in — with password reset if they have a password, or with Google if
the account is a Google one; if it was not them, nothing has changed and nothing is needed.

**Audit.** The request is recorded as other auth commands are. The processor may record which branch ran;
the response may not.

### 4.4 Errors

| Condition | Status | Body |
| --- | --- | --- |
| Validation failure | 400 | The validator's messages |
| Scope missing, deleted or closed | 403 | *"This instance is not accepting new accounts."* |
| Rate limit | 429 | The existing policy's answer |
| Address free or taken | 202 | The fixed message above |

### 4.5 Tests

- Handler: scope missing, deleted, closed → 403 and nothing queued; open scope → 202 and exactly one
  request queued, carrying a hash and no plaintext; identical response for any address.
- Processor: address free (pending row written with a token hash and expiry, link mailed, no person
  created); taken by a password person; taken by a Google user (registration-attempt email, nothing written);
  email case variants count as taken; persistence failure logged, not thrown.
- Confirmation: valid pending token creates a verified `User` and clears the address's other pending rows;
  unknown, expired, already-claimed tokens; scope closed or address taken in the meantime; unique-violation
  race; signing in before confirmation answers 401 like a wrong password, and after it succeeds.
- Validator: each field's boundary (name 200/201, password 7/8, malformed email, missing scope).
- Toggle: SystemAdmin, owning ScopeAdmin, non-owning ScopeAdmin refused, `Enabled` missing refused.
- WebApi: anonymous access, the status table above, the rate-limit policy is applied.

## 5. fortuna-api

**Proposed use case:** `UC-81: Register Through the Fortuna API`. **Proposed requirements:** `FR-ID-45`
onward, mirroring `FR-ID-18` (proxy with the configured scope identifier).

- **Command:** `RegisterThroughApiCommand { Name, Email, Password }` in `HeimdallAuthCommands.cs`.
- **Output:** `RegisterThroughApiCommandOutput { Message }` in `HeimdallAuthCommandOutputs.cs`.
- **Validator:** in `HeimdallAuthCommandValidators.cs`, the same rules as Heimdall's — rejecting early
  saves a round trip, but Heimdall stays authoritative.
- **Gateway:** `IHeimdallAuthGateway.RegisterAsync(name, email, password, scopeId)` posting
  `{name, email, password, scopeId}` to Heimdall's `api/auth/register`, with outcomes
  `Accepted | Invalid(messages) | Closed(message) | Unavailable` added to the existing outcome enum and
  result records.
- **Handler:** `RegisterThroughApiCommandHandler` — trims the email, calls the gateway with
  `HeimdallAuthOptions.ScopeId`, maps outcomes through the shared `Failure<T>`. Registered with
  `AddAuditedCommandHandler<…>` in `FortunaCommandsServiceCollectionExtensions.cs`.
- **Controller:** `POST /api/auth/register` on `AuthController`, `[AllowAnonymous]`, `"AuthAnonymous"`
  rate limit, status map `202 / 400 / 403 / 503`.
- **Provisioning:** none added. The profile is created by `UserProfileProvisioningMiddleware` on the
  first authenticated request after the user signs in.
- **Contract:** regenerate with `scripts/openapi.py`; `check-openapi.yml` must pass.

**Tests:** handler (each outcome, email trimmed, scope id from options); gateway with a fake
`HttpMessageHandler` (request shape, each Heimdall status mapped, timeout → unavailable); WebApi proxy test
with the `StubGateway` (anonymous, status map, rate-limit policy).

## 6. fortuna-ui

**Proposed use case:** `UC-47: Sign Up` (next free number). **Proposed requirements:** `FR-SE-24` onward.

### 6.1 Routing

- `Routes.signUp = '/sign-up'`, added to `Routes.anonymous`.
- `GoRoute(path: Routes.signUp, builder: … SignUpScreen())` in `router.dart`.
- No change to `resolveRedirect`: anonymous membership already admits it signed out and sends a signed-in
  user home.

### 6.2 Data and state

- `lib/features/auth/data/registration_repository.dart` — `RegistrationRepository.register({name, email,
  password}) → Result<String>` (the API's message), `HttpRegistrationRepository` over the regenerated
  `AuthClient.postApiAuthRegister`, failures through `failureFromDioException`. Provider
  `registrationRepositoryProvider`.
- `lib/features/auth/state/sign_up_controller.dart` — sealed state: `SignUpIdle`, `SignUpBusy`,
  `SignUpAccepted(message)`, `SignUpRefused(message)`, `SignUpUnreachable(message)`. `submit`, `reset`.
  The password is passed through and never held in state.
- Google on this screen calls the existing `signInControllerProvider.notifier.signInWithGoogle` — the
  `UC-05` exchange, unchanged. Success routes onward through the guard as it does from sign-in.

### 6.3 Screen

`lib/features/auth/ui/sign_up_screen.dart`, laid out like `SignInScreen` (centred, max width 420):

- Heading *"Create an account"*.
- Fields: name, email, password with reveal toggle. Keys `signUp.name`, `signUp.email`,
  `signUp.password`, `signUp.reveal`.
- Client-side checks mirroring Heimdall: all required, name ≤ 200, email shape, password ≥ 8. Shown
  inline; the API remains authoritative.
- `FilledButton` *"Create account"* (`signUp.submit`), spinner while busy.
- Where Google is configured: the "or" divider and *"Continue with Google"* (`signUp.google`).
- On `SignUpRefused` / `SignUpUnreachable`: the API's message in the error notice; retry offered only for
  unreachable.
- On `SignUpAccepted`: the form is replaced by the API's message and a *"Back to sign in"* button
  (`signUp.done`) going to `Routes.signIn`.
- *"Already have an account? Sign in"* (`signUp.signIn`).
- Fields cleared before dispose, as on sign-in.

`SignInScreen` gains *"New to Fortuna? Create an account"* (`signIn.signUp`) under the recovery link,
pushing `Routes.signUp`. `LocalSignInScreen` is unchanged.

### 6.4 Client

Copy fortuna-api's `docs/openapi/fortuna.json` to `api/fortuna.json` and run
`dart run tool/generate_api_client.dart`; `check-generated.yml` must pass.

### 6.5 Tests

- Widget: sign-in shows the sign-up link and it navigates; sign-up renders all fields; Google button only
  when configured; inline validation; busy state disables input; accepted replaces the form; refused and
  unreachable show the API's message, retry only for unreachable; fields cleared on dispose.
- Controller: each repository outcome to each state.
- Repository: request mapping and failure mapping with a fake client.
- Route guard: `/sign-up` admitted signed out; a signed-in user on `/sign-up` is sent to their home.

## 7. Delivery

Three `feature/self-service-sign-up` branches and three pull requests into `develop`, merged in order —
each consumes the previous one's contract:

1. **heimdall-api** — flag, toggle, register endpoint, email template, docs (`UC-47`, `FR-SR-*`).
2. **fortuna-api** — gateway, command, endpoint, OpenAPI, docs (`UC-81`, `FR-ID-45+`).
3. **fortuna-ui** — contract copy, regenerated client, route, screen, sign-in link, docs (`UC-47`,
   `FR-SE-24+`), README backlog.

Operationally, Fortuna's Heimdall scope must have `SelfRegistrationEnabled` switched on through the new
toggle before credential sign-up works on an instance; until then the screen shows the 403 message and
Google sign-up still works.
