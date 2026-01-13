import 'package:equatable/equatable.dart';
import 'package:example/domain/models/models.dart';

class NoteState extends Equatable {
  final List<NoteModel>? notes;

  const NoteState({this.notes});

  NoteState copyWith({List<NoteModel>? notes}) {
    return NoteState(
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [notes];
}
