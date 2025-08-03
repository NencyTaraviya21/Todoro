import 'package:todoro/import_export/todoro_import_export.dart';

class PomodoroService extends GetxService {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  Future<int> startPomodoroSession(PomodoroSessionModel session) async {
    try {
      final db = await _databaseService.database;
      final id = await db.insert('pomodoroSessions', session.toMap());
      return id;
    } catch (e) {
      Get.snackbar('Error', 'Failed to start pomodoro session: ${e.toString()}');
      throw e;
    }
  }

  Future<List<PomodoroSessionModel>> getPomodoroSessionsByTask(int taskId) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pomodoroSessions',
        where: 'taskId = ?',
        whereArgs: [taskId],
        orderBy: 'startTime DESC',
      );
      return List.generate(maps.length, (i) => PomodoroSessionModel.fromMap(maps[i]));
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch pomodoro sessions: ${e.toString()}');
      return [];
    }
  }

  Future<PomodoroSessionModel?> getActivePomodoroSession() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pomodoroSessions',
        where: 'endTime IS NULL',
        orderBy: 'startTime DESC',
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return PomodoroSessionModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch active session: ${e.toString()}');
      return null;
    }
  }

  Future<bool> completePomodoroSession(int sessionId, bool wasCompleted) async {
    try {
      final db = await _databaseService.database;
      final count = await db.update(
        'pomodoroSessions',
        {
          'endTime': DateTime.now().toIso8601String(),
          'wasCompleted': wasCompleted ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [sessionId],
      );
      return count > 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete pomodoro session: ${e.toString()}');
      return false;
    }
  }

  Future<List<PomodoroSessionModel>> getTodayPomodoroSessions() async {
    try {
      final db = await _databaseService.database;
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      final List<Map<String, dynamic>> maps = await db.query(
        'pomodoroSessions',
        where: 'startTime BETWEEN ? AND ?',
        whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
        orderBy: 'startTime DESC',
      );
      return List.generate(maps.length, (i) => PomodoroSessionModel.fromMap(maps[i]));
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch today\'s sessions: ${e.toString()}');
      return [];
    }
  }
}
