# Production & Performance Audit

Audit date: 2026-10-17 · Scope: `lib/` (~101k lines, 48 features) · `flutter analyze`: 0 issues.

These are runtime and architecture issues the analyzer can't catch. Work through them batch by batch; tick each box when it's merged, and note the commit.

Severity: 🔴 critical · 🟠 high · 🟡 medium · 🔵 deps/build

---

## Batch 1: Small and safe (~½ day)

<!-- - [ ] **#2 🔴 The WebSocket reconnects after logout**
  - **Where:** [websocket_service.dart](../lib/core/websocket/websocket_service.dart): `disconnect()`, `onDone`, `_scheduleReconnect()`
  - **Problem:** `disconnect()` closes the sink, which fires `onDone`, which calls `_scheduleReconnect()`. `_token` is never cleared, so the reconnect falls back to the stale token, up to 10 times.
  - **Fix:**
    - Add a `_manuallyClosed` flag that `onDone`/`onError` check.
    - Clear `_token` in `disconnect()`.
    - Cancel the old stream subscription. -->

<!-- - [ ] **#4 🔴 The AdMob App ID is Google's test ID**
  - **Where:** [AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml) (`com.google.android.gms.ads.APPLICATION_ID`)
  - **Problem:** The ad unit IDs are real (from `.env`), but the App ID is the test one (`ca-app-pub-3940256099942544~3347511713`).
  - **Fix:** Use the real ID, which is already in the comment next to it (`ca-app-pub-2392427719761726~4483671614`). Better still, inject it through `manifestPlaceholders` so debug builds keep the test ID. Keep it in sync with `lib/core/ads/ad_config.dart`. -->

<!-- - [ ] **#5 🔴 Every API request reads the token from secure storage**
  - **Where:** [di.dart](../lib/core/di.dart) `getToken`, [api_client.dart](../lib/core/network/api_client.dart) `onRequest`
  - **Problem:** Each request makes a Keystore/Keychain platform-channel call.
  - **Fix:** Keep the token in memory and write through to storage on login, refresh and logout. The WebSocket should read it from the same place. -->

<!-- - [ ] **#11 🟠 The theme is rebuilt on every root rebuild**
  - **Where:** [main.dart](../lib/main.dart) `MyApp.build`
  - **Problem:** `buildLightTheme()`/`buildDarkTheme()` run on every build, and there are three duplicated `MaterialApp.router` branches.
  - **Fix:** Build the themes once as top-level `final`s. Use a single `MaterialApp.router` with `themeMode: themeAsync.value ?? ThemeMode.system`.

- [ ] **#12 🟠 Startup work runs one step at a time before `runApp`**
  - **Where:** [main.dart](../lib/main.dart) `main()`
  - **Fix:** Don't `await` `MobileAds.instance.initialize()` (use `unawaited`). Check whether `initBackgroundHandler()` can move after `runApp`.

- [ ] **#15 🟡 Controllers are never disposed**
  - **Where:**
    - `new_student_sign_up_screen.dart`, `new_student_create_account_screen.dart`, `verification_page.dart`, `new_staff_signup_screen.dart`, `new_teacher_signup_screen.dart` (`features/auth/presentation/screens/`)
    - `claim_bottom_sheet.dart` (lost_found)
    - The edit sheets in `discussion_card.dart` and `comment_item.dart` (community)
    - `add_edit_resource_screen.dart`, which creates 11 controllers and disposes 4
  - **Fix:** Add `dispose()`. For the sheet/dialog controllers, dispose after `showModalBottomSheet`/`showDialog` completes. -->

---

## Batch 2: Observability and images (~1 day)

- [ ] **#1 🔴 No crash reporting**
  - **Where:** [main.dart](../lib/main.dart)
  - **Problem:** There is no `FlutterError.onError`, no `PlatformDispatcher.instance.onError`, and no Crashlytics or Sentry.
  - **Fix:** Add `firebase_crashlytics` (Firebase is already set up) and wire both handlers. Turn collection off in debug.
  - **Decision needed:** Crashlytics or Sentry?

<!-- - [ ] **#6 🟠 Images are decoded at full resolution with no disk cache**
  - **Problem:**
    - 31 files use `Image.network`/`NetworkImage`, which never write to disk. Examples: `market_product_card.dart`, `discussion_card.dart`, `notice_card.dart`, `cart_screen.dart`.
    - Of the 48 `CachedNetworkImage` uses, only 1 file sets `memCacheWidth`/`cacheWidth`, so every image is decoded at full resolution.
    - Main risk: out-of-memory kills and scroll jank on low-end Android.
  - **Fix:**
    - Create `lib/core/widgets/app_network_image.dart`: cached, sizes its decode from `LayoutBuilder` × `devicePixelRatio`, with a placeholder and error widget.
    - Migrate all call sites.
    - For avatars: use `CachedNetworkImageProvider` with `ResizeImage`. -->

---

## Batch 3: Perceived speed (largest change)
<!-- 
- [ ] **#3 🔴 The splash screen waits on a network `/me` call**
  - **Where:** [auth_provider.dart](../lib/features/auth/presentation/providers/auth_provider.dart) `CurrentUser.build` / `_checkAuthStatus`
  - **Problem:** Cold start waits 2–15 s on slow networks, even when a cached user exists.
  - **Fix:** If a token and a cached user exist, return the cached user right away, then refresh `/me` in the background and update `state`. Only block on the network when there's no cache.

- [ ] **#9 🟠 Two different caching strategies**
  - **Where:** [offline_first_mixin.dart](../lib/core/cache/offline_first_mixin.dart) is network-first; `course_repository_impl.dart` and others are cache-first with unbounded in-memory `Map`s.
  - **Problem:** In both, the cache write is `await`ed before data is returned.
  - **Fix:**
    - Standardise on stale-while-revalidate (emit the cache, then fetch and emit fresh data), probably as a `Stream`-based helper.
    - Don't await cache writes.
    - Remove the per-repository in-memory maps, or cap them.

--- -->

## Batch 4: Rendering and memory

<!-- - [ ] **#7 🟠 Chat loads the whole conversation**
  - **Where:** [app_database.dart](../lib/core/database/app_database.dart) `ChatDatabase.getMessages()` has no `LIMIT`.
  - **Fix:** Paginate by keyset: `WHERE created_at < ? ORDER BY created_at DESC LIMIT 50`. Load more as the user scrolls up. The index `idx_messages_conv` already supports this.

- [ ] **#8 🟠 JSON parsing runs on the UI isolate**
  - **Where:** `getCachedEntities`/`getCachedEntity` in `app_database.dart`, and Dio's response decoding.
  - **Fix:**
    - Use `Isolate.run` for cached lists over N items.
    - Give Dio a `BackgroundTransformer`, or decode with `Isolate.run`, for large payloads.

- [ ] **#10 🟠 `keepAlive` on parameterised providers grows memory without limit**
  - **Where:** `studentByUserId`, `allStudents`, `courseByCode`, `chaptersForCourse`, and other `@Riverpod(keepAlive: true)` providers that take arguments.
  - **Fix:** Make them `autoDispose` with `ref.keepAlive()` and a timer (cache for N minutes after the last listener leaves).

- [ ] **#13 🟠 The home page builds every section eagerly**
  - **Where:** [home_page.dart](../lib/features/home/home_page.dart)
  - **Problem:** All 9 sections sit in one `Column` inside a `SliverToBoxAdapter`, so all their API calls fire on the first frame.
  - **Fix:** Use a `SliverList.list` so sections below the fold build lazily.

- [ ] **#14 🟠 11 ad-hoc `Dio()` instances and the `http` package bypass `ApiClient`**
  - **Where:**
    - `content_card.dart:930`, `resource_card.dart:1108`
    - `teacher_details_screen.dart:116`, `staff_details_screen.dart:93`
    - `syllabus_card.dart:272`, `discussion_card.dart:692`, `image_viewer.dart:42`
    - `full_media_viewer.dart:57`, `job_image_gallery.dart` (dio and http)
    - `app_pdf_viewer.dart` (http), `firebase_api.dart` (http)
  - **Fix:** Add one shared download client (a provider) with sensible timeouts. Remove the `http` dependency.

- [ ] **#21 🟡 Every card rescans the bookmark list and watches the whole profile**
  - **Where:** `resource_card.dart:123-160`, `content_card.dart:87-105`
  - **Fix:** Add a `bookmarkedIdsProvider` that returns a `Set<String>`. Use `.select((s) => s.contains(id))`, and select only `uid` from the profile. -->

---

## Batch 5: Correctness and robustness

<!-- - [ ] **#16 🟡 The WebSocket has further problems**
  - **Where:** [websocket_service.dart](../lib/core/websocket/websocket_service.dart)
  - **Fix:**
    - Guard `connect()` with an `_connecting` flag or Completer, since two concurrent calls can open two channels.
    - Add jitter to the backoff.
    - Skip reconnects while offline, and reconnect when connectivity returns.
    - Reset the attempt counter on resume.
    - Use the secure storage provider instead of `const FlutterSecureStorage()`.

- [ ] **#17 🟡 The `SyncManager` timer is a no-op**
  - **Where:** [sync_manager.dart](../lib/core/cache/sync_manager.dart)
  - **Problem:**
    - `isFresh('teacher')` never matches the real keys (`teacher_<key>`).
    - `PATCH` is sent as `PUT`.
    - Failed syncs retry forever with no backoff.
  - **Fix:**
    - Remove the stale-check loop, or make it real; keep the pruning.
    - Add `ApiClient.patch`.
    - Cap `retryCount` and add a dead-letter status.

- [ ] **#18 🟡 The refresh flow drops a rotated refresh token**
  - **Where:** [di.dart](../lib/core/di.dart) `onUnauthorized`
  - **Fix:** If the response contains `refresh_token`, store it too.

- [ ] **#19 🟡 No retry for transient errors; upload timeout too short**
  - **Where:** [api_client.dart](../lib/core/network/api_client.dart)
  - **Fix:**
    - Retry idempotent GETs on timeout or connection error, with backoff.
    - Give uploads and downloads their own longer `receiveTimeout`/`sendTimeout`.

- [ ] **#27 🟡 ~50 hand-written `.family` providers never dispose** (found while doing #10)
  - **Where:** `FutureProvider.family` without `.autoDispose` across marketplace, career, club, association, routine, lost_found, session, … (`grep -rn "Provider.family" lib | grep -v autoDispose`). Worst growers are per-id detail providers: `productDetailsProvider`, `orderDetailsProvider`, `careerJobByIdProvider`, `circularDetailProvider`, `userProfileByUidProvider`, `entityDetailProvider`.
  - **Fix:** Same as #10: `.autoDispose.family` + `ref.cacheFor(kParamProviderCacheTime)` from `core/providers/cache_for.dart`.

- [ ] **#20 🟡 Community realtime is dead code**
  - **Where:** `community_repository.dart` `subscribeToRealtime()` is never called, and its `listen` is never cancelled.
  - **Fix:** Wire it up with a stored subscription that is cancelled on dispose, or delete it. -->

---

## Batch 6: Dependencies, build, web, tests

- [x] **#22 🔵 Pre-release and end-of-life packages**
  - `flutter_local_notifications: ^23.0.0-dev.3` is a dev release; pin a stable version.
  - `sqlite3_flutter_libs: ^0.6.0+eol` is end-of-life; check Drift's current recommendation.

- [ ] **#23 🔵 Duplicate and unused packages**
  - **Fix:**
    - Remove `flutter_spinkit` (0 uses).
    - Pick one PDF engine: `pdfx` (3 files) or `syncfusion_flutter_pdfviewer` (1 file). Syncfusion is large and needs a commercial licence.
    - Drop `http` after #14.
    - Long term, consider moving the chat DB from sqflite to Drift (one SQLite stack).

- [x] **#24 🔵 Android size**
  - Ship the AAB to Play, or use `--split-per-abi` for sideloaded APKs.
  - Move `icon_foreground.png` and `icon_monochrome.png` out of `assets/images/`; only the launcher-icon generator needs them, and they add ~310 KB to the bundle.

- [x] **#25 🔵 Web: no deferred loading**
  - **Where:** [router_config.dart](../lib/routes/router_config.dart) eagerly imports about 120 screens.
  - **Fix:** Use `deferred as` imports for heavy, rarely used routes (marketplace seller tools, PDF tabs, migration, developer, career).

- [ ] **#26 🔵 No tests or CI**
  - **Fix:**
    - Add `test/` with unit tests for `ApiClient` refresh, `SyncManager`, the WebSocket lifecycle and the router redirect.
    - Add a CI workflow that runs `flutter analyze`, the tests and `scripts/check_colors.sh`.

---

## Progress log

| Date | Item(s) | Commit | Notes |
|---|---|---|---|
| 2026-10-17 | #2 | — (uncommitted) | `_manuallyClosed` flag, token cleared, subscription cancelled, no stale-token fallback, handshake race guarded |
| 2026-10-17 | #11 | — (uncommitted) | Themes built once as top-level finals; single `MaterialApp.router` with `themeMode: value ?? system` |
| 2026-10-17 | #12 | — (uncommitted) | `MobileAds.initialize()` unawaited; `initBackgroundHandler` kept before `runApp` (only registers a callback; FCM requires it early) |
| 2026-10-17 | #15 | — (uncommitted) | `dispose()` added to 5 auth screens; claim sheet controller moved into its State; edit post/comment use new `core/widgets/text_controller_scope.dart`. `add_edit_resource_screen` was a false positive (disposes its map in a loop) |
| 2026-10-17 | #4 | — (uncommitted) | Manifest App ID is now `${admobAppId}`, injected by `build.gradle.kts` from the `ADMOB_ANDROID_APP_ID` dart-define (same `.env` as the unit IDs), test ID fallback. Verified in merged debug manifest with `.env` |
| 2026-10-17 | #6 | — (uncommitted) | New `core/widgets/app_network_image.dart` (disk cache + decode at display size via a cover-aware resize provider). Migrated 25 `Image.network`, 13 `NetworkImage` (→ `AppNetworkImage.provider`), 27 `CachedNetworkImage`. 5 `imageBuilder` sites got `memCacheWidth`. Fullscreen/zoom viewers (`full_image`, `image_viewer`, `full_media_viewer`, gallery `InteractiveViewer`) intentionally left full-res |
| 2026-10-17 | #7 | — (uncommitted) | `ChatDatabase.getMessages` keyset-paginated (50/page, `before:`). `loadMore` reads older pages from SQLite first, then the server, deduped by id; cursor derived from the oldest loaded message at full precision (the server's `nextCursor` is truncated to seconds) — also fixes cache-seeded chats refetching the newest page on scroll-up |
| 2026-10-17 | #8 | — (uncommitted) | Cache reads decode via `compute()` above 50 KB. Dio needed nothing: 5.11's default `FusedTransformer` already decodes ≥50 KB bodies off the UI isolate |
| 2026-10-17 | #10 | — (uncommitted) | `courses`, `courseByCode`, `studentByUserId`, `allStudents`, `chaptersForCourse`, `resourcesList` → autoDispose + new `ref.cacheFor()` (5 min after last listener). Hand-written families split out as #27 |
| 2026-10-17 | #13 | — (uncommitted) | Home sections in a `SliverList.list`, each wrapped in `KeepAlive` so they build lazily but aren't torn down/refetched (or the banner ad reloaded) on scroll-back |
| 2026-10-17 | #14 | — (uncommitted) | New `core/network/download_client.dart` (`downloadClient` + `downloadBytes()`); all 11 sites migrated; `http` removed from pubspec. Top-level, not a provider, because the FCM handler has no `ref` |
| 2026-10-17 | #21 | — (uncommitted) | `resourceBookmarkIdsProvider` (entityId → bookmarkId; a Map not a Set since cards need the id to remove). Cards select their own entry and only `uid` from the profile; no more `setState` in `build`. Fixes `content_card` never showing an existing bookmark (it only `listen`ed) |
| 2026-10-17 | #16 | — (uncommitted) | In-flight `connect()` shared via a future, plus a generation counter so a handshake that started before `disconnect()` drops its socket even after a fast re-login; equal jitter on the 3–30 s backoff; reconnects held while offline and resumed (attempts reset) when connectivity returns or the app resumes. Secure storage was already done by #5 (`TokenStore`) |
| 2026-10-17 | #17 | — (uncommitted) | Stale-check loop removed (it could only log), pruning kept. `ApiClient.patch` added and used. Real bug was worse than listed: `failed` rows were never re-read, so failed writes were stranded, not retried forever. Now: stays `pending` up to 5 attempts then `dead`; 4xx (not 408/429) dead-letters at once; a network error ends the pass without counting. Legacy `failed` rows are picked up again |
| 2026-10-17 | #18 | — (uncommitted) | Rotated `refresh_token` stored when present; refresh Dio got 15 s timeouts |
| 2026-10-17 | #19 | — (uncommitted) | GETs retried twice (0.5 s, 1.5 s) on connect/receive timeout, connection error, 502/503/504 — after the auth interceptor, so 401s still refresh. Any `FormData` body gets 2 min send/receive timeouts (covers `uploadFile`/`uploadBytes` and community's own multipart post) |
| 2026-10-17 | #20 | — (uncommitted) | Deleted: the backend never emits `new_post`, and nothing read `onPostUpdate`. `CommunityRepository` no longer takes the WebSocket service |
| 2026-10-17 | #27 | — (uncommitted) | All 51 `FutureProvider.family` → `.autoDispose.family` + `ref.cacheFor(kParamProviderCacheTime)`. Left alone: chat's `NotifierProvider.family`, community's `StateNotifierProvider.family` (live UI state) and session's cheap `Provider.family` |
| 2026-10-17 | #22 | — (uncommitted) | `flutter_local_notifications` pinned to stable `^22.3.2` (no API changes needed). `sqlite3_flutter_libs` removed: the `+eol` release is an empty stub, and `sqlite3` 3.x (already resolved via Drift 2.35) bundles SQLite itself through build hooks |
| 2026-10-17 | #23 (partial) | — (uncommitted) | `flutter_spinkit` removed; `http` already gone with #14. **PDF engine still open:** `pdfx` can't go (it rasterises pages for resource and job-attachment thumbnails, which Syncfusion's viewer can't), so consolidating means moving `PdfViewerPage` from Syncfusion to `pdfx` — loses scroll head, pagination dialog and the web streaming path. Needs a product call. sqflite→Drift for chat still long-term |
| 2026-10-17 | #24 | — (uncommitted) | Launcher-only icons moved to `assets/launcher/` (not bundled). `make build-apk-split` added; Play releases already use `make build-appbundle` |
| 2026-10-17 | #25 | — (uncommitted) | New `core/widgets/deferred_page.dart`. Deferred: create/edit job, merchant apply/manage (+loader), add/edit resource, developer, contributors, cache management — each only imported by the router. Career stays eager (it's a tab). **Verified build:** the JS fallback splits into `main.dart.js_*.part.js`, but the `--wasm` output is still one `main.dart.wasm` (7.4 MB) — dart2wasm doesn't split here, so wasm users see no gain yet |
| 2026-10-17 | #26 (partial) | — (uncommitted) | `test/`: `ApiClient` (single shared refresh, retry with new token, login exempt, GET-only transient retry), `SyncManager` (in-memory Drift; order, offline, 4xx dead-letter, 5xx retry cap, network stop), router redirect (logic extracted to pure `routes/route_guard.dart`). 23 tests. `.github/workflows/ci.yml`: build_runner freshness, analyze, test, colour ratchet. **WebSocket lifecycle tests not written yet** |
