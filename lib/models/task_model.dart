enum TaskStatus {
  todo,
  inProgress,
  done,
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final String? blockedBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
  });
}