// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/pages/add_page.dart';
import 'package:frontend/services/note_service.dart';
import 'package:frontend/widgets/note_card.dart';

import '../utils/snackbar_helper.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLoading = true;
  List<dynamic> notes = [];

  get index => int;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchNotes,
          child: Visibility(
            visible: notes.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Notes',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: GridView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                final note = notes[index] as Map;
                final id = note['_id'] as String;
                return GestureDetector(
                  onTapDown: (position) {
                    _getTapPosition(position);
                  },
                  onLongPress: () {
                    _showContextMenu(context, note, id);
                  },
                  child: NoteCard(
                    index: index,
                    note: note,
                    editButton: editButton,
                    deleteNote: deleteNote,
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigationButton,
        backgroundColor: Color.fromARGB(255, 255, 232, 147),
        label: const Text(
          '+',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> editButton(Map note) async {
    final route = MaterialPageRoute(
      builder: (context) => AddNotesPage(note: note),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

  Future<void> navigationButton() async {
    final route = MaterialPageRoute(
      builder: (context) => AddNotesPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

  Future<void> deleteNote(String id) async {
    final success = await NoteService.deleteNote(id);
    showSuccessMessage(context, message: 'Successfull Delete');
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final response = await NoteService.fetchNotes();
    setState(
      () {
        notes = response;
      },
    );
    setState(
      () {
        isLoading = false;
      },
    );
  }

  void _showContextMenu(context, note, id) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
    switch (result) {
      case 'edit':
        editButton(note);
        break;
      case 'delete':
        deleteNote(id);
        break;
    }
  }
}
