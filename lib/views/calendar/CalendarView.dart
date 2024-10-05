import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_ai/functions/FormatDate.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
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
  List<Task> tasks = [];
  List<Event> events = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  _getTasks() async {
    tasks = await _firestoreDatabase.fetchTasksFromFirestore(uid);
  }

  _getEvents() async {
    events = await _firestoreDatabase.fetchUserEvents(uid);
  }

  @override
  void initState() {
    _getTasks();
    _getEvents();
    super.initState();
  }

  List<Task> _getTasksForDay(DateTime day) {
    return tasks.where((task) {
      // Match only the date part, ignore time
      return DateTime(
              task.deadline.year, task.deadline.month, task.deadline.day) ==
          DateTime(day.year, day.month, day.day);
    }).toList();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events.where((event) {
      // Match only the date part, ignore time
      return DateTime(event.startTime.year, event.startTime.month, event.startTime.day) ==
          DateTime(day.year, day.month, day.day);
    }).toList();
  }

  // Add new event
  dynamic _addNewEvent(Event newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  // Edit an existing event
  dynamic _editEvent(Event oldEvent, Event newEvent) {
    setState(() {
      int eventIndex = events.indexOf(oldEvent);
      if (eventIndex != -1) {
        events[eventIndex] = newEvent;
      }
    });
  }

  // Delete an event
  dynamic _deleteEvent(Event eventToDelete) {
    setState(() {
      events.remove(eventToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksForDay =
        _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];
    final eventsForDay =
        _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Calendar'),
      ),
      body: Column(
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
            // Event loader to display markers for tasks and events
            eventLoader: (day) {
              List<Task> tasksForDay = _getTasksForDay(day);
              List<Event> eventsForDay = _getEventsForDay(day);

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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
                child: _buildTaskList(
                    tasksForDay.cast<Task>())), // Cast to List<Task>
            const SizedBox(height: 10),
            const Text('Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
                child: _buildEventList(
                    eventsForDay.cast<Event>())), // Cast to List<Event>
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new event button
          if (_selectedDay != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditEventScreen(
                  date: _selectedDay!,
                  onAddEvent: _addNewEvent,
                ),
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
              setState(() {
                // task.isCompleted = value!;
              });
            },
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EditTaskScreen(
            //       task: task,
            //       onEditTask: (editedTask) {
            //         setState(() {
            //           int taskIndex = tasks.indexOf(task);
            //           if (taskIndex != -1) {
            //             tasks[taskIndex] = editedTask as Task;
            //           }
            //         });
            //       },
            //       onDeleteTask: (taskToDelete) {
            //         setState(() {
            //           tasks.remove(taskToDelete);
            //         });
            //       },
            //     ),
            //   ),
            // );
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
                  onEditEvent: (editedEvent) {
                    _editEvent(event, editedEvent);
                  },
                  onDeleteEvent: _deleteEvent,
                  onAddEvent: _addNewEvent,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
