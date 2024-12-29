import 'dart:async'; // For handling streams and subscriptions
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:flutter/material.dart'; // Flutter framework for UI

// TaskService manages tasks and interacts with Firestore
class TaskService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance; // Reference to Firestore database
  List<Task> tasks = []; // List to store tasks for the current user
  late StreamSubscription<QuerySnapshot> _tasksStream; // Subscription to Firestore stream for real-time updates

  // Subscribe to Firestore collection and listen for changes
  void listenToTasks(String userId) {
    try {
      _tasksStream = _db
          .collection('tasks') // Reference 'tasks' collection in Firestore
          .where('userId', isEqualTo: userId) // Filter tasks by the authenticated user
          .snapshots() // Real-time stream of task changes
          .listen((snapshot) {
        // Convert Firestore documents to Task objects
        tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
        notifyListeners(); // Notify UI to rebuild with updated tasks
      });
    } catch (e) {
      throw 'Failed to retrieve tasks. Please try again later.'; // Error handling for subscription issues
    }
  }

  // Clear listener and task list when user logs out
  void clearListener() {
    try {
      _tasksStream.cancel(); // Cancel the Firestore subscription
      tasks.clear(); // Clear the in-memory task list
      notifyListeners(); // Notify UI to reflect changes
    } catch (e) {
      throw 'Failed to clear task listener. Please try again.'; // Error handling for unsubscribing issues
    }
  }

  // Add a new task to Firestore
  Future<void> createTask(Task task) async {
    try {
      var newTaskRef = _db.collection('tasks').doc(task.id); // Create a new document in 'tasks' collection with task ID
      await newTaskRef.set(task.toMap()); // Set the document with task data
    } catch (e) {
      throw 'Failed to create a new task. Please try again.'; // Error handling for task creation issues
    }
  }

  // Remove a task from Firestore
  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete(); // Delete the document with specified task ID
    } catch (e) {
      throw 'Failed to delete the task. Please try again.'; // Error handling for deletion issues
    }
  }

  // Update an existing task in Firestore
  Future<void> updateTask(Task task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toMap()); // Update the document with new task data
    } catch (e) {
      throw 'Failed to update the task. Please try again.'; // Error handling for update issues
    }
  }
}

// Task class represents individual task data
class Task {
  String id; // Unique task ID
  String title; // Task title
  String description; // Task description
  bool isCompleted; // Completion status
  DateTime deadline; // Deadline for the task
  String userId; // ID of the user who owns this task

  // Constructor for Task
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.deadline,
    required this.userId,
  });

  // Factory method to create a Task object from Firestore document
  factory Task.fromFirestore(DocumentSnapshot doc) {
    try {
      var data = doc.data() as Map<String, dynamic>; // Extract Firestore document data
      return Task(
        id: doc.id, // Firestore document ID
        title: data['title'], // Task title
        description: data['description'] ?? '', // Default empty description if null
        isCompleted: data['isCompleted'], // Task completion status
        deadline: DateTime.parse(data['deadline']), // Convert Firestore string to DateTime
        userId: data['userId'], // User ID
      );
    } catch (e) {
      throw 'Failed to load task data.'; // Error handling for data parsing issues
    }
  }

  // Convert Task object to Firestore-friendly map format
  Map<String, dynamic> toMap() {
    return {
      'title': title, // Store title
      'description': description, // Store description
      'isCompleted': isCompleted, // Store completion status
      'deadline': deadline.toIso8601String(), // Convert deadline to ISO 8601 format
      'userId': userId, // Store user ID
    };
  }
}
