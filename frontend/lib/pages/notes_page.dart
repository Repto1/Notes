import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/pages/add_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isLoading = true;
  List notes = [];

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
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              final note = notes[index] as Map;
              final id = note['_id'] as String;
              return Card(
                borderOnForeground: true,
                child: ListTile(
                  title: Text(
                    note['title'],
                  ),
                  subtitle: Text(
                    note['description'],
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        editButton(note);
                      }
                      if (value == 'delete') {
                        deleteNote(id);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigationButton,
        label: const Text('+'),
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
    final uri = Uri.parse('http://localhost:3000/api/notes/$id');
    final response = await http.delete(uri);
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/notes'),
    );
    final List<dynamic> notesJson = json.decode(response.body);
    setState(
      () {
        notes = notesJson;
      },
    );
    setState(
      () {
        isLoading = false;
      },
    );
  }
}
