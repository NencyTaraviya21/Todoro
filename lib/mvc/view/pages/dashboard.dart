import 'package:todoro/import_export/todoro_import_export.dart';
import 'package:todoro/mvc/contoller/dashboard_controller.dart';

class Dashboard extends GetView<DashboardController> {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Color(0xFFF5ECE0),
      body: SafeArea(
        child: Obx(() => RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // Custom header
              SliverToBoxAdapter(child: _buildCuteHeader()),

              // Pomodoro Timer Section
              SliverToBoxAdapter(child: _buildPomodoroSection()),

              // Stats Cards
              SliverToBoxAdapter(child: _buildStatsCards()),

              // Quick Actions
              SliverToBoxAdapter(child: _buildQuickActions()),

              // Task list header
              SliverToBoxAdapter(child: _buildTaskListHeader()),

              // Task list
              controller.taskController.isLoading
                  ? SliverToBoxAdapter(child: _buildLoadingState())
                  : controller.filteredTasks.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final task = controller.filteredTasks[index];
                    return _buildTaskCard(task);
                  },
                  childCount: controller.filteredTasks.length,
                ),
              ),
            ],
          ),
        )),
      ),
      floatingActionButton: _buildCuteFloatingButton(),
    );
  }

  Widget _buildCuteHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF693382), Color(0xFF336D82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.greeting,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Obx(() => Text(
                  controller.authService.currentUser?.name ?? 'User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SizedBox(height: 8),
                _buildProgressInfo(),
              ],
            ),
          ),
          // User Avatar & Menu
          Column(
            children: [
              GestureDetector(
                onTap: controller.showUserProfile,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFF5ECE0),
                    child: Obx(() => Text(
                      controller.authService.currentUser?.name.isNotEmpty == true
                          ? controller.authService.currentUser!.name[0].toUpperCase()
                          : '🌟',
                      style: TextStyle(
                        color: Color(0xFF693382),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(height: 8),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: Colors.white),
                onSelected: controller.handleMenuSelection,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFF693382)),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh, color: Color(0xFF336D82)),
                        SizedBox(width: 8),
                        Text('Refresh'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red[400]),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.red[400])),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo() {
    return Obx(() {
      final completedTasks = controller.completedTasksCount;
      final totalTasks = controller.totalTasksCount;
      final todayPomodoros = controller.pomodoroController.todayCompletedPomodoros;

      if (totalTasks > 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white70, size: 16),
                SizedBox(width: 6),
                Text(
                  '$completedTasks of $totalTasks tasks completed',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, color: Colors.white70, size: 16),
                SizedBox(width: 6),
                Text(
                  '$todayPomodoros pomodoros completed today',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white24,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: totalTasks > 0 ? completedTasks / totalTasks : 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return Text(
          'Ready to start your productive day? 🚀',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        );
      }
    });
  }

  Widget _buildPomodoroSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF5F99AE).withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🍅 Pomodoro Timer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF693382),
                ),
              ),
              Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF5F99AE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${controller.pomodoroController.todayCompletedPomodoros} today',
                  style: TextStyle(
                    color: Color(0xFF336D82),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
            ],
          ),
          SizedBox(height: 20),

          // Timer Display
          Obx(() => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: controller.pomodoroController.isRunning
                    ? [Color(0xFF693382), Color(0xFF336D82)]
                    : [Color(0xFF5F99AE).withOpacity(0.3), Color(0xFF5F99AE).withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                controller.pomodoroController.formattedTime,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: controller.pomodoroController.isRunning ? Colors.white : Color(0xFF336D82),
                ),
              ),
            ),
          )),

          SizedBox(height: 20),

          // Timer Controls
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (controller.pomodoroController.isRunning) ...[
                _buildTimerButton(
                  icon: Icons.stop,
                  label: 'Stop',
                  onTap: controller.pomodoroController.stopPomodoro,
                  color: Colors.red[400]!,
                ),
                _buildTimerButton(
                  icon: controller.pomodoroController.isPaused ? Icons.play_arrow : Icons.pause,
                  label: controller.pomodoroController.isPaused ? 'Resume' : 'Pause',
                  onTap: controller.pomodoroController.isPaused
                      ? controller.pomodoroController.resumePomodoro
                      : controller.pomodoroController.pausePomodoro,
                  color: Color(0xFF693382),
                ),
              ] else ...[
                _buildTimerButton(
                  icon: Icons.play_arrow,
                  label: 'Start Focus',
                  onTap: controller.showTaskSelectionDialog,
                  color: Color(0xFF693382),
                ),
              ],
            ],
          )),

          // Active task display
          Obx(() {
            if (controller.pomodoroController.currentTaskId > 0) {
              final task = controller.taskController.tasks.firstWhereOrNull(
                      (t) => t.id == controller.pomodoroController.currentTaskId
              );
              if (task != null) {
                return Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF5F99AE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.task_alt, color: Color(0xFF336D82), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Working on: ${task.title}',
                          style: TextStyle(
                            color: Color(0xFF336D82),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildTimerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '📝',
              'Total Tasks',
                  () => controller.totalTasksCount.toString(),
              Color(0xFF693382),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '✅',
              'Completed',
                  () => controller.completedTasksCount.toString(),
              Color(0xFF336D82),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '🍅',
              'Pomodoros',
                  () => controller.pomodoroController.todayCompletedPomodoros.toString(),
              Color(0xFF5F99AE),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String title, String Function() getValue, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 8),
          Obx(() => Text(
            getValue(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          )),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.add_task,
              title: 'Add Task',
              color: Color(0xFF693382),
              onTap: () => controller.navigateToAddTask(),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.filter_list,
              title: 'Filter',
              color: Color(0xFF336D82),
              onTap: controller.showFilterDialog,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF693382),
            ),
          ),
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF5F99AE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              controller.selectedFilter.value == 'all'
                  ? 'All Tasks'
                  : controller.selectedFilter.value.toUpperCase(),
              style: TextStyle(
                color: Color(0xFF336D82),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF693382)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your tasks...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: controller.getPriorityColor(task.priority).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: GestureDetector(
          onTap: () => controller.taskController.toggleTaskCompletion(task),
          child: Obx(() => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: task.isCompleted ? Color(0xFF693382) : Colors.transparent,
              border: Border.all(
                color: task.isCompleted ? Color(0xFF693382) : Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: task.isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          )),
        ),
        title: Obx(() => Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : Color(0xFF693382),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description?.isNotEmpty == true && task.description != "Null")
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  task.description!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            if (task.estimatedPomodoros! > 0)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      '${task.estimatedPomodoros} pomodoros estimated',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            if (task.deadLine != null)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      'Due: ${controller.formatDate(task.deadLine!)}',
                      style: TextStyle(
                        color: controller.isOverdue(task.deadLine!) ? Colors.red[400] : Colors.grey[500],
                        fontSize: 12,
                        fontWeight: controller.isOverdue(task.deadLine!) ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: controller.getPriorityColor(task.priority),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.getPriorityText(task.priority),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8),
            Obx(() => !task.isCompleted && !controller.pomodoroController.isRunning
                ? GestureDetector(
              onTap: () => controller.pomodoroController.startPomodoro(task.id!),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF693382).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: Color(0xFF693382), size: 18),
              ),
            )
                : SizedBox.shrink()),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => controller.deleteTask(task.id!),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 18),
              ),
            ),
          ],
        ),
        onTap: () => controller.navigateToAddTask(task),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF5F99AE).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '📝',
                style: TextStyle(fontSize: 48),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No tasks yet!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF693382),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the ✨ button to add your first task',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuteFloatingButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF693382), Color(0xFF336D82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF693382).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => controller.navigateToAddTask(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Text(
          '✨',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}