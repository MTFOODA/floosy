# Floosy

Floosy is a Flutter personal finance app for tracking transactions and expenses, managing cash and budgets, and reviewing spending activity. It supports Arabic and English.

## Key features

- Track transactions and expenses, including bank SMS detection on Android and Shortcuts-based bank message import on iPhone (iOS 16+).
- Manage cash balances and reusable expense items.
- Set budgets and review spending analytics.
- Use an in-app AI chat interface.
- Switch between Arabic and English, including right-to-left Arabic layouts.

## Technology stack

- **Flutter and Dart** for the application.
- **Clean Architecture** with **flutter_bloc (Cubit)** for state management and **GoRouter** for navigation. See [architecture documentation](docs/architecture.md).
- **Supabase** for authentication and remote data.
- **Drift and SQLite** for local data storage.

## Prerequisites and setup

- Flutter 3.13.0 or later and Dart 3.1.0 or later.
- Android SDK for building or running the Android app.
- A Supabase project.

```bash
git clone https://github.com/MTFOODA/floosy.git
cd floosy
flutter pub get
```

Configure Supabase as described below, then start the app on a connected device or emulator:

```bash
flutter run
```

For the database schema and backend setup, follow the [Supabase setup guide](supabase/README.md).

## Required configuration

The app reads its Supabase credentials from constants in `lib/config/supabase_config.dart`. Set `url` to your project's URL and `publishableKey` to its publishable (anon) key:

```dart
class SupabaseConfig {
  static const String url = 'https://<project-ref>.supabase.co';
  static const String publishableKey = '<supabase-publishable-or-anon-key>';
}
```

Use only a client-safe publishable/anon key; never put a service-role key in the app. App startup does not load an `.env` file.

## Validation and builds

Check the application source:

```bash
flutter analyze
```

Build a release APK for Android:

```bash
flutter build apk --release
```

To install a personal test build on an iPhone from Windows, see the [iPhone installation guide](docs/iphone-installation.md). For real incoming messages on iPhone, enable [Shortcuts message import](docs/ios-bank-messages.md). Direct SMS inbox reading is implemented for Android only.
