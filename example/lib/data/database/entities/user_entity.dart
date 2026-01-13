part of 'entities.dart';

@Collection(accessor: 'user')
class UserEntity extends BaseNoSqlSingletonEntity {
  String name = '';
  String email = '';
  int? age;

  UserEntity();

  factory UserEntity.empty() => UserEntity();

  factory UserEntity.fromModel(UserModel model) {
    final entity = UserEntity();
    entity.name = model.name;
    entity.email = model.email;
    entity.age = model.age;
    return entity;
  }

  UserModel toModel() => UserModel(name: name, email: email, age: age);
}
