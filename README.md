# 🛠️ virnavi_isar_e2m

A **generic Isar DAO wrapper** that bridges the gap between Isar entities and domain models, streamlining NoSQL database interactions in Flutter applications.

This package provides a robust abstraction layer over Isar, offering generic DAOs with built-in support for `Optional` and `ModelStream` from the `virnavi_common_sdk`. It handles the boilerplate of transaction management, entity-to-model conversion, and reactive data streaming.

## ✨ Features

✅ **BaseNoSqlDaoImpl** — Generic implementation of CRUD operations (Get, Upsert, Delete)  
✅ **Reactive Streams** — Automatic conversion of Isar watchers to `ModelStream`  
✅ **Entity Abstractions** — `BaseNoSqlEntity` and `BaseNoSqlSingletonEntity` for consistent schema  
✅ **Transaction Management** — Safe read/write transaction handling  
✅ **Model-Entity Mapping** — Enforced separation of concerns between database entities and domain models  

## 🚀 Usage

### 1. Define your Entity

Extend `BaseNoSqlEntity` to create your Isar collection. The base class automatically handles `tempId` and `updatedDateTime`.

```dart
part of 'entities.dart';

@Collection(accessor: 'users')
class UserEntity extends BaseNoSqlEntity {
  @Index(unique: true, replace: true)
  String id = '';
  String name = '';
  int? age;
  String json = '';

  UserEntity();

  factory UserEntity.empty() => UserEntity();

  factory UserEntity.fromModel(UserModel model) {
    final entity = UserEntity();
    entity.id = model.id;
    entity.name = model.name;
    entity.age = model.age;
    entity.json = jsonEncode(model.toJson());
    return entity;
  }

  UserModel toModel() => UserModel.fromJson(jsonDecode(json));
}
```

### 2. Define your Model

Create a pure Dart model for your domain layer with JSON serialization support. This ensures your business logic isn't tied directly to the database implementation.

```dart
part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final String id;
  final String name;
  final int? age;

  UserModel({
    required this.id,
    required this.name,
    this.age,
  });

  factory UserModel.empty() => UserModel(
        id: '',
        name: '',
        age: null,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```

### 3. Create the DAO Interface

Define an abstract DAO interface for your domain layer.

```dart
import 'package:virnavi_isar_e2m/virnavi_isar_e2m.dart';

abstract class UserDao extends BaseNoSqlDao<UserModel, String> {}
```

### 4. Implement the DAO

Extend `BaseNoSqlDaoImpl` to connect your entity and model. The conversion logic leverages the entity's built-in methods.

```dart
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';
import 'package:virnavi_isar_e2m/virnavi_isar_e2m.dart';
import 'package:isar_community/isar.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: UserDao)
class UserDaoImpl extends BaseNoSqlDaoImpl<UserModel, UserEntity, String>
    implements UserDao {
  UserDaoImpl();

  @override
  IsarCollection<UserEntity> get entityCollection => Database.shared.db.users;

  @override
  Optional<UserEntity> convertToEntity(UserModel? model) {
    if (model == null) return Optional.empty();
    return Optional.ofNullable(UserEntity.fromModel(model));
  }

  @override
  Optional<UserModel> convertToModel(UserEntity? entity) =>
      Optional.ofNullable(entity?.toModel());

  @override
  QueryBuilder<UserEntity, UserEntity, QAfterWhereClause> idEqual(
      QueryBuilder<UserEntity, UserEntity, QWhereClause> queryBuilder,
      String value) =>
      queryBuilder.idEqualTo(value);

  @override
  String idFromModel(UserModel model) => model.id;
}
```

### 5. Use it in your App

```dart
void main() async {
  // Initialize Isar and register DAOs with dependency injection
  // (using get_it or injectable)
  
  final userDao = getIt<UserDao>();

  // Upsert a user
  final user = UserModel(id: '1', name: 'Shakib', age: 30);
  await userDao.upsert(user);

  // Get by ID
  final userOpt = await userDao.getById('1');
  userOpt.ifPresent((u) => print('Found: ${u.name}'));

  // Watch changes (Stream) - automatically converted to ModelStream
  final stream = await userDao.getByIdWatcher('1');
  stream.listen((opt) {
    opt.ifPresent((u) => print('Updated name: ${u.name}'));
  });

  // Get all users
  final allUsers = await userDao.getAll();
  print('Total users: ${allUsers.length}');

  // Watch all users
  final allStream = await userDao.getAllWatcher();
  allStream.listen((opt) {
    opt.ifPresent((users) => print('User count: ${users.length}'));
  });
}
```

### 6. Singleton Entities

For storing configuration or single-instance data, use `BaseNoSqlSingletonEntity`.

```dart
part of 'entities.dart';

@Collection(accessor: 'appConfig')
class ConfigEntity extends BaseNoSqlSingletonEntity {
  String themeMode = 'light';
  String language = 'en';
  String json = '';

  ConfigEntity();

  factory ConfigEntity.empty() => ConfigEntity();

  factory ConfigEntity.fromModel(ConfigModel model) {
    final entity = ConfigEntity();
    entity.themeMode = model.themeMode;
    entity.language = model.language;
    entity.json = jsonEncode(model.toJson());
    return entity;
  }

  ConfigModel toModel() => ConfigModel.fromJson(jsonDecode(json));
}
```

## 🧠 How It Works

- **Clean Architecture**: The package enforces separation of concerns:
  - `Entity` classes handle Isar persistence with `tempId` and `updatedDateTime` managed automatically
  - `Model` classes represent your domain objects with business logic
  - JSON serialization in entities provides a flexible backup for complex nested objects
  
- **Generic CRUD Operations**: `BaseNoSqlDaoImpl` provides out-of-the-box implementations:
  - **Read**: `getById`, `getAll`, `getIdList`
  - **Watch**: `getByIdWatcher`, `getAllWatcher`, `getIdListWatcher` (reactive streams)
  - **Write**: `upsert`, `upsertAll`
  - **Delete**: `delete`, `deleteAll`, `clear`
  
- **Reactive Streams**: All watcher methods return `ModelStream` that automatically:
  - Convert Isar entity streams to domain model streams
  - Wrap results in `Optional` for safe null handling
  - Fire immediately with current data
  
- **Type Safety**: Uses `Optional` from `virnavi_common_sdk` to:
  - Handle nullability explicitly
  - Prevent runtime null errors
  - Provide functional programming patterns (`ifPresent`, `orElse`, etc.)

- **Transaction Management**: All write operations are wrapped in Isar transactions automatically, ensuring data consistency.

## 🧰 Dependencies

- [virnavi_common_sdk](https://pub.dev/packages/virnavi_common_sdk)
- [isar_community](https://pub.dev/packages/isar_community)

## 🧑‍💻 Contributors

* **Mohammed Shakib** ([@shakib1989](https://github.com/shakib1989)) - *Main Library Development*
* **Shuvo Prosad Sarnakar** ([@shuvoprosadsarnakar](https://github.com/shuvoprosadsarnakar)) - *Extensive documentation and getting the project for pub.dev.*

## 🪪 License

This project is licensed under the **MIT License** — see the LICENSE file for details.
