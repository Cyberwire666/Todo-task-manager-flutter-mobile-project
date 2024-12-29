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
    // Watch the AuthService to manage user authentication
    final authService = context.watch<AuthService>();
    
    // Watch the TaskService to manage tasks related to the logged-in user
    final taskService = context.watch<TaskService>();

    // Listen to tasks only if the user is logged in
    if (authService.user != null) {
      taskService.listenToTasks(authService.user!.uid);
    }

    return Scaffold(
      // AppBar for the screen with title and logout button
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true, // Centers the title
        elevation: 2, // Sets the shadow depth of the AppBar
        backgroundColor: Colors.greenAccent, // AppBar background color
        actions: [
          // Logout button in the AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout', // Tooltip when the user hovers over the button
            onPressed: () {
              // Log out the user
              authService.logout();
              
              // Clear the task listener after logging out
              taskService.clearListener();

              // Navigate back to the LoginScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        // Background gradient for the screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.lightGreenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text for adding tasks
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add Your Task:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ),
            // The input widget for creating a task
            TaskInput(),

            // Divider between task input and task list
            const Divider(
              thickness: 2,
              color: Colors.white70, // Divider color
            ),
            
            // The list that displays all tasks
            Expanded(
              child: TaskList(),
            ),
          ],
        ),
      ),
    );
  }
}
