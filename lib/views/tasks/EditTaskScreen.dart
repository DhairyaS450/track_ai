import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/utilities/dialogs/delete_dialog.dart';
import 'package:track_ai/utilities/dialogs/error_dialog.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function onSave;
  final Function onDelete;

  const EditTaskScreen({super.key, required this.task, required this.onSave, required this.onDelete});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // Controllers for text fields
  late TextEditingController _taskNameController;
  late TextEditingController _descriptionController;

  // Variables to hold edited values
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? _deadline;
  String _selectedPriority = 'Low';
  double _progress = 0.0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing task values
    _taskNameController = TextEditingController(text: widget.task.name);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');

    // Set initial values for other fields
    _startTime = widget.task.startTime;
    _endTime = widget.task.endTime;
    _deadline = widget.task.deadline;
    _selectedPriority = widget.task.priority;
    _progress = widget.task.progress;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Method to pick deadline date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate =
        _deadline != null && _deadline!.isAfter(DateTime.now())
            ? _deadline!
            : DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // Ensure initialDate is never before firstDate
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

// Method to pick both date and time
  Future<void> _selectDateTime(BuildContext context, int field) async {
    // Step 1: Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) {
      return; // User canceled the date picker
    }

    // Step 2: Pick Time
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return; // User canceled the time picker
    }

    // Combine the picked date and time into a DateTime object
    DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (field == 0) {
        _startTime = pickedDateTime;
      } else if (field == 1) {
        _endTime = pickedDateTime;
      } else if (field == 2) {
        _deadline = pickedDateTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () async {
              final delete = await showDeleteDialog(context);
              if (delete) {
                widget.onDelete();
                Navigator.pushNamed(context, homeDashboardNewRoute);
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            iconSize: 40,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name
            _buildTextInputField('Task Name', Icons.title, _taskNameController),
            const SizedBox(height: 20),

            // Description
            _buildTextInputField(
                'Brief Description', Icons.description, _descriptionController),
            const SizedBox(height: 20),

            // Start Time
            _buildTimePicker('Start Time', _startTime, 0),
            const SizedBox(height: 20),

            // End Time
            _buildTimePicker('End Time', _endTime, 1),
            const SizedBox(height: 20),

            // Deadline
            _buildTimePicker('Deadline', _deadline, 2),
            const SizedBox(height: 20),

            // Priority
            const Text(
              'Priority',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            _buildPrioritySelector(),
            const SizedBox(height: 20),

            // Progress Slider
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Slider(
              value: _progress,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              label: '${_progress.toInt()}%',
              onChanged: (double value) {
                setState(() {
                  _progress = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Is Completed Checkbox
            Row(
              children: [
                Checkbox(
                  value: _isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCompleted = value ?? false;
                      if (_isCompleted) {
                        _progress = 100;
                      }
                    });
                  },
                ),
                const Text(
                  'Completed?',
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_startTime == null) {
                    await showErrorDialog(context, 'Please enter valid start time');
                    return;
                  }

                  if (_endTime == null) {
                    await showErrorDialog(context, 'Please enter valid end time');
                    return;
                  }

                  if (_endTime!.difference(_startTime!).inMinutes < 30) {
                      await showErrorDialog(context, 'Difference between start time and end time must be at least 30 minutes');
                      return;
                  }

                  // Create a new task object with the edited values
                  final Task updatedTask = Task.fromSnapshot({
                    'id': widget.task.id,
                    'name': _taskNameController.text,
                    'startTime': _startTime,
                    'endTime': _endTime,
                    'priority': _selectedPriority,
                    'description': _descriptionController.text,
                    'deadline': _deadline!,
                    'isCompleted': _isCompleted,
                    'progress': _progress / 100,
                  });

                  // Call the onSave callback to save the edited task
                  widget.onSave(updatedTask);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Text Input Field Widget
  Widget _buildTextInputField(
      String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Update the Time Picker widget to use the new date and time selection
  Widget _buildTimePicker(String label, DateTime? dateTime, int field) {
    return GestureDetector(
      onTap: () => _selectDateTime(context, field),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateTime == null
                  ? label
                  : '${dateTime.day}/${dateTime.month}/${dateTime.year} ${TimeOfDay.fromDateTime(dateTime).format(context)}',
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            Icon(Icons.access_time, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  // Date Picker Widget
  Widget _buildDatePicker(String label, DateTime? date) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null ? label : '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            const Icon(Icons.calendar_today, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  // Priority Selector Widget
  Widget _buildPrioritySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriorityChip('High', Colors.red),
        _buildPriorityChip('Mid', Colors.orange),
        _buildPriorityChip('Low', Colors.green),
      ],
    );
  }

  // Priority Chip Widget
  Widget _buildPriorityChip(String priority, Color color) {
    return ChoiceChip(
      label: Text(priority, style: const TextStyle(color: Colors.white)),
      selected: _selectedPriority == priority,
      onSelected: (bool selected) {
        setState(() {
          _selectedPriority = priority;
        });
      },
      selectedColor: color,
      backgroundColor: color.withOpacity(0.5),
    );
  }
}
