import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart'; // Import for authentication services
import '../services/task_service.dart'; // Import for task management services

// Stateful widget for inputting new tasks
class TaskInput extends StatefulWidget {
  @override
  _TaskInputState createState() => _TaskInputState();
}

// State class for TaskInput widget
class _TaskInputState extends State<TaskInput> {
  // Controllers to manage text input for task fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDeadline; // Store selected deadline date

  @override
  Widget build(BuildContext context) {
    // Access AuthService and TaskService via Provider
    final authService = context.read<AuthService>();
    final taskService = context.read<TaskService>();

    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding around the form
      child: Form(
        key: _formKey, // Assign the form key for validation
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch fields to fill width
          children: [
            // Title Field
            TextFormField(
              controller: _titleController, // Bind the title controller
              decoration: const InputDecoration(
                labelText: 'Task Title', // Placeholder label
                border: OutlineInputBorder(), // Add borders to the field
              ),
              validator: (value) {
                // Validator to ensure title is not empty
                if (value == null || value.isEmpty) {
                  return 'Please enter a title'; // Error message for empty title
                }
                return null; // Validation passes
              },
            ),
            const SizedBox(height: 8), // Spacing between fields

            // Description Field
            TextFormField(
              controller: _descriptionController, // Bind the description controller
              decoration: const InputDecoration(
                labelText: 'Description', // Placeholder label
                border: OutlineInputBorder(), // Add borders to the field
              ),
              validator: (value) {
                // Validator to ensure description is not empty
                if (value == null || value.isEmpty) {
                  return 'Please enter a description'; // Error message for empty description
                }
                return null; // Validation passes
              },
            ),
            const SizedBox(height: 8), // Spacing between fields

            // Deadline Field
            TextFormField(
              controller: _deadlineController, // Bind the deadline controller
              readOnly: true, // Make the field read-only
              decoration: const InputDecoration(
                labelText: 'Deadline', // Placeholder label
                border: OutlineInputBorder(), // Add borders to the field
              ),
              onTap: () async {
                // Show date picker when tapped
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Default to current date
                  firstDate: DateTime.now(), // Prevent past dates
                  lastDate: DateTime(2100), // Limit to a far future date
                );
                if (pickedDate != null) {
                  // Update the deadline field with the selected date
                  setState(() {
                    _selectedDeadline = pickedDate; // Save selected date
                    _deadlineController.text =
                        pickedDate.toLocal().toString().split(' ')[0]; // Format as yyyy-mm-dd
                  });
                }
              },
              validator: (value) {
                // Validator to ensure a deadline is selected
                if (value == null || value.isEmpty) {
                  return 'Please select a deadline'; // Error message for empty deadline
                }
                return null; // Validation passes
              },
            ),
            const SizedBox(height: 8), // Spacing between fields

            // Create Task Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedDeadline != null) {
                  // Only proceed if form validation passes and deadline is selected
                  final userId = authService.user!.uid; // Get the authenticated user ID
                  final newTask = Task(
                    id: DateTime.now().toString(), // Generate unique task ID
                    title: _titleController.text, // Title from input
                    description: _descriptionController.text, // Description from input
                    isCompleted: false, // New task is incomplete by default
                    deadline: _selectedDeadline!, // Selected deadline
                    userId: userId, // Associate task with current user
                  );

                  taskService.createTask(newTask); // Add the new task to the service

                  // Clear the form fields
                  _titleController.clear();
                  _descriptionController.clear();
                  _deadlineController.clear();
                  setState(() {
                    _selectedDeadline = null; // Reset the deadline
                  });
                }
              },
              child: const Text('Add Task'), // Button text
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}
