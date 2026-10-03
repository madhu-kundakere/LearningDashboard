# Learning Dashboard — iOS (SwiftUI)

Login → course dashboard → course details with lesson completion, working offline. iOS 17+, Swift 6 (strict concurrency), English + German.

**Run:** open `LearningDashboard.xcodeproj` and run the `LearningDashboard` scheme. Log in with any valid email and password **`password123`** (any other password shows the error state).
**Test:** `⌘U`, or `xcodebuild test -project LearningDashboard.xcodeproj -scheme LearningDashboard -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`. This runs 25 unit tests and 1 end-to-end UI test.
**Demo switches (launch arguments):** `-mockOffline YES` (simulate no network), `-mockScenario emptyCourses|serverError`, `-AppleLanguages "(de)"`. Screenshots are in `Docs/Screenshots`.

## 1. Architecture
Clean Architecture + MVVM, split into modules inside a local Swift package (`Packages/LearningKit`):

```
App (composition root, routing) ─► AuthFeature, CoursesFeature (SwiftUI views + @Observable view models)
Features ─► Domain (entities, use cases, repository protocols) + DesignSystem + Core
DataLayer (repositories, DTOs, data sources) ─► Domain, Networking, Persistence
```
Package targets enforce the dependency rule, so features cannot import Core Data or networking. View models depend only on use-case protocols, and `AppContainer` is the only place concrete types are created. This keeps every layer unit-testable with simple fakes. Modules can be reused (DesignSystem, Networking, Persistence) and built incrementally. Teams can also own a feature without touching the others.

## 2. Offline support
Core Data with a programmatic model (no `.xcdatamodeld`, so it works cleanly in SPM and supports in-memory stores for tests). The dashboard shows cached courses **immediately**, then refreshes from the API. If the refresh fails, cached data stays on screen with an offline banner. With no cache, the screen shows an error with Retry. Lesson completion writes locally first and is flagged `needsSync`. It is pushed in the background and retried on the next refresh. Lesson completion only ever moves forward, so when server data is merged in, a lesson completed locally is never reverted by an older server response. A cache that fails to load is rebuilt automatically, because it is only a cache.

## 3. Security
Auth tokens are stored in the **Keychain** (`kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`, not synced or backed up), behind a `SecureStore` protocol, never in UserDefaults or logs. In production I would add short-lived access tokens + refresh-token rotation, an auth interceptor that refreshes on 401, ATS/TLS with certificate pinning for the API, and file protection on the cache (already set). On logout the token and the cached course data are wiped.

## 4. Scale (1M users, hundreds of courses)
1. **Pagination + incremental sync:** cursor-paginated `/courses`, `updatedSince` deltas, Core Data batch inserts and fetch batching; lessons loaded lazily per course.
2. **Edge caching:** the catalog is the same for every user, so serve it via a CDN with `ETag`/`If-None-Match`. Per-user progress comes from a separate, small endpoint.
3. **Durable outbox:** promote `needsSync` to a proper outbox with idempotency keys, exponential backoff and `BGTaskScheduler` sync, plus explicit conflict rules across devices.
4. **Observability & safe rollout:** crash/performance metrics (MetricKit), structured logging, feature flags, phased App Store releases, and API version negotiation.
5. **Engineering scale:** more feature modules with clear ownership, CI with test sharding, snapshot tests for DesignSystem, and real API client generated from an OpenAPI spec.

## 5. Second platform — Android
Same layering with Gradle modules (`:core`, `:domain`, `:data`, `:designsystem`, `:feature-auth`, `:feature-courses`). Jetpack Compose UI and `ViewModel` exposing `StateFlow<UiState>` (sealed class mirroring `ViewState`), Hilt for DI, Retrofit/Ktor + kotlinx.serialization, Room as the offline cache (same cache-then-refresh repository), WorkManager for pending-completion sync, tokens encrypted with the Android Keystore (DataStore + Tink), Navigation Compose, and `strings.xml` per locale. Domain use cases and tests translate almost one-to-one.
