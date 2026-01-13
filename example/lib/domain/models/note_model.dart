part of 'models.dart';

class NoteModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final bool isFavorite;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isFavorite,
  });

  factory NoteModel.empty() =>
      NoteModel(id: '', title: '', content: '', isFavorite: false);

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    bool? isFavorite,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, content, isFavorite];
}
