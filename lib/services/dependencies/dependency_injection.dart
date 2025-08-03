import 'package:todoro/import_export/todoro_import_export.dart';

class DependencyInjection {
  static Future<void> init() async {
    await Get.putAsync(()async => await DatabaseService().init());
    Get.put(TaskService());
    Get.put(PomodoroService());
    Get.put(TaskController());
    Get.put(AuthController());
    await GetStorage.init();
    Get.put<IStorageService>(StorageService());
    Get.put<IAuthRepository>(AuthRepository());
    Get.put<AuthService>(AuthService());

  }
}
// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => AuthController());
//   }
// }
//
// class TodoBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => TodoController());
//   }
// }