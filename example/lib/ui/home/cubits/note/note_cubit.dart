import 'dart:async';
import 'package:example/domain/database/dao/note_dao.dart';
import 'package:example/domain/models/models.dart';
import 'package:example/ui/home/cubits/note/note_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteDao _noteDao;
  StreamSubscription? _subscription;

  NoteCubit(this._noteDao) : super(const NoteState()) {
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    final modelStream = await _noteDao.getAllWatcher();
    _subscription = modelStream.listen((notesOptional) {
    
      if (notesOptional.hasData) {
        emit(state.copyWith(notes: notesOptional.data));
      }
    });
  }

  Future<void> addNote(NoteModel note) async {
    await _noteDao.upsert(note);
  }

  Future<void> updateNote(NoteModel note) async {
    await _noteDao.upsert(note);
  }

  Future<void> toggleFavorite(NoteModel note) async {
    await _noteDao.upsert(note.copyWith(isFavorite: !note.isFavorite));
  }

  Future<void> deleteNote(String noteId) async {
    await _noteDao.delete(noteId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
