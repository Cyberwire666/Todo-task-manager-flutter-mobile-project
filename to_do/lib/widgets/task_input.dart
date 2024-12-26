import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';

class TaskInput extends StatefulWidget {
  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDeadline;

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final taskService = context.read<TaskService>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            // Deadline Field
            TextFormField(
              controller: _deadlineController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Deadline',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDeadline = pickedDate;
                    _deadlineController.text = pickedDate.toLocal().toString().split(' ')[0]; // Format as yyyy-mm-dd
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a deadline';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            // Create Task Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _selectedDeadline != null) {
                  final userId = authService.user!.uid; // Use authenticated user's ID
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isCompleted: false,
                    deadline: _selectedDeadline!, // Pass the selected deadline
                    userId: userId,
                  );

                  taskService.createTask(newTask);

                  // Clear the form
                  _titleController.clear();
                  _descriptionController.clear();
                  _deadlineController.clear();
                  setState(() {
                    _selectedDeadline = null;
                  });
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }
}
