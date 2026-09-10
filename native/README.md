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

## What is here, and what is not

The **header is vendored** — `include/fortuna_core.h`, copied verbatim from
[fortuna-api](https://github.com/artur-rios/fortuna-api), and diffed against the
published copy by CI so drift fails the build rather than surfacing at run time
(`FR-DA-06`, UC-02 `AF-04`).

The **libraries are not**, and will not be. `libfortuna_core.so` and
`fortuna_core.dll` are build artifacts of that repository; the desktop packages
ship them beside the executable, and a developer running from source drops a
locally built one into `linux/` or `windows/`. UC-01's probe looks in both
places, so an installation that carries no library is simply never offered
offline mode.

## One wrinkle in the published header

cbindgen emits the route-export doc comment containing glob patterns like
`/api/auth/**`. The `/*` inside `auth/**` opens a nested comment, so clang warns
three times and ffigen refuses on warnings by default. `ffigen.yaml` therefore
sets `ignore-source-errors: true`, with the reasoning recorded there.

The warnings are about comment lexing only — every declaration parses normally,
and `test/core/bindings/core_route_test.dart` checks the generated route table
against the header's own declarations, so a genuinely mis-parsed header would
fail the suite. Editing the vendored header to silence it is not an option:
`FR-DA-06` requires it verbatim. The fix belongs to fortuna-api's cbindgen
output.
