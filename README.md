# Passworthy

[![License: BSD-3-Clause][license_badge]][license_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

![Passworthy Banner][passworthy_banner]

In a sentence - Simple yet secured password manager application.

Passworthy is a no-frills, offline password manager designed for privacy-conscious users. It securely stores passwords locally on your device, ensuring that only you have access to your credentials.

Unlike cloud-based managers, Passworthy requires no logins, no accounts, and no internet connection — your passwords remain encrypted and protected, without compromise.

_\*\* Password icon by [Solar Icons][solar_icons] from [SVG Repo][svg_repo], licensed under CC Attribution License._

## Mission

To provide a **secure**, **lightweight**, and **privacy-first password manager** that is accessible to everyone, without the need for cloud storage or subscriptions.

Passworthy exists to serve those who value control over their data, offering a simple yet powerful tool for managing credentials without compromise.

## Why Passworthy?

Most password managers push you toward cloud storage, paid subscriptions, and data tracking. Passworthy takes a different approach—one that puts you in full control.

- 🔒 **Offline & Secure** – Your passwords are stored only on your device, encrypted for maximum security.
- ⚡ **Fast & Lightweight** – No unnecessary bloat, just a simple and efficient password manager.
- 🚫 **No Tracking, No Ads** – Your data is yours. No hidden analytics, no profiling, no third-party access.
- 🛠️ **Open-Source & Transparent** – Built for privacy-first users, with source code available for review.

## Feature & Roadmap

Below is a breakdown of the initial release features and upcoming enhancements. We are actively improving Passworthy and would love to hear from the community! If you have feature suggestions or priorities, feel free to contribute or open a discussion.

### 🚀 Initial Release (Tentative Date: Early 2024)

- 🔹 Secure local storage for passkeys and passwords (PBKDF2 and AES encryptions)
- 🔹 Add, Update and Delete passwords (in other name, entries)
- 🔹 Search (with account and usernames), and Copy to clipboard
- 🔹 Minimal and Intuitive UI

### 🌟 Near-Term Updates (Coming Soon)

- 🔹 Favorites and Reordering
- 🔹 Auto-lock and Biometric Authentication
- 🔹 Improved UI/UX and Multiple Theme
- 🔹 Folders, Categorization, or Tagging for better Organization
- 🔹 Store Secure Notes and Sensitive Information (e.g., Bank Details, Recovery Codes)
- 🔹 Custom Filtering

### 👀 Long-Term Vision

- 🔹 Cloud Sync (Optional, maybe Self-hosted, End-to-End Encryption)
- 🔹 Multi-device Support
- 🔹 Password sharing with other Users

## Disclaimer

- ⚠️ Passworthy is **under active development**. Expect bugs, missing features, and breaking changes.
- ⚠️ **Do not rely on Passworthy as your sole password storage solution.** Always keep a backup of your important credentials.
- ⚠️ **Your data stays offline and is not recoverable if lost.** If you forget your passkey or uninstall the app, there is no way to retrieve your stored data.

## Getting Started

### Prerequisites

**Required Versions:**

- Flutter: >=3.24.0
- Dart: >=3.0.0

Before running the application, you need to set up the environment variables:

Copy `.env.example` to `.env.development`, `.env.staging`, `.env.production` and configure the following variables:

> [!NOTE]
> This application contains 3 flavors: development, staging, production. Each flavor has its own environment variable setup.

```env
# The ObjectBox is going to use this directory to keep the user defined entries
OBJECTBOX_STORE_DIRECTORY_PATH = objectbox_store_diretory
# Flutter Secure Storage is going to use this key to persist the encrypted passkey
PASSKEY_STORAGE_KEY = passworthy_storage_key
```

At the end, don't forget to run the `build_runner` command:

```sh
$ dart run build_runner build --delete-conflicting-outputs
```

---

## Running Tests

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov][lcov_github].

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

For more details on how to add strings, supported locales, and translations into the app, read the [VGV Documentation][very_good_localizations].

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE][license_link] file for details.

## Security

If you discover a security vulnerability within this project, please check the [SECURITY][security_link] for more information.

[passworthy_banner]: ./design/passworthy_banner.jpg
[solar_icons]: https://www.figma.com/community/file/1166831539721848736?ref=svgrepo.com
[svg_repo]: https://www.svgrepo.com/
[license_badge]: https://img.shields.io/github/license/thisissandipp/passworthy
[license_link]: https://github.com/thisissandipp/passworthy/blob/main/LICENSE
[security_link]: https://github.com/thisissandipp/passworthy/blob/main/SECURITY.md
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[lcov_github]: https://github.com/linux-test-project/lcov
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[very_good_localizations]: https://cli.vgv.dev/docs/templates/core#working-with-translations-
