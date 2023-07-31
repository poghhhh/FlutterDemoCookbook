class Task {
  final int id;
  final String taskName;
  final String time;

  Task({
    this.id = 0,
    required this.taskName,
    required this.time,
  });
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      taskName: map['taskName'],
      time: map['time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': taskName,
      'time': time,
    };
  }
}
