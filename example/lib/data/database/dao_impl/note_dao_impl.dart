import 'package:example/data/database/database.dart';
import 'package:example/data/database/entities/entities.dart';
import 'package:example/domain/database/dao/note_dao.dart';
import 'package:example/domain/models/models.dart';
import 'package:isar_community/isar.dart';
import 'package:virnavi_common_sdk/virnavi_common_sdk.dart';

import 'package:virnavi_isar_e2m/virnavi_isar_e2m.dart';

class NoteDaoImpl extends BaseNoSqlDaoImpl<NoteModel, NoteEntity, String>
    implements NoteDao {
  NoteDaoImpl();

  @override
  IsarCollection<NoteEntity> get entityCollection => Database.shared.db.note;

  @override
  Optional<NoteEntity> convertToEntity(NoteModel? model) {
    if (model == null) {
      return Optional.empty();
    }
    return Optional.ofNullable(NoteEntity.fromModel(model));
  }

  @override
  Optional<NoteModel> convertToModel(NoteEntity? entity) =>
      Optional.ofNullable(entity?.toModel());

  @override
  QueryBuilder<NoteEntity, NoteEntity, QAfterWhereClause> idEqual(
    QueryBuilder<NoteEntity, NoteEntity, QWhereClause> queryBuilder,
    String value,
  ) => queryBuilder.idEqualTo(value);

  @override
  String idFromModel(NoteModel model) => model.id;
}