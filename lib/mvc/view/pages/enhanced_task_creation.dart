import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoro/mvc/model/daily_plan_model.dart';
import 'package:todoro/mvc/model/enums.dart';
import 'package:todoro/mvc/contoller/daily_plan_controller.dart';

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
  final _titleController = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.focus;
  int _pomodoroSessions = 4;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Create Task', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Task Name',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<TaskCategory>(
              value: _selectedCategory,
              dropdownColor: const Color(0xFF2A2A2A),
              style: const TextStyle(color: Colors.white),
              items: TaskCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text('${category.icon} ${category.displayName}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: List.generate(5, (index) {
                final sessionCount = index + 1;
                final isSelected = sessionCount == _pomodoroSessions;
                return GestureDetector(
                  onTap: () => setState(() => _pomodoroSessions = sessionCount),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6B6B) : const Color(0xFF3A3A3A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        sessionCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Done', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePlan() async {
    if (_titleController.text.trim().isEmpty) return;

    try {
      final controller = Get.find<DailyPlanController>();
      
      final plan = DailyPlanModel(
        userId: 1,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        planDate: _selectedDate,
        pomodoroSessions: _pomodoroSessions,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await controller.createDailyPlan(plan);
      Navigator.pop(context);
    } catch (e) {
      print('Error saving plan: $e');
    }
  }
}