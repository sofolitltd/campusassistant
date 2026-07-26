# Build & Deploy

This documents how app configuration works and the exact commands to build
and deploy each target. Read this before your next `flutter build` /
`firebase deploy` — the config mechanism changed from a **runtime** `.env`
file (bundled as a Flutter asset) to a **build-time** `.env` file consumed
via `--dart-define-from-file`.

## Why this exists (history)

The app used to load config at **runtime** via `flutter_dotenv`, reading a
`.env` file bundled as a Flutter asset (`assets/.env`). That caused two real
incidents on the web deploy:

1. **The value never updated.** Firebase Hosting's default `ignore` rule
   (`**/.*`) excludes dotfiles from upload — including `assets/.env` — so a
   correctly-edited local `.env` silently never reached the deployed site,
   which kept falling back to a hardcoded default (`http://10.0.2.2:8080`,
   the Android-emulator loopback address) and broke over HTTPS with a mixed
   content error.
2. **It was a public, downloadable file.** Once actually deployed, anyone
   could run `curl https://campusassistantbd.web.app/assets/.env` and read
   the whole file in plaintext — no auth, no DevTools needed. At one point
   this included live bKash sandbox credentials.

Neither problem is really about `.env` specifically — it's that **anything
shipped to a web/mobile client is not secret**, whether it's a runtime file
or a compiled string. The fix is removing the accidental "separate fetchable
file at a known URL" failure mode by having Flutter's build tool consume
`.env` directly (`--dart-define-from-file`) instead of the app fetching it
at runtime. It does **not** make `API_KEY` a real secret — see "What can and
can't go in here" below.

## How config works now

- `lib/core/config/env.dart` defines `Env` — a class of `String.fromEnvironment(...)`
  constants (`Env.baseUrl`, `Env.apiKey`, `Env.fcmVapidKey`, `Env.admobAndroidAppId`, etc).
- Values are injected at **build/run time** via `--dart-define-from-file=<path>`.
  Flutter's build tool reads the file directly and the Dart compiler inlines
  the values as real constants — nothing is fetched at runtime, and no such
  file exists anywhere in the compiled app output (`build/web`, the APK, etc).
- The file can be plain `KEY=VALUE` (`.env` syntax, `#` comments allowed) or
  JSON — Flutter auto-detects the format by content. This project uses `.env`
  syntax to keep the familiar format.
- `.env` (git-ignored, real values) is your production config.
- `.env.example` (committed) is the template new developers copy.

## One-time setup (new machine / new developer)

```bash
cd campusassistant
cp .env.example .env
# edit .env with real values — ask a teammate for the production ones
```

## Local development

```bash
flutter pub get
flutter run --dart-define-from-file=.env
```

### Shortcuts — don't retype the flag every time

- **Terminal**: `make run` (production), `make run-local` (emulator),
  `make run-lan` (real device) — see `Makefile`, which also has
  `make build-web`, `make deploy`, `make build-apk`, `make build-appbundle`,
  `make build-ios`.
- **VS Code**: pick one of the three `campusassistant (...)` configs in the
  Run and Debug panel (production / Android emulator / LAN device) and hit
  F5. No extra setup needed; `.vscode/launch.json` is already committed to
  the repo.

There are three ready-made config files (all git-ignored — only you have
them locally, same as `.env` before), one per backend target:

| File | `BASE_URL` | When to use |
|---|---|---|
| `.env` | `https://campusassistant.duckdns.org/api/v1` | Production API (Coolify) — default |
| `.env.local` | `http://10.0.2.2:8080/api/v1` | Local backend + **Android emulator** (`10.0.2.2` is the emulator's alias for your host machine) |
| `.env.lan` | `http://<your-lan-ip>:8080/api/v1` | Local backend + **real device** on the same WiFi/hotspot |

Run against whichever one you need:

```bash
flutter run --dart-define-from-file=.env         # production
flutter run --dart-define-from-file=.env.local   # emulator, local backend
flutter run --dart-define-from-file=.env.lan     # real device, local backend
```

or the shortcuts (`make run` / `make run-local` / `make run-lan`, or the
matching VS Code launch configs) above.

**`.env.lan`'s IP changes whenever you switch networks** (home WiFi →
phone hotspot → office WiFi, etc.) — before testing on a real device, get
your machine's current LAN IP and update the file:

```bash
ipconfig getifaddr en0   # macOS Wi-Fi; use en1/en2 etc. if that's not your active interface
```

Then run your local `campusassistant-api` backend so it's actually
reachable at that address (`PORT=8080` by default).

## Building for web (Firebase Hosting)

```bash
flutter build web --release --dart-define-from-file=.env
firebase deploy --only hosting
```

Since config is now compiled in, there is no `assets/.env` (or any config
file at all) in `build/web` — nothing extra to double check w.r.t. Firebase
Hosting's `ignore` rules. `firebase.json`'s `ignore` list is back to the
boilerplate default (`["firebase.json", "**/.*", "**/node_modules/**"]`);
you do not need to special-case anything there again.

**After deploying, do a hard refresh** (DevTools → Network tab → "Disable
cache" → Cmd/Ctrl+Shift+R) before testing — `main.dart.js` is cached
`immutable` for a year by design (Flutter fingerprints the filename... except
this project's `flutter_service_worker.js` is a minimal "kill switch" worker
that unregisters itself on activate, so stale JS is mostly a browser-cache
concern, not a service-worker one).

## Building for Android

```bash
flutter build apk --release --dart-define-from-file=.env
# or, for Play Store:
flutter build appbundle --release --dart-define-from-file=.env
```

## Building for iOS

```bash
flutter build ios --release --dart-define-from-file=.env
```

## What can and can't go in `.env`

**Fine to put here** (non-secret app identifiers — same category as a Stripe
publishable key or a Google Maps API key; restricted by server-side checks,
not by being hidden):
- `BASE_URL`
- `API_KEY` — sent as `X-API-Key`; the backend should treat this as a coarse
  "is this our app" filter (rate limiting, origin checks), never as the
  actual authorization boundary. Real authorization is the per-user
  `Authorization: Bearer <JWT>` obtained at login.
- `FCM_VAPID_KEY` — a public key by design (Firebase Web Push).
- `ADMOB_*` ad unit / app IDs.

**Never put here** — real third-party secrets (payment gateway app secrets,
etc.). If the app ever needs to talk to a service that requires a true
secret (like bKash), route it through your own backend instead: the app
calls `campusassistant-api`'s `/payments/bkash/create` and
`/payments/bkash/execute`, and only `campusassistant-api`'s server-side
environment holds `BKASH_PROD_APP_SECRET` etc. The app never sees it. This
is already how bKash payments work in this codebase
(`lib/features/bkash/bkash_payment.dart`) — don't change that pattern when
adding new paid integrations.
