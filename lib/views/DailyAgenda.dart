import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/views/EditTaskOrEventScreen.dart';
import 'package:track_ai/views/tasks/EditTaskScreen.dart';

class DailyAgendaWidget extends StatelessWidget {
  final List<Task> tasks;
  final List<Event> events;
  final double height;

  DailyAgendaWidget(
      {required this.tasks,
      required this.events,
      required this.height,
      super.key});

  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  final String uid = AuthService().currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    // Combine tasks and events into one list with a unified structure.
    final List<dynamic> dayItems = [...tasks, ...events];

    // Find the earliest and latest times to set the start and end of the schedule.
    final earliestTime = dayItems
        .map((item) => item.startTime as DateTime)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final latestTime = dayItems
        .map((item) => item.endTime as DateTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    log('Here');

    final startHour = earliestTime.hour;
    final endHour =
        latestTime.hour + 1; // Add 1 to include the final hour block

    return Container(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(endHour - startHour, (hourIndex) {
            final hour = startHour + hourIndex;
            final timeLabel = TimeOfDay(hour: hour, minute: 0).format(context);

            // Filter items that fall within this hour block
            final hourItems = dayItems.where((item) {
              final itemStart = item.startTime as DateTime;
              final itemEnd = item.endTime as DateTime;
              return (itemStart.hour <= hour && itemEnd.hour >= hour);
            }).toList();

            log(hourItems.toString());

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Label
                Container(
                  width: 50,
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    timeLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                // Hour Block
                Expanded(
                  child: Container(
                    height:
                        60.0, // Adjust the height of each hour block as needed
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: Stack(
                      children: hourItems.map((item) {
                        final itemStart = item.startTime as DateTime;
                        final itemEnd = item.endTime as DateTime;
                        Color color = Colors.orange;
                        if (item is Event) {
                          color = Colors.blue;
                        }

                        // Calculate the positioning within the hour block
                        final topOffset =
                            ((itemStart.hour - hour) * 60 + itemStart.minute)
                                .toDouble();
                        final bottomOffset =
                            ((itemEnd.hour - hour) * 60 + itemEnd.minute)
                                .toDouble();
                        final itemHeight = (bottomOffset - topOffset).abs();

                        return Positioned(
                            top: topOffset,
                            left: 0,
                            right: 0,
                            height: itemHeight,
                            child: Container(
                              color: color.withOpacity(0.5),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 8.0),
                              child: TextButton(
                                  child: Text(item.name as String,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditTaskOrEventScreen(
                                          item: item,
                                          onSave: (updatedItem) {
                                            if (updatedItem is Task) {
                                              _firestoreDatabase.updateTask(
                                                  uid,
                                                  updatedItem.id,
                                                  updatedItem.toMap());
                                            } else if (updatedItem is Event) {
                                              _firestoreDatabase.updateEvent(
                                                  uid,
                                                  updatedItem.id,
                                                  updatedItem.toMap());
                                            }
                                          },
                                          onDelete: () async {
                                            if (item is Task) {
                                              await _firestoreDatabase
                                                  .deleteTask(uid, item.id);
                                            } else if (item is Event) {
                                              await _firestoreDatabase
                                                  .deleteEvent(uid, item.id);
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ));
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
