# Project Overview — Fortuna UI

## What This Is

Fortuna is a personal finance system that tracks a person's whole financial life — bank accounts,
credit cards, investments, expenses and earnings — in one place, and turns that history into
tabular views, charts and forward-looking projections. **This repository is the front end only:**
a single Flutter application that runs on the web, Windows, Linux and Android from one code base,
and reads and writes everything through the
[Fortuna API](https://github.com/artur-rios/fortuna-api).

The API owns the domain, the money and the integrations. This application owns the experience:
what a person sees, how they enter a transaction, how a chart responds to a tap, and how the same
interface manages to feel native on four very different targets.

## The Problem

A person's financial life is scattered across places that do not talk to each other: one bank's
app, another bank's statement PDF, a broker's portal, a credit card invoice, and a spreadsheet
somebody maintains by hand to make sense of the rest. The Fortuna API solves the data half of that
problem — it reconciles the sources and answers the two questions that matter, *where did the money
go?* and *where will I be in six months?*

But an API answers those questions in JSON, and nobody reads their finances in JSON. Without a
client the system is unusable by the person it was built for. And a client that exists only on one
platform recreates the original problem in a new form: the desktop tells you one thing, the phone
another, and the habit of checking never forms because checking is inconvenient.

The people who feel it are individuals and households who want a single, trustworthy view of their
own money, on whichever device is in front of them, without handing that data to a service they do
not control.

## Who It's For

| User | What they need from the application |
| --- | --- |
| **Account owner** | The everyday user. Records and reviews their own financial data, imports statements, connects banks, reads charts and projections, exports what they need. Sees only their own data. |
| **Instance administrator** | Runs a shared instance. Manages the instance and watches its operational health through the same application — and sees no user's financial records anywhere in it. |
| **Desktop offline user** | An account owner on a Windows or Linux installation running with no network and no identity provider reachable. Signs in against a local account and works against a local database. |

The application runs in three shapes, and the interface is the same in all three:

- **Connected** — signed in through the Fortuna API against the shared identity provider, talking
  to a remote instance. This is the normal path, and the only one on the web and Android.
- **Self-hosted** — the same connected experience, pointed at an instance the user runs themselves.
- **Desktop offline** — Windows and Linux only. The installation ships the Fortuna core as a native
  library and a SQLite database, and calls the core in process, so the application works with no
  network and no server at all.

## What It Does

- **Signs the user in** — email and password, or Google, both through the Fortuna API, with
  two-factor authentication where the account has it enabled, and a local account for desktop
  offline mode.
- **Shows holdings** — bank accounts, credit cards with their billing cycles and statements, and
  investments with their positions, each with its own balance, currency and history.
- **Records money movement** — expenses, earnings, transfers between the user's own accounts,
  installment purchases and recurring commitments, entered through forms that validate before they
  submit.
- **Brings data in** — starts a bank connection, runs a synchronization, uploads an Excel workbook
  or a credit card statement PDF, and follows the import job to its per-row outcome.
- **Presents data as a spreadsheet** — a filterable, sortable, paginated grid over any set of
  records, with the filtering and sorting done by the API rather than in the client.
- **Presents data as charts** — aggregations by period, category, account and counterparty, each
  drillable: tapping a chart element asks the API for the breakdown behind it, and keeps going
  until it reaches the individual transactions.
- **Shows the future** — projections and committed obligations, always visually distinct from what
  actually happened.
- **Organizes** — categories as a tree, tags, counterparties, budgets and goals.
- **Exports** — asks the API for a CSV, Excel or PDF rendering and saves it where the platform
  saves files.
- **Administers** — for an instance administrator, the operational surface of the instance and its
  health, and nothing else.
- **Honors data rights** — asks for consent before any data reaches an external processor and lets
  it be withdrawn, exports everything the system holds about the user, and erases the account
  outright when they ask.

## What It Doesn't Do

The application inherits every exclusion the API declares — it does not move money, does not give
financial advice, does not do tax filing, does not store bank credentials, and does not write back
to any financial institution. On top of those, and specific to this repository:

- **It does not compute money.** Every balance, total, aggregation and projection is asked of the
  API and displayed as received. The client formats figures; it never derives them.
- **It does not own data.** There is no client-side database in the connected experience, and
  nothing the user enters is authoritative until the API has accepted it.
- **It does not parse or render import files.** A spreadsheet or a statement PDF is uploaded whole;
  the API reads it. An export is produced by the API and merely saved by the client.
- **It does not talk to Pluggy, or to any other external service.** Every integration is reached
  through the Fortuna API. The one exception is Google, which issues the sign-in token the API
  exchanges.
- **It does not run on iOS or macOS.** Neither platform folder exists, and neither is planned for
  now.
- **It does not work offline in the connected experience.** Offline capability is desktop offline
  mode, where a local core and database are present — not a cache pretending the network is there.

## How Success Is Measured

- **Every feature is reachable.** Every use case the API exposes has a way into it from the
  interface, and none of them requires knowing an identifier, a route or a payload shape.
- **It is the same application everywhere.** One code base, four targets, and a person moving from
  the desktop to the phone finds the same concepts in the same order. Platform differences are
  confined to what genuinely differs — file pickers, window chrome, and the offline mode that only
  desktop has.
- **Money is displayed exactly.** No figure is ever computed in binary floating point, at any layer.
  A number on screen matches the API's answer to the cent, in the currency it belongs to.
- **It feels instant.** Interaction holds a steady frame rate with no dropped frames on a normal
  scroll or chart animation; a screen backed by a single API read is on screen as fast as that read
  returns; a chart drill-down feels like a direct manipulation rather than a page load. The
  application never blocks on work the API defines as asynchronous — imports, synchronizations and
  exports report progress instead.
- **Nothing leaks.** A credential is never written to disk, a log or a crash report. A token lives
  in the platform's secure storage and nowhere else. A signed-out application retains nothing about
  who was signed in.
- **The data rights work.** Consent is asked for before anything leaves for a third party, an export
  produces everything the system holds, and an erasure leaves nothing identifying behind. The
  application is compliant with the **GDPR** and the **LGPD** — with the caveat that who the
  controller is depends on the deployment: in a self-hosted or offline installation it is the user
  themselves, and on a shared instance it is whoever runs it.
- **It installs cleanly on each target.** The web build is served from a container behind a reverse
  proxy; Windows has an installer and a portable archive; Linux has an installer; Android has an
  APK. Each is produced by the same pipeline from the same source.
