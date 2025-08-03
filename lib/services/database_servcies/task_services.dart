import 'package:todoro/import_export/todoro_import_export.dart';


class TaskService extends GetxService {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  // Task CRUD Operations

  //region ADD TASK
  Future<int> createTask(TaskModel task) async {
    try {
      final db = await _databaseService.database;
      final id = await db.insert('tasks', task.toMap());
      Get.snackbar('Success', 'Task created successfully');
      return id;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create task: ${e.toString()}',colorText: Colors.white);
      throw e;
    }
  }
  //endregion

  //region GET ALL TASK
  Future<List<TaskModel>> getAllTasks({int? userId}) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: userId != null ? 'userId = ?' : null,
        whereArgs: userId != null ? [userId] : null,
        orderBy: 'createdAt DESC',
      );
      return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tasks: ${e.toString()}',colorText: Colors.white);
      return [];
    }
  }
//endregion

  //region GET UPDATE TASK
  Future<bool> updateTask(TaskModel task) async {
    try {
      final db = await _databaseService.database;
      final count = await db.update(
        'tasks',
        task.copyWith(updatedAt: DateTime.now()).toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (count > 0) {
        Get.snackbar('Success', 'Task updated successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: ${e.toString()}',colorText: Colors.white);
      return false;
    }
  }
  //endregion

  //region DELETE TASK
  Future<bool> deleteTask(int id) async {
    try {
      final db = await _databaseService.database;
      final count = await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (count > 0) {
        Get.snackbar('Success', 'Task deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: ${e.toString()}',colorText: Colors.white);
      return false;
    }
  }
//endregion

}

void showSnackbar({String? title, String? msg, dynamic colorCode}) {
  Get.snackbar(
    title!,
    msg!,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 2),
    colorText: Colors.white,
  );
}