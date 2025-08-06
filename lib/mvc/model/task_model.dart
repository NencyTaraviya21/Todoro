import 'package:todoro/import_export/todoro_import_export.dart';

class TaskModel {
  final int? id;
  final int userId;
  final String title;
  final String ? description;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime? deadLine;
  final int ? estimatedPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    required this.category,
    this.deadLine,
    this.estimatedPomodoros,
    this.completedPomodoros = 0,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.name,
      'category': category.name,
      'deadline': deadLine?.toIso8601String(),
      'estimatedPomodoros': estimatedPomodoros,
      'completedPomodoros': completedPomodoros,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      priority: TaskPriority.values.firstWhere(
            (p) => p.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      category: TaskCategory.values.firstWhere(
            (c) => c.name == map['category'],
        orElse: () => TaskCategory.other,
      ),
      deadLine: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      estimatedPomodoros: map['estimatedPomodoros'],
      completedPomodoros: map['completedPomodoros'] ?? 0,
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  TaskModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? deadline,
    int? estimatedPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      deadLine: deadline ?? this.deadLine,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }



  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted)';
  }
}