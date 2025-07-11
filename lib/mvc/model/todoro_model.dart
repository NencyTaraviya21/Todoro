class Task {
  int id;
  int userId;
  String title;
  bool completed;
  String createdAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'completed': completed,
    };
  }
}
