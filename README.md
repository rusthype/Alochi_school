# A'lochi Maktab

School management cross-platform app built with Flutter. Targets Android, iOS, Windows, macOS, Web, and Tablet.

Backend: Django REST API at `https://api.alochi.uz` with JWT Bearer auth.

---

## Prerequisites

- Flutter 3.41.4+ (`flutter --version`)
- Dart 3.x
- For Android: Android Studio + SDK (API 21+)
- For iOS: Xcode 15+ (macOS only)
- For Windows: Visual Studio 2022 with "Desktop development with C++" workload
- For macOS: Xcode 15+

---

## Setup

```bash
cd alochi_maktab
flutter pub get
```

---

## Running

```bash
# Chrome (web)
flutter run -d chrome

# Android device/emulator
flutter run -d android

# iOS simulator (macOS only)
flutter run -d ios

# macOS desktop
flutter run -d macos

# Windows desktop
flutter run -d windows
```

---

## Building

### Android APK

```bash
flutter build apk --release --split-per-abi
# Output: build/app/outputs/flutter-apk/
```

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA (requires macOS + Xcode)

```bash
flutter build ios --release
# Then archive and export via Xcode
```

### Web

```bash
flutter build web --release --web-renderer canvaskit
# Output: build/web/
```

### Windows

```bash
flutter build windows --release
# Output: build/windows/x64/runner/Release/
```

### macOS

```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/alochi_maktab.app
```

---

## CI/CD

GitHub Actions workflow at `.github/workflows/flutter-release.yml` automatically builds Android, Web, Windows, and macOS artifacts and creates a GitHub Release when a `v*` tag is pushed.

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## Project Structure

```
lib/
  app/           # Router, theme, app bootstrap
  core/
    api/         # Dio HTTP client, auth + school API services
    storage/     # flutter_secure_storage wrapper
    utils/       # score_color, avatar_color, i18n
  features/
    auth/        # Login screen + auth state (Riverpod)
    shell/       # Adaptive layout (sidebar/bottom nav)
    dashboard/   # Overview, charts, top students
    classes/     # Class cards CRUD
    students/    # DataTable2 with filters + search
    teachers/    # Teacher grid with stats
    org/         # Staff directory with role filters
    bsb/         # BSB test results table
    schedule/    # Weekly timetable grid
    attendance/  # Per-student present/absent/late
    tasks/       # Kanban board (Todo/In Progress/Done)
    messages/    # Split-panel chat
    settings/    # Profile, School, Language, Security tabs
  shared/
    constants/   # Color tokens
    widgets/     # StatCard, AvatarWidget, BadgeWidget, EmptyState
```

---

## Architecture

- **State**: `flutter_riverpod` `StateNotifierProvider`
- **Navigation**: `go_router` with `ShellRoute` + redirect guard
- **HTTP**: `dio` with JWT attach + auto-refresh on 401
- **Storage**: `flutter_secure_storage` (encrypted) for access/refresh tokens
- **Charts**: `fl_chart` BarChart
- **Tables**: `data_table_2` DataTable2

### Score Colors

| Score | Color   |
|-------|---------|
| ≥90   | Green   |
| 75–89 | White   |
| 60–74 | Yellow  |
| <60   | Red     |

### Security

- Role (`lavozim`) field is **read-only** — never editable in UI, never sent in PATCH
- JWT access token auto-refreshed on 401; on refresh failure, user is logged out
- Tokens stored in encrypted secure storage (Android `EncryptedSharedPreferences`, iOS Keychain)

---

## Backend API

Base URL: `https://api.alochi.uz/api/v1`

Key endpoints used:

| Method | Path | Description |
|--------|------|-------------|
| POST | `/users/login/` | Login → access + refresh tokens |
| POST | `/auth/token/refresh/` | Refresh access token |
| GET | `/users/me/` | Current user profile |
| PATCH | `/users/me/` | Update profile (role excluded) |
| GET | `/school/dashboard/` | Dashboard stats |
| GET/POST | `/school/classes/` | Class list + create |
| GET | `/school/students/` | Student list |
| GET | `/school/teachers/` | Teacher list |
| GET | `/school/org/` | Staff/org directory |
| GET | `/school/bsb/` | BSB test results |
| POST | `/school/attendance/` | Save attendance |
| GET | `/school/tasks/` | Task list |
| GET | `/school/messages/` | Messages |

CORS must allow `localhost:*` for web development and `alochi.uz` for production web.

---

## Lint

```bash
flutter analyze
```

---

## Tests

```bash
# Unit + widget tests
flutter test

# Integration tests (requires device/emulator)
flutter test integration_test/app_test.dart
```
