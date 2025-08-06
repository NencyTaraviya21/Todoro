//Enums in Dart are used to represent a fixed set of related values with meaningful names,
//alternative of enum is making class TaskPriority{...}
enum TaskPriority { low, medium, high }

enum SessionType { work, break_ }

enum TaskCategory { 
  focus, 
  study, 
  learning, 
  working, 
  personal, 
  exercise, 
  reading,
  meeting,
  other 
}

enum RepeatType { 
  none, 
  daily, 
  weekly, 
  monthly 
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  int get value {
    switch (this) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
    }
  }
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.focus:
        return 'Focus';
      case TaskCategory.study:
        return 'Study';
      case TaskCategory.learning:
        return 'Learning';
      case TaskCategory.working:
        return 'Working';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.exercise:
        return 'Exercise';
      case TaskCategory.reading:
        return 'Reading';
      case TaskCategory.meeting:
        return 'Meeting';
      case TaskCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case TaskCategory.focus:
        return '🎯';
      case TaskCategory.study:
        return '📚';
      case TaskCategory.learning:
        return '🧠';
      case TaskCategory.working:
        return '💼';
      case TaskCategory.personal:
        return '👤';
      case TaskCategory.exercise:
        return '💪';
      case TaskCategory.reading:
        return '📖';
      case TaskCategory.meeting:
        return '🤝';
      case TaskCategory.other:
        return '📝';
    }
  }
}

extension RepeatTypeExtension on RepeatType {
  String get displayName {
    switch (this) {
      case RepeatType.none:
        return 'No Repeat';
      case RepeatType.daily:
        return 'Daily';
      case RepeatType.weekly:
        return 'Weekly';
      case RepeatType.monthly:
        return 'Monthly';
    }
  }
}
