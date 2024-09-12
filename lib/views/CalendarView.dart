import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:track_ai/data/tasks.dart';
import 'package:track_ai/views/EditTaskScreen.dart';
import 'package:track_ai/views/HomeDashboard.dart';

class CalendarView extends StatefulWidget {
  final List<Task> tasks;
  const CalendarView({required this.tasks});

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _editTask(Task oldTask, Task newTask) {
    setState(() {
      int taskIndex = todaysTasks.indexOf(oldTask);
      if (taskIndex != -1) {
        todaysTasks[taskIndex] =
            newTask; // Replace the old task with the edited task
      }
    });
  }

  void _deleteTask(Task taskToDelete) {
    setState(() {
      todaysTasks.remove(taskToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Show dots on days with tasks
            eventLoader: (day) {
              DateTime normalizedDay =
                  DateTime(day.year, day.month, day.day); // Normalize the date
              // Return tasks whose deadline matches the selected day
              return widget.tasks
                  .where((task) => task.deadline != null)
                  .where((task) =>
                      DateTime(task.deadline!.year, task.deadline!.month,
                          task.deadline!.day) ==
                      normalizedDay)
                  .toList();
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

          // Display tasks for the selected day
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  // Build the task list for the selected day
  Widget _buildTaskList() {
    if (_selectedDay == null) {
      return const Center(child: Text('Select a day to view items'));
    }

    // Normalize selected day to ignore the time
    DateTime normalizedDay =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

    List<Task> tasks = widget.tasks
        .where((task) => task.deadline != null)
        .where((task) =>
            DateTime(task.deadline!.year, task.deadline!.month,
                task.deadline!.day) ==
            normalizedDay)
        .toList();

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
                  task.isCompleted = value!;
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(
                    task: task,
                    onEditTask: (editedTask) {
                      _editTask(task, editedTask);
                    },
                    onDeleteTask: (taskToDelete) {
                      _deleteTask(taskToDelete);
                    },
                  ),
                ),
              );
            });
      },
    );
  }
}