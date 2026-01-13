part of 'entities.dart';

@Collection(accessor: 'note')
class NoteEntity extends BaseNoSqlEntity {
  @Index(unique: true, replace: true)
  String id = '';
  String title = '';
  String content = '';
  bool isFavorite = false;

  NoteEntity();

  factory NoteEntity.empty() => NoteEntity();

  factory NoteEntity.fromModel(NoteModel model) {
    final entity = NoteEntity();
    entity.id = model.id;
    entity.title = model.title;
    entity.content = model.content;
    entity.isFavorite = model.isFavorite;
    return entity;
  }

  NoteModel toModel() =>
      NoteModel(id: id, title: title, content: content, isFavorite: isFavorite);
}
