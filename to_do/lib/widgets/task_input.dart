import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import 'package:uuid/uuid.dart';

class TaskInput extends StatefulWidget {
  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Title Input
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          
          // Description Input
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          
          // Deadline Input with Date Picker
          TextField(
            controller: deadlineController,
            readOnly: true, // Disable manual editing
            decoration: const InputDecoration(labelText: 'Deadline'),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                deadlineController.text = pickedDate.toLocal().toString().split(' ')[0]; // Format 'yyyy-mm-dd'
              }
            },
          ),
          
          // Create Task Button
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  deadlineController.text.isNotEmpty) {
                    
                // Create a Task object
                var task = Task(
                  id: Uuid().v4(),
                  title: titleController.text,
                  description: descriptionController.text,
                  isCompleted: false,
                  deadline: DateTime.parse(deadlineController.text),
                );
                
                // Call createTask method from TaskService
                context.read<TaskService>().createTask(task);
                
                // Clear Text Controllers after Task is created
                titleController.clear();
                descriptionController.clear();
                deadlineController.clear();
              }
            },
            child: const Text('Create Task'),
          ),
        ],
      ),
    );
  }
}
