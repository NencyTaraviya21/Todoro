import 'package:todoro/import_export/todoro_import_export.dart';

class DailyPlanningPage extends StatelessWidget {
  const DailyPlanningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyPlanController>(
      init: DailyPlanController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF1E1E1E),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(controller),
                _buildCalendarHeader(controller),
                Expanded(
                  child: _buildPlansList(controller),
                ),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(controller),
        );
      },
    );
  }

  Widget _buildHeader(DailyPlanController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield, color: Colors.grey, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Shield Off',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    controller.pendingPlansForDate.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(DailyPlanController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  final newDate = controller.selectedDate.subtract(const Duration(days: 1));
                  controller.changeSelectedDate(newDate);
                },
                icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 30),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _formatSelectedDate(controller.selectedDate),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  final newDate = controller.selectedDate.add(const Duration(days: 1));
                  controller.changeSelectedDate(newDate);
                },
                icon: const Icon(Icons.chevron_right, color: Colors.grey, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildWeekCalendar(controller),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar(DailyPlanController controller) {
    final today = DateTime.now();
    final startOfWeek = controller.selectedDate.subtract(
      Duration(days: controller.selectedDate.weekday - 1),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final date = startOfWeek.add(Duration(days: index));
        final isSelected = _isSameDay(date, controller.selectedDate);
        final isToday = _isSameDay(date, today);
        
        return GestureDetector(
          onTap: () => controller.changeSelectedDate(date),
          child: Container(
            width: 40,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF6B6B) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getWeekdayName(date.weekday),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : (isToday ? const Color(0xFFFF6B6B) : Colors.white),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlansList(DailyPlanController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildPlansHeader(controller),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B6B)))
                : controller.filteredPlans.isEmpty
                    ? _buildEmptyState()
                    : _buildPlansListView(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansHeader(DailyPlanController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Daily plan (${controller.totalPlansForDate})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Add filter/sort options
            },
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No plans for this day',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first plan',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansListView(DailyPlanController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.filteredPlans.length,
      itemBuilder: (context, index) {
        final plan = controller.filteredPlans[index];
        return _buildPlanCard(plan, controller);
      },
    );
  }

  Widget _buildPlanCard(DailyPlanModel plan, DailyPlanController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getCategoryColor(plan.category),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                plan.category.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: plan.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    if (plan.startTime != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A4A4A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          plan.timeSlot,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      plan.pomodoroInfo,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (!plan.isCompleted) ...[
                      GestureDetector(
                        onTap: () => controller.startPomodoroSession(plan.id!),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    GestureDetector(
                      onTap: () => controller.togglePlanCompletion(plan.id!),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: plan.isCompleted ? const Color(0xFF4CAF50) : const Color(0xFF4A4A4A),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          plan.isCompleted ? Icons.check : Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(DailyPlanController controller) {
    return FloatingActionButton(
      onPressed: () {
        Get.to(() => EnhancedTaskCreationPage(
          initialDate: controller.selectedDate,
        ));
      },
      backgroundColor: const Color(0xFFFF6B6B),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.focus:
        return const Color(0xFFFF6B6B);
      case TaskCategory.study:
        return const Color(0xFF4ECDC4);
      case TaskCategory.learning:
        return const Color(0xFF45B7D1);
      case TaskCategory.working:
        return const Color(0xFFFFA726);
      case TaskCategory.personal:
        return const Color(0xFF9C27B0);
      case TaskCategory.exercise:
        return const Color(0xFF66BB6A);
      case TaskCategory.reading:
        return const Color(0xFF8D6E63);
      case TaskCategory.meeting:
        return const Color(0xFF42A5F5);
      case TaskCategory.other:
        return const Color(0xFF78909C);
    }
  }

  String _formatSelectedDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return weekdays[weekday % 7];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}