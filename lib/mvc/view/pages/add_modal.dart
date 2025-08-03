
import 'package:todoro/import_export/todoro_import_export.dart';

class AddTask extends StatefulWidget {
  final bool isEdit;
  final TaskModel? task;

  AddTask({this.isEdit = false, this.task});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with TickerProviderStateMixin {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final TextEditingController _estimatedPomodorosController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Rx<TaskPriority> _selectedPriority = TaskPriority.low.obs;
  final Rx<DateTime?> _deadline = Rx<DateTime?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _hasDeadline = false.obs;
  final RxInt _estimatedPomodoros = 1.obs;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _noteController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _estimatedPomodorosController = TextEditingController(
      text: widget.task?.estimatedPomodoros?.toString() ?? '1',
    );

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

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
    _estimatedPomodorosController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f1eb),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFFBED7DC)),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Enter New Task',
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color:Color(0xFF336D82))
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          TextFormField(
                            controller: _noteController,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Notes',
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 12),
                              // contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 12),
                            ),
                            keyboardType: TextInputType.multiline,
                          ),
                        ],
                      ),
                    ),


                    // _buildInputField(
                    //   htext: "Enter task",
                    //   _titleController,
                    //   icon: Icons.task_alt,
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Task title is required';
                    //     }
                    //     if (value.trim().length < 3) {
                    //       return 'Title must be at least 3 characters';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(height: 8),
                    // _buildInputField(
                    //   htext: "Notes",
                    //   icon: Icons.note_alt_outlined,
                    //   _noteController,
                    //   maxLines: 1,
                    //   keyboardType: TextInputType.multiline,
                    // ),
                    SizedBox(height: 10),
                    _buildPomodoroSection(),
                    SizedBox(height: 10),
                    _buildPrioritySelector(),
                    SizedBox(height: 10),
                    _buildDeadlineSection(context),
                    SizedBox(height: 15),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.3),
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey.shade700,
            size: 18,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        widget.isEdit ? 'Edit Task' : 'Create New Task',
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6366F1).withOpacity(0.1),
            Color(0xFF8B5CF6).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.isEdit ? Icons.edit_rounded : Icons.add_task_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEdit ? 'Update Task' : 'New Task',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.isEdit
                      ? 'Modify your task details below'
                      : 'Fill in the details to create a new task',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      TextEditingController controller, {
        IconData? icon,
        int maxLines = 1,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        String? htext,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color:  Color(0xFF336D82), fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,color: Color(0xFFBED7DC),),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFBED7DC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFBED7DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFBED7DC), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade200, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintText: htext,
            hintStyle: TextStyle(color: Color(0xFF5F99AE)),
          ),
        ),
      ],
    );
  }

  Widget _buildPomodoroSection() {
    return Container(
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFBED7DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF5F99AE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.timer, color: Color(0xFF5F99AE), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Estimated Pomodoros',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(
                () => Row(
              children: [
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFBED7DC)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _estimatedPomodoros.value >= 0
                              ? () {
                            _estimatedPomodoros.value--;
                            _estimatedPomodorosController.text =
                                _estimatedPomodoros.value.toString();
                          }
                              : null,
                          icon: Icon(Icons.remove, color: Colors.grey.shade600),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(4),
                          ),
                        ),
                        Text(
                          '${_estimatedPomodoros.value}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: _estimatedPomodoros.value < 20
                              ? () {
                            _estimatedPomodoros.value++;
                            _estimatedPomodorosController.text =
                                _estimatedPomodoros.value.toString();
                          }
                              : null,
                          icon: Icon(Icons.add, color: Color(0xFF5F99AE)),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF5F99AE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '≈ ${_estimatedPomodoros.value * 25} min',
                    style: TextStyle(
                      color: Color(0xFF5F99AE),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFBED7DC)),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color:  Color(0xFF336D82), size: 18),
              SizedBox(width: 8),
              Text(
                'Priority Level',
                style: TextStyle(
                  color:  Color(0xFF336D82),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Obx(
                () => Row(
              children: TaskPriority.values.map((priority) {
                final isSelected = _selectedPriority.value == priority;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _selectedPriority.value = priority,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: priority != TaskPriority.values.last ? 6 : 0,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ), // reduced from 12
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                          colors: [
                            _getPriorityColor(priority),
                            _getPriorityColor(priority).withOpacity(0.9),
                          ],
                        )
                            : null,
                        color: isSelected ? null : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // slightly smaller corners
                        border: Border.all(
                          color: isSelected
                              ? _getPriorityColor(priority)
                              :  Color(0xFF336D82),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 6), // reduced spacing
                          Text(
                            priority.name.capitalize!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.shade700,
                              fontSize: 12, // reduced from 12
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFBED7DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color:  Color(0xFF336D82), size: 18),
              SizedBox(width: 8),
              Text(
                'Deadline',
                style: TextStyle(
                  color:  Color(0xFF336D82),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Obx(
                    () => Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: _hasDeadline.value,
                    onChanged: (value) {
                      _hasDeadline.value = value;
                      if (!value) _deadline.value = null;
                    },
                    activeColor:  Color(0xFF336D82),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(
                () => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _hasDeadline.value ? null : 0,
              child: _hasDeadline.value
                  ? GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                    _deadline.value ??
                        DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary:  Color(0xFF336D82),
                            surface: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) _deadline.value = picked;
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFBED7DC)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _deadline.value == null
                            ? 'Select deadline date'
                            : 'Due: ${_deadline.value!.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(
                          color: _deadline.value != null
                              ? Color(0xFF336D82)
                              : Color(0xFFBED7DC),
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      if (_deadline.value != null)
                        IconButton(
                          onPressed: () => _deadline.value = null,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading.value ? null : () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                foregroundColor:  Color(0xFF336D82),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),

                ),
                elevation: 0,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isLoading.value ? null : () => _createTask(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF336D82),
                foregroundColor: Colors.white.withOpacity(0.3),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _isLoading.value
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.3)),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isEdit ? Icons.save : Icons.add_task,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.isEdit ? 'Update Task' : 'Create Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createTask(BuildContext context) async {
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
          Get.back(); // Go back to previous screen
          Get.offAllNamed('/home'); // Navigate to dashboard and clear stack
          Get.snackbar(
            "Success",
            "Task updated successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white.withOpacity(0.3),
            icon: Icon(Icons.check_circle, color: Colors.white.withOpacity(0.3)),
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to update task",
            backgroundColor: Colors.red,
            colorText: Colors.white.withOpacity(0.3),
            icon: Icon(Icons.error, color: Colors.white.withOpacity(0.3)),
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
          Get.back(); // Go back to previous screen
          Get.offAllNamed(
            '/dashboard',
          ); // Navigate to dashboard and clear stack
          Get.snackbar(
            "Success",
            "Task created successfully",
            backgroundColor: Colors.green.shade200,
            colorText: Colors.white.withOpacity(0.3),
            icon: Icon(Icons.check_circle, color: Colors.white.withOpacity(0.3)),
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to create task",
            backgroundColor: Colors.red.shade300,
            colorText: Colors.white.withOpacity(0.3),
            icon: Icon(Icons.error, color: Colors.white.withOpacity(0.3)),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
        backgroundColor: Colors.red.shade300,
        colorText: Colors.white.withOpacity(0.3),
        icon: Icon(Icons.error, color: Colors.white.withOpacity(0.3)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Color(0xFF62B3A9);
      case TaskPriority.medium:
        return Color(0xFFF6B873);
      case TaskPriority.high:
        return Color(0xFFD64A37);
    }
  }

}
