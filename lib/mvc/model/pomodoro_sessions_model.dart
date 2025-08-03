import 'package:todoro/import_export/todoro_import_export.dart';

class PomodoroSessionModel {
  final int? id;
  final int taskId;
  final DateTime startTime;
  final DateTime? endTime;
  final SessionType type;
  final bool wasCompleted;
  final DateTime createdAt;

  PomodoroSessionModel({
    this.id,
    required this.taskId,
    required this.startTime,
    this.endTime,
    required this.type,
    this.wasCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': type == SessionType.work ? 1 : 0,
      'wasCompleted': wasCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  PomodoroSessionModel copyWith({
    int? id,
    int? taskId,
    DateTime? startTime,
    DateTime? endTime,
    SessionType? type,
    bool? wasCompleted,
    DateTime? createdAt,
  }) {
    return PomodoroSessionModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PomodoroSessionModel.fromMap(Map<String, dynamic> map) {
    return PomodoroSessionModel(
      id: map['id'],
      taskId: map['taskId'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      type: map['type'] == 1 ? SessionType.work : SessionType.break_,
      wasCompleted: map['wasCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Duration get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return Duration.zero;
  }

  @override
  String toString() {
    return 'PomodoroSessionModel(id: $id, taskId: $taskId, type: $type, wasCompleted: $wasCompleted)';
  }
}