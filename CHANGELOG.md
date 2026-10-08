# Changelog

All notable changes to Fortuna UI are recorded in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

No release has been tagged yet. What exists so far:

### Added

- One Flutter application for the web, Windows, Linux and Android, reaching the Fortuna API over HTTP or, in
  desktop offline mode, the Fortuna core in process through FFI.
- Instance and mode setup, sign-in with credentials, Google or a desktop local account, account recovery,
  two-factor management, session restore and sign-out, and presentation preferences.
- Financial accounts, credit cards and their statements, investments, transactions, transfers, installment
  purchases and reconciliation.
- Categories, tags, counterparties, budgets and goals.
- Institution connections, file imports, import job monitoring and imported record review.
- A spreadsheet view, charts with drill-down, net position, projections and obligations, and data set export.
- Consents, a complete personal data export, account erasure, deleted record restoration, the audit trail and
  instance health.
- A web container image served by nginx.

### Changed

- In desktop offline mode, the features the Fortuna core does not implement offline are shown as "Not available
  offline", with the core's reason, instead of being offered and then failing: file imports and import retry,
  data-set export, charts, net position and projections, transfers, installment purchases, card statements and
  closing or settling them, budget consumption, goal progress and reconciliation. The application asks the core
  once, when offline mode starts. Connected installations are unchanged.
- A refusal the core answers with `501` ("not available offline") shows the core's reason and offers no retry,
  since it would be refused the same way again. A stored session the core cannot verify offline is discarded with
  that reason, so the user signs in again instead of stopping at the start screen.
- Requires the Fortuna core with `FORTUNA_STATUS_NOT_IMPLEMENTED` and `fortuna_capabilities.notImplemented`. An
  older core still works; its features are offered as before.
- The application is deployed to four environments: `local` on Docker Desktop, and `development`, `homologation`
  and `production` on one VPS (development and homologation on demand). A deployed web build names its own origin
  (`https://fortuna-dev.example.com`, `fortuna-hml`, `fortuna`) as the API address, since the API is served under it
  at `/api/`. For local runs, `config/local.json.example` holds the local API address (`http://localhost:8083`), for
  `--dart-define-from-file`; the copy, `config/local.json`, is git-ignored.

### Fixed

- A refusal from the API or the offline core now shows its own reason instead of "The request could not be
  completed." The reason travels in the envelope's `errors`, which the client never read.
- Transactions, transfers, installment purchases, investment movements and valuations, budgets, goals, statement
  settlements and other dated records are no longer refused by the API: their dates are sent as `yyyy-MM-dd`, the
  only form it accepts for a calendar date, on both transports.
- Exporting a filtered data set by date no longer fails with an invalid filter value.
- A credit card limit, an investment movement or valuation, and an account's opening balance are read in the
  chosen locale, like every other amount. `5.000` typed in pt-BR was sent as five instead of five thousand.
- An amount whose separators are not where the chosen locale puts them, such as `10.50` in pt-BR or `1,5` in
  en-US, is refused as unreadable rather than read as a different number.
- A negative amount shows its minus sign before the currency symbol (`-$1,234.50`), the spacing between symbol and
  number follows the locale, and an amount shown without a symbol rounds to the instance's precision for the
  currency.
- Audit entries, import jobs, connections and consents show their times in the device's time zone rather than UTC.
- Deleted transactions show their amount and date formatted for the chosen locale.
- A file import attempted in desktop offline mode is refused with a reason instead of an anonymous failure.
- The vendored core header is the one fortuna-api publishes with `FORTUNA_STATUS_NOT_IMPLEMENTED`. The header drift
  check passes once that fortuna-api change is on its `develop` branch. The header no longer produces comment
  warnings, so the bindings are generated without ignoring source errors.
- The bindings generator reports how many routes it wrote, instead of printing the literal
  `${matches.length}`.

[Unreleased]: https://github.com/artur-rios/fortuna-ui/commits/develop
