import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabase {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference for users
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Method to create a new user in Firestore
  Future<void> createUser({
    required String userId,
    required String name,
    required String email,
    required String levelOfStudy,
  }) async {
    try {
      // Create a new document in 'users' collection using userId as the document ID
      await _usersCollection.doc(userId).set({
        'userId': userId,
        'name': name,
        'email': email,
        'levelOfStudy': levelOfStudy,
        'createdAt': FieldValue.serverTimestamp(),
        'tasks': [],
        'events': []
      });
      log("User created successfully.");
    } catch (e) {
      log("Error creating user: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  // Method to get user information from Firestore by userId
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      // Retrieve the document from 'users' collection with the given userId
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();

      // Check if the document exists
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        log("User not found.");
        return null;
      }
    } catch (e) {
      log("Error fetching user: $e");
      return null;
    }
  }

  Future<List<Task>> fetchTasksFromFirestore(String userId) async {
    try {
      // Fetch user info to get the task references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null || userInfo['tasks'] == null) {
        log("No tasks found for user.");
        return [];
      }

      List<Task> tasks = [];
      List<DocumentReference> taskRefs =
          List<DocumentReference>.from(userInfo['tasks']);

      // Fetch each task's details
      for (var taskRef in taskRefs) {
        DocumentSnapshot taskDoc = await taskRef.get();
        if (taskDoc.exists) {
          tasks.add(Task.fromSnapshot(taskDoc.data() as Map<String, dynamic>));
        } else {
          log("Task not found: ${taskRef.id}");
        }
      }

      return tasks;
    } catch (e) {
      log("Error fetching tasks: $e");
      return [];
    }
  }
  
  Future<List<Event>> fetchUserEvents(String userId) async {
    try {
      // Fetch user info to get the event references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null || userInfo['events'] == null) {
        log("No events found for user.");
        return [];
      }

      List<Event> events = [];
      List<DocumentReference> eventRefs =
          List<DocumentReference>.from(userInfo['events']);

      // Fetch each event's details
      for (var eventRef in eventRefs) {
        DocumentSnapshot eventDoc = await eventRef.get();
        if (eventDoc.exists) {
          events
              .add(Event.fromSnapshot(eventDoc.data() as Map<String, dynamic>));
        } else {
          log("Event not found: ${eventRef.id}");
        }
      }
      return events;
    } catch (e) {
      log("Error fetching events: $e");
      return [];
    }
  }


  // Stream to fetch tasks from Firestore in real-time
  Stream<List<Task>> taskStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((userSnapshot) async {
      if (userSnapshot.exists && userSnapshot.data() != null) {
        List<dynamic> taskReferences = userSnapshot.data()!['tasks'] ?? [];
        List<DocumentReference<Map<String, dynamic>>> taskRefs =
            taskReferences.cast<DocumentReference<Map<String, dynamic>>>();

        // Fetch each task snapshot using the list of document references
        List<Task> tasks = await Future.wait(taskRefs.map((ref) async {
          DocumentSnapshot<Map<String, dynamic>> taskSnapshot = await ref.get();
          return Task.fromSnapshot(taskSnapshot.data()!);
        }));

        return tasks;
      } else {
        return [];
      }
    });
  }

  // Stream to fetch events from Firestore in real-time
  Stream<List<Event>> eventStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((userSnapshot) async {
      if (userSnapshot.exists && userSnapshot.data() != null) {
        List<dynamic> eventReferences = userSnapshot.data()!['events'] ?? [];
        List<DocumentReference<Map<String, dynamic>>> eventRefs =
            eventReferences.cast<DocumentReference<Map<String, dynamic>>>();

        // Fetch each event snapshot using the list of document references
        List<Event> events = await Future.wait(eventRefs.map((ref) async {
          DocumentSnapshot<Map<String, dynamic>> eventSnapshot = await ref.get();
          return Event.fromSnapshot(eventSnapshot.data()!);
        }));

        return events;
      } else {
        return [];
      }
    });
  }

  Future<void> addTask(String userId, Map<String, dynamic> taskData) async {
    try {
      // Fetch user info to get the task references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null) {
        log("User not found.");
        return;
      }

      // Create a new task document in the 'tasks' collection
      DocumentReference taskRef =
          await _firestore.collection('tasks').add(taskData);

      // Get the auto-generated document ID
      String taskId = taskRef.id;

      // Update the task document with its own ID
      await taskRef.update({'id': taskId});

      // Update the user's tasks array with the new task reference
      await _usersCollection.doc(userId).update({
        'tasks': FieldValue.arrayUnion([taskRef])
      });

      log("Task added successfully with ID: $taskId");
    } catch (e) {
      log("Error adding task: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  Future<void> updateTask(
      String userId, String taskId, Map<String, dynamic> updatedData) async {
    try {
      // Fetch user info to get the task references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null || userInfo['tasks'] == null) {
        log("No tasks found for user.");
        return;
      }

      // Find the task reference
      List<DocumentReference> taskRefs =
          List<DocumentReference>.from(userInfo['tasks']);
      DocumentReference? taskRef;

      for (var ref in taskRefs) {
        if (ref.id == taskId) {
          taskRef = ref;
          break;
        }
      }

      if (taskRef == null) {
        log("Task with ID $taskId not found.");
        return;
      }

      // Update the task document
      await taskRef.update(updatedData);
      log("Task updated successfully.");
    } catch (e) {
      log("Error updating task: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      // Fetch user info to get the task references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null || userInfo['tasks'] == null) {
        log("No tasks found for user.");
        return;
      }

      // Find the task reference
      List<DocumentReference> taskRefs =
          List<DocumentReference>.from(userInfo['tasks']);
      DocumentReference? taskRef;

      for (var ref in taskRefs) {
        if (ref.id == taskId) {
          taskRef = ref;
          break;
        }
      }

      if (taskRef == null) {
        log("Task with ID $taskId not found.");
        return;
      }

      // Delete the task document
      await taskRef.delete();
      log("Task deleted successfully.");
    } catch (e) {
      log("Error deleting task: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  Future<void> addEvent(String userId, Map<String, dynamic> eventData) async {
    try {
      // Fetch user info to get the event references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null) {
        log("User not found.");
        return;
      }

      // Create a new event document in the 'events' collection
      DocumentReference eventRef =
          await _firestore.collection('events').add(eventData);

      // Update the user's events array with the new event reference
      await _usersCollection.doc(userId).update({
        'events': FieldValue.arrayUnion([eventRef])
      });

      log("Event added successfully.");
    } catch (e) {
      log("Error adding event: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  Future<void> updateEvent(
      String userId, String eventId, Map<String, dynamic> updatedData) async {
    try {
      // Fetch user info to get the event references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null || userInfo['events'] == null) {
        log("No events found for user.");
        return;
      }

      // Find the event reference
      List<DocumentReference> eventRefs =
          List<DocumentReference>.from(userInfo['events']);
      DocumentReference? eventRef;

      for (var ref in eventRefs) {
        if (ref.id == eventId) {
          eventRef = ref;
          break;
        }
      }

      if (eventRef == null) {
        log("Event with ID $eventId not found.");
        return;
      }

      // Update the event document
      await eventRef.update(updatedData);
      log("Event updated successfully.");
    } catch (e) {
      log("Error updating event: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    try {
      // Fetch user info to get the event references
      Map<String, dynamic>? userInfo = await getUserInfo(userId);

      if (userInfo == null || userInfo['events'] == null) {
        log("No events found for user.");
        return;
      }

      // Find the event reference
      List<DocumentReference> eventRefs =
          List<DocumentReference>.from(userInfo['events']);
      DocumentReference? eventRef;

      for (var ref in eventRefs) {
        if (ref.id == eventId) {
          eventRef = ref;
          break;
        }
      }

      if (eventRef == null) {
        log("Event with ID $eventId not found.");
        return;
      }

      // Delete the event document
      await eventRef.delete();
      log("Event deleted successfully.");
    } catch (e) {
      log("Error deleting event: $e");
      if (e is FirebaseException) {
        log("Firebase error code: ${e.code}");
      }
    }
  }

  Future<void> testFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('test')
          .add({'testField': 'testValue'});
      log("Test document added successfully.");
    } catch (e) {
      log("Error adding test document: $e");
    }
  }
}

// Task Model
class Task {
  final String id;
  final String name;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? description;
  final String priority;
  final DateTime deadline;
  final bool isCompleted;
  final double progress;

  Task({
    required this.id,
    required this.name,
    this.startTime,
    this.endTime,
    required this.priority,
    this.description,
    required this.deadline,
    required this.isCompleted,
    required this.progress,
  });

  factory Task.fromSnapshot(Map<String, dynamic> snapshot) {
    return Task(
      id: snapshot['id'],
      name: snapshot['name'] ?? '',
      startTime: snapshot['startTime'] is Timestamp
          ? snapshot['startTime'].toDate()
          : snapshot['startTime'],
      endTime: snapshot['endTime'] is Timestamp
          ? snapshot['endTime'].toDate()
          : snapshot['endTime'],
      description: snapshot['description'] ?? '',
      priority: snapshot['priority'] ?? 'Low',
      deadline: snapshot['deadline'] is Timestamp
          ? snapshot['deadline'].toDate()
          : snapshot['deadline'],
      isCompleted: snapshot['isCompleted'] ?? false,
      progress: (snapshot['progress'] ?? 0.0).toDouble(),
    );
  }

  // Convert Task to Map<String, dynamic> for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'description': description,
      'priority': priority,
      'deadline': Timestamp.fromDate(deadline),
      'isCompleted': isCompleted,
      'progress': progress,
    };
  }
}

// Event model
class Event {
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  Event({
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromSnapshot(Map<String, dynamic> snapshot) {
    return Event(
      name: snapshot["name"] ?? '',
      description: snapshot['description'] ?? '',
      startTime: (snapshot['startTime'] as Timestamp).toDate(),
      endTime: (snapshot['endTime'] as Timestamp).toDate(),
    );
  }
}
