import 'package:todoro/import_export/todoro_import_export.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();

  // Observable variables
  final RxList<TaskModel> _tasks = <TaskModel>[].obs;
  final RxList<TaskModel> _completedTasks = <TaskModel>[].obs;
  final RxList<TaskModel> _pendingTasks = <TaskModel>[].obs;
  final RxList<TaskModel> _todayTasks = <TaskModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedPriority = 'all'.obs;
  final Rx<TaskModel?> _selectedTask = Rx<TaskModel?>(null);
  final RxMap<String, int> _statistics = <String, int>{}.obs;

  // Getters
  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get completedTasks => _completedTasks;
  List<TaskModel> get pendingTasks => _pendingTasks;
  List<TaskModel> get todayTasks => _todayTasks;
  bool get isLoading => _isLoading.value;
  String get selectedPriority => _selectedPriority.value;
  TaskModel? get selectedTask => _selectedTask.value;
  Map<String, int> get statistics => _statistics;

  // Filtered tasks based on priority
  List<TaskModel> get filteredTasks {
    if (_selectedPriority.value == 'all') {
      return _tasks;
    }
    return _tasks.where((task) => task.priority.name == _selectedPriority.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadAllTasks();
    // loadStatistics();
  }

  // region Load all tasks
  Future<void> loadAllTasks() async {
    _isLoading.value = true;
    try {
      final tasks = await _taskService.getAllTasks();
      _tasks.assignAll(tasks);
      _updateTaskLists();
      // await loadTasksByStatus();
    } finally {
      _isLoading.value = false;
    }
  }
  //endregion

  // region Update task lists based on status and date
  void _updateTaskLists() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _completedTasks.assignAll(_tasks.where((task) => task.isCompleted).toList());
    _pendingTasks.assignAll(_tasks.where((task) => !task.isCompleted).toList());

    // Today's tasks - tasks with deadline today or overdue
    _todayTasks.assignAll(_tasks.where((task) {
      if (task.deadLine == null) return false;
      final taskDate = DateTime(task.deadLine!.year, task.deadLine!.month, task.deadLine!.day);
      return taskDate.isBefore(today.add(Duration(days: 1))) && !task.isCompleted;
    }).toList());
  }
  //endregion

  // region Create new task
  Future<bool> createTask({
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? deadline, // Keep parameter name as deadline for consistency with UI
    int? estimatedPomodoros,
    int userId = 1,
  }) async {
    try {
      final now = DateTime.now();
      final task = TaskModel(
        userId: userId,
        title: title,
        description: description ?? "No description",
        priority: priority,
        deadLine: deadline, // Map to deadLine property
        estimatedPomodoros: estimatedPomodoros ?? 1,
        createdAt: now,
        updatedAt: now,
        isCompleted: false, // Ensure new tasks are not completed
      );

      final id = await _taskService.createTask(task);
      if (id > 0) {
        await loadAllTasks();
        // await loadStatistics();
        return true;
      }
      return false;
    } catch (e) {
      print("Error in createTask: $e");
      return false;
    }
  }
  //endregion

  //region Update task
  Future<bool> updateTask(TaskModel task) async {
    try {
      final success = await _taskService.updateTask(task);
      if (success) {
        await loadAllTasks();
        // await loadStatistics();
        return true;
      }
      return false;
    } catch (e) {
      print("Error in updateTask: $e");
      return false;
    }
  }
  //endregion

  //region Delete task
  Future<bool> deleteTask(int taskId) async {
    try {
      final success = await _taskService.deleteTask(taskId);
      if (success) {
        await loadAllTasks();
        // await loadStatistics();
        return true;
      }
      return false;
    } catch (e) {
      print("Error in deleteTask: $e");
      return false;
    }
  }
  //endregion

  //region Toggle task completion
  Future<bool> toggleTaskCompletion(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
        // createdAt: !task.isCompleted ? DateTime.now() : null,
      );
      return await updateTask(updatedTask);
    } catch (e) {
      print("Error in toggleTaskCompletion: $e");
      return false;
    }
  }
  //endregion

  //region Filter methods
  void setSelectedPriority(String priority) {
    _selectedPriority.value = priority;
  }

  void setSelectedTask(TaskModel? task) {
    _selectedTask.value = task;
  }

  List<TaskModel> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority && !task.isCompleted).toList();
  }

  List<TaskModel> getOverdueTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _tasks.where((task) {
      if (task.deadLine == null || task.isCompleted) return false;
      final taskDate = DateTime(task.deadLine!.year, task.deadLine!.month, task.deadLine!.day);
      return taskDate.isBefore(today);
    }).toList();
  }

  List<TaskModel> getTasksDueToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _tasks.where((task) {
      if (task.deadLine == null || task.isCompleted) return false;
      final taskDate = DateTime(task.deadLine!.year, task.deadLine!.month, task.deadLine!.day);
      return taskDate.isAtSameMomentAs(today);
    }).toList();
  }
  //endregion

  //region Statistics and analytics
  void updateStatistics() {
    _statistics['total'] = _tasks.length;
    _statistics['completed'] = _completedTasks.length;
    _statistics['pending'] = _pendingTasks.length;
    _statistics['overdue'] = getOverdueTasks().length;
    _statistics['dueToday'] = getTasksDueToday().length;
    _statistics['highPriority'] = getTasksByPriority(TaskPriority.high).length;
    _statistics['mediumPriority'] = getTasksByPriority(TaskPriority.medium).length;
    _statistics['lowPriority'] = getTasksByPriority(TaskPriority.low).length;
  }

  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return (_completedTasks.length / _tasks.length) * 100;
  }

  int get totalEstimatedPomodoros {
    return _pendingTasks.fold(0, (sum, task) => sum + (task.estimatedPomodoros ?? 0));
  }
  //endregion

  // Refresh data
  Future<void> refresh() async {
    await loadAllTasks();
    updateStatistics();
  }

  //region Search and sort
  List<TaskModel> searchTasks(String query) {
    if (query.isEmpty) return _tasks;

    return _tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          (task.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  List<TaskModel> sortTasksByPriority(List<TaskModel> tasks) {
    tasks.sort((a, b) {
      const priorityOrder = {
        TaskPriority.high: 3,
        TaskPriority.medium: 2,
        TaskPriority.low: 1,
      };
      return (priorityOrder[b.priority] ?? 0).compareTo(priorityOrder[a.priority] ?? 0);
    });
    return tasks;
  }

  List<TaskModel> sortTasksByDeadline(List<TaskModel> tasks) {
    tasks.sort((a, b) {
      if (a.deadLine == null && b.deadLine == null) return 0;
      if (a.deadLine == null) return 1;
      if (b.deadLine == null) return -1;
      return a.deadLine!.compareTo(b.deadLine!);
    });
    return tasks;
  }
//endregion
}