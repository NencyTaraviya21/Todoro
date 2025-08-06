
import 'package:todoro/import_export/todoro_import_export.dart';

class SampleDataController extends GetxController {
  final TaskController taskController = Get.find();

  Future<void> createSampleTasks() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Sample tasks for different dates
    final sampleTasks = [
      // Today's tasks
      {
        'title': 'Complete project proposal',
        'description': 'Finish the quarterly project proposal for client review',
        'priority': TaskPriority.high,
        'deadline': today,
      },
      {
        'title': 'Team meeting preparation',
        'description': 'Prepare agenda and materials for tomorrow\'s team meeting',
        'priority': TaskPriority.medium,
        'deadline': today,
      },
      {
        'title': 'Code review',
        'description': 'Review pull requests from team members',
        'priority': TaskPriority.low,
        'deadline': today,
      },

      // Tomorrow's tasks
      {
        'title': 'Client presentation',
        'description': 'Present the new features to client stakeholders',
        'priority': TaskPriority.high,
        'deadline': today.add(Duration(days: 1)),
      },
      {
        'title': 'Update documentation',
        'description': 'Update API documentation with latest changes',
        'priority': TaskPriority.medium,
        'deadline': today.add(Duration(days: 1)),
      },

      // Next few days
      {
        'title': 'Database optimization',
        'description': 'Optimize database queries for better performance',
        'priority': TaskPriority.high,
        'deadline': today.add(Duration(days: 2)),
      },
      {
        'title': 'UI/UX improvements',
        'description': 'Implement user feedback on the new dashboard design',
        'priority': TaskPriority.medium,
        'deadline': today.add(Duration(days: 3)),
      },
      {
        'title': 'Security audit',
        'description': 'Conduct security audit of the authentication system',
        'priority': TaskPriority.high,
        'deadline': today.add(Duration(days: 4)),
      },
      {
        'title': 'Write unit tests',
        'description': 'Add unit tests for the new calendar functionality',
        'priority': TaskPriority.medium,
        'deadline': today.add(Duration(days: 5)),
      },
      {
        'title': 'Deploy to staging',
        'description': 'Deploy latest changes to staging environment',
        'priority': TaskPriority.low,
        'deadline': today.add(Duration(days: 6)),
      },

      // Some overdue tasks
      {
        'title': 'Fix critical bug',
        'description': 'Fix the login issue reported by users',
        'priority': TaskPriority.high,
        'deadline': today.subtract(Duration(days: 1)),
      },
      {
        'title': 'Update dependencies',
        'description': 'Update project dependencies to latest versions',
        'priority': TaskPriority.low,
        'deadline': today.subtract(Duration(days: 2)),
      },
    ];

    // Create tasks
    // for (var taskData in sampleTasks) {
    //   await taskController.isCreated(
    //     title: taskData['title'] as String,
    //     description: taskData['description'] as String,
    //     priority: taskData['priority'] as TaskPriority,
    //     deadLine: taskData['deadline'] as DateTime,
    //     estimatedPomodoros: 2,
    //   );
    // }

    Get.snackbar(
      'Sample Data Created',
      '${sampleTasks.length} sample tasks have been added to your calendar',
      backgroundColor: Color(0xFF693382),
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
      duration: Duration(seconds: 3),
    );
  }

  // Future<void> clearAllTasks() async {
  //   final tasks = taskController.tasks;
  //   int deletedCount = 0;
  //
  //   for (var task in tasks) {
  //     if (task.id != null) {
  //       final success = await taskController.isDeleted(task.id!);
  //       if (success) deletedCount;
  //     }
  //   }
  //
  //   Get.snackbar(
  //     'Tasks Cleared',
  //     '$deletedCount tasks have been removed',
  //     backgroundColor: Colors.orange,
  //     colorText: Colors.white,
  //     icon: Icon(Icons.delete_sweep, color: Colors.white),
  //     duration: Duration(seconds: 2),
  //   );
  // }
}
