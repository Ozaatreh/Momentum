import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:momentum/analysis_page.dart';
import 'add_task_page.dart'; // make sure to import this or route to it

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final String userId = user.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text("Daily Tasks", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AnalysisPage()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where('userId', isEqualTo: userId)
              .orderBy('dueDate')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No tasks yet"));
            }

            final tasks = snapshot.data!.docs;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final title = task['title'];
                final isCompleted = task['isCompleted'] ?? false;

                return ListTile(
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: (val) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(task.id)
                          .update({'isCompleted': val});
                    },
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage())),
        backgroundColor: Colors.blue[600],
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
