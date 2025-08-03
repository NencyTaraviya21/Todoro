import 'package:todoro/import_export/todoro_import_export.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialBinding: AuthBinding(),
      home: AddTask(),
      getPages: [
        GetPage(
          name: '/auth',
          page: () => AuthPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => Dashboard(), // Your home/dashboard page
        ),
      ],
    );
  }
}

