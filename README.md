# Workin 🏋️‍♂️

There were no good workout tracking apps that didn’t lock features behind paywalls, so I made one myself.

---

## Features

### 💪 Add Workout templates

### 📱 Log Workout

### 📊 History per workout

---

## Tech Stack

- **Flutter** (Dart) for the UI and app logic.
- **Hive / hive_flutter** for fast, local, offline storage.
- Targets:
  - **Web** (for development / quick testing).
  - **iOS** (running on a physical device via Xcode / `flutter run`).

---

Everything is stored locally in Hive boxes (e.g. `workouts`, `workout_results`).

---

## Getting Started (Development)

### Clone and install dependencies

```bash
git clone <this-repo-url>
cd workin
flutter pub get
flutter run -d chrome
flutter run -d <device_id>
