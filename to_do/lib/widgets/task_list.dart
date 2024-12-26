import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskService>().tasks;

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found. Add a task to get started!',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Task Description
                Text(
                  task.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                // Display Due Date
                Text(
                  'Due: ${task.deadline.toLocal()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                context.read<TaskService>().deleteTask(task.id);
              },
            ),
            onTap: () {
              task.isCompleted = !task.isCompleted;
              context.read<TaskService>().updateTask(task);
            },
          ),
        );
      },
    );
  }
}
