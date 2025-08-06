import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoro/mvc/model/daily_plan_model.dart';
import 'package:todoro/mvc/model/enums.dart';
import 'package:todoro/mvc/contoller/pomodoro_controller.dart';

class DailyPlanController extends GetxController {
  // Observable variables
  final RxList<DailyPlanModel> _dailyPlans = <DailyPlanModel>[].obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<TaskCategory?> _selectedCategory = Rx<TaskCategory?>(null);

  // Getters
  List<DailyPlanModel> get dailyPlans => _dailyPlans;
  DateTime get selectedDate => _selectedDate.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  TaskCategory? get selectedCategory => _selectedCategory.value;

  // Filtered daily plans for selected date
  List<DailyPlanModel> get plansForSelectedDate {
    return _dailyPlans.where((plan) {
      final planDate = DateTime(
        plan.planDate.year,
        plan.planDate.month,
        plan.planDate.day,
      );
      final selected = DateTime(
        _selectedDate.value.year,
        _selectedDate.value.month,
        _selectedDate.value.day,
      );
      return planDate.isAtSameMomentAs(selected);
    }).toList();
  }

  // Filtered plans by category
  List<DailyPlanModel> get filteredPlans {
    var plans = plansForSelectedDate;
    if (_selectedCategory.value != null) {
      plans = plans.where((plan) => plan.category == _selectedCategory.value).toList();
    }
    return plans..sort((a, b) {
      // Sort by start time, putting null times at the end
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;
      
      final aMinutes = a.startTime!.hour * 60 + a.startTime!.minute;
      final bMinutes = b.startTime!.hour * 60 + b.startTime!.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  // Statistics
  int get totalPlansForDate => plansForSelectedDate.length;
  int get completedPlansForDate => plansForSelectedDate.where((p) => p.isCompleted).length;
  int get pendingPlansForDate => totalPlansForDate - completedPlansForDate;
  
  double get completionPercentage {
    if (totalPlansForDate == 0) return 0.0;
    return (completedPlansForDate / totalPlansForDate) * 100;
  }

  @override
  void onInit() {
    super.onInit();
    loadPlansForDate(_selectedDate.value);
  }

  // Change selected date
  void changeSelectedDate(DateTime date) {
    _selectedDate.value = date;
    loadPlansForDate(date);
  }

  // Change selected category filter
  void changeSelectedCategory(TaskCategory? category) {
    _selectedCategory.value = category;
  }

  // Load plans for specific date
  Future<void> loadPlansForDate(DateTime date) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      // TODO: Implement database service call
      // For now, we'll use mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      _errorMessage.value = 'Failed to load plans: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // Create new daily plan
  Future<bool> createDailyPlan(DailyPlanModel plan) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      // TODO: Implement database service call
      // For now, add to local list with generated ID
      final newPlan = plan.copyWith(
        id: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _dailyPlans.add(newPlan);
      
      return true;
    } catch (e) {
      _errorMessage.value = 'Failed to create plan: ${e.toString()}';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update daily plan
  Future<bool> updateDailyPlan(DailyPlanModel plan) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final index = _dailyPlans.indexWhere((p) => p.id == plan.id);
      if (index != -1) {
        _dailyPlans[index] = plan.copyWith(updatedAt: DateTime.now());
      }
      
      return true;
    } catch (e) {
      _errorMessage.value = 'Failed to update plan: ${e.toString()}';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete daily plan
  Future<bool> deleteDailyPlan(int planId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      _dailyPlans.removeWhere((plan) => plan.id == planId);
      
      return true;
    } catch (e) {
      _errorMessage.value = 'Failed to delete plan: ${e.toString()}';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Toggle plan completion
  Future<void> togglePlanCompletion(int planId) async {
    final planIndex = _dailyPlans.indexWhere((p) => p.id == planId);
    if (planIndex != -1) {
      final plan = _dailyPlans[planIndex];
      final updatedPlan = plan.copyWith(
        isCompleted: !plan.isCompleted,
        updatedAt: DateTime.now(),
      );
      await updateDailyPlan(updatedPlan);
    }
  }

  // Start Pomodoro session for a plan
  Future<void> startPomodoroSession(int planId) async {
    final plan = _dailyPlans.firstWhereOrNull((p) => p.id == planId);
    if (plan != null) {
      try {
        final pomodoroController = Get.find<PomodoroController>();
        await pomodoroController.startPomodoro(1); // Using default task ID
      } catch (e) {
        print('Error starting pomodoro: $e');
      }
    }
  }

  // Create repeated plans based on repeat type
  Future<void> createRepeatedPlans(DailyPlanModel basePlan, int numberOfDays) async {
    if (basePlan.repeatType == RepeatType.none) return;
    
    final plans = <DailyPlanModel>[];
    
    for (int i = 1; i <= numberOfDays; i++) {
      DateTime nextDate;
      switch (basePlan.repeatType) {
        case RepeatType.daily:
          nextDate = basePlan.planDate.add(Duration(days: i));
          break;
        case RepeatType.weekly:
          nextDate = basePlan.planDate.add(Duration(days: i * 7));
          break;
        case RepeatType.monthly:
          nextDate = DateTime(
            basePlan.planDate.year,
            basePlan.planDate.month + i,
            basePlan.planDate.day,
          );
          break;
        case RepeatType.none:
          continue;
      }
      
      final repeatedPlan = basePlan.copyWith(
        id: null,
        planDate: nextDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      plans.add(repeatedPlan);
    }
    
    for (final plan in plans) {
      await createDailyPlan(plan);
    }
  }
}