import 'package:todoro/import_export/todoro_import_export.dart';
class FloatingTimer extends StatelessWidget {
  final PomodoroController pomodoroController = Get.find<PomodoroController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!pomodoroController.isRunning) return SizedBox.shrink();

      return Positioned(
        top: 100,
        right: 16,
        child: GestureDetector(
          onTap: () => _showTimerDialog(context),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 20),
                SizedBox(height: 4),
                Text(
                  pomodoroController.formattedTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (pomodoroController.activeSession != null)
                  Text(
                    pomodoroController.currentSessionType.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Pomodoro Timer'),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pomodoroController.formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              pomodoroController.currentSessionType.name.toUpperCase(),
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () {
              if (pomodoroController.isPaused) {
                pomodoroController.resumePomodoro();
              } else {
                pomodoroController.pausePomodoro();
              }
            },
            child: Obx(() => Text(
              pomodoroController.isPaused ? 'Resume' : 'Pause',
            )),
          ),
          TextButton(
            onPressed: () {
              pomodoroController.stopPomodoro();
              Navigator.of(context).pop();
            },
            child: Text('Stop', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}