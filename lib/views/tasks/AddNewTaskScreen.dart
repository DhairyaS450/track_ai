import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/utilities/dialogs/error_dialog.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  // Controllers
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variables for storing selected values
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? _deadline;
  String _selectedPriority = 'Mid';

  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  final String uid = AuthService().currentUser!.uid;

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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


  // Method to pick deadline date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.blueAccent,
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
            _buildTextInputField('Brief Description', Icons.description, _descriptionController),
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
            const SizedBox(height: 30),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final now = DateTime.now();
                  DateTime? startTimeDate;
                  DateTime? endTimeDate;

                  if (_startTime != null) {
                    startTimeDate = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
                  } else {
                    await showErrorDialog(context, 'Must enter valid start time');
                    return;
                  }

                  if (_endTime != null) {
                    endTimeDate = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);
                    if (endTimeDate.difference(startTimeDate).inMinutes < 30) {
                      await showErrorDialog(context, 'Difference between start time and end time must be at least 30 minutes');
                      return;
                    }
                  } else {
                    await showErrorDialog(context, 'Must enter valid end time');
                  }

                  if (_deadline == null) {
                    await showErrorDialog(context, 'Deadline must be entered');
                    return;
                  } else if (_taskNameController.text.isEmpty) {
                    await showErrorDialog(context, 'Please enter a task name');
                    return;
                  }
                  // Handle task creation logic here
                  log('Task Name: ${_taskNameController.text}');
                  log('Description: ${_descriptionController.text}');
                  log('Start Time: $startTimeDate');
                  log('End Time: $endTimeDate');
                  log('Deadline: $_deadline');
                  log('Priority: $_selectedPriority');

                  _firestoreDatabase.addTask(uid, {
                    "name": _taskNameController.text,
                    "description": _descriptionController.text,
                    "startTime": startTimeDate,
                    "endTime": endTimeDate,
                    "deadline": _deadline,
                    "priority": _selectedPriority,
                    "isCompleted": false,
                    "progress": 0.0
                  });

                  Navigator.of(context).pushNamed(homeDashboardNewRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Task',
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
  Widget _buildTextInputField(String hint, IconData icon, TextEditingController controller) {
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
