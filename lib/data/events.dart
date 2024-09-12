// Event model
class Event {
  String name;
  String description;
  DateTime date;

  Event({
    required this.name,
    required this.description,
    required this.date,
  });
}

List<Event> events = [
  Event(name: 'Coding Club', description: 'attend at CHCI', date: DateTime(2024, 9, 13, 14, 30)),
  Event(name: 'Chess Club', description: 'attend at CHCI', date: DateTime(2024, 9, 11, 14, 30))
];