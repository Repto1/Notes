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
              final note = notes[index];
              return ListTile(
                title: Text(note['title']),
                subtitle: Text(note['description']),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        child: Text('Edit'),
                      ),
                    ];
                  },
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
          onPressed: navigationButton, label: const Text('+')),
    );
  }

  void navigationButton() {
    final route = MaterialPageRoute(builder: (context) => AddNotesPage());
    Navigator.push(context, route);
  }

  Future<void> fetchNotes() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/notes'));
    final List<dynamic> notesJson = json.decode(response.body);
    setState(() {
      notes = notesJson;
    });
    setState(() {
      isLoading = false;
    });
  }
}
