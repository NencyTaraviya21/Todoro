// import 'package:todoro/import_export/todoro_import_export.dart';
// import 'package:todoro/mvc/view/widgets/floating_pomodoro.dart';
//
// class Dashboard extends StatelessWidget {
//   final DashboardController controller = Get.put(DashboardController());
//   final PomodoroController pomodoroController = Get.put(PomodoroController());
//
//   Dashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFf5f1eb),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         title: Text(
//           controller.greeting,
//           style: TextStyle(
//             color: Color(0xFF693382),
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list, color: Color(0xFF693382)),
//             onPressed: controller.showFilterDialog,
//           ),
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert, color: Color(0xFF693382)),
//             onSelected: controller.handleMenuSelection,
//             itemBuilder: (context) => [
//               PopupMenuItem(value: 'profile', child: Text('Profile')),
//               PopupMenuItem(value: 'refresh', child: Text('Refresh')),
//               PopupMenuItem(value: 'logout', child: Text('Logout')),
//             ],
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isRefreshing.value) {
//           return Center(child: CircularProgressIndicator(color: Color(0xFF693382)));
//         }
//         return RefreshIndicator(
//           onRefresh: controller.refreshData,
//           color: Color(0xFF693382),
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildStatsCards(),
//                 SizedBox(height: 20),
//                 _buildQuickActions(),
//                 SizedBox(height: 20),
//                 _buildTasksList(),
//               ],
//             ),
//           ),
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xFF693382),
//         onPressed: () => controller.navigateToAddTask(),
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildStatsCards() {
//     return Container(
//       height: 120,
//       child: Row(
//         children: [
//           Expanded(child: Obx(() => _buildStatCard(
//             'Total Tasks',
//             controller.totalTasksCount.toString(),
//             Icons.task_alt,
//             Color(0xFF5F99AE),
//           ))),
//           SizedBox(width: 12),
//           Expanded(child: Obx(() => _buildStatCard(
//             'Completed',
//             controller.completedTasksCount.toString(),
//             Icons.check_circle,
//             Color(0xFF336D82),
//           ))),
//           SizedBox(width: 12),
//           Expanded(child: Obx(() => _buildStatCard(
//             'Progress',
//             '${controller.completionPercentage.toInt()}%',
//             Icons.trending_up,
//             Color(0xFF693382),
//           ))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: color, size: 28),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Quick Actions',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF693382),
//           ),
//         ),
//         SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionButton(
//                 'Start Pomodoro',
//                 Icons.play_circle_filled,
//                 Color(0xFF336D82),
//                 controller.showTaskSelectionDialog,
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: _buildActionButton(
//                 'Add Task',
//                 Icons.add_task,
//                 Color(0xFF5F99AE),
//                     () => controller.navigateToAddTask(),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 32),
//             SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTasksList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Tasks',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF693382),
//               ),
//             ),
//             Obx(() => Text(
//               controller.selectedFilter.value == 'all'
//                   ? 'All Tasks'
//                   : '${controller.selectedFilter.value.toUpperCase()} Priority',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             )),
//           ],
//         ),
//         SizedBox(height: 12),
//         Obx(() {
//           final tasks = controller.filteredTasks;
//           if (tasks.isEmpty) {
//             return _buildEmptyState();
//           }
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               final task = tasks[index];
//               return _buildTaskCard(task);
//             },
//           );
//         }),
//       ],
//     );
//   }
//
//   Widget _buildTaskCard(TaskModel task) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: controller.getPriorityColor(task.priority).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   controller.getPriorityText(task.priority),
//                   style: TextStyle(
//                     color: controller.getPriorityColor(task.priority),
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Spacer(),
//               if (task.deadLine != null)
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: controller.isOverdue(task.deadLine!)
//                         ? Colors.red.withOpacity(0.1)
//                         : Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     controller.formatDate(task.deadLine!),
//                     style: TextStyle(
//                       color: controller.isOverdue(task.deadLine!)
//                           ? Colors.red
//                           : Colors.blue,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               PopupMenuButton<String>(
//                 icon: Icon(Icons.more_vert, size: 18),
//                 onSelected: (value) {
//                   if (value == 'edit') {
//                     controller.navigateToAddTask(task);
//                   } else if (value == 'delete') {
//                     controller.deleteTask(task.id!);
//                   }
//                 },
//                 itemBuilder: (context) => [
//                   PopupMenuItem(value: 'edit', child: Text('Edit')),
//                   PopupMenuItem(value: 'delete', child: Text('Delete')),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             task.title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[800],
//             ),
//           ),
//           if (task.description != null && task.description != "Null")
//             Padding(
//               padding: EdgeInsets.only(top: 4),
//               child: Text(
//                 task.description!,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           if (task.estimatedPomodoros != null)
//             Padding(
//               padding: EdgeInsets.only(top: 8),
//               child: Row(
//                 children: [
//                   Icon(Icons.timer, size: 16, color: Colors.grey[600]),
//                   SizedBox(width: 4),
//                   Text(
//                     '${task.estimatedPomodoros} pomodoros',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Spacer(),
//                   Text(
//                     '${task.completedPomodoros}/${task.estimatedPomodoros ?? 0} done',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Obx(() {
//                 final runningForTask = pomodoroController.currentTaskId == (task.id ?? '');
//                 return ElevatedButton(
//                   onPressed: () {
//                     if (runningForTask) {
//                       pomodoroController.pausePomodoro();
//                     } else {
//                       pomodoroController.startPomodoro(task.id!);
//                       _showBlurTimerOverlay(Get.context!, task);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: runningForTask ? Colors.orange : Colors.green,
//                     minimumSize: Size(80, 36),
//                   ),
//                   child: Text(runningForTask ? 'Pause' : 'Start', style: TextStyle(color: Colors.white)),
//                 );
//               }),
//               SizedBox(width: 8),
//               // ElevatedButton(
//               //   onPressed: () {
//               //     pomodoroController.resetPomodors();
//               //     FloatingPomodoroOverlay.hide();
//               //   },
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: Colors.grey,
//               //     minimumSize: Size(80, 36),
//               //   ),
//               //   child: Text('Stop', style: TextStyle(color: Colors.white)),
//               // ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // void _showBlurTimerOverlay(BuildContext context, TaskModel task) {
//   //   FloatingPomodoroOverlay.show(
//   //     context,
//   //     taskId: task.id.toString()??'',
//   //     title: task.title,
//   //     onClose: () {
//   //       pomodoroController.pausePomodoro();
//   //       FloatingPomodoroOverlay.hide();
//   //     },
//   //     onOpenFullScreen: () {
//   //       FloatingPomodoroOverlay.hide();
//   //     },
//   //   );
//   // }
//
//   Widget _buildEmptyState() {
//     return Container(
//       padding: EdgeInsets.all(32),
//       child: Column(
//         children: [
//           Icon(
//             Icons.task_alt,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No tasks found',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Create your first task to get started!',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => controller.navigateToAddTask(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF693382),
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               'Add Task',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
