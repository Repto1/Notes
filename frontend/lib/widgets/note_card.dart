import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NoteCard extends StatelessWidget {
  final int index;
  final Map note;
  final Function(Map) editButton;
  final Function(String) deleteNote;
  const NoteCard({
    super.key,
    required this.index,
    required this.note,
    required this.editButton,
    required this.deleteNote,
  });

  @override
  Widget build(BuildContext context) {
    final id = note['_id'] as String;
    return Card(
      shape: Border(),
      color: Color.fromARGB(255, 255, 232, 147),
      surfaceTintColor: Colors.amber,
      borderOnForeground: true,
      child: ListTile(
        title: Text(
          note['title'],
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        subtitle: Text(
          note['description'],
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        trailing: PopupMenuButton(
          color: Colors.grey[900],
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
  }
}
