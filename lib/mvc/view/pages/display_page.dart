import 'package:todoro/import_export/todoro_import_export.dart';

class TaskListPage extends StatelessWidget {
  final TaskController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Task Details")),
      body: Obx(() {
        if (controller.taskList.isEmpty) {
          return Center(child: Text("No tasks yet."));
        }

        return ListView.builder(
          itemCount: controller.taskList.length,
          itemBuilder: (context, index) {
            final task = controller.taskList[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text("ID: ${task.id} | Title: ${task.title}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User ID: ${task.userId}"),
                    Text("Completed: ${task.completed ? "Yes" : "No"}"),
                    Text("Created At: ${task.createdAt.split('T').first}"),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


