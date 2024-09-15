import 'package:flutter/material.dart';
import 'package:track_ai/test_data/tasks.dart';
import '../HomeDashboard.dart';
import 'package:intl/intl.dart'; // For date formatting

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onEditTask;
  final Function(Task) onDeleteTask;

  const EditTaskScreen({required this.task, required this.onEditTask, required this.onDeleteTask,});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String taskName;
  late String description;
  late String priority;
  late DateTime deadline;

  @override
  void initState() {
    super.initState();
    taskName = widget.task.name;
    description = widget.task.description ?? "";
    priority = widget.task.priority;
    deadline = widget.task.deadline!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Task Name Input
              TextFormField(
                initialValue: taskName,
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
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),
              
              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(labelText: 'Priority'),
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
                title: Text('Deadline: ${DateFormat.yMMMd().format(deadline)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: deadline,
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

                    // Update the task with new values
                    Task editedTask = Task(
                      name: taskName,
                      description: description,
                      priority: priority,
                      deadline: deadline,
                      isCompleted: widget.task.isCompleted,
                      startTime: widget.task.startTime, // Keep start time unchanged
                    );

                    // Pass the edited task back to the parent
                    widget.onEditTask(editedTask);

                    // Go back to the previous screen
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),

              // Delete Button
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () {
                  // Confirm before deleting
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Task'),
                        content: const Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Delete the task
                              widget.onDeleteTask(widget.task);

                              // Close the dialog and go back to the previous screen
                              Navigator.pop(context); // Close the dialog
                              Navigator.pop(context); // Close the edit screen
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Delete Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
