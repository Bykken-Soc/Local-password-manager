# Desktop Password Manager

A lightweight, secure desktop password manager built with Flutter and Drift (SQLite). This application allows users to store, retrieve, categorize, update, and delete credentials locally on desktop operating systems.

---

## Features

* Local SQLite database powered by Drift for fast and structured offline data storage.
* Full CRUD operations: create, read, update, and delete stored passwords.
* Category filtering to group credentials by context (e.g., Personal, Work, Social).
* Field length constraints ensuring strong stored passwords (minimum 6 characters, maximum 32 characters).
* Reactive UI updates using Drift Streams.

---

## Prerequisites

Before setting up the project, make sure your development environment meets the following requirements:

* Flutter SDK (stable channel, version 3.19 or later recommended).
* Dart SDK included with the Flutter installation.
* Visual Studio 2022 (or Build Tools for Visual Studio) with the "Desktop development with C++" workload installed for Windows builds.
* Visual Studio Code or Android Studio with Flutter/Dart extensions installed.

Important Windows consideration: keep the project folder path short and avoid spaces or special characters in the directory path to prevent Windows MAX_PATH (260 characters) compilation errors with CMake.

---

## Project Structure

## Project Structure

```text
final_project_desktop/
├── lib/
│   ├── db/
│   │   ├── app_db.dart                  # Drift database configuration and table definitions
│   │   └── app_db.g.dart                # Auto-generated Drift code
│   ├── models/
│   │   └── password_model.dart          # Credential data model and serialization logic
│   ├── providers/
│   │   ├── password_provider.dart       # Form UI state management (create/save workflows)
│   │   └── theme_provider.dart          # Theme toggle and SharedPreferences persistence
│   ├── repositories/
│   │   └── repositories_password.dart   # AES-256 encryption/decryption & Drift coordination
│   ├── services/
│   │   ├── app_router.dart              # GoRouter route declarations and navigation mapping
│   │   └── service_locator.dart         # GetIt dependency injection setup
│   ├── Theme/
│   │   └── app_theme.dart               # Light and Dark Material 3 theme configurations
│   ├── views/
│   │   ├── add_passwords.dart           # Credential creation form screen
│   │   ├── block_screen.dart            # Master password lock & factory reset screen
│   │   ├── details_screen.dart          # Credential detail viewing and editing screen
│   │   └── home_screen.dart             # Main dashboard, category filters & clipboard actions
│   ├── widgets/
│   │   └── themebotton.dart             # Theme toggle icon button component
│   └── main.dart                        # Application bootstrap, locator setup & root widget
├── windows/                             # Native Windows desktop runner files and CMake scripts
├── pubspec.yaml                         # Project dependencies and asset declarations
└── README.md                            # Documentation and project overview
```

---

## Database Configuration

The application uses Drift with SQLite. The database schema is defined as follows:

* id: auto-incrementing integer serving as the primary key.
* password: text field with a length restriction between 6 and 32 characters.
* site: text field for the service URL, application, or website name.
* Category: text field indicating the grouping category.

---

## Setup and Installation

Follow these steps in order to install dependencies and run the application.

### 1. Clone or Open the Project

Open a terminal and navigate to the project directory containing the pubspec.yaml file:

```bash
cd path/to/your/project

```

### 2. Install Dependencies

Download all required packages defined in pubspec.yaml:

```bash
flutter pub get

```

Key packages required:

* drift and drift_flutter (runtime database support)
* sqlite3_flutter_libs (native SQLite binaries)
* drift_dev and build_runner (in dev_dependencies for code generation)

### 3. Generate Database Code

Because Drift relies on compile-time code generation, you must generate the companion classes and queries (app_database.g.dart) before the project can compile:

```bash
dart run build_runner build --delete-conflicting-outputs

```

If you plan to modify the database schema during development, you can keep the code generator running in watch mode:

```bash
dart run build_runner watch

```

### 4. Run the Application

Start the desktop application in debug mode:

```bash
flutter run -d windows

```

---

## Troubleshooting

### 1. CMakeCache.txt Directory Mismatch

* Cause: moving the project to a new directory while cached build artifacts from the previous path still exist.
* Solution: run `flutter clean`, followed by `flutter pub get`, then rerun `flutter run -d windows`. If issues persist, manually delete the `build/` folder and `windows/flutter/ephemeral/`.

### 2. build_runner Writes 0 Outputs

* Cause: the database file is not located within `lib/`, the `part` directive does not strictly match the file name, or the database class lacks the `@DriftDatabase` annotation.
* Solution: ensure your file contains `part 'app_database.g.dart';` (matching the exact casing of your file) and that the database file is inside the `lib/` directory.

### 3. Native C++ Compilation Errors (sqlite3_flutter_libs_plugin.cpp)

* Cause: path length exceeding the default Windows MAX_PATH limit (260 characters).
* Solution: move the project to a shorter root folder (such as `C:\dev\password_manager`) and avoid deep nesting inside folders like Downloads or Desktop.
