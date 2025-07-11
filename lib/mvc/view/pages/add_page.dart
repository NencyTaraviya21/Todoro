
import 'package:todoro/import_export/todoro_import_export.dart';


class AddTaskPage extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());
  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (taskController.text.trim().isNotEmpty) {
                  controller.addTask(taskController.text.trim());
                  taskController.clear();
                  Get.snackbar('Success', 'Task added!');
                }
              },
              child: Text('Add Task'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.list),
              label: Text("Go to Task List"),
              onPressed: () {
                Get.to(() => TaskListPage());
              },
            )
          ],
        ),
      ),
    );
  }
}

