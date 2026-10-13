# Self-Service Sign-Up — Plan 2 of 3: fortuna-api

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Proxy Heimdall's new `POST /api/auth/register` through Fortuna, with Fortuna's configured scope attached, so the UI can register an account.

**Architecture:** Same shape as every other `/api/auth/*` route. `AuthController.Register` sends `RegisterThroughApiCommand` through the mediator to `RegisterThroughApiCommandHandler`. The handler calls a new `IHeimdallAuthGateway.RegisterAsync`, which posts `{name, email, password, scopeId}` to Heimdall. Heimdall's `403` means "registration closed" on this route only, so the gateway gains a `Closed` outcome that only `RegisterAsync` produces. No Fortuna data is written: `UserProfileProvisioningMiddleware` creates the profile on the user's first authenticated request.

**Tech Stack:** .NET 10, ASP.NET Core, ArturRios.Mediator, FluentValidation, xUnit + `ArturRios.Util.Test` (`[UnitFact]`, `[FunctionalFact]`), `WebApplicationFactory`.

**Spec:** `D:\Repositories\fortuna-ui\docs\superpowers\specs\2026-10-12-self-service-sign-up-design.md` (§5).

**Repository:** `D:\Repositories\fortuna-api`. Every path below is relative to it.

**Depends on:** Plan 1 (heimdall-api) merged, or at least its contract fixed: `POST /api/auth/register` → `202` with `data: {}`; `403` when closed; `400` when malformed.

## Global Constraints

- Branch: `feature/self-service-sign-up` from an up-to-date `develop`.
- Commit subjects: lowercase Conventional Commits, ≤ 50 chars, imperative; end every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Test names: `GivenX_WhenY_ThenZ`, with `[UnitFact]` or `[FunctionalFact]`. Run with `-m:1` like the rest of the suite.
- Statuses: success **`202`**; closed **`403`**; malformed **`400`**; Heimdall unreachable **`503`**.
- Messages, verbatim: `RegistrationRequested = "If this address can be registered, we've sent it an email. Follow it, then sign in."`, `RegistrationUnavailable = "This instance is not accepting new accounts."`
- Field rules match Heimdall: name required, ≤ 200; email required, valid; password required, ≥ 8.
- The password is never logged, echoed or stored by Fortuna.
- The Heimdall-side `403` for *other* routes keeps mapping to `Rejected`. Only `RegisterAsync` maps it to `Closed`.
- Use case: **UC-81: Register through the Fortuna API**. Requirements: **FR-ID-45 … FR-ID-47**.

## Review Focus

1. **Heimdall `403` on an existing route** (e.g. Google sign-in with the setting off) must still be `Rejected` → `401`, not the new `Closed`. Pinned in Task 1.
2. **Heimdall answering `429`** (its own limiter) — surfaces as `503`, never as a success. Pinned in Task 1.
3. **Name or email with surrounding whitespace** — trimmed before forwarding; the password is not. Pinned in Task 2.
4. **A malformed request** — `400` with the field message, and Heimdall is never called. Pinned in Task 3.
5. **The eleventh request in a minute from one address** — `429`, the shared `AuthAnonymous` limit. Pinned in Task 3.

---

### Task 1: Gateway — `RegisterAsync` and the `Closed` outcome

**Files:**
- Modify: `src/Application/ArturRios.Fortuna.Shared/Security/IHeimdallAuthGateway.cs`
- Modify: `src/Infrastructure/ArturRios.Fortuna.Integration/Security/HeimdallAuthGateway.cs`
- Modify (stubs must implement the new member): `tests/Application/ArturRios.Fortuna.Command.Tests/HeimdallAuthCommandHandlerTests.cs`, `tests/Application/ArturRios.Fortuna.Command.Tests/HeimdallCredentialCommandHandlerTests.cs`, `tests/Presentation/ArturRios.Fortuna.WebApi.Tests/HeimdallAuthProxyTests.cs`
- Test: `tests/Infrastructure/ArturRios.Fortuna.Integration.Tests/HeimdallAuthGatewayTests.cs`

**Interfaces:**
- Produces: `HeimdallAuthOutcome.Closed = 6`; `Task<HeimdallAuthResult<object>> RegisterAsync(string name, string email, string password, Guid scopeId, CancellationToken cancellationToken)`.

- [ ] **Step 1: Write the failing gateway tests**

Add to `HeimdallAuthGatewayTests` (after `GivenPasswordRecovery_WhenForwarded_ThenConfiguredScopeIsAttached`):

```csharp
    [UnitFact]
    public async Task GivenRegistration_WhenForwarded_ThenExactShapeAndConfiguredScopeAreUsed()
    {
        var handler = new RecordingHandler(_ => Json(HttpStatusCode.Accepted, "{\"data\":{}}"));

        var result = await Gateway(handler).RegisterAsync(
            "New Person", "new@example.test", "a-long-secret", ScopeId, CancellationToken.None);

        Assert.Equal(HeimdallAuthOutcome.Succeeded, result.Outcome);
        Assert.Equal("/api/auth/register", handler.Path);
        Assert.Equal(HttpMethod.Post, handler.Method);
        Assert.Contains("\"name\":\"New Person\"", handler.Body, StringComparison.Ordinal);
        Assert.Contains("\"email\":\"new@example.test\"", handler.Body, StringComparison.Ordinal);
        Assert.Contains("\"password\":\"a-long-secret\"", handler.Body, StringComparison.Ordinal);
        Assert.Contains($"\"scopeId\":\"{ScopeId}\"", handler.Body, StringComparison.OrdinalIgnoreCase);
        Assert.Null(handler.Authorization);
    }

    [UnitTheory]
    [InlineData(HttpStatusCode.Forbidden, HeimdallAuthOutcome.Closed)]
    [InlineData(HttpStatusCode.BadRequest, HeimdallAuthOutcome.InvalidRequest)]
    [InlineData(HttpStatusCode.TooManyRequests, HeimdallAuthOutcome.Unavailable)]
    [InlineData(HttpStatusCode.InternalServerError, HeimdallAuthOutcome.Unavailable)]
    public async Task GivenHeimdallRefusesARegistration_WhenForwarded_ThenTheOutcomeIsMapped(
        HttpStatusCode status, HeimdallAuthOutcome expected)
    {
        var handler = new RecordingHandler(_ => Json(status, "{\"errors\":[\"upstream\"]}"));

        var result = await Gateway(handler).RegisterAsync(
            "New Person", "new@example.test", "a-long-secret", ScopeId, CancellationToken.None);

        Assert.Equal(expected, result.Outcome);
    }

    [UnitFact]
    public async Task GivenForbiddenOnGoogleSignIn_WhenForwarded_ThenItIsStillRejectedNotClosed()
    {
        var handler = new RecordingHandler(_ => Json(HttpStatusCode.Forbidden, "{\"errors\":[\"off\"]}"));

        var result = await Gateway(handler).GoogleSignInAsync("id-token", ScopeId, CancellationToken.None);

        Assert.Equal(HeimdallAuthOutcome.Rejected, result.Outcome);
    }

    [UnitFact]
    public async Task GivenARegistrationThatFails_WhenLogged_ThenThePasswordIsNotWritten()
    {
        var logger = new ListLogger();
        var gateway = new HeimdallAuthGateway(
            new HttpClient(new RecordingHandler(_ => Json(HttpStatusCode.InternalServerError, "{}")))
            {
                BaseAddress = new Uri("https://heimdall.example.test/")
            },
            logger);

        await gateway.RegisterAsync(
            "New Person", "new@example.test", "a-long-secret", ScopeId, CancellationToken.None);
        var log = string.Join(' ', logger.Messages);

        Assert.DoesNotContain("a-long-secret", log, StringComparison.Ordinal);
        Assert.DoesNotContain("new@example.test", log, StringComparison.Ordinal);
    }
```

- [ ] **Step 2: Run them to verify they fail**

Run: `dotnet test tests/Infrastructure/ArturRios.Fortuna.Integration.Tests -m:1 --filter "FullyQualifiedName~HeimdallAuthGatewayTests"`
Expected: build FAILS — `RegisterAsync` and `HeimdallAuthOutcome.Closed` do not exist.

- [ ] **Step 3: Extend the interface**

In `IHeimdallAuthGateway.cs`, add after `RequestPasswordRecoveryAsync`:

```csharp
    /// <summary>
    ///     Asks Heimdall to register a password user in <paramref name="scopeId" /> (UC-81). Succeeds
    ///     identically for a free and a taken address; <see cref="HeimdallAuthOutcome.Closed" /> when the
    ///     scope does not accept registrations.
    /// </summary>
    Task<HeimdallAuthResult<object>> RegisterAsync(
        string name,
        string email,
        string password,
        Guid scopeId,
        CancellationToken cancellationToken);
```

and extend the enum:

```csharp
public enum HeimdallAuthOutcome
{
    Succeeded = 1,
    InvalidRequest = 2,
    Rejected = 3,
    Unavailable = 4,
    NotFound = 5,

    /// <summary>The scope does not accept self-registration. Only <c>RegisterAsync</c> produces it.</summary>
    Closed = 6
}
```

- [ ] **Step 4: Implement it in the gateway**

In `HeimdallAuthGateway.cs`, add after `RequestPasswordRecoveryAsync`:

```csharp
    public Task<HeimdallAuthResult<object>> RegisterAsync(
        string name, string email, string password, Guid scopeId, CancellationToken cancellationToken) =>
        SendAsync<object, object>(HttpMethod.Post,
            "api/auth/register", new { name, email, password, scopeId }, null, cancellationToken,
            forbidden: HeimdallAuthOutcome.Closed);
```

Give `SendAsync` an optional last parameter and use it for `403` only:

```csharp
    private async Task<HeimdallAuthResult<TResponse>> SendAsync<TRequest, TResponse>(
        HttpMethod method,
        string path,
        TRequest? payload,
        string? bearerToken,
        CancellationToken cancellationToken,
        HeimdallAuthOutcome forbidden = HeimdallAuthOutcome.Rejected)
        where TResponse : class
```

and replace the status switch with:

```csharp
            return response.StatusCode switch
            {
                HttpStatusCode.BadRequest => new(HeimdallAuthOutcome.InvalidRequest),
                HttpStatusCode.NotFound => new(HeimdallAuthOutcome.NotFound),
                HttpStatusCode.Unauthorized => new(HeimdallAuthOutcome.Rejected),
                // A refusal on most routes; on registration, a scope that is closed to it (UC-81).
                HttpStatusCode.Forbidden => new(forbidden),
                _ => new(HeimdallAuthOutcome.Unavailable)
            };
```

- [ ] **Step 5: Make the three test stubs implement the new member**

In `HeimdallAuthCommandHandlerTests.StubGateway`, add these properties next to the others, and the method:

```csharp
        public HeimdallAuthResult<object> RegisterResult { get; init; } =
            new(HeimdallAuthOutcome.Rejected);
        public (string Name, string Email, string Password, Guid ScopeId)? RegisterRequest { get; private set; }

        public Task<HeimdallAuthResult<object>> RegisterAsync(
            string name, string email, string password, Guid scopeId, CancellationToken cancellationToken)
        {
            RegisterRequest = (name, email, password, scopeId);

            return Task.FromResult(RegisterResult);
        }
```

In `HeimdallCredentialCommandHandlerTests.StubGateway`, add:

```csharp
        public Task<HeimdallAuthResult<object>> RegisterAsync(
            string name, string email, string password, Guid scopeId, CancellationToken cancellationToken) =>
            Task.FromResult(new HeimdallAuthResult<object>(HeimdallAuthOutcome.Rejected));
```

In `HeimdallAuthProxyTests.StubGateway`, add next to `RecoveryRequest` / `RecoveryCalls`:

```csharp
        public HeimdallAuthResult<object> RegisterResult { get; init; } =
            new(HeimdallAuthOutcome.Rejected);
        public (string Name, string Email, Guid ScopeId)? RegisterRequest { get; private set; }
        public int RegisterCalls { get; private set; }

        public Task<HeimdallAuthResult<object>> RegisterAsync(
            string name, string email, string password, Guid scopeId, CancellationToken cancellationToken)
        {
            RegisterCalls++;
            RegisterRequest = (name, email, scopeId);

            return Task.FromResult(RegisterResult);
        }
```

- [ ] **Step 6: Run the gateway tests and the whole unit suite**

Run: `dotnet test tests/Infrastructure/ArturRios.Fortuna.Integration.Tests -m:1 --filter "FullyQualifiedName~HeimdallAuthGatewayTests"`
Expected: all pass, including the existing ones (the `403` → `Rejected` mapping is unchanged for them).

Run: `dotnet test src/ArturRios.Fortuna.sln -m:1 --filter "Category=Unit"`
Expected: all pass.

- [ ] **Step 7: Commit**

```bash
git add src tests
git commit -m "feat: forward registrations to heimdall" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Command, validator and handler

**Files:**
- Modify: `src/Application/ArturRios.Fortuna.Command/Input/HeimdallAuthCommands.cs`
- Modify: `src/Application/ArturRios.Fortuna.Command/Output/HeimdallAuthCommandOutputs.cs`
- Modify: `src/Application/ArturRios.Fortuna.Command/Input/Validation/HeimdallAuthCommandValidators.cs`
- Modify: `src/Application/ArturRios.Fortuna.Command/Handlers/HeimdallAuthCommandHandlers.cs`
- Modify: `src/Application/ArturRios.Fortuna.Shared/Messages/HeimdallAuthMessages.cs` (find with `git ls-files | grep HeimdallAuthMessages.cs`)
- Modify: `src/Presentation/ArturRios.Fortuna.WebApi/Extensions/FortunaCommandsServiceCollectionExtensions.cs`
- Test: `tests/Application/ArturRios.Fortuna.Command.Tests/HeimdallAuthCommandHandlerTests.cs`

**Interfaces:**
- Consumes: `IHeimdallAuthGateway.RegisterAsync`, `HeimdallAuthOutcome.Closed` (Task 1); `HeimdallAuthOptions(Guid ScopeId)`.
- Produces: `RegisterThroughApiCommand { Name, Email, Password }`; `RegisterThroughApiCommandOutput` (empty); `HeimdallAuthMessages.RegistrationRequested`, `RegistrationUnavailable`, `NameRequired`, `NameTooLong`, `PasswordTooShort`.

- [ ] **Step 1: Write the failing handler tests**

Add to `HeimdallAuthCommandHandlerTests` (before the `StubGateway` class):

```csharp
    [UnitFact]
    public async Task GivenAnyAddress_WhenRegistering_ThenConfiguredScopeIsUsedAndAnsweredGenerically()
    {
        var gateway = new StubGateway { RegisterResult = new(HeimdallAuthOutcome.Succeeded, new object()) };
        var handler = new RegisterThroughApiCommandHandler(gateway, new(ScopeId))
            .Validated(new RegisterThroughApiCommandValidator());

        var result = await handler.HandleAsync(new()
        {
            Name = "  New Person ", Email = " new@example.test ", Password = " keep spaces "
        });

        Assert.True(result.Success);
        Assert.Contains(HeimdallAuthMessages.RegistrationRequested, result.Messages);
        // Name and address are trimmed; the password is forwarded exactly as typed.
        Assert.Equal(("New Person", "new@example.test", " keep spaces ", ScopeId), gateway.RegisterRequest);
    }

    [UnitFact]
    public async Task GivenAClosedScope_WhenRegistering_ThenRegistrationUnavailable()
    {
        var gateway = new StubGateway { RegisterResult = new(HeimdallAuthOutcome.Closed) };
        var handler = new RegisterThroughApiCommandHandler(gateway, new(ScopeId))
            .Validated(new RegisterThroughApiCommandValidator());

        var result = await handler.HandleAsync(new()
        {
            Name = "New Person", Email = "new@example.test", Password = "a-long-secret"
        });

        Assert.Contains(HeimdallAuthMessages.RegistrationUnavailable, result.Errors);
    }

    [UnitTheory]
    [InlineData(HeimdallAuthOutcome.Unavailable, HeimdallAuthMessages.ServiceUnavailable)]
    [InlineData(HeimdallAuthOutcome.InvalidRequest, HeimdallAuthMessages.RequestRejected)]
    public async Task GivenHeimdallFails_WhenRegistering_ThenTheSafeMessageIsReturned(
        HeimdallAuthOutcome outcome, string expected)
    {
        var gateway = new StubGateway { RegisterResult = new(outcome) };
        var handler = new RegisterThroughApiCommandHandler(gateway, new(ScopeId))
            .Validated(new RegisterThroughApiCommandValidator());

        var result = await handler.HandleAsync(new()
        {
            Name = "New Person", Email = "new@example.test", Password = "a-long-secret"
        });

        Assert.Contains(expected, result.Errors);
    }

    [UnitTheory]
    [InlineData("", "new@example.test", "a-long-secret", HeimdallAuthMessages.NameRequired)]
    [InlineData("New Person", "not-an-address", "a-long-secret", HeimdallAuthMessages.EmailInvalid)]
    [InlineData("New Person", "new@example.test", "1234567", HeimdallAuthMessages.PasswordTooShort)]
    [InlineData("New Person", "new@example.test", "", HeimdallAuthMessages.PasswordRequired)]
    public async Task GivenMalformedInput_WhenRegistering_ThenRejectedWithoutCallingHeimdall(
        string name, string email, string password, string expected)
    {
        var gateway = new StubGateway();
        var handler = new RegisterThroughApiCommandHandler(gateway, new(ScopeId))
            .Validated(new RegisterThroughApiCommandValidator());

        var result = await handler.HandleAsync(new() { Name = name, Email = email, Password = password });

        Assert.Contains(expected, result.Errors);
        Assert.Null(gateway.RegisterRequest);
    }

    [UnitFact]
    public async Task GivenANameOf201Characters_WhenRegistering_ThenNameTooLong()
    {
        var gateway = new StubGateway();
        var handler = new RegisterThroughApiCommandHandler(gateway, new(ScopeId))
            .Validated(new RegisterThroughApiCommandValidator());

        var result = await handler.HandleAsync(new()
        {
            Name = new string('a', 201), Email = "new@example.test", Password = "a-long-secret"
        });

        Assert.Contains(HeimdallAuthMessages.NameTooLong, result.Errors);
    }
```

- [ ] **Step 2: Run them to verify they fail**

Run: `dotnet test tests/Application/ArturRios.Fortuna.Command.Tests -m:1 --filter "FullyQualifiedName~HeimdallAuthCommandHandlerTests"`
Expected: build FAILS — `RegisterThroughApiCommandHandler` does not exist.

- [ ] **Step 3: Add messages, command, output and validator**

`HeimdallAuthMessages.cs`, after `PasswordRecoveryRequested`:

```csharp
    public const string RegistrationRequested =
        "If this address can be registered, we've sent it an email. Follow it, then sign in.";
    public const string RegistrationUnavailable = "This instance is not accepting new accounts.";
    public const string NameRequired = "Name is required.";
    public const string NameTooLong = "Name must be at most 200 characters.";
    public const string PasswordTooShort = "Password must be at least 8 characters.";
```

`HeimdallAuthCommands.cs`, after `RequestPasswordRecoveryThroughApiCommand`:

```csharp
/// <summary>
///     Intent to register a connected identity through Fortuna (UC-81). Fortuna attaches its configured
///     Heimdall scope; the caller never names one.
/// </summary>
public sealed class RegisterThroughApiCommand : BaseCommand
{
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}
```

`HeimdallAuthCommandOutputs.cs`, after `RequestPasswordRecoveryThroughApiCommandOutput`:

```csharp
/// <summary>
///     Deliberately empty: any field describing what happened would say whether the address was
///     already registered (UC-81 AF-01).
/// </summary>
public sealed class RegisterThroughApiCommandOutput : CommandOutput;
```

`HeimdallAuthCommandValidators.cs`, after `RequestPasswordRecoveryThroughApiCommandValidator`:

```csharp
/// <summary>
///     Heimdall's UC-47 field rules, applied here so a malformed request costs no round trip. Heimdall
///     stays the authority and validates again.
/// </summary>
public sealed class RegisterThroughApiCommandValidator : AbstractValidator<RegisterThroughApiCommand>
{
    public RegisterThroughApiCommandValidator()
    {
        RuleFor(command => command.Name)
            .Cascade(CascadeMode.Stop)
            .Must(name => !string.IsNullOrWhiteSpace(name)).WithMessage(HeimdallAuthMessages.NameRequired)
            .Must(name => name.Trim().Length <= 200).WithMessage(HeimdallAuthMessages.NameTooLong);
        RuleFor(command => command.Email)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().WithMessage(HeimdallAuthMessages.EmailRequired)
            .EmailAddress().WithMessage(HeimdallAuthMessages.EmailInvalid);
        RuleFor(command => command.Password)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().WithMessage(HeimdallAuthMessages.PasswordRequired)
            .MinimumLength(8).WithMessage(HeimdallAuthMessages.PasswordTooShort);
    }
}
```

- [ ] **Step 4: Add the handler**

`HeimdallAuthCommandHandlers.cs`, after `RequestPasswordRecoveryThroughApiCommandHandler`:

```csharp
/// <summary>
///     Forwards a registration to Heimdall with the configured scope (UC-81). Heimdall answers a free
///     and a taken address alike, and so does this: the only answers that differ are a closed scope,
///     a malformed request and an unreachable Heimdall, none of which says anything about an address.
/// </summary>
public sealed class RegisterThroughApiCommandHandler(
    IHeimdallAuthGateway gateway,
    HeimdallAuthOptions options)
    : ICommandHandlerAsync<RegisterThroughApiCommand, RegisterThroughApiCommandOutput>
{
    public async Task<DataOutput<RegisterThroughApiCommandOutput?>> HandleAsync(
        RegisterThroughApiCommand command,
        CancellationToken cancellationToken = default)
    {
        var result = await gateway.RegisterAsync(
            command.Name.Trim(), command.Email.Trim(), command.Password, options.ScopeId, cancellationToken);

        return result.Outcome switch
        {
            HeimdallAuthOutcome.Succeeded => DataOutput<RegisterThroughApiCommandOutput?>.New
                .WithData(new RegisterThroughApiCommandOutput())
                .WithMessage(HeimdallAuthMessages.RegistrationRequested),
            HeimdallAuthOutcome.Closed => DataOutput<RegisterThroughApiCommandOutput?>.New
                .WithError(HeimdallAuthMessages.RegistrationUnavailable),
            _ => LoginThroughApiCommandHandler.Failure<RegisterThroughApiCommandOutput>(
                result.Outcome, HeimdallAuthMessages.RequestRejected)
        };
    }
}
```

- [ ] **Step 5: Register it**

In `FortunaCommandsServiceCollectionExtensions.AddFortunaCommands`, after the `RequestPasswordRecoveryThroughApiCommand` registration:

```csharp
        services.AddAuditedCommandHandler<RegisterThroughApiCommand,
            RegisterThroughApiCommandOutput, RegisterThroughApiCommandHandler,
            RegisterThroughApiCommandValidator>();
```

- [ ] **Step 6: Run the tests to verify they pass**

Run: `dotnet test tests/Application/ArturRios.Fortuna.Command.Tests -m:1 --filter "FullyQualifiedName~HeimdallAuthCommandHandlerTests"`
Expected: all pass.

- [ ] **Step 7: Commit**

```bash
git add src tests
git commit -m "feat: add the register-through-api command" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Endpoint and proxy tests

**Files:**
- Modify: `src/Presentation/ArturRios.Fortuna.WebApi/Controllers/AuthController.cs`
- Test: `tests/Presentation/ArturRios.Fortuna.WebApi.Tests/HeimdallAuthProxyTests.cs`

**Interfaces:**
- Consumes: `RegisterThroughApiCommand`, `RegisterThroughApiCommandOutput`, the messages (Task 2); `StubGateway.RegisterResult/RegisterRequest/RegisterCalls` (Task 1).
- Produces: `POST /api/auth/register` (anonymous, `AuthAnonymous` limit) → `202` / `403` / `400` / `503`.

- [ ] **Step 1: Write the failing proxy tests**

Add to `HeimdallAuthProxyTests` (before `CreateFactory`):

```csharp
    [FunctionalFact]
    public async Task GivenAnyAddress_WhenRegistering_ThenAcceptedWithTheGenericMessageAndConfiguredScope()
    {
        var gateway = new StubGateway { RegisterResult = new(HeimdallAuthOutcome.Succeeded, new object()) };
        await using var factory = CreateFactory(gateway);
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/auth/register", new
        {
            name = "New Person",
            email = "new@example.test",
            password = "never-return-this"
        });
        var body = await response.Content.ReadAsStringAsync();

        Assert.Equal(HttpStatusCode.Accepted, response.StatusCode);
        Assert.Contains(HeimdallAuthMessages.RegistrationRequested, body, StringComparison.Ordinal);
        Assert.Equal(("New Person", "new@example.test", Guid.Parse("00000000-0000-0000-0000-000000000076")),
            gateway.RegisterRequest);
        Assert.DoesNotContain("never-return-this", body, StringComparison.Ordinal);
    }

    [FunctionalTheory]
    [InlineData(HeimdallAuthOutcome.Closed, HttpStatusCode.Forbidden)]
    [InlineData(HeimdallAuthOutcome.Unavailable, HttpStatusCode.ServiceUnavailable)]
    [InlineData(HeimdallAuthOutcome.InvalidRequest, HttpStatusCode.BadRequest)]
    public async Task GivenHeimdallRefuses_WhenRegistering_ThenTheMappedStatusIsReturned(
        HeimdallAuthOutcome outcome, HttpStatusCode expected)
    {
        var gateway = new StubGateway { RegisterResult = new(outcome) };
        await using var factory = CreateFactory(gateway);
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/auth/register", new
        {
            name = "New Person",
            email = "new@example.test",
            password = "a-long-secret"
        });

        Assert.Equal(expected, response.StatusCode);
    }

    [FunctionalFact]
    public async Task GivenAClosedScope_WhenRegistering_ThenTheUnavailableMessageIsReturned()
    {
        var gateway = new StubGateway { RegisterResult = new(HeimdallAuthOutcome.Closed) };
        await using var factory = CreateFactory(gateway);
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/auth/register", new
        {
            name = "New Person",
            email = "new@example.test",
            password = "a-long-secret"
        });
        var body = await response.Content.ReadAsStringAsync();

        Assert.Contains(HeimdallAuthMessages.RegistrationUnavailable, body, StringComparison.Ordinal);
    }

    [FunctionalFact]
    public async Task GivenAShortPassword_WhenRegistering_ThenBadRequestAndHeimdallIsNotCalled()
    {
        var gateway = new StubGateway();
        await using var factory = CreateFactory(gateway);
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/auth/register", new
        {
            name = "New Person",
            email = "new@example.test",
            password = "1234567"
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        Assert.Equal(0, gateway.RegisterCalls);
    }

    [FunctionalFact]
    public async Task GivenElevenRegistrationsInAMinute_WhenRegistering_ThenTheLastIsRateLimited()
    {
        var gateway = new StubGateway { RegisterResult = new(HeimdallAuthOutcome.Succeeded, new object()) };
        await using var factory = CreateFactory(gateway);
        using var client = factory.CreateClient();
        HttpResponseMessage? response = null;

        for (var attempt = 0; attempt < 11; attempt++)
        {
            response?.Dispose();
            response = await client.PostAsJsonAsync("/api/auth/register", new
            {
                name = "New Person",
                email = "new@example.test",
                password = "a-long-secret"
            });
        }

        using (response)
        {
            Assert.Equal(HttpStatusCode.TooManyRequests, response!.StatusCode);
        }
    }
```

- [ ] **Step 2: Run them to verify they fail**

Run: `dotnet test tests/Presentation/ArturRios.Fortuna.WebApi.Tests -m:1 --filter "FullyQualifiedName~HeimdallAuthProxyTests"`
Expected: the new tests FAIL with `404 Not Found` (no route yet).

- [ ] **Step 3: Add the action and its statuses**

In `AuthController.cs`, extend `Statuses`:

```csharp
            [HeimdallAuthMessages.ServiceUnavailable] = StatusCodes.Status503ServiceUnavailable,
            [HeimdallAuthMessages.RegistrationRequested] = StatusCodes.Status202Accepted,
            [HeimdallAuthMessages.RegistrationUnavailable] = StatusCodes.Status403Forbidden
```

(`ServiceUnavailable` is the existing last entry; add a comma after it.)

Add the action after `RequestPasswordRecovery`:

```csharp
    /// <summary>
    ///     Registers a connected identity in Fortuna's Heimdall scope (UC-81). Answers 202 alike for a
    ///     free and a taken address; the account exists, and can sign in, once its holder follows the
    ///     verification email. The Fortuna profile is created on the first authenticated request.
    /// </summary>
    [HttpPost("register")]
    [AllowAnonymous]
    [EnableRateLimiting(AnonymousRateLimitPolicy)]
    public async Task<ActionResult<DataOutput<RegisterThroughApiCommandOutput?>>> Register(
        [FromBody] RegisterThroughApiCommand command)
    {
        return await SendAsync<RegisterThroughApiCommand, RegisterThroughApiCommandOutput>(command);
    }
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `dotnet test tests/Presentation/ArturRios.Fortuna.WebApi.Tests -m:1 --filter "FullyQualifiedName~HeimdallAuthProxyTests"`
Expected: all pass.

- [ ] **Step 5: Commit**

```bash
git add src tests
git commit -m "feat: expose post /api/auth/register" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: Contract, documentation and backlog

**Files:**
- Modify: `docs/openapi/fortuna.json` (generated)
- Modify: `docs/requirements/Use Case Specification Document.md`, `docs/requirements/System Requirements Document.md`
- Modify: `README.md`, `CHANGELOG.md`

- [ ] **Step 1: Regenerate the OpenAPI document**

Run: `python3 scripts/openapi.py`
Expected: `docs/openapi/fortuna.json` gains `/api/auth/register` (POST, `RegisterThroughApiCommand`, response `DataOutput<RegisterThroughApiCommandOutput>`). Then `python3 scripts/openapi.py --check` exits 0.

- [ ] **Step 2: Add UC-81**

Insert after the UC-80 section, before the state-diagram appendix that ends the document (keep the existing `---` separators):

```markdown
### UC-81: Register through the Fortuna API

| Field | Value |
| --- | --- |
| **ID** | UC-81 |
| **Name** | Register through the Fortuna API |
| **Actors** | Anonymous Fortuna Client, Heimdall API |
| **Description** | Create a connected identity in Fortuna's Heimdall scope without an administrator |
| **Preconditions** | The Heimdall base address and Fortuna scope public identifier are configured; the scope has opened self-registration in Heimdall (Heimdall UC-47) |
| **Postconditions** | Heimdall has created an unverified identity, or told the address's holder of the attempt. Fortuna state is unchanged until the identity's first authenticated request provisions its profile |
| **Requirements** | FR-ID-45 through FR-ID-47 |

**Main Flow**

1. An anonymous caller sends a name, an email address and a password; Fortuna rate-limits the request.
2. Fortuna validates the request with Heimdall's field rules and attaches the configured scope.
3. Fortuna forwards the request to Heimdall and answers `202 Accepted` with one message.
4. The holder follows Heimdall's verification email and signs in through UC-76; the first authenticated
   request provisions the Fortuna profile.

**Alternative Flows**

| ID | Condition | Outcome |
| --- | --- | --- |
| AF-01 | The address is already registered | `202 Accepted` with the same message as a free address |
| AF-02 | The scope does not accept self-registration | `403 Forbidden` with a message that names no address |
| AF-03 | A request is malformed | `400 Bad Request`, and Heimdall is not called |
| AF-04 | Heimdall is unreachable or returns a server error | `503 Service Unavailable`; upstream details are not returned |

UC-81 uses the same limit of ten attempts per source address per minute as UC-76. The native core
answers `/api/auth/**` as unavailable offline, which already covers this route.
```

- [ ] **Step 3: Requirements, endpoint table, transport table**

In `System Requirements Document.md`, after the `FR-ID-44` row:

```markdown
| FR-ID-45 | The system shall forward an anonymous registration (name, email, password) to Heimdall with the configured Fortuna scope identifier, and shall store no part of it |
| FR-ID-46 | The system shall answer a registration identically whether or not the address is already registered |
| FR-ID-47 | The system shall answer `403 Forbidden` when Heimdall reports the scope closed to self-registration, and shall otherwise map failures as UC-76 does |
```

Update the two coverage rows that say `FR-ID-16 through FR-ID-43` / `FR-ID-01 … FR-ID-44` so their upper bound reads `FR-ID-47`. In the endpoint table after the `/api/auth/password-recovery` row:

```markdown
| POST | `/api/auth/register` | Register a connected identity without disclosing whether the address is taken — *anonymous* | FR-ID-45 through FR-ID-47 |
```

In the Use Case Specification's transport table, change `| UC-76 … UC-77 | HTTP only. …` to `| UC-76 … UC-77, UC-81 | HTTP only. …`, and in the introduction's authentication sentence add "UC-81's registration" to the list of anonymous exchanges.

- [ ] **Step 4: Backlog and changelog**

Ask the user before running (it publishes to GitHub):

```bash
gh issue create --repo artur-rios/fortuna-api --title "UC-81: Register through the Fortuna API" --body "Proxy Heimdall UC-47 self-registration with the configured scope. See UC-81 in docs/requirements/Use Case Specification Document.md."
```

Add the README row after the `#175` row (same milestone table as UC-76/UC-77):

```markdown
| [#<n>](https://github.com/artur-rios/fortuna-api/issues/<n>) | ✅ UC-81: Register through the Fortuna API | [Use Case Specification](docs/requirements/Use%20Case%20Specification%20Document.md) |
```

`CHANGELOG.md`, `Unreleased` → `### Added`:

```markdown
- UC-81: `POST /api/auth/register` forwards self-registration to Heimdall with the configured scope, answering new and taken addresses alike.
```

- [ ] **Step 5: Final verification**

Run: `dotnet test src/ArturRios.Fortuna.sln -m:1`
Expected: all pass.
Run: `python3 scripts/openapi.py --check`
Expected: exit 0.

- [ ] **Step 6: Commit and open the pull request**

```bash
git add docs README.md CHANGELOG.md
git commit -m "docs: specify registration proxy (uc-81)" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -u origin feature/self-service-sign-up
gh pr create --repo artur-rios/fortuna-api --base develop --title "feat: register through the fortuna api (UC-81)" --body "Implements UC-81 per fortuna-ui docs/superpowers/specs/2026-10-12-self-service-sign-up-design.md §5. Depends on heimdall-api UC-47.

🤖 Generated with [Claude Code](https://claude.com/claude-code)"
```

Pushing and opening the PR are outward-facing: confirm with the user first.
