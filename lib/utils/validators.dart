class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  static String? validatePomodoros(String? value) {
    if (value == null || value.isEmpty) {
      return 'Estimated pomodoros is required';
    }
    final number = int.tryParse(value);
    if (number == null || number < 1) {
      return 'Must be a positive number';
    }
    return null;
  }
}