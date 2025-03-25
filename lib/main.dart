import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'wnNBNC8seMIhZJeyZPkbBBsy9qI3TVddgz1Fz6wf', 
    'https://parseapi.back4app.com/', 
    clientKey: 'MFvyML5s7HInnpJ2BkCb2bOUSMlk6LRQ77nqx24L', 
    autoSendSessionId: true,
  );
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      home: LoginScreen(),
    );
  }
}
