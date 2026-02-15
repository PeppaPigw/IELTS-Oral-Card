# IELTS Oral Reviser

A Flutter mobile app for IELTS speaking revision with:

- topic browsing from `IELTS.md`
- one-tap answer show/hide
- light and dark theme
- customizable font size

## UI Preview

### Main Page (Dark Mode)

<img src="docs/3.png" alt="Main Page Dark Mode" width="50%" />

### Main Page (Light Mode)

<img src="docs/4.png" alt="Main Page Light Mode" width="50%" />

### Question Page

<img src="docs/1.png" alt="Question Page" width="50%" />

### Answer Page

<img src="docs/2.png" alt="Answer Page" width="50%" />

## Run

```bash
flutter pub get
flutter run
```

## CI/CD and Release

This repository includes GitHub Actions workflows:

- `.github/workflows/ci.yml`: run `flutter analyze` + `flutter test` on push/PR.
- `.github/workflows/release.yml`: build release artifacts on tags like `v1.0.0`.

### Distribution strategy

- Android users can install from:
  - GitHub Release APK (direct install), or
  - Google Play (recommended for public users).
- iOS users should install from:
  - TestFlight (beta), or
  - App Store (public release).

Direct iOS installation from GitHub downloads is not convenient for normal users.

### Required GitHub Secrets

Android signing:

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_STORE_PASSWORD`
- `ANDROID_KEY_PASSWORD`
- `ANDROID_KEY_ALIAS`

Optional Google Play upload:

- `PLAY_SERVICE_ACCOUNT_JSON`

iOS signing:

- `IOS_CERTIFICATE_P12_BASE64`
- `IOS_CERTIFICATE_PASSWORD`
- `IOS_PROVISIONING_PROFILE_BASE64`
- `KEYCHAIN_PASSWORD`

Optional TestFlight upload:

- `APP_STORE_CONNECT_ISSUER_ID`
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_PRIVATE_KEY`

### Required GitHub Variables

- `PLAY_PACKAGE_NAME` (example: `com.pigpeppa.oral.ielts_oral_reviser`)
- `ENABLE_PLAY_UPLOAD` (`true`/`false`)
- `ENABLE_IOS_RELEASE` (`true`/`false`)
- `ENABLE_TESTFLIGHT_UPLOAD` (`true`/`false`)

### Trigger a release

```bash
git tag v1.0.0
git push origin v1.0.0
```

That will run cloud build/release for Android and (if enabled) iOS/TestFlight.
