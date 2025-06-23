import 'package:flutter/material.dart';
import 'package:momentum/auth/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthCheck(),
      // routes: {
      //   '/': (context) => HomePage(),
      //   '/add': (context) => AddTaskPage(),
      //   '/analysis': (context) => AnalysisPage(),
      // },
    );
  }
}
