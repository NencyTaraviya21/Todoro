import 'package:todoro/import_export/todoro_import_export.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  final TaskService _taskService = TaskService();
  var userCounter = 1.obs;

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() async {
    try {
      final tasks = await _taskService.fetchTasks();
      taskList.assignAll(tasks);

      // Update userId counter based on max existing userId
      if (tasks.isNotEmpty) {
        final maxUserId = tasks.map((t) => t.userId).reduce((a, b) => a > b ? a : b);
        userCounter.value = maxUserId + 1;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void addTask(String title) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: userCounter.value,
      title: title,
      completed: false,
      createdAt: DateTime.now().toIso8601String(),
    );

    await _taskService.addTask(newTask);
    taskList.add(newTask);

    // Increment userId for next task
    userCounter.value += 1;
  }
}

