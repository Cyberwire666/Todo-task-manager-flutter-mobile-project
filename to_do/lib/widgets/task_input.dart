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
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                prefixIcon: const Icon(Icons.title, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Task Description',
                prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: deadlineController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Deadline',
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  deadlineController.text = pickedDate.toLocal().toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    deadlineController.text.isNotEmpty) {
                  var task = Task(
                    id: Uuid().v4(),
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: false,
                    deadline: DateTime.parse(deadlineController.text),
                  );
                  context.read<TaskService>().createTask(task);

                  titleController.clear();
                  descriptionController.clear();
                  deadlineController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
