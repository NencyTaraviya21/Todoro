import 'package:todoro/import_export/todoro_import_export.dart';

extension PomodoroSessionModelExtension on PomodoroSessionModel {
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
}