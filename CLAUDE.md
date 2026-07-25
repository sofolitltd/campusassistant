# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Flutter app (Android/iOS/Web) for the Campus Assistant platform — courses/resources, community, real-time chat, clubs/associations, marketplace with bKash payments, subscriptions, and more. Talks to the `campusassistant-api` Go backend. Uses Riverpod for state, GoRouter for navigation, Dio for networking, Drift/sqflite for offline-first local storage, Firebase for push.

## Commands

- `flutter pub get` — install deps
- `flutter run` — run the app
- `dart run build_runner build --delete-conflicting-outputs` — regenerate codegen (freezed models, json_serializable, riverpod_generator, drift). Use `watch` instead of `build` while iterating on models/providers.
- `flutter analyze` — lint (uses `package:flutter_lints/flutter.yaml`; generated `*.g.dart`/`*.freezed.dart` files are excluded)
- No `test/` directory exists — there is currently no automated test suite to run, despite `flutter_test` being a dev dependency.
- Env file: copy `.env.example` to `.env` (gitignored, bundled as a Flutter asset, loaded in `main.dart` via `flutter_dotenv`). Key vars: `BASE_URL`, `API_KEY`, `BKASH_PROD_*`.

## Architecture

**Entry point** `lib/main.dart`: inits Firebase, `FirebaseApi().initBackgroundHandler()`, loads `.env`, inits `MobileAds` (mobile only), sets `PathUrlStrategy` for web, wraps the app in `ProviderScope` (Riverpod root). `MyApp` watches `routerProvider`/`themeProvider`, wires connectivity listening and background sync, and opens a WebSocket keyed to auth state.

**Routing** — `lib/routes/router_config.dart` defines `routerProvider`, backed by a `RouterNotifier` (ChangeNotifier) that listens to `currentUserProvider` and re-evaluates auth-gated redirects (splash → login/home). Bottom-nav tabs use `StatefulShellRoute.indexedStack` + `ScaffoldWithNavBar` (`lib/routes/scaffold_with_navbar.dart`); everything else is flat `GoRoute`s with `parentNavigatorKey: rootNavigatorKey`. Route names/paths are centralized in `lib/routes/app_route.dart`. Web has its own side nav (`lib/routes/web_side_nav.dart`).

**Feature-first structure** under `lib/features/<feature>/`, each typically layered `data/{datasources,models,repositories}`, `domain/{entities,repositories,usecases}`, `presentation/{providers,screens,widgets}` — not every feature has all layers; simpler ones skip domain/usecases. Major features: `auth`, `home`, `study` (courses/chapters/syllabus/library/questions/research), `course`, `syllabus`, `chapter`, `session`, `batch`, `department`, `university`, `teacher`, `staff`, `student`, `cr`, `career`, `marketplace` (products/cart/checkout/orders/merchants/addresses), `community`, `inbox` (chat), `notification`, `notice`, `banner`, `club`, `association`, `alumni`, `blood`, `emergency`, `transport`, `lost_found`, `bookmark`, `resource`, `routine`, `skill`, `subscription`, `bkash` (payment webview), `profile`, `contributor`, `cache`, `migration`. When adding a feature, mirror an existing one of similar complexity (e.g. `club` or `association` for a CRUD-ish feature; `inbox` for anything needing offline-first sync).

**`lib/core/`** — cross-cutting infra: `network` (`api_client.dart`, `api_endpoints.dart`), `cache` (`cache_manager.dart`, `sync_manager.dart`, `offline_first_mixin.dart`, `connectivity_service.dart`), `database` (Drift setup, platform-split connection in `connection/connection_native.dart` vs `connection/connection_web.dart` — web uses sql.js/WASM via `sqflite_common_ffi_web`), `theme` (design tokens), `providers` (global Riverpod providers: theme, is-pro, download counter, app refresh), `websocket`, `ads` (AdMob), `error`, `usecase` (base usecase class), `widgets`.

Other top-level dirs: `lib/services/` (`firebase_api.dart` — FCM), `lib/utils/`, `lib/widgets/` (app-wide shared widgets: webview, YouTube player, image viewer).

## Networking

`lib/core/network/api_client.dart` — a Dio-based `ApiClient`. Every request gets `X-API-Key` (from `dotenv.env['API_KEY']`) and `Authorization: Bearer <token>` (via an injected `getToken()` callback backed by secure storage). A 401 interceptor calls an injected `onUnauthorized` to refresh the token (deduped via an in-flight `Completer` guard) and retries once, skipping `/auth/login` and `/auth/refresh`. Endpoints are centralized in `lib/core/network/api_endpoints.dart`.

**Models**: `freezed` + `json_serializable`, generated per `build.yaml`'s global config (`field_rename: snake`, `include_if_null: false`) — so Dart fields are camelCase, wire JSON is snake_case, and null fields are omitted on serialize. Convention: models in `features/<x>/data/models/`, entities in `features/<x>/domain/entities/`. Riverpod providers using `@riverpod` generate a matching `*.g.dart`.

## Local storage

`flutter_secure_storage` holds auth/session tokens (`lib/features/auth/data/datasources/auth_local_data_source.dart`), consumed by the WebSocket layer and `firebase_api.dart`. Drift (`lib/core/database/app_database.dart`) backs the **offline-first** pattern used for chat and general caching: local DB is the source of truth, kept fresh via WebSocket + background sync on reconnect/app-resume (see `lib/core/cache/sync_manager.dart`, `offline_first_mixin.dart`). `inbox` (chat) is the reference implementation — conversations/messages/outgoing_messages tables with a `pending → sent → delivered → read` status lifecycle; generalize this pattern (via `offline_first_mixin.dart`) rather than inventing a new caching approach per feature.

## Design system

`DESIGN_SYSTEM_V1.md` is the source of truth for all UI tokens (status: "Proposal", but treat as current unless told otherwise) — feature code should consume tokens under `lib/core/theme/`, never hardcode values. Key rules:
- **Colors**: `ColorScheme.fromSeed(seedColor: #6C7BFF)` drives both light/dark — don't hand-roll a separate dark `ColorScheme`. App-specific slots go through an `AppColors` `ThemeExtension` (includes semantic `success`/`warning`/`error`/`info`). Notification-category colors are a separate static `kNotificationColors` map, intentionally unchanged across themes. Legacy `kPrimaryColor`/`kSecondaryColor`/`kContentLightColor`/`kContentDarkColor` constants are deprecated in favor of `colorScheme.*` — don't add new usages.
- **Typography**: primary font `Outfit` via `GoogleFonts.outfit()` (called once at theme construction, never inline in `build()`); `Hind Siliguri`/`Tiro Bangla` for Bengali content. Always pull from `Theme.of(context).textTheme.*`, never raw `TextStyle(fontSize: ...)`.
- **Spacing**: `Spacing` token class (`lib/core/theme/tokens/app_spacing.dart`, `xxs`(2)…`xxxxl`(48)) instead of raw `SizedBox`/`EdgeInsets` numbers.
- **Radius**: `RadiusToken` (`xs`(4)…`full`(999), default `md`=8 for cards/buttons/dialogs).
- **Elevation**: `ElevationToken` (`none`(0)…`xl`(12), default `md`=4 for cards).
- Full component specs (buttons, inputs, cards, dialogs, nav, tabs, snackbars, etc.) live in the doc itself — consult it directly for anything not covered above rather than guessing.

## Firebase / push

`firebase.json` configures FlutterFire for project `campusassistantbd` (Android + web). Only `firebase_core`/`firebase_messaging` are active (`cloud_firestore`/`firebase_auth`/`firebase_storage` are commented out in `pubspec.yaml` — not in use, don't assume they're available). Push is wired through `lib/services/firebase_api.dart`: `initBackgroundHandler()` runs before `runApp`, `initNotifications()` runs on app resume to resync FCM topic subscriptions by university/department/batch.

## Misc

- `replace_batch.py` / `replace_study_page.py` at repo root are disposable one-off migration scripts (hardcoded file paths, specific past refactor) — not part of the standard workflow, safe to ignore.
- `opencode.json` configures MCP servers (`dart mcp-server`, `gopls`) for a different tool (opencode), not Claude Code.
