import 'package:todo_app/import_export/import_export.dart';

class AddTask extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final Rx<TaskPriority> _selectedPriority = TaskPriority.low.obs;
  final Rx<DateTime?> _deadline = Rx<DateTime?>(null);
  final RxBool _isLoading = false.obs;
  TaskController taskController = Get.find<TaskController>();

  AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(title: 'Add Task', centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Title", _titleController),
            SizedBox(height: 12),
            _buildInputField("Add Note (optional)", _noteController, maxLines: 3),
            SizedBox(height: 20),
            _buildPrioritySelector(),
            SizedBox(height: 20),
            _buildDeadlinePicker(context),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    label: 'Cancel',
                    onPressed: () => Get.back(),
                    backgroundColor: Colors.grey[800]!,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildButton(
                    label: _isLoading.value ? 'Creating...' : 'Create Task',
                    onPressed: _isLoading.value ? null : () => _createTask(context),
                    backgroundColor: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    icon: _isLoading.value ? null : Icons.add_task,
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Obx(() => Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = _selectedPriority.value == priority;
            return GestureDetector(
              onTap: () => _selectedPriority.value = priority,
              child: Container(
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _getPriorityColor(priority) : Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _getPriorityColor(priority)),
                ),
                child: Text(
                  priority.name.capitalize!,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildDeadlinePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deadline (Optional)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Obx(() => GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) _deadline.value = picked;
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _deadline.value == null
                  ? 'No deadline selected'
                  : 'Deadline: ${_deadline.value!.toLocal().toString().split(' ')[0]}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, color: textColor) : SizedBox.shrink(),
      label: Text(label, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _createTask(BuildContext context) async {
    final taskController = Get.find<TaskController>();

    if (_titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Title cannot be empty",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    _isLoading.value = true;

    final success = await taskController.createTask(
      title: _titleController.text.trim(),
      description: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      priority: _selectedPriority.value,
      deadLine: _deadline.value,
    );

    _isLoading.value = false;

    if (success) {
      Get.back(); // Close modal
    } else {
      Get.snackbar("Failed", "Unable to create task",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
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
}
