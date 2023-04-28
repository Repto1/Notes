import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
    final completed = note['completed'];
    final body = {
      "title": title,
      "description": description,
      "completed": completed
    };
    // ignore: unused_local_variable
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/notes/$id'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Successfull Creation');
      showSuccessMessage('Successfull Update');
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
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/notes/'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      print('Successfull Creation');
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage('Successfull Creation');
    } else {
      print('Failed Creation');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
