import 'package:flutter/material.dart';
import 'package:track_ai/data/tasks.dart';
import 'package:track_ai/views/ChatBotScreen.dart';
import 'package:track_ai/views/EditTaskScreen.dart';
import 'CalendarView.dart'; // Import Calendar View
import 'AddNewTaskScreen.dart'; // Import Add New Task Screen

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final String studentName = "Dhairya"; // Example name for the greeting

  void _addNewTask(Task newTask) {
    setState(() {
      todaysTasks.add(newTask); // Add the new task to the task list
    });
  }

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
    int completedTasks = todaysTasks.where((task) => task.isCompleted).length;
    double progress = completedTasks / todaysTasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Greeting section
            Text(
              'Good Morning, $studentName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Today's tasks header
            const Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // Progress Indicator
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            Text('${completedTasks} of ${todaysTasks.length} tasks completed'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todaysTasks.length,
                itemBuilder: (context, index) {
                  Task task = todaysTasks[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: ListTile(
                        title: Text(task.name),
                        subtitle: Text('Start Time: ${task.startTime}'),
                        trailing: Chip(
                          label: Text(task.priority),
                          backgroundColor: getPriorityColor(task.priority),
                        ),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              task.isCompleted = value!;
                            });
                          },
                        ),
                        // When task is tapped, open the EditTaskScreen
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
                        }),
                  );
                },
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Chat with Bot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Access Buttons
            const SizedBox(height: 30),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddNewTaskScreen(onAddTask: _addNewTask)),
                        );
                      },
                      child: const Text('Add New Task'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Add New Event'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to View All Tasks Screen
                      },
                      child: const Text('Add Study Session'),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CalendarView(tasks: todaysTasks)),
                        );
                      },
                      child: const Text('View Calendar'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Sync with Google Calendar',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('View Study Sessions',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get color based on priority
  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Mid':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// Task model

