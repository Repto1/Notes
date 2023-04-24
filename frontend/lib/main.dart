import 'dart:convert';
import 'dart:html';
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

  get index => int;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/notes'));
    final List<dynamic> tasksJson = json.decode(response.body);
    setState(() {
      tasks = tasksJson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: Stack(
        children: [
          Container(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  trailing: Stack(
                    children: [
                      Checkbox(
                        value: task['completed'],
                        onChanged: (bool? value) {
                          setState(() {
                            task['completed'] = value!;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var taskid = task['id'];
                          var request = new HttpRequest();
                          request.open('DELETE',
                              'http://localhost:3000/api/notes/$taskid');
                          request.send();
                        },
                        child: Text('+'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  color: Colors.grey,
                  child: TextField(
                    decoration: InputDecoration(hintText: 'adicionar nota'),
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('+'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
