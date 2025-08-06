import 'package:todoro/import_export/todoro_import_export.dart';

class DashboardController extends GetxController {
  final TaskController taskController = Get.find();
  final AuthService authService = Get.find<AuthService>();
  final PomodoroController pomodoroController = Get.put(PomodoroController());

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  // Getters
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning! ☀️';
    } else if (hour < 17) {
      return 'Good afternoon! 🌤️';
    } else {
      return 'Good evening! 🌙';
    }
  }

  List<TaskModel> get filteredTasks {
    if (selectedFilter.value == 'all') {
      return taskController.tasks;
    }
    return taskController.tasks.where((task) =>
    task.priority.name == selectedFilter.value
    ).toList();
  }

  int get completedTasksCount => taskController.tasks.where((task) => task.isCompleted).length;
  int get totalTasksCount => taskController.tasks.length;
  int get pendingTasksCount => taskController.tasks.where((task) => !task.isCompleted).length;

  double get completionPercentage {
    if (totalTasksCount == 0) return 0.0;
    return (completedTasksCount / totalTasksCount * 100);
  }

  // Methods
  Future<void> refreshData() async {
    isRefreshing.value = true;
    try {
      await taskController.refresh();
      await pomodoroController.loadTodaySessions();
    } finally {
      isRefreshing.value = false;
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      return 'Overdue';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  bool isOverdue(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(deadline.year, deadline.month, deadline.day);
    return taskDate.isBefore(today);
  }

  Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Color(0xFF5F99AE);
      case TaskPriority.medium:
        return Color(0xFF336D82);
      case TaskPriority.high:
        return Color(0xFF693382);
      default:
        return Color(0xFF5F99AE);
    }
  }

  String getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MED';
      case TaskPriority.high:
        return 'HIGH';
      default:
        return 'LOW';
    }
  }

  // Dialog methods
  void showTaskSelectionDialog() {
    if (pendingTasksCount == 0) {
      Get.snackbar(
        'No Tasks',
        'Please add some tasks first to start a pomodoro session',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Select Task for Pomodoro',
          style: TextStyle(color: Color(0xFF693382)),
        ),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: pendingTasksCount,
            itemBuilder: (context, index) {
              final availableTasks = taskController.tasks.where((task) => !task.isCompleted).toList();
              final task = availableTasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: task.description != "Null" ? Text(task.description!) : null,
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: getPriorityColor(task.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    getPriorityText(task.priority),
                    style: TextStyle(
                      color: getPriorityColor(task.priority),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back();
                  pomodoroController.startPomodoro(task.id!);
                },
              );
            },
          )),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Color(0xFF693382))),
          ),
        ],
      ),
    );
  }

  void showFilterDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Filter Tasks',
          style: TextStyle(color: Color(0xFF693382)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('All Tasks', 'all'),
            _buildFilterOption('High Priority', 'high'),
            _buildFilterOption('Medium Priority', 'medium'),
            _buildFilterOption('Low Priority', 'low'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, String value) {
    return Obx(() => RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: selectedFilter.value,
      onChanged: (String? newValue) {
        if (newValue != null) {
          changeFilter(newValue);
          Get.back();
        }
      },
      activeColor: Color(0xFF693382),
    ));
  }

  void showUserProfile() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'User Profile',
          style: TextStyle(color: Color(0xFF693382)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF693382),
              child: Obx(() => Text(
                authService.currentUser?.name.isNotEmpty == true
                    ? authService.currentUser!.name[0].toUpperCase()
                    : '🌟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            SizedBox(height: 16),
            Obx(() => Text(
              authService.currentUser?.name ?? 'User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF693382),
              ),
            )),
            SizedBox(height: 8),
            Text(
              'Member since ${DateTime.now().year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            // User Stats
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      totalTasksCount.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF693382),
                      ),
                    ),
                    Text(
                      'Total Tasks',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      pomodoroController.todayCompletedPomodoros.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF336D82),
                      ),
                    ),
                    Text(
                      'Pomodoros',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${completionPercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5F99AE),
                      ),
                    ),
                    Text(
                      'Completion',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(color: Color(0xFF693382)),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[400]),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Get.back();
              // Add your logout logic here
              // authService.logout();
              Get.snackbar(
                'Logged Out',
                'You have been successfully logged out',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                icon: Icon(Icons.check_circle, color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> deleteTask(int taskId) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFF693382)),
            SizedBox(width: 8),
            Text('Confirm Delete'),
          ],
        ),
        content: Text('Are you sure you want to delete this task? This action cannot be undone.'),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF693382),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Get.back();
              final success = await taskController.deleteTask(taskId);
              if (!success) {
                Get.snackbar(
                  "Error",
                  "Failed to delete task",
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  icon: Icon(Icons.error, color: Colors.white),
                );
              } else {
                Get.snackbar(
                  "Success",
                  "Task deleted successfully",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  icon: Icon(Icons.check_circle, color: Colors.white),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void navigateToAddTask([TaskModel? task]) {
    if (task != null) {

      // Edit existing task - explicitly set isEdit to true
      Get.to(() => AddTask(isEdit: true, task: task));
    } else {
      // Create new task - explicitly set isEdit to false
      Get.to(() => AddTask(isEdit: false, task: null));
    }
  }

  void handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        showUserProfile();
        break;
      case 'refresh':
        refreshData();
        break;
      case 'logout':
        showLogoutDialog();
        break;
    }
  }
}