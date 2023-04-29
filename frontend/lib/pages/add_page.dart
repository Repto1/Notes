import 'dart:convert';
import 'package:frontend/services/note_service.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../utils/snackbar_helper.dart';

class AddNotesPage extends StatefulWidget {
  final Map? note;
  const AddNotesPage({super.key, this.note});

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    if (note != null) {
      isEdit = true;
      final title = note['title'];
      final description = note['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit note' : 'Add note'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: isEdit ? 'Edit the title' : 'Add a title'),
            keyboardType: TextInputType.text,
            maxLines: 1,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
                hintText:
                    isEdit ? 'Edit the description' : 'Add a description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton.extended(
              onPressed: isEdit ? updateNote : createNote,
              label: Text(isEdit ? 'Edit note' : 'Add note'))
        ],
      ),
    );
  }

  Future<void> updateNote() async {
    final note = widget.note;
    if (note == null) {
      return;
    }
    final id = note['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {"title": title, "description": description};
    // ignore: unused_local_variable
    final response = await NoteService.updateNote(id, body);
    if (response) {
      print('Successfull Update');
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Successfull Update');
    } else {
      print('Failed Update');
      print(id);
    }
  }

  Future<void> createNote() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {"title": title, "description": description};
    // ignore: unused_local_variable
    final response = await NoteService.createNote(body);
    if (response) {
      print('Successfull Creation');
      titleController.text = '';
      descriptionController.text = '';

      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Successfull Creation');
    } else {
      print('Failed Creation');
    }
  }
}
