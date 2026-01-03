import 'package:virnavi_isar_e2m/src/entities/base_nosql_entity.dart';
import 'package:virnavi_isar_e2m/src/constants/db_constants.dart';

class BaseNoSqlSingletonEntity extends BaseNoSqlEntity {
  BaseNoSqlSingletonEntity() {
    tempId = DbConstants.singletonId;
  }
  String value = '';
}
