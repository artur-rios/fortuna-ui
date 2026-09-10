# Native

The Fortuna core, as this repository consumes it (IR-10, IR-11, IR-21).

```
native/
├── include/fortuna_core.h       the core's C header, vendored verbatim
├── windows/fortuna_core.dll     the core library for Windows
└── linux/libfortuna_core.so     the core library for Linux
```

The names follow what `fortuna-api` actually publishes: its core is a Rust crate
called `fortuna_core`, whose cbindgen header is `fortuna_core.h` and whose
artifacts are `libfortuna_core.so` and `fortuna_core.dll`. Earlier drafts of this
file called all three `fortuna_ffi`; the publishing repository owns the name, so
this side follows it.

Nothing here is written by hand. The header is copied **verbatim** from the
[Fortuna API](https://github.com/artur-rios/fortuna-api), which publishes it, and
CI diffs the two so that drift fails the build rather than being discovered at
run time. The libraries are build artifacts of that repository, and the desktop
packages ship them beside the application.

`dart run tool/generate_bindings.dart` turns the header into
`lib/core/bindings/fortuna_bindings.dart`, which is committed and never
hand-edited. A wrong binding means a wrong header: fix it at the source and
regenerate.

## Currently absent, pending UC-02

The directory holds no header and no libraries yet. Everything it waits on has
landed upstream — the C ABI and its header
([fortuna-api#156](https://github.com/artur-rios/fortuna-api/issues/156)), the
offline operation surface
([#157](https://github.com/artur-rios/fortuna-api/issues/157)) and the SQLite
provider ([#155](https://github.com/artur-rios/fortuna-api/issues/155)) are all
closed. Vendoring the header and generating the bindings is **UC-02**, the use
case that introduces the transport.

Two things are still to reconcile there, and they are recorded here so they are
not discovered again: `ffigen.yaml`, `tool/generate_bindings.dart` and the drift
check in `.github/workflows/check-generated.yml` all still name the header
`fortuna_ffi.h`. They are deliberately untouched for now — renaming them before
the header is vendored would make the drift check demand a file that is not
there yet, failing the build for describing the future accurately.

Until UC-02 lands, this application is HTTP-only. That is what the web and
Android targets use regardless, and what a desktop installation pointed at a
remote or self-hosted instance uses; only desktop **offline** mode needs what is
missing. UC-01 already probes for the library, so an installation that does not
carry one simply is not offered the mode.

The generator refuses to run rather than emitting empty bindings, and
`tool/check_boundaries.dart` still enforces that `dart:ffi` stays confined to
`lib/core/bindings/` — so the rule that protects this boundary is in force
before there is a boundary to protect.
