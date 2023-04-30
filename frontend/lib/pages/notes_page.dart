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
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                final note = notes[index] as Map;
                final id = note['_id'] as String;
                return NoteCard(
                  index: index,
                  note: note,
                  editButton: editButton,
                  deleteNote: deleteNote,
                );
              },
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
}
