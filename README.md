# QuickNotes — Simple Note Taking App

A mobile note-taking app built with Flutter, featuring persistent storage, a clean UI, and modern features like dynamic theming and swipe actions.

## 🎯 Project Goal

To build a functional and beautiful mobile note-taking app using Flutter, implementing core features like CRUD operations, local storage, and a responsive UI, along with several bonus enhancements.

---

## ✅ Features Implemented

### Core Features
- [x] **Create a note** (with title and description)
- [x] **View a list of saved notes** in a clean, card-based layout.
- [x] **Edit and delete a note**.
- [x] **Persist notes using local storage** (`shared_preferences`).
- [x] **Simple and responsive UI** that works on various screen sizes.
- [x] **View note details** on a separate screen.
- [x] **Search/filter notes** by title and description.
- [x] **State management** using `Provider`.

### Bonus Features
- [x] **Add tags and categories** to notes for better organization.
- [x] **Dark mode toggle** with dynamic theming using `FlexColorScheme`.
- [x] **Swipe-to-delete** with an "UNDO" action.
- [x] **Pin important notes** to keep them at the top.
- [x] **Custom splash screen** for a better user experience.

---

## 🛠️ Tech Stack

- **Framework**: Flutter (Latest Stable Version)
- **State Management**: `Provider`
- **Local Storage**: `shared_preferences`
- **Theming**: `flex_color_scheme`
- **UI Components**: `flutter_slidable`

---

## ✔️ Acceptance Criteria

- **Functional Features**: All core and bonus features are implemented and bug-free.
- **Clean UI/UX**: The app has a clean, organized, and intuitive user interface.
- **Organized Project Structure**: The codebase follows a standard Flutter project structure, separating UI, logic, and models.
- **Code Readability**: The code is well-commented and follows best practices for readability.
- **No Hardcoded Values**: Constants are used for strings, padding, and other values to avoid magic numbers.
- **Local Storage**: Notes are persisted locally and are available across app sessions.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.9.0 or higher)
- An IDE like Android Studio or VS Code with the Flutter plugin.
- An Android/iOS emulator or a physical device.

### Installation
1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/quicknotes.git
    cd quicknotes
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the app:**
    ```sh
    flutter run
    ```

### Building the APK

To create smaller, optimized APKs for different device architectures, this project uses the `--split-per-abi` flag.

```sh
flutter build apk --release --split-per-abi
```

This generates the following files in `build/app/outputs/flutter-apk/`:
- `app-armeabi-v7a-release.apk` (14.2MB)
- `app-arm64-v8a-release.apk` (16.7MB)
- `app-x86_64-release.apk` (17.8MB)

### ProGuard Configuration

To further reduce app size and obfuscate the code, ProGuard is enabled for release builds. The configuration is stored in `android/app/proguard-rules.pro`:

```
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**
```

---

## 🎥 App Demo

A video demonstrating the app's features is available in the repository.

[Link to Video](assets/videos/QuickNotes_video.mp4)
