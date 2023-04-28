import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({super.key});

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add note'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Add a title'),
            keyboardType: TextInputType.text,
            maxLines: 1,
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Add a description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton.extended(
              onPressed: createNote, label: const Text('Add note'))
        ],
      ),
    );
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
      showSuccessMessage('Successfull Creation');
    } else {
      print('Failed Creation');
    }
  }

  void showSuccessMessage(String message) {
    titleController.text = '';
    descriptionController.text = '';

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
