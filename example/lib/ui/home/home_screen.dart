import 'package:example/ui/home/cubits/note/note_cubit.dart';
import 'package:example/ui/home/cubits/note/note_state.dart';
import 'package:example/ui/home/widgets/note_edit_dialog.dart';
import 'package:example/ui/home/widgets/note_list.dart';
import 'package:example/ui/home/widgets/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = ['Notes', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                final notes = state.notes;
                if (notes == null) return const SizedBox.shrink();

                final favoriteCount = notes
                    .where((note) => note.isFavorite)
                    .length;
                if (favoriteCount > 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('$favoriteCount'),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [NoteList(), ProfileView()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Note'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showCreateNoteDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showCreateNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => NoteEditDialog(
        onSave: (note) {
          context.read<NoteCubit>().addNote(note);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}
