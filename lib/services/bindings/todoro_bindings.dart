import 'package:todoro/import_export/todoro_import_export.dart';
class AuthBinding extends Bindings {
@override
void dependencies() {
  Get.lazyPut<AuthController>(() => AuthController());
}
}

// class TodoBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => TodoController());
//   }
// }