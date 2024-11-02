import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/utilities/dialogs/error_dialog.dart';

class AddNewEventScreen extends StatefulWidget {
  const AddNewEventScreen({super.key});
  
  @override
  State<AddNewEventScreen> createState() => _AddNewEventScreenState();
}

class _AddNewEventScreenState extends State<AddNewEventScreen> {
  // Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variables for storing selected values
  DateTime? _startTime;
  DateTime? _endTime;
  String _selectedPriority = 'Mid';

  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  final String uid = AuthService().currentUser!.uid;

  @override
  void dispose() {
    _eventNameController.dispose();
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name
            _buildTextInputField('Event Name', Icons.title, _eventNameController),
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
                    return;
                  }

                  if (_eventNameController.text.isEmpty) {
                    await showErrorDialog(context, 'Please enter an event name');
                    return;
                  }
                  // Handle event creation logic here
                  log('Event Name: ${_eventNameController.text}');
                  log('Description: ${_descriptionController.text}');
                  log('Start Time: $startTimeDate');
                  log('End Time: $endTimeDate');
                  log('Priority: $_selectedPriority');

                  // Add the event to Firestore (replace with your event creation logic)
                  _firestoreDatabase.addEvent(uid, {
                    "name": _eventNameController.text,
                    "description": _descriptionController.text,
                    "startTime": startTimeDate,
                    "endTime": endTimeDate,
                    "priority": _selectedPriority,
                  });

                  Navigator.of(context).pop(); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save Event',
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

  // Time Picker Widget
  Widget _buildTimePicker(String label, DateTime? dateTime, int field) {
    return GestureDetector(
      onTap: () => _selectDateTime(context, field),
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
              dateTime == null
                  ? label
                  : '${dateTime.day}/${dateTime.month}/${dateTime.year} ${TimeOfDay.fromDateTime(dateTime).format(context)}',
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            const Icon(Icons.access_time, color: Colors.blueAccent),
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
