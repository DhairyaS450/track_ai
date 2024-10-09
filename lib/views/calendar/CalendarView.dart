import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_ai/functions/FormatDate.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/views/events/AddNewEventScreen.dart';
import '../tasks/EditTaskScreen.dart';
import '../events/EditEventScreen.dart'; // Import for editing events

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final String uid = AuthService().currentUser!.uid;
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  List<Task> _getTasksForDay(DateTime day, List<Task> tasks) {
    return tasks.where((task) {
      // Match only the date part, ignore time
      return DateTime(
              task.deadline.year, task.deadline.month, task.deadline.day) ==
          DateTime(day.year, day.month, day.day);
    }).toList();
  }

  List<Event> _getEventsForDay(DateTime day, List<Event> events) {
    return events.where((event) {
      // Match only the date part, ignore time
      return DateTime(event.startTime.year, event.startTime.month,
              event.startTime.day) ==
          DateTime(day.year, day.month, day.day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Calendar'),
      ),
      body: Column(
        children: [
          StreamBuilder<List<Task>>(
            stream: _firestoreDatabase.taskStream(uid),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (taskSnapshot.hasError) {
                return const Center(child: Text('Error loading tasks.'));
              }

              return StreamBuilder<List<Event>>(
                stream: _firestoreDatabase.eventStream(uid),
                builder: (context, eventSnapshot) {
                  if (eventSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (eventSnapshot.hasError) {
                    return const Center(child: Text('Error loading events.'));
                  }

                  final List<Task> tasks = taskSnapshot.data ?? [];
                  final List<Event> events = eventSnapshot.data ?? [];

                  final tasksForDay = _selectedDay != null
                      ? _getTasksForDay(_selectedDay!, tasks)
                      : [];
                  final eventsForDay = _selectedDay != null
                      ? _getEventsForDay(_selectedDay!, events)
                      : [];

                  return Expanded(
                    child: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2050, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          eventLoader: (day) {
                            List<Task> tasksForDay = _getTasksForDay(day, tasks);
                            List<Event> eventsForDay = _getEventsForDay(day, events);

                            return [
                              ...tasksForDay,
                              ...eventsForDay
                            ]; // Combine tasks and events
                          },
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Display tasks and events for the selected day
                        if (_selectedDay != null) ...[
                          const Text('Deadlines',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: _buildTaskList(tasksForDay as List<Task>),
                          ),
                          const SizedBox(height: 10),
                          const Text('Events',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: _buildEventList(eventsForDay as List<Event>),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new event button
          if (_selectedDay != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewEventScreen(),
              ),
            );
          }
        },
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the task list for the selected day
  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks scheduled for this day'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return ListTile(
          title: Text(task.name),
          subtitle: Text('Priority: ${task.priority}'),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              // setState(() {
              //   // Update task completion status
              //   // task.isCompleted = value ?? false;
              // });
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(
                  task: task,
                  onSave: (Task updatedTask) {
                    _firestoreDatabase.updateTask(
                        uid, updatedTask.id, updatedTask.toMap());
                    setState(() {
                      task = updatedTask;
                    });
                  },
                  onDelete: () async {
                    _firestoreDatabase.deleteTask(uid, task.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Build the event list for the selected day
  Widget _buildEventList(List<Event> events) {
    if (events.isEmpty) {
      return const Center(child: Text('No events scheduled for this day'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        Event event = events[index];
        return ListTile(
          title: Text(event.name),
          subtitle: Text(formatTimeOfDay(event.startTime)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditEventScreen(
                  event: event,
                  onSave: (Event updatedEvent) {
                    _firestoreDatabase.updateEvent(
                        uid, updatedEvent.id, updatedEvent.toMap());
                    setState(() {
                      event = updatedEvent;
                    });
                  },
                  onDelete: () async {
                    _firestoreDatabase.deleteEvent(uid, event.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
