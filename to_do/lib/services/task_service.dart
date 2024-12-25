import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Task> tasks = [];

  // Fetch tasks based on userId
  Future<void> fetchTasks(String userId) async {
    var snapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    notifyListeners(); // Notify listeners that tasks have been fetched
  }

  // Create a new task for the authenticated user
  Future<void> createTask(Task task) async {
    var newTaskRef = _db.collection('tasks').doc();
    await newTaskRef.set(task.toMap(task.id));

    tasks.add(task); // Adds task to the local list
    notifyListeners();
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
    tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Update task details
  Future<void> updateTask(Task task) async {
    await _db.collection('tasks').doc(task.id).update(task.toMap(task.id));
    notifyListeners();
  }
}

// Task Model with necessary details
class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.deadline,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      isCompleted: data['isCompleted'],
      deadline: DateTime.parse(data['deadline']),
    );
  }

  // Convert Task object to Firestore-friendly map format
  Map<String, dynamic> toMap(String taskId) {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline.toIso8601String(),
      'userId': taskId,  // Store the userId in the task data
    };
  }
}
