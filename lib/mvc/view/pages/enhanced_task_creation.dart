import 'package:todoro/import_export/todoro_import_export.dart';

class EnhancedTaskCreationPage extends StatefulWidget {
  final DailyPlanModel? planToEdit;
  final DateTime? initialDate;

  const EnhancedTaskCreationPage({
    Key? key,
    this.planToEdit,
    this.initialDate,
  }) : super(key: key);

  @override
  State<EnhancedTaskCreationPage> createState() => _EnhancedTaskCreationPageState();
}

class _EnhancedTaskCreationPageState extends State<EnhancedTaskCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TaskCategory _selectedCategory = TaskCategory.focus;
  int _pomodoroSessions = 4;
  int _pomodoroMinutes = 25;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  RepeatType _repeatType = RepeatType.none;
  DateTime? _reminderTime;
  bool _isAnytime = true;

  @override
  void initState() {
    super.initState();
    _initializeFromPlan();
  }

  void _initializeFromPlan() {
    if (widget.planToEdit != null) {
      final plan = widget.planToEdit!;
      _titleController.text = plan.title;
      _descriptionController.text = plan.description ?? '';
      _selectedCategory = plan.category;
      _pomodoroSessions = plan.pomodoroSessions;
      _pomodoroMinutes = plan.pomodoroMinutes;
      _selectedDate = plan.planDate;
      _startTime = plan.startTime;
      _endTime = plan.endTime;
      _repeatType = plan.repeatType;
      _reminderTime = plan.reminderTime;
      _isAnytime = plan.startTime == null;
    } else if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 16),
          ),
        ),
        title: const Text(
          'Create',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leadingWidth: 80,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryAndTitle(),
              const SizedBox(height: 30),
              _buildPomodoroSettings(),
              const SizedBox(height: 30),
              _buildScheduling(),
              const SizedBox(height: 30),
              _buildRepeatSettings(),
              const SizedBox(height: 30),
              _buildReminderSettings(),
              const SizedBox(height: 30),
              _buildNotesSection(),
              const SizedBox(height: 40),
              _buildDoneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAndTitle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getCategoryColor(_selectedCategory),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _selectedCategory.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Task Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCategorySelector(),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: TaskCategory.values.length,
        itemBuilder: (context, index) {
          final category = TaskCategory.values[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? _getCategoryColor(category) : const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPomodoroSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                '1 focus =',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Text(
                '${_pomodoroMinutes} min',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.refresh, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Number of Sessions',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              Text(
                '$_pomodoroSessions Sessions = ${_pomodoroSessions * _pomodoroMinutes} min',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildPomodoroSessionSelector(),
        ],
      ),
    );
  }

  Widget _buildPomodoroSessionSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (sessionIndex) {
        final sessionCount = sessionIndex + 1;
        final isSelected = sessionCount == _pomodoroSessions;
        
        return GestureDetector(
          onTap: () => setState(() => _pomodoroSessions = sessionCount),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF6B6B) : const Color(0xFF3A3A3A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.timer,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScheduling() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Starts',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isAnytime = !_isAnytime),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _isAnytime ? const Color(0xFF3A3A3A) : const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _isAnytime ? 'Anytime' : _formatTime(_startTime),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (!_isAnytime) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTimeButton('Start Time', _startTime, _selectStartTime),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeButton('End Time', _endTime, _selectEndTime),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay? time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              time?.format(context) ?? 'Select',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Repeat',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          DropdownButton<RepeatType>(
            value: _repeatType,
            dropdownColor: const Color(0xFF3A3A3A),
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            onChanged: (RepeatType? newValue) {
              if (newValue != null) {
                setState(() => _repeatType = newValue);
              }
            },
            items: RepeatType.values.map<DropdownMenuItem<RepeatType>>((RepeatType value) {
              return DropdownMenuItem<RepeatType>(
                value: value,
                child: Text(value.displayName),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Reminder',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          GestureDetector(
            onTap: _selectReminderTime,
            child: Text(
              _reminderTime != null ? _formatDateTime(_reminderTime!) : 'No Reminder',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Add a note',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _savePlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Done',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
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

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select';
    return time.format(context);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B6B),
              surface: Color(0xFF2A2A2A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B6B),
              surface: Color(0xFF2A2A2A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        _isAnytime = false;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? (_startTime?.replacing(hour: _startTime!.hour + 1) ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B6B),
              surface: Color(0xFF2A2A2A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _selectReminderTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? _selectedDate,
      firstDate: DateTime.now(),
      lastDate: _selectedDate.add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B6B),
              surface: Color(0xFF2A2A2A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFF6B6B),
                surface: Color(0xFF2A2A2A),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;

    final dailyPlanController = Get.find<DailyPlanController>();
    
    final plan = DailyPlanModel(
      id: widget.planToEdit?.id,
      userId: 1, // TODO: Get from auth controller
      taskId: widget.planToEdit?.taskId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      category: _selectedCategory,
      planDate: _selectedDate,
      startTime: _isAnytime ? null : _startTime,
      endTime: _isAnytime ? null : _endTime,
      pomodoroSessions: _pomodoroSessions,
      pomodoroMinutes: _pomodoroMinutes,
      repeatType: _repeatType,
      reminderTime: _reminderTime,
      createdAt: widget.planToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    bool success;
    if (widget.planToEdit != null) {
      success = await dailyPlanController.updateDailyPlan(plan);
    } else {
      success = await dailyPlanController.createDailyPlan(plan);
      
      // Create repeated plans if needed
      if (success && _repeatType != RepeatType.none) {
        await dailyPlanController.createRepeatedPlans(plan, 30); // Create for next 30 occurrences
      }
    }

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dailyPlanController.errorMessage),
          backgroundColor: const Color(0xFFFF6B6B),
        ),
      );
    }
  }
}