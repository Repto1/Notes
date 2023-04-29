import 'dart:convert';

import 'package:http/http.dart' as http;

class NoteService {
  static Future<bool> deleteNote(String id) async {
    final uri = Uri.parse('http://localhost:3000/api/notes/$id');
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List> fetchNotes() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/notes'),
    );
    final List<dynamic> notesJson = json.decode(response.body);
    final result = notesJson;
    return result;
  }

  static Future<bool> updateNote(String id, Map body) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/notes/$id'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> createNote(Map body) async {
    final response = await await http.post(
      Uri.parse('http://localhost:3000/api/notes/'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
