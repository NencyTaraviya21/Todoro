import 'package:todoro/import_export/todoro_import_export.dart';

class PomodoroController extends GetxController {
  final PomodoroService _pomodoroService = Get.find<PomodoroService>();
  final TaskController _taskController = Get.find<TaskController>();

  // Observable variables
  final RxInt _remainingSeconds = 0.obs;
  final RxBool _isRunning = false.obs;
  final RxBool _isPaused = false.obs;
  final Rx<SessionType> _currentSessionType = SessionType.work.obs;
  final Rx<PomodoroSessionModel?> _activeSession = Rx<PomodoroSessionModel?>(null);
  final RxInt _currentTaskId = 0.obs;
  final RxList<PomodoroSessionModel> _todaySessions = <PomodoroSessionModel>[].obs;

  // Timer
  Timer? _timer;

  // Constants
  static const int _workDuration = 25 * 60; // 25 minutes
  static const int _breakDuration = 5 * 60; // 5 minutes
  static const int _longBreakDuration = 15 * 60; // 15 minutes

  // Getters
  int get remainingSeconds => _remainingSeconds.value;
  bool get isRunning => _isRunning.value;
  bool get isPaused => _isPaused.value;
  SessionType get currentSessionType => _currentSessionType.value;
  PomodoroSessionModel? get activeSession => _activeSession.value;
  int get currentTaskId => _currentTaskId.value;
  List<PomodoroSessionModel> get todaySessions => _todaySessions;

  String get formattedTime {
    int minutes = _remainingSeconds.value ~/ 60;
    int seconds = _remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    int totalDuration = _currentSessionType.value == SessionType.work
        ? _workDuration
        : _breakDuration;
    return (_remainingSeconds.value / totalDuration).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    loadTodaySessions();
    checkActiveSession();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Load today's sessions
  Future<void> loadTodaySessions() async {
    try {
      final sessions = await _pomodoroService.getTodayPomodoroSessions();
      _todaySessions.assignAll(sessions);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load today\'s sessions');
    }
  }

  // Check for active session
  Future<void> checkActiveSession() async {
    try {
      final session = await _pomodoroService.getActivePomodoroSession();
      if (session != null) {
        _activeSession.value = session;
        _currentTaskId.value = session.taskId;
        _currentSessionType.value = session.type;

        // Calculate remaining time
        final elapsed = DateTime.now().difference(session.startTime);
        final totalDuration = session.type == SessionType.work
            ? _workDuration
            : _breakDuration;
        final remaining = totalDuration - elapsed.inSeconds;

        if (remaining > 0) {
          _remainingSeconds.value = remaining;
          _isRunning.value = true;
          _startTimer();
        } else {
          // Session should have ended
          await _completeSession(true);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check active session');
    }
  }

  // Start pomodoro session
  Future<bool> startPomodoro(int taskId, {SessionType type = SessionType.work}) async {
    try {
      if (_isRunning.value) {
        Get.snackbar('Warning', 'A pomodoro session is already running');
        return false;
      }

      final now = DateTime.now();
      final session = PomodoroSessionModel(
        taskId: taskId,
        startTime: now,
        type: type,
        createdAt: now,
      );

      final sessionId = await _pomodoroService.startPomodoroSession(session);
      if (sessionId > 0) {
        _activeSession.value = session.copyWith(id: sessionId);
        _currentTaskId.value = taskId;
        _currentSessionType.value = type;
        _remainingSeconds.value = type == SessionType.work ? _workDuration : _breakDuration;
        _isRunning.value = true;
        _isPaused.value = false;

        _startTimer();
        await loadTodaySessions();

        Get.snackbar('Success', 'Pomodoro session started');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to start pomodoro session');
      return false;
    }
  }

  // Pause pomodoro
  void pausePomodoro() {
    if (_isRunning.value && !_isPaused.value) {
      _isPaused.value = true;
      _timer?.cancel();
      Get.snackbar('Info', 'Pomodoro paused');
    }
  }

  // Resume pomodoro
  void resumePomodoro() {
    if (_isRunning.value && _isPaused.value) {
      _isPaused.value = false;
      _startTimer();
      Get.snackbar('Info', 'Pomodoro resumed');
    }
  }

  // Stop pomodoro
  Future<void> stopPomodoro() async {
    if (_activeSession.value != null) {
      await _completeSession(false);
      Get.snackbar('Info', 'Pomodoro stopped');
    }
  }

  // Complete pomodoro session
  Future<void> completePomodoro() async {
    if (_activeSession.value != null) {
      await _completeSession(true);

      // // If it was a work session, increment completed pomodoros
      // if (_currentSessionType.value == SessionType.work) {
      //   await _taskController.incrementPomodoros(_currentTaskId.value);
      // }

      Get.snackbar('Success', 'Pomodoro completed!');
    }
  }

  // Internal timer logic
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        // Session completed
        completePomodoro();
      }
    });
  }

  // Complete session helper
  Future<void> _completeSession(bool wasCompleted) async {
    _timer?.cancel();
    _isRunning.value = false;
    _isPaused.value = false;

    if (_activeSession.value != null) {
      await _pomodoroService.completePomodoroSession(
        _activeSession.value!.id!,
        wasCompleted,
      );
      _activeSession.value = null;
      _currentTaskId.value = 0;
      await loadTodaySessions();
    }
  }

  // Get sessions for specific task
  Future<List<PomodoroSessionModel>> getSessionsForTask(int taskId) async {
    return await _pomodoroService.getPomodoroSessionsByTask(taskId);
  }

  // Get total pomodoros completed today
  int get todayCompletedPomodoros {
    return _todaySessions.where((session) =>
    session.wasCompleted && session.type == SessionType.work
    ).length;
  }

  // Get total work time today
  Duration get todayWorkTime {
    Duration total = Duration.zero;
    for (final session in _todaySessions) {
      if (session.type == SessionType.work && session.wasCompleted) {
        total += session.duration;
      }
    }
    return total;
  }
}

