# AGENTS.md

## Cursor Cloud specific instructions

This is a **Flutter** app ("ELT Hub" / `music_team_app`) — an English/music learning app for students and teachers. It targets web, Android, iOS and Windows, and is backed by a **live Firebase project** (`elt-app-7ca1b`: Auth with email/password + Google, Cloud Firestore, Storage). Source layout: `lib/features/<feature>/...` with shared code in `lib/core/` and `lib/shared/`.

### Toolchain (already installed in the VM snapshot)
- Flutter **3.29.3** (Dart 3.7.2) is installed at `/opt/flutter` and added to `PATH` via `~/.bashrc`. This version is pinned to match the project's `.metadata` revision (`ea121f8859`).
- **Do not upgrade to Flutter 3.32+**: newer Flutter renamed the `ThemeData.cardTheme` type from `CardTheme` to `CardThemeData`, which makes `lib/app/theme.dart` fail to compile. Stay on 3.29.x (Dart `^3.7.2`, per `pubspec.yaml`).

### Common commands (run from repo root)
- Install deps: `flutter pub get` (this is the startup update script).
- Lint: `flutter analyze` — note it exits non-zero due to **pre-existing** warnings/infos (unused declarations, deprecations), but there are **no errors**.
- Test: `flutter test` (currently just a placeholder widget test).
- Run on web (dev): `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`, then open `http://localhost:8080`. The VM has no auto-launchable GUI Chrome device, so use the `web-server` device and a separate browser. First load compiles for ~20-30s.

### Gotchas
- `pubspec.yaml` declares `assets/animations/` but git cannot track empty dirs, so the build (and `flutter test`/`run`) errors with "unable to find directory entry in pubspec.yaml". A tracked placeholder `assets/animations/.gitkeep` keeps the asset path resolvable — keep it.
- Firebase Auth allows `localhost`, so email/password and backend calls work from the local web server. The Firebase config is committed in `lib/firebase_options.dart`; no secrets are needed for local dev.
- **Auth UI caveat (app behavior, not environment):** signing up a brand-new account via the web UI does not reliably reach the home screen. After `createUserWithEmailAndPassword`, the global `AuthBloc` enters `AuthLoading` while fetching the (not-yet-existing) Firestore profile doc, and the router redirects the in-flight role-selection navigation to splash → login. To get an authenticated session for testing, provision a **complete** account (a Firebase Auth user **plus** a matching `users/{uid}` Firestore doc — see `UserModel.toFirestore()` / `AuthService.createUserDocument`) and then log in. A working demo student account: `student.demo@elthub.test` / `DemoPass123!`.
