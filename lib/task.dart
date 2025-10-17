class Task {
  String title;
  String description;
  DateTime date;
  bool completed;

  Task({required this.title, required this.description, required this.date, this.completed = false});
}