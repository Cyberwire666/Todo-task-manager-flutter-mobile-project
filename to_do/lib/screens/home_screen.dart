import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';
import 'login_screen.dart'; // Import the LoginScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final taskService = context.watch<TaskService>();

    // Listen to tasks for the logged-in user
    if (authService.user != null) {
      taskService.listenToTasks(authService.user!.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authService.logout();
              taskService.clearListener(); // Clear task listener when user logs out

              // Navigate to login screen after logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            TaskInput(),
            const Divider(thickness: 2, color: Colors.white54),
            Expanded(child: TaskList()),
          ],
        ),
      ),
    );
  }
}
