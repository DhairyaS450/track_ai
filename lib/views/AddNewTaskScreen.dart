import 'package:flutter/material.dart';
import 'package:track_ai/data/tasks.dart';
import 'HomeDashboard.dart';
import 'package:intl/intl.dart'; // For date formatting

class AddNewTaskScreen extends StatefulWidget {
  final Function(Task) onAddTask; // Callback to add task

  AddNewTaskScreen({required this.onAddTask});

  @override
  _AddNewTaskScreenState createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String taskName = '';
  String description = '';
  String priority = 'Mid'; // Default priority
  DateTime? deadline = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Task Name Input
              TextFormField(
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
                onSaved: (value) => taskName = value!,
              ),
              
              // Description Input
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),
              
              // Priority Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Priority'),
                value: priority,
                items: ['High', 'Mid', 'Low']
                    .map((level) => DropdownMenuItem(
                          child: Text(level),
                          value: level,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),
              
              // Deadline Picker
              ListTile(
                title: Text('Deadline: ${DateFormat.yMMMd().format(deadline!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      deadline = picked;
                    });
                  }
                },
              ),
              
              // Submit Button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create a new Task object
                    Task newTask = Task(
                      name: taskName,
                      startTime: 'Anytime', // Default time
                      priority: priority,
                      deadline: deadline!,
                      isCompleted: false,
                    );

                    // Pass the new task back to the parent
                    widget.onAddTask(newTask);

                    // Go back to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
