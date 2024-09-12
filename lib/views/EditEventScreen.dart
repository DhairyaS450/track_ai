
import 'package:flutter/material.dart';
import 'package:track_ai/data/events.dart';
import 'HomeDashboard.dart'; // Import the Event model
import 'package:intl/intl.dart'; // For date formatting

class EditEventScreen extends StatefulWidget {
  final Event? event;
  final DateTime? date;
  final Function(Event) onAddEvent;
  final Function(Event)? onEditEvent;
  final Function(Event)? onDeleteEvent;

  EditEventScreen({
    this.event,
    this.date,
    required this.onAddEvent,
    this.onEditEvent,
    this.onDeleteEvent,
  });

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late String eventName;
  late String description;
  late DateTime eventDate;

  @override
  void initState() {
    super.initState();
    eventName = widget.event?.name ?? '';
    description = widget.event?.description ?? '';
    eventDate = widget.event?.date ?? widget.date!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : 'Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Event Name Input
              TextFormField(
                initialValue: eventName,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onSaved: (value) => eventName = value!,
              ),
              
              // Description Input
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),

              // Date Picker
              ListTile(
                title: Text('Date: ${DateFormat.yMMMd().format(eventDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: eventDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      eventDate = picked;
                    });
                  }
                },
              ),

              // Save Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Event newEvent = Event(
                      name: eventName,
                      description: description,
                      date: eventDate,
                    );

                    if (widget.event != null) {
                      widget.onEditEvent!(newEvent);
                    } else {
                      widget.onAddEvent(newEvent);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.event != null ? 'Save Changes' : 'Add Event'),
              ),

              // Delete Button (if editing an existing event)
              if (widget.event != null) ...[
                SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    // Confirm before deleting
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Event'),
                          content: Text('Are you sure you want to delete this event?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onDeleteEvent!(widget.event!);
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Go back to Calendar view
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Delete Event'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}