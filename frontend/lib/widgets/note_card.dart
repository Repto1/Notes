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
  }
}
