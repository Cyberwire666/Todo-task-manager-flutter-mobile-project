import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart'; // Import TaskService to manage task-related operations

// Stateless widget to display a list of tasks
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the list of tasks from TaskService using Provider
    final tasks = context.watch<TaskService>().tasks;

    // If there are no tasks, display a placeholder message
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found. Add a task to get started!', // Placeholder message
          style: TextStyle(fontSize: 16, color: Colors.white), // Styling the message
        ),
      );
    }

    // If tasks exist, display them in a ListView
    return ListView.builder(
      itemCount: tasks.length, // Number of tasks to display
      itemBuilder: (context, index) {
        final task = tasks[index]; // Get the task at the current index
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Margin around each card
          elevation: 5, // Adds a shadow effect
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners for the card
          child: ListTile(
            leading: Icon(
              // Icon changes based on whether the task is completed or not
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey, // Green if completed, grey otherwise
            ),
            title: Text(
              task.title, // Display the task title
              style: TextStyle(
                fontSize: 18, // Font size for title
                fontWeight: FontWeight.w500, // Medium weight for title
                decoration: task.isCompleted ? TextDecoration.lineThrough : null, // Strike-through for completed tasks
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                // Display Task Description
                Text(
                  task.description, // Task description
                  style: TextStyle(color: Colors.grey[600], fontSize: 14), // Styling for description text
                ),
                // Display Due Date
                Text(
                  'Due: ${task.deadline.toLocal()}', // Deadline of the task
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]), // Styling for deadline text
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent), // Delete button
              onPressed: () {
                context.read<TaskService>().deleteTask(task.id); // Deletes the task
              },
            ),
            onTap: () {
              // Toggle task completion status on tap
              task.isCompleted = !task.isCompleted;
              context.read<TaskService>().updateTask(task); // Update task in TaskService
            },
          ),
        );
      },
    );
  }
}
