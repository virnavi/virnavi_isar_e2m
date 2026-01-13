import 'package:example/domain/models/models.dart';
import 'package:example/ui/home/cubits/note/note_cubit.dart';
import 'package:example/ui/home/cubits/note/note_state.dart';
import 'package:example/ui/home/widgets/note_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        final notes = state.notes;

        if (notes == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notes.isEmpty) {
          return const Center(
            child: Text(
              'No notes yet.\nTap + to create one!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return NoteItem(
              note: notes[index],
              onToggleFavorite: () =>
                  context.read<NoteCubit>().toggleFavorite(notes[index]),
              onEdit: () => _showEditDialog(context, notes[index]),
              onDelete: () => _confirmDelete(context, notes[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
          itemCount: notes.length,
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (dialogContext) => NoteEditDialog(
        note: note,
        onSave: (updatedNote) {
          context.read<NoteCubit>().updateNote(updatedNote);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, NoteModel note) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteCubit>().deleteNote(note.id);
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onToggleFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteItem({
    super.key,
    required this.note,
    required this.onToggleFavorite,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      note.isFavorite ? Icons.star : Icons.star_border,
                      color: note.isFavorite ? Colors.amber : Colors.grey,
                    ),
                    onPressed: onToggleFavorite,
                    tooltip: note.isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Delete note',
                  ),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  note.content,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
