# 🌳 Tree

A personal life tracker built with Flutter. Track your budgets, tasks, plans, projects, habits, movies, songs, weight — anything you want to keep tabs on, all in one place.

## What is Tree?

Tree is a project designed to be a single app where you can organize and monitor every aspect of your life. Like branches on a tree, each area of your life grows from one central place.

### Current Features

- **Budget & Finance Tracking** — Log transactions, manage wallets, track spending with charts and graphs
- **Cloud Sync & Backup** — Google Sign-In with automatic Google Drive backups
- **Home Screen Widgets** — Quick-add transactions and view net worth at a glance
- **Notifications & Reminders** — Daily reminders to log your expenses
- **Multi-language Support** — Localized via Easy Localization
- **Biometric Lock** — Secure your data with fingerprint/face authentication
- **CSV Export** — Export your data for use anywhere
- **Dark Mode** — Full theme support

### Planned / In Progress

- Task & project management
- Habit tracking
- Media logging (movies, songs, books)
- Weight & health tracking
- General-purpose life logging

## Tech Stack

| Layer        | Technology                          |
|--------------|-------------------------------------|
| Framework    | Flutter (Android, iOS, Web)         |
| Database     | Drift (SQLite)                      |
| Auth         | Firebase Auth + Google Sign-In      |
| Cloud Sync   | Cloud Firestore + Google Drive API  |
| State        | Provider                            |
| Notifications| flutter_local_notifications         |

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- A Firebase project with Android/iOS/Web apps configured
- `google-services.json` in `android/app/`
- `GoogleService-Info.plist` in `ios/Runner/`
- A `.env` file in the project root with your Firebase config (copy `.env.example` and fill in values)

### Run

```bash
flutter pub get
flutter run
```

### Build

```bash
flutter build apk        # Android
flutter build ios         # iOS
flutter build web         # Web
```

## Project Structure

```
lib/
├── main.dart             # App entry point
├── colors.dart           # Theme & color definitions
├── functions.dart        # Shared utility functions
├── database/             # Drift database tables & queries
├── pages/                # App screens
├── struct/               # Core logic (auth, sync, settings)
└── widgets/              # Reusable UI components
```

## CI/CD

All pipelines run via **GitHub Actions** (Android only for now).

| Workflow | File | Trigger | What it does |
|---|---|---|---|
| Analyze & Test | `analyze_test.yml` | PR / push to `master` | Runs `flutter analyze` and `flutter test` |
| Build Verification | `build.yml` | PR / push to `master` | Builds debug APK, uploads as artifact |
| Firebase Distribution | `distribute.yml` | Push to `master` | Builds release APK, uploads to Firebase App Distribution |
| Release Build | `release.yml` | Tag `v*` | Builds signed APK, creates GitHub Release |

### Required GitHub Secrets

Set these in **Settings → Secrets and variables → Actions**:

| Secret | Used by | Description |
|---|---|---|
| `ENV_FILE` | All workflows | Full contents of your `.env` file |
| `KEYSTORE_BASE64` | Release | Base64-encoded `.jks` keystore |
| `KEY_ALIAS` | Release | Keystore key alias |
| `KEY_PASSWORD` | Release | Keystore key password |
| `STORE_PASSWORD` | Release | Keystore store password |
| `FIREBASE_APP_ID` | Distribute | Firebase Android App ID |
| `CREDENTIAL_FILE_CONTENT` | Distribute | Firebase service account JSON |

### Creating a release

```bash
git tag v5.4.4
git push --tags
```

## Contributing

1. Create a new branch from `master` for your feature or fix
2. Make your changes and test locally
3. Open a pull request with a clear description of what you changed and why
4. Get at least one review before merging

Keep commits focused and descriptive. If you're working on a new tracker module (e.g. habits, movies), coordinate with the team to avoid conflicts.

## License

All rights reserved.
