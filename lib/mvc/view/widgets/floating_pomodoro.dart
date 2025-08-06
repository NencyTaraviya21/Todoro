import 'package:todoro/import_export/todoro_import_export.dart';

class PomodoroTimerScreen extends StatefulWidget {
  final String? taskTitle;
  final String? taskId;

  const PomodoroTimerScreen({
    Key? key,
    this.taskTitle,
    this.taskId,
  }) : super(key: key);

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen>
    with TickerProviderStateMixin {
  static const int totalSeconds = 25 * 60; // 25 minutes
  int remainingSeconds = totalSeconds;
  Timer? _timer;
  bool isRunning = false;
  bool isCompleted = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer(BuildContext context) {
    if (isCompleted) {
      _resetTimer();
    }

    setState(() {
      isRunning = true;
    });

    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _completeTimer(context);
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      remainingSeconds = totalSeconds;
      isRunning = false;
      isCompleted = false;
    });
  }

  void _completeTimer(BuildContext context) {
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      isRunning = false;
      isCompleted = true;
      remainingSeconds = 0;
    });

    // Show completion dialog or notification
    _showCompletionDialog(context);
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('🍅 Pomodoro Complete!'),
          content: Text('Great job! You\'ve completed a 25-minute focus session.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
              child: Text('Start New Session'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get _progress => (totalSeconds - remainingSeconds) / totalSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f1eb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'Pomodoro Timer',
          style: TextStyle(
            color: Color(0xFF693382),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF693382)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Task Title
            if (widget.taskTitle != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.taskTitle!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF693382),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            SizedBox(height: 40),

            // Timer Circle
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRunning ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 280,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Circle
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                        ),

                        // Progress Circle
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted ? Colors.green : Color(0xFF693382),
                            ),
                          ),
                        ),

                        // Timer Text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(remainingSeconds),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: isCompleted ? Colors.green : Color(0xFF693382),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              isCompleted ? 'Completed!' :
                              isRunning ? 'Focus Time' : 'Ready to Start',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 60),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reset Button
                FloatingActionButton(
                  heroTag: "reset",
                  onPressed: _resetTimer,
                  backgroundColor: Colors.grey[600],
                  child: Icon(Icons.refresh, color: Colors.white),
                ),

                // Start/Pause Button
                Container(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    heroTag: "play_pause",
                    onPressed: (){},
                    backgroundColor: isRunning ? Colors.orange : Color(0xFF693382),
                    child: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Stop Button
                FloatingActionButton(
                  heroTag: "stop",
                  onPressed: () {
                    _pauseTimer();
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.red[400],
                  child: Icon(Icons.stop, color: Colors.white),
                ),
              ],
            ),

            SizedBox(height: 40),

            // Progress Text
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Progress: ${(_progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF693382),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}