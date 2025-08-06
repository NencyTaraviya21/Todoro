import 'package:flutter/material.dart';
import 'package:todoro/mvc/model/enums.dart';

class DailyPlanModel {
  final int? id;
  final int userId;
  final int? taskId;
  final String title;
  final String? description;
  final TaskCategory category;
  final DateTime planDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int? estimatedMinutes;
  final int pomodoroSessions;
  final int pomodoroMinutes;
  final bool isCompleted;
  final RepeatType repeatType;
  final DateTime? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyPlanModel({
    this.id,
    required this.userId,
    this.taskId,
    required this.title,
    this.description,
    required this.category,
    required this.planDate,
    this.startTime,
    this.endTime,
    this.estimatedMinutes,
    this.pomodoroSessions = 1,
    this.pomodoroMinutes = 25,
    this.isCompleted = false,
    this.repeatType = RepeatType.none,
    this.reminderTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'taskId': taskId,
      'title': title,
      'description': description,
      'category': category.name,
      'planDate': planDate.toIso8601String(),
      'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'estimatedMinutes': estimatedMinutes,
      'pomodoroSessions': pomodoroSessions,
      'pomodoroMinutes': pomodoroMinutes,
      'isCompleted': isCompleted ? 1 : 0,
      'repeatType': repeatType.name,
      'reminderTime': reminderTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DailyPlanModel.fromMap(Map<String, dynamic> map) {
    TimeOfDay? parseTimeOfDay(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return DailyPlanModel(
      id: map['id'],
      userId: map['userId'],
      taskId: map['taskId'],
      title: map['title'],
      description: map['description'],
      category: TaskCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => TaskCategory.other,
      ),
      planDate: DateTime.parse(map['planDate']),
      startTime: parseTimeOfDay(map['startTime']),
      endTime: parseTimeOfDay(map['endTime']),
      estimatedMinutes: map['estimatedMinutes'],
      pomodoroSessions: map['pomodoroSessions'] ?? 1,
      pomodoroMinutes: map['pomodoroMinutes'] ?? 25,
      isCompleted: map['isCompleted'] == 1,
      repeatType: RepeatType.values.firstWhere(
        (r) => r.name == map['repeatType'],
        orElse: () => RepeatType.none,
      ),
      reminderTime: map['reminderTime'] != null 
          ? DateTime.parse(map['reminderTime']) 
          : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  DailyPlanModel copyWith({
    int? id,
    int? userId,
    int? taskId,
    String? title,
    String? description,
    TaskCategory? category,
    DateTime? planDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? estimatedMinutes,
    int? pomodoroSessions,
    int? pomodoroMinutes,
    bool? isCompleted,
    RepeatType? repeatType,
    DateTime? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      planDate: planDate ?? this.planDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      pomodoroSessions: pomodoroSessions ?? this.pomodoroSessions,
      pomodoroMinutes: pomodoroMinutes ?? this.pomodoroMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      repeatType: repeatType ?? this.repeatType,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get timeSlot {
    if (startTime != null && endTime != null) {
      return '${_formatTimeOfDay(startTime!)} - ${_formatTimeOfDay(endTime!)}';
    } else if (startTime != null) {
      return 'Starts at ${_formatTimeOfDay(startTime!)}';
    }
    return 'Anytime';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get pomodoroInfo {
    return '$pomodoroSessions × ${pomodoroMinutes}m';
  }

  Duration? get duration {
    if (startTime != null && endTime != null) {
      final start = DateTime(2000, 1, 1, startTime!.hour, startTime!.minute);
      final end = DateTime(2000, 1, 1, endTime!.hour, endTime!.minute);
      return end.difference(start);
    }
    return null;
  }

  @override
  String toString() {
    return 'DailyPlanModel(id: $id, title: $title, category: $category, planDate: $planDate, timeSlot: $timeSlot)';
  }
}