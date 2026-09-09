# Native

The Fortuna core, as this repository consumes it (IR-10, IR-11, IR-21).

```
native/
├── include/fortuna_ffi.h        the core's C header, vendored verbatim
├── windows/fortuna_ffi.dll      the core library for Windows
└── linux/libfortuna_ffi.so      the core library for Linux
```

Nothing here is written by hand. The header is copied **verbatim** from the
[Fortuna API](https://github.com/artur-rios/fortuna-api), which publishes it, and
CI diffs the two so that drift fails the build rather than being discovered at
run time. The libraries are build artifacts of that repository, and the desktop
packages ship them beside the application.

`dart run tool/generate_bindings.dart` turns the header into
`lib/core/bindings/fortuna_bindings.dart`, which is committed and never
hand-edited. A wrong binding means a wrong header: fix it at the source and
regenerate.

## Currently absent, deliberately

The directory holds no header and no libraries yet, and this is not an oversight
— they do not exist to vendor. They are blocked on:

- [artur-rios/fortuna-api#156](https://github.com/artur-rios/fortuna-api/issues/156)
  — the C ABI and its published header.
- [artur-rios/fortuna-api#157](https://github.com/artur-rios/fortuna-api/issues/157)
  — the offline operation surface exported over it.
- [artur-rios/fortuna-api#155](https://github.com/artur-rios/fortuna-api/issues/155)
  — the SQLite provider that surface reads.

Until they land, this application is HTTP-only. That is what the web and Android
targets use regardless, and what a desktop installation pointed at a remote or
self-hosted instance uses; only desktop **offline** mode needs what is missing.

The generator refuses to run rather than emitting empty bindings, and
`tool/check_boundaries.dart` still enforces that `dart:ffi` stays confined to
`lib/core/bindings/` — so the rule that protects this boundary is in force
before there is a boundary to protect.
