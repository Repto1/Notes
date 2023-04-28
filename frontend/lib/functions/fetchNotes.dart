import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List notes = [];

get index => int;

Future<void> fetchNotes() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/notes'));
  final List<dynamic> notesJson = json.decode(response.body);
  setState(() {
    notes = notesJson;
  });
}
