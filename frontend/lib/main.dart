import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      home: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:3000/tasks'));
    final List<dynamic> tasksJson = json.decode(response.body);
    setState(() {
      tasks = tasksJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task['title']),
            trailing: Checkbox(
              value: task['completed'],
              onChanged: (bool? value) {
                setState(() {
                  task['completed'] = value!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}