import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoro/import_export/todoro_import_export.dart';

class AddTask extends StatefulWidget {
  final bool isEdit;
  final TaskModel? task;

  AddTask({Key? key, this.isEdit = false, this.task}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Rx<TaskPriority> _selectedPriority = TaskPriority.medium.obs;
  final Rx<DateTime?> _deadline = Rx<DateTime?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _hasDeadline = false.obs;
  final RxInt _estimatedPomodoros = 1.obs;
  final RxString _selectedRepeat = 'No Repeat'.obs;
  final RxString _selectedReminder = 'No Reminder'.obs;

  TaskController taskController = Get.find<TaskController>();

  final List<String> _repeatOptions = [
    'No Repeat', 'Daily', 'Weekly', 'Monthly'
  ];

  final List<String> _reminderOptions = [
    'No Reminder', '5 min before', '15 min before', '30 min before', '1 hour before'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _noteController = TextEditingController(text: widget.task?.description ?? '');

    // Initialize values for edit mode
    if (widget.isEdit && widget.task != null) {
      _selectedPriority.value = widget.task!.priority;
      _deadline.value = widget.task!.deadLine;
      _hasDeadline.value = widget.task!.deadLine != null;
      _estimatedPomodoros.value = widget.task!.estimatedPomodoros ?? 1;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTaskNameField(),
                    SizedBox(height: 24),
                    _buildPomodoroSection(),
                    SizedBox(height: 24),
                    _buildSessionsSection(),
                    SizedBox(height: 24),
                    _buildScheduleSection(context),
                    SizedBox(height: 24),
                    _buildRepeatSection(),
                    SizedBox(height: 24),
                    _buildReminderSection(),
                    SizedBox(height: 24),
                    _buildPrioritySection(),
                    SizedBox(height: 24),
                    _buildNotesSection(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF1C1C1E),
      elevation: 0,
      leading: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.red,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      title: Text(
        widget.isEdit ? 'Edit' : 'Create',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leadingWidth: 80,
    );
  }

  Widget _buildTaskNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.timer,
              color: Colors.white,
              size: 20,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _titleController,
              style: TextStyle(color: Colors.white, fontSize: 17),
              decoration: InputDecoration(
                hintText: 'Task Name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Task name is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPomodoroSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Text(
            '1 focus =',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Spacer(),
          Text(
            '25 min',
            style: TextStyle(color: Colors.grey, fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.refresh, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Number of Sessions',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              Spacer(),
              Obx(() => Text(
                '${_estimatedPomodoros.value} Sessions = ${_estimatedPomodoros.value * 25} min',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
            ],
          ),
          SizedBox(height: 16),
          Obx(() => Row(
            children: List.generate(5, (index) {
              int sessionCount = index + 1;
              bool isSelected = _estimatedPomodoros.value == sessionCount;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _estimatedPomodoros.value = sessionCount,
                  child: Container(
                    margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red.withOpacity(0.8) : Color(0xFF3A3A3C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.timer,
                      color: isSelected ? Colors.white : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              );
            }),
          )),
          SizedBox(height: 8),
          if (_estimatedPomodoros.value < 5)
            GestureDetector(
              onTap: () {
                if (_estimatedPomodoros.value < 10) {
                  _estimatedPomodoros.value++;
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Starts',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF3A3A3C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => Text(
                      _deadline.value != null
                          ? _formatDate(_deadline.value!)
                          : '6 Aug 2025',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Anytime',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Repeat',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          GestureDetector(
            onTap: () => _showRepeatOptions(),
            child: Obx(() => Text(
              _selectedRepeat.value,
              style: TextStyle(color: Colors.grey, fontSize: 17),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reminder',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          GestureDetector(
            onTap: () => _showReminderOptions(),
            child: Obx(() => Text(
              _selectedReminder.value,
              style: TextStyle(color: Colors.grey, fontSize: 17),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.flag, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Text(
            'Priority',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Spacer(),
          Row(
            children: TaskPriority.values.map((priority) {
              return Obx(() => GestureDetector(
                onTap: () => _selectedPriority.value = priority,
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedPriority.value == priority
                        ? _getPriorityColor(priority)
                        : Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priority.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _noteController,
        maxLines: 4,
        style: TextStyle(color: Colors.white, fontSize: 17),
        decoration: InputDecoration(
          hintText: 'Add a note',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Obx(() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading.value ? null : _createTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3A3A3C),
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading.value
              ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Text(
            'Done',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      )),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.red,
              surface: Color(0xFF2C2C2E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _deadline.value = picked;
      _hasDeadline.value = true;
    }
  }

  void _showRepeatOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _repeatOptions.map((option) {
            return ListTile(
              title: Text(
                option,
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _selectedRepeat.value = option;
                Get.back();
              },
              trailing: _selectedRepeat.value == option
                  ? Icon(Icons.check, color: Colors.red)
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showReminderOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _reminderOptions.map((option) {
            return ListTile(
              title: Text(
                option,
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _selectedReminder.value = option;
                Get.back();
              },
              trailing: _selectedReminder.value == option
                  ? Icon(Icons.check, color: Colors.red)
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  void _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _isLoading.value = true;

    try {
      if (widget.isEdit && widget.task != null) {
        // Edit mode
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          priority: _selectedPriority.value,
          deadline: _hasDeadline.value ? _deadline.value : null,
          estimatedPomodoros: _estimatedPomodoros.value,
          updatedAt: DateTime.now(),
        );

        final success = await taskController.updateTask(updatedTask);
        if (success) {
          Get.back();
          Get.snackbar(
            "Success",
            "Task updated successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to update task",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Create mode
        final success = await taskController.createTask(
          title: _titleController.text.trim(),
          description: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          priority: _selectedPriority.value,
          deadline: _hasDeadline.value ? _deadline.value : null,
          estimatedPomodoros: _estimatedPomodoros.value,
        );

        if (success) {
          Get.back();
          Get.snackbar(
            "Success",
            "Task created successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to create task",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}