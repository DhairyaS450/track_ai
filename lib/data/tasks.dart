class Task {
  String name;
  String startTime;
  String priority;
  String? description;
  bool isCompleted;
  DateTime? deadline;

  Task({
    required this.name,
    required this.startTime,
    required this.priority,
    this.description,
    this.isCompleted = false,
    this.deadline,
  });
}

  final List<Task> todaysTasks = [
    Task(
      name: 'Math Homework', 
      startTime: '9:00 AM', 
      priority: 'High', 
      isCompleted: false, 
      deadline: DateTime(2024, 9, 14)
    ),
    Task(
      name: 'English Essay', 
      startTime: '11:00 AM', 
      priority: 'Mid', 
      isCompleted: true, 
      deadline: DateTime(2024, 9, 15)
    ),
    Task(
      name: 'Science Project', 
      startTime: '2:00 PM', 
      priority: 'Low', 
      isCompleted: false, 
      deadline: DateTime(2024, 9, 15)
    ),
  ];