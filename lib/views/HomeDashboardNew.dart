import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/functions/FormatDate.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/views/DailyAgenda.dart';
import 'package:track_ai/views/tasks/EditTaskScreen.dart';
import 'package:track_ai/views/events/EditEventScreen.dart';

class HomeDashboardNew extends StatefulWidget {
  const HomeDashboardNew({super.key});

  @override
  State<HomeDashboardNew> createState() => _HomeDashboardNewState();
}

class _HomeDashboardNewState extends State<HomeDashboardNew> {
  final String uid = AuthService().currentUser!.uid;
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track AI'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 40),
            onPressed: () =>
                Navigator.of(context).pushNamed(settingsScreenRoute),
          ),
        ],
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: Rx.combineLatest2(
          _firestoreDatabase.taskStream(uid),
          _firestoreDatabase.eventStream(uid),
          (List<Task> tasks, List<Event> events) => [tasks, events],
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Task> todaysTasks = snapshot.data![0].where((task) {
            final now = DateTime.now();
            return (task.startTime == null ||
                (task.startTime!.day == now.day &&
                    task.startTime!.month == now.month &&
                    task.startTime!.year == now.year));
          }).toList();

          List<Event> todaysEvents = snapshot.data![1].where((event) {
            final now = DateTime.now();
            return (event.startTime == null ||
                (event.startTime!.day == now.day &&
                    event.startTime!.month == now.month &&
                    event.startTime!.year == now.year));
          }).toList();

          for (Task task in todaysTasks) {
            log(task.name);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskStatsOverview(todaysTasks),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's agenda",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blueAccent),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(addNewTaskScreenRoute);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.blueAccent),
                          onPressed: () {
                            Navigator.of(context).pushNamed(calendarViewRoute);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DailyAgendaWidget(
                  tasks: todaysTasks,
                  events: todaysEvents,
                  height: 300
                ),
                const SizedBox(height: 30),
                _buildDailyMotivation(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Combined Task and Event List Builder
  Widget _buildTaskAndEventList(
      List<Task> todaysTasks, List<Event> todaysEvents) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...todaysTasks.map((task) => _buildTaskCard(task)).toList(),
            ...todaysEvents.map((event) => _buildEventCard(event)).toList(),
          ],
        ),
      ),
    );
  }

  // Task Card
  Widget _buildTaskCard(Task task) {
    return InkWell(
      onLongPress: () {
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    task.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              _buildTaskPriorityChip(task.priority),
            ],
          ),
        ),
      ),
    );
  }

  // Event Card
  Widget _buildEventCard(Event event) {
    return InkWell(
      onLongPress: () {
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.event,
                color: Colors.green,
                size: 30,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    event.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              _buildEventPriorityChip(event.priority),
            ],
          ),
        ),
      ),
    );
  }

  // Task Priority Chip
  Widget _buildTaskPriorityChip(String priority) {
    Color chipColor;
    if (priority == 'High') {
      chipColor = Colors.red;
    } else if (priority == 'Medium') {
      chipColor = Colors.orange;
    } else {
      chipColor = Colors.green;
    }
    return Chip(
      label: Text(priority, style: const TextStyle(color: Colors.white)),
      backgroundColor: chipColor,
    );
  }

  // Event Priority Chip
  Widget _buildEventPriorityChip(String priority) {
    Color chipColor;
    if (priority == 'Urgent') {
      chipColor = Colors.redAccent;
    } else if (priority == 'Standard') {
      chipColor = Colors.blue;
    } else {
      chipColor = Colors.teal;
    }
    return Chip(
      label: Text(priority, style: const TextStyle(color: Colors.white)),
      backgroundColor: chipColor,
    );
  }
}

// Task Stats Overview
Widget _buildTaskStatsOverview(List<Task> todaysTasks) {
  int completedTasks = todaysTasks.where((task) => task.isCompleted).length;
  int totalTasks = todaysTasks.length;

  if (totalTasks == 0) {
    totalTasks = 1;
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blueAccent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              '$completedTasks / $totalTasks',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Tasks Completed',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
        CircularProgressIndicator(
          value: completedTasks / totalTasks,
          backgroundColor: Colors.grey[300],
          color: Colors.blueAccent,
          strokeWidth: 8,
        ),
      ],
    ),
  );
}

// Daily Motivation Section
Widget _buildDailyMotivation() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.greenAccent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.lightbulb_outline, color: Colors.greenAccent, size: 30),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '"Success is the sum of small efforts, repeated day in and day out."',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

// Modernized Study Session Overlay
Widget StudySessionOverlay() {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Ongoing Study Session'),
      backgroundColor: Colors.blueAccent,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {
            // Settings or more options
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Circular Countdown Timer
          _buildCircularCountdownTimer(),
          const SizedBox(height: 20),

          // Study Session Overview
          _buildStudySessionOverview(),
          const SizedBox(height: 30),

          // Control Buttons (Pause, Skip, End Session)
          _buildControlButtons(),
          const SizedBox(height: 30),

          // Chatbot Interaction
          _buildChatbotInputField(),
        ],
      ),
    ),
  );
}

// Circular Countdown Timer Widget
Widget _buildCircularCountdownTimer() {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: 0.5, // 50% completed
              strokeWidth: 10,
              backgroundColor: Colors.lightBlue[300],
              color: Colors.blueAccent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '12:25',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                'Remaining',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10),
      const Text(
        'Pomodoro Timer',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blueAccent,
        ),
      ),
    ],
  );
}

// Study Session Overview Widget
Widget _buildStudySessionOverview() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 4,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.book, color: Colors.lightBlueAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Math & Physics Revision',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Focus on solving algebraic equations and revising Newton’s Laws for the upcoming test.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              Icon(Icons.timer, color: Colors.blueAccent, size: 28),
              SizedBox(width: 10),
              Text(
                'Time Allocated: 2 hours',
                style: TextStyle(fontSize: 16, color: Colors.blueAccent),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Control Buttons for Pause, Skip, End Session
Widget _buildControlButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton.icon(
        onPressed: () {
          // Pause logic
        },
        icon: const Icon(Icons.pause_circle_filled, color: Colors.white),
        label: const Text('Pause'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      ElevatedButton.icon(
        onPressed: () {
          // Skip logic
        },
        icon: const Icon(Icons.skip_next, color: Colors.white),
        label: const Text('Skip'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      ElevatedButton.icon(
        onPressed: () {
          // End Session logic
        },
        icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
        label: const Text('End'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ],
  );
}

// Chatbot Input Field Widget
Widget _buildChatbotInputField() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blueGrey[100],
      borderRadius: BorderRadius.circular(15),
    ),
    child: const TextField(
      decoration: InputDecoration(
        hintText: 'Have any questions? Ask the Track Chatbot.',
        hintMaxLines: 2,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.chat, color: Colors.blueAccent),
        suffixIcon: Icon(Icons.send, color: Colors.blueAccent),
      ),
    ),
  );
}
