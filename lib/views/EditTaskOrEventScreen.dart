import 'package:flutter/material.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/views/events/EditEventScreen.dart';
import 'package:track_ai/views/tasks/EditTaskScreen.dart';

class EditTaskOrEventScreen extends StatelessWidget {
  final dynamic item; // Can be either Task or Event
  final Function(dynamic) onSave; // Save callback
  final Future<void> Function() onDelete; // Delete callback

  EditTaskOrEventScreen({
    required this.item,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if item is Task or Event
    if (item is Task) {
      // If item is a Task, navigate to EditTaskScreen
      return EditTaskScreen(
        task: item,
        onSave: (Task updatedTask) {
          onSave(updatedTask);
        },
        onDelete: () async {
          await onDelete();
        },
      );
    } else if (item is Event) {
      // If item is an Event, navigate to EditEventScreen
      return EditEventScreen(
        event: item,
        onSave: (Event updatedEvent) {
          onSave(updatedEvent);
        },
        onDelete: () async {
          await onDelete();
        },
      );
    } else {
      // If neither, show an error message or placeholder
      return Scaffold(
        appBar: AppBar(
          title: const Text("Invalid Item"),
        ),
        body: const Center(
          child: Text("This item type is not supported."),
        ),
      );
    }
  }
}
