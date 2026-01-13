import 'package:example/data/database/database.dart';
import 'package:example/data/database/entities/entities.dart';
import 'package:example/domain/database/dao/user_dao.dart';
import 'package:example/domain/models/models.dart';
import 'package:isar_community/isar.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';

import 'package:virnavi_isar_e2m/virnavi_isar_e2m.dart';

class UserDaoImpl extends BaseNoSqlDaoImpl<UserModel, UserEntity, int>
    implements UserDao {
  UserDaoImpl();

  @override
  IsarCollection<UserEntity> get entityCollection => Database.shared.db.user;

  @override
  Optional<UserEntity> convertToEntity(UserModel? model) {
    if (model == null) {
      return Optional.empty();
    }
    return Optional.ofNullable(UserEntity.fromModel(model));
  }

  @override
  Optional<UserModel> convertToModel(UserEntity? entity) =>
      Optional.ofNullable(entity?.toModel());

  @override
  QueryBuilder<UserEntity, UserEntity, QAfterWhereClause> idEqual(
    QueryBuilder<UserEntity, UserEntity, QWhereClause> queryBuilder,
    int value,
  ) => queryBuilder.tempIdEqualTo(value);

  @override
  int idFromModel(UserModel model) =>  DbConstants.singletonId;
}
