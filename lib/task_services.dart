import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Add new task
  Future<void> addTask(String title, String description, DateTime dueDate) async {
   await FirebaseFirestore.instance.collection('tasks').add({
  'userId': FirebaseAuth.instance.currentUser!.uid, // ← this is critical
  'title': title,
  'description': description,
  'dueDate': Timestamp.fromDate(dueDate),
  'isCompleted': false,
  'createdAt': FieldValue.serverTimestamp(),
});

  }

  // Get user's tasks (stream)
  Stream<QuerySnapshot> getUserTasks() {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots();
  }

  // Toggle task completion
  Future<void> toggleTaskCompleted(String taskId, bool isCompleted) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
