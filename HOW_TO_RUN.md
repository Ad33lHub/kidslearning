# How to Run the Kids Learning App

A step-by-step guide to set up, run, and use this Flutter preschool learning app on Android, iOS, and Windows.

---

## 1. Prerequisites

Install the following before you start:

| Tool | Version | Notes |
|------|---------|-------|
| Flutter SDK | 3.0.0 or higher | https://docs.flutter.dev/get-started/install |
| Dart SDK | Bundled with Flutter | Comes with Flutter install |
| Android Studio | Latest | For Android SDK + emulator |
| Xcode | Latest (macOS only) | For iOS builds |
| Visual Studio 2022 | With "Desktop development with C++" workload | For Windows builds |
| Git | Latest | To clone the repo |

Verify your setup:

```bash
flutter doctor
```

Fix every issue `flutter doctor` reports before continuing.

---

## 2. Get the Code

```bash
git clone <your-repo-url>
cd kids
```

---

## 3. Install Dependencies

```bash
flutter pub get
```

This downloads all packages listed in `pubspec.yaml` (Google Mobile Ads, sqflite, flutter_tts, url_launcher, responsive_framework, etc.).

---

## 4. Firebase Setup (Required for Authentication)

The app uses **Firebase Auth** (email/password) and **Google Sign-In**. You must configure Firebase before the app will run.

### Step 1: Install the Firebase CLI and FlutterFire CLI

```bash
# Install Firebase CLI (requires Node.js)
npm install -g firebase-tools

# Log in
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### Step 2: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add project** and follow the wizard
3. Give it a name (e.g. `kids-learning-app`)

### Step 3: Configure the Flutter App

From the project root, run:

```bash
flutterfire configure --project=kids-learning-app-303cc
```

Select **Android** and **iOS** when prompted. This command will:
- Register your app with Firebase
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- **Overwrite** `lib/firebase_options.dart` with real configuration values

### Step 4: Enable Auth Providers in Firebase Console

1. Open your project in [Firebase Console](https://console.firebase.google.com/)
2. Go to **Authentication > Sign-in method**
3. Enable **Email/Password**
4. Enable **Google** — set a support email when prompted

### Step 5: Android — Add SHA-1 Fingerprint (required for Google Sign-In)

Get your debug SHA-1:

```bash
# Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# macOS / Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Then in [Firebase Console](https://console.firebase.google.com/):
1. Go to **Project Settings > Your apps > Android app**
2. Click **Add fingerprint** and paste the SHA-1
3. Re-run `flutterfire configure` to update configuration files

### Step 6: iOS — Additional Setup (macOS only)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Under **Runner > Info > URL Types**, add a URL scheme:
   - **URL Schemes**: your `REVERSED_CLIENT_ID` from `GoogleService-Info.plist`
3. Set the **iOS Deployment Target** to `13.0` or higher in Xcode (General > Deployment Info)

### How Auth Works in this App

- **First login/signup requires internet** (Firebase Auth over network)
- **After first successful login**, Firebase caches the user locally — the parent and children can use the app **offline**
- **Logging out** clears the cached session — internet is needed again to re-authenticate

---

## 5. Run the App

### Run on a connected device or emulator

```bash
flutter run
```

Flutter will auto-detect a connected device. If multiple devices are available, choose one with:

```bash
flutter devices
flutter run -d <device-id>
```

### Run on a specific platform

```bash
flutter run -d android        # Android phone / emulator
flutter run -d ios            # iOS simulator (macOS only)
flutter run -d windows        # Windows desktop
```

### Hot reload while running

- Press `r` in the terminal — hot reload
- Press `R` — hot restart
- Press `q` — quit

---

## 6. Build a Release

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

For smaller per-architecture APKs:

```bash
flutter build apk --release --split-per-abi
```

### iOS (macOS only)

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

### Windows

```bash
flutter build windows --release
```

Output: `build/windows/x64/runner/Release/`

---

## 7. Run the Tests

```bash
flutter test                  # All tests
flutter test test/unit/       # Unit tests only
flutter test test/widget/     # Widget tests only
```

Tests run on the Windows host using `sqflite_common_ffi`, so no emulator is needed.

---

## 8. Static Analysis & Formatting

```bash
flutter analyze               # Lint and analyze
dart format lib/ test/        # Auto-format all Dart files
```

---

## 9. Using the App

Once launched, the app opens on the **Home** tab with a 3-tab bottom navigation:

- **Settings** (left)
- **Home** (center, default) — picks one of four learning modes
- **Privacy Policy** (right)

### The Four Learning Modes

| Mode | What it does |
|------|--------------|
| Let's Start Learning | Static image grids for each category |
| Video Learning | YouTube thumbnails — taps open in browser |
| Look And Choose | Multiple-choice quiz; score shown via motion toast |
| Listen And Guess | Text-to-speech pronounces an item; child picks the matching image |

### The Ten Categories

Alphabet · Numbers · Colors · Shapes · Animals · Birds · Flowers · Fruits · Months · Vegetables

---

## 10. Before Publishing to Play Store / App Store

1. Replace the test AdMob IDs in `lib/utils/app_constrant.dart` with your real ad unit IDs.
2. Update the app icon (`flutter pub run flutter_launcher_icons`).
3. Update `pubspec.yaml` `version:` field.
4. Build a signed release with obfuscation:

   ```bash
   flutter build apk --release --obfuscate --split-debug-info=./debug-info/
   ```

5. Test the release build on a real device before uploading.

---

## 11. Troubleshooting

| Problem | Fix |
|---------|-----|
| `flutter doctor` shows missing Android licenses | `flutter doctor --android-licenses` |
| Gradle build fails | Delete `build/` and `.dart_tool/`, run `flutter clean`, then `flutter pub get` |
| Ads don't appear in debug | Expected — test ads load only on real devices/emulators with Google Play services |
| App crashes on Windows when loading ads | Confirmed handled — `AdHelper` returns `null` on desktop; ads are a no-op there |
| Tests fail with "MissingPluginException" for sqflite | Already handled via `sqflite_common_ffi` in `AppDatabase` — make sure you haven't bypassed it |

---

## 12. Project Structure (Quick Reference)

```
lib/
├── main.dart                       # Entry point
├── bottomnavigation.dart           # 3-tab root scaffold
├── homeScreen.dart                 # Home grid
├── Pages/                          # Entry screens for each learning mode
├── Learning/                       # "Let's Start Learning" category screens
├── VideoLearning/                  # Video mode category screens
├── Quiz/                           # Quiz mode category screens
├── ListenGuessSongs/               # Listen & Guess category screens
├── Alphabetssound/                 # Item detail / pronunciation screens
├── core/db/                        # SQLite (favorites, quiz scores)
└── utils/                          # model.dart, admob.dart, ad_helper.dart, constants
```

Content (images and list builders) is centralized in `lib/utils/model.dart`. All images live in `assets/images/`.

---

Happy building!
