// import 'package:todoro/import_export/todoro_import_export.dart';
// import 'package:http/http.dart'  as http;
//
// class TaskService {
//   final String baseUrl = 'https://67c6fd70c19eb8753e782e89.mockapi.io/todoro';
//
//   Future<List<Task>> fetchTasks() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final List jsonData = json.decode(response.body);
//       return jsonData.map((e) => Task.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load tasks');
//     }
//   }
//
//   Future<void> addTask(Task task) async {
//     await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(task.toJson()),
//     );
//   }
//
//   Future<void> updateTask(Task task) async {
//     await http.put(
//       Uri.parse('$baseUrl/${task.id}'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(task.toJson()),
//     );
//   }
//
//   Future<void> deleteTask(int id) async {
//     await http.delete(Uri.parse('$baseUrl/$id'));
//   }
// }
