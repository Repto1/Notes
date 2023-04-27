import 'dart:async';
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

  final TextEditingController taskController = TextEditingController();

  Future<void> createTask() async {
    final title = taskController.text;
    final body = {"title": title};
    final response = await http.post(
        Uri.parse('http://localhost:3000/api/notes/'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'});
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTasks,
        child: Stack(
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
                            var taskid = task['_id'];
                            var request = HttpRequest();
                            request.open('DELETE',
                                'http://localhost:3000/api/notes/$taskid');
                            var completer = Completer();
                            request.onLoad.listen((_) {
                              completer.complete();
                            });
                            request.send();
                            await completer.future;
                            await fetchTasks();
                          },
                          child: Text('-'),
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
                    color: Colors.black12,
                    child: TextFormField(
                      controller: taskController,
                      decoration: InputDecoration(hintText: 'adicionar nota'),
                      keyboardType: TextInputType.text,
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    child: ElevatedButton(
                      onPressed: createTask,
                      child: Text('+'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
