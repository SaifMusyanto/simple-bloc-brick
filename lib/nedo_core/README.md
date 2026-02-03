# Core Architecture

This package provides the core architecture components for the application, based on Clean Architecture principles.

## Features

- **UseCase**: Base class for application use cases using `fpdart` for functional error handling.
- **failures**: Standardized failure classes.
- **exceptions**: Standardized exception classes.
- **l10n**: Localization files, support English and Indonesian (app_en.arb, app_id.arb).

## Dependencies

This package requires the following dependencies to be added to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  equatable: ^2.0.5
  fpdart: ^1.1.0
  intl: ^0.19.0 

# The following section is specific to Flutter packages.
flutter:
  generate: true
```

## Localization

This core module uses `flutter_localizations`. Ensure you have configured `l10n.yaml` and `pubspec.yaml` correctly.

## After run

After you running with the `make nedo-core` command, you need to run `flutter pub get` in your project to install the dependencies. and `flutter gen-l10n` to generate the localization files.