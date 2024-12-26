import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Task> tasks = [];
  late StreamSubscription<QuerySnapshot> _tasksStream;

  // Subscribe to Firestore changes for real-time updates
  void listenToTasks(String userId) {
    try {
      _tasksStream = _db
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
        tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
        notifyListeners();
      });
    } catch (e) {
      throw 'Failed to retrieve tasks. Please try again later.';
    }
  }

  // Stop listening when user logs out
  void clearListener() {
    try {
      _tasksStream.cancel();
      tasks.clear();
      notifyListeners();
    } catch (e) {
      throw 'Failed to clear task listener. Please try again.';
    }
  }

  // Create a new task for the authenticated user
  Future<void> createTask(Task task) async {
    try {
      var newTaskRef = _db.collection('tasks').doc(task.id);
      await newTaskRef.set(task.toMap());
    } catch (e) {
      throw 'Failed to create a new task. Please try again.';
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw 'Failed to delete the task. Please try again.';
    }
  }

  // Update task details
  Future<void> updateTask(Task task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      throw 'Failed to update the task. Please try again.';
    }
  }
}

class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime deadline;
  String userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.deadline,
    required this.userId,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    try {
      var data = doc.data() as Map<String, dynamic>;
      return Task(
        id: doc.id,
        title: data['title'],
        description: data['description'] ?? '', // Add fallback value if description is missing
        isCompleted: data['isCompleted'],
        deadline: DateTime.parse(data['deadline']),
        userId: data['userId'],
      );
    } catch (e) {
      throw 'Failed to load task data.';
    }
  }

  // Convert Task object to Firestore-friendly map format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'deadline': deadline.toIso8601String(),
      'userId': userId,
    };
  }
}