import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final taskService = context.watch<TaskService>();

    // Fetch tasks for the logged-in user if they are authenticated
    if (authService.user != null && taskService.tasks.isEmpty) {
      taskService.fetchTasks(authService.user!.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthService>().logout();
              taskService.tasks.clear(); // Clear tasks locally when logout
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TaskInput(),
          Expanded(child: TaskList()),  // Task list auto-updates when tasks change
        ],
      ),
    );
  }
}
