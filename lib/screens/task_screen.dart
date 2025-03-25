import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'login_screen.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<ParseObject> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('Tasks'));
    final response = await query.query();

    if (response.success) {
      setState(() {
        tasks = (response.results as List<ParseObject>?) ?? [];
      });
    }
  }

  Future<void> addTask(String title) async {
    final task = ParseObject('Tasks')..set('title', title);
    await task.save();
    fetchTasks();
  }

  Future<void> updateTask(ParseObject task, String newTitle) async {
    task.set('title', newTitle);
    await task.save();
    fetchTasks();
  }

  Future<void> deleteTask(ParseObject task) async {
    await task.delete();
    fetchTasks();
  }

  Future<void> logout() async {
  final user = await ParseUser.currentUser() as ParseUser?;
  if (user != null) {
    await user.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}


  @override
Widget build(BuildContext context) {
  final TextEditingController taskController = TextEditingController();

  return Scaffold(
    appBar: AppBar(
      title: Text('Task Manager'),
      actions: [  //Add Logout Button Inside AppBar
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: logout, //Calls the logout function
        ),
      ],
    ),
    body: Column(
      children: [
        TextField(controller: taskController, decoration: InputDecoration(labelText: 'Enter Task')),
        ElevatedButton(
          onPressed: () => addTask(taskController.text),
          child: Text('Add Task'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index].get<String>('title') ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteTask(tasks[index]),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController updateController = TextEditingController(text: tasks[index].get<String>('title') ?? '');
                      return AlertDialog(
                        title: Text('Edit Task'),
                        content: TextField(controller: updateController),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              updateTask(tasks[index], updateController.text);
                              Navigator.pop(context);
                            },
                            child: Text('Update'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
}