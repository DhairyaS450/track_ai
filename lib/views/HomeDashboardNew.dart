import 'package:flutter/material.dart';

class HomeDashboardNew extends StatelessWidget {
  final List<Task> todaysTasks = [
    Task(
      name: 'Math Homework',
      startTime: '9:00 AM',
      priority: 'High',
      deadline: DateTime(2023, 9, 14),
      isCompleted: false,
      progress: 0.5, // 50% done
    ),
    Task(
      name: 'Physics Revision',
      startTime: '11:00 AM',
      priority: 'Medium',
      deadline: DateTime(2023, 9, 14),
      isCompleted: true,
      progress: 1.0, // Completed
    ),
  ];

  HomeDashboardNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Today’s Study Plan'),
          backgroundColor: Colors.blueAccent,
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudySessionOverlay()),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Stats Overview
                _buildTaskStatsOverview(),
                const SizedBox(height: 20),

                // Section: "Your Tasks for Today" with Edit and Calendar Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Tasks for Today',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            // Logic to edit tasks
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.blueAccent),
                          onPressed: () {
                            // Navigate to calendar view
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTaskList(),
                const SizedBox(height: 30),
                _buildDailyMotivation(),
              ],
            ),
          ),
        ));
  }

  // Task Stats Overview
  Widget _buildTaskStatsOverview() {
    int completedTasks = todaysTasks.where((task) => task.isCompleted).length;
    int totalTasks = todaysTasks.length;

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

  // Task List Builder
  Widget _buildTaskList() {
    return Column(
      children: todaysTasks.map((task) => _buildTaskCard(task)).toList(),
    );
  }

  // Task Card
  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  task.isCompleted
                      ? Icons.check_circle_outline
                      : Icons.schedule,
                  color: task.isCompleted ? Colors.green : Colors.orange,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  task.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: task.isCompleted ? Colors.green : Colors.black87,
                  ),
                ),
                const Spacer(),
                _buildTaskPriorityChip(task.priority),
              ],
            ),
            const SizedBox(height: 10),

            // Task Progress Bar
            LinearProgressIndicator(
              value: task.progress,
              backgroundColor: Colors.grey[300],
              color: task.isCompleted ? Colors.green : Colors.blueAccent,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start Time: ${task.startTime}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                if (task.isCompleted)
                  const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
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
          Container(
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

// Task Model
class Task {
  final String name;
  final String startTime;
  final String priority;
  final DateTime deadline;
  final bool isCompleted;
  final double progress;

  Task({
    required this.name,
    required this.startTime,
    required this.priority,
    required this.deadline,
    required this.isCompleted,
    required this.progress,
  });
}