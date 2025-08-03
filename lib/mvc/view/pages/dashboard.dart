import 'package:todo_app/import_export/import_export.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'TODORO'),
      backgroundColor: Colors.black,
      body: Obx(() {
        final tasks = taskController.tasks;
        if (taskController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tasks.isEmpty) {
          return Center(
            child: Text(
              'No tasks yet',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final color = _getPriorityColor(task.priority!);

            return Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  task.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: task.description != null
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    task.description!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
                    : null,
                trailing: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.priority!.name.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTask());
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.greenAccent;
      case TaskPriority.medium:
        return Colors.orangeAccent;
      case TaskPriority.high:
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }
}
