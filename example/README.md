# Virnavi Isar E2M Example

A production-ready example demonstrating how to use `virnavi_isar_e2m` for high-performance NoSQL data persistence in Flutter applications using Isar.

## Project Overview

This example demonstrates a complete Note-taking application with integrated User Profile management. It showcases best practices for:
- Layered Architecture (Clean Architecture).
- State Management using BLoC/Cubit.
- Reactive Data Streams with Isar Watchers.
- Singleton Entity patterns for global application state (User Profile).

---

## Folder Structure

```text
lib/
├── data/               # Data layer implementation
│   └── database/       # Isar configuration & persistence
│       ├── dao_impl/   # Concrete DAO implementations
│       ├── entities/   # Isar Database Entities
│       └── database.dart # Database initialization & shared instance
├── domain/             # Business logic layer (Framework independent)
│   ├── database/dao/   # Abstract DAO interfaces
│   └── models/         # Pure Dart domain models
├── ui/                 # Presentation layer
│   └── home/
│       ├── cubits/     # BLoC logic for state management
│       ├── widgets/    # Reusable UI components
│       └── home_screen.dart # Main feature entry point
└── main.dart           # DI setup and app entry
```

---

## Architecture & Code Pattern

The project follows a **Clean Architecture** pattern to decouple the UI from the database implementation.

1.  **Domain Layer**: Contains the core logic. Models (`NoteModel`, `UserModel`) and DAO interfaces (`NoteDao`, `UserDao`) reside here. It knows nothing about Isar or Flutter.
2.  **Data Layer**: Implements the Domain interfaces. `NoteDaoImpl` and `UserDaoImpl` handle the actual communication with the Isar database.
3.  **Presentation Layer (UI)**: Uses Cubits to interact with DAOs. The UI observes state changes and updates reactively.

### Reactive UI Pattern
We use `ModelStream` (returned by `getAllWatcher` and `getByIdWatcher`) to create a reactive bridge between the database and the UI. When data changes in Isar, the Cubit receives an automatic update through the stream and emits a new state.

---

## DAO Details

### NoteDao
Handles CRUD operations for multiple records.
- **Implementation**: Extends `BaseNoSqlDaoImpl<NoteModel, NoteEntity, String>`.
- **Key Feature**: Uses `getAllWatcher()` to provide a real-time list of notes that automatically refreshes when any note is added, updated, or deleted.

### UserDao
Handles a **Singleton Entity** (User Profile).
- **Implementation**: Extends `BaseNoSqlDaoImpl<UserModel, UserEntity, int>` and handles a `BaseNoSqlSingletonEntity`.
- **Key Feature**: Since there is only one user, it always uses `DbConstants.singletonId` (ID: 1). It uses `getByIdWatcher(singletonId)` to ensure the profile UI is always in sync with the database.

---

## Getting Started

1.  **Dependencies**: Run `flutter pub get`.
2.  **Code Generation**: If you modify entities, run:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Run**: `flutter run`.
