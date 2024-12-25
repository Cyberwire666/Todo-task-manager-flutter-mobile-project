import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch tasks from the TaskService through Provider
    List<Task> tasks = context.watch<TaskService>().tasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(
              task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            onPressed: () {
              // Toggle the task completion
              task.isCompleted = !task.isCompleted;
              context.read<TaskService>().updateTask(task);
            },
          ),
          onLongPress: () {
            // Handle task deletion on long press
            context.read<TaskService>().deleteTask(task.id);
          },
        );
      },
    );
  }
}
