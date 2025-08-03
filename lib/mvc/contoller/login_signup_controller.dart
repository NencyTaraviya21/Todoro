import 'package:todoro/import_export/todoro_import_export.dart';

class AuthController extends GetxController {
  var isLogin = true.obs;
  var hidePassword = true.obs;
  var isLoading = false.obs;
  var isGoogleLoading = false.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleMode() {
    isLogin.value = !isLogin.value;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  bool _validateFields() {
    if (!isLogin.value && nameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your full name',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your email',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Validation Error', 'Please enter a valid email',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter your password',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('Validation Error', 'Password must be at least 6 characters',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
      return false;
    }

    return true;
  }

  void login() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    try {
      // Your login logic here
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar('Success', 'Welcome back!',
          backgroundColor: Color(0xFFB5A28F), colorText: Colors.white);

      // Navigate to home page
      Get.offAllNamed('/dashboard');

    } catch (e) {
      Get.snackbar('Login Failed', 'Invalid credentials',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void register() async {
    if (!_validateFields()) return;

    isLoading.value = true;

    try {
      // Your registration logic here
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar('Success', 'Account created successfully!',
          backgroundColor: Color(0xFFB5A28F), colorText: Colors.white);

      // Navigate to home page
      Get.offAllNamed('/home');

    } catch (e) {
      Get.snackbar('Registration Failed', 'Something went wrong',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void signInWithGoogle() async {
    isGoogleLoading.value = true;

    try {
      // Your Google Sign-In logic here
      // Example: await GoogleSignIn().signIn();
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar('Success', 'Google sign-in successful!',
          backgroundColor: Color(0xFFB5A28F), colorText: Colors.white);

      // Navigate to home page
      Get.offAllNamed('/home');

    } catch (e) {
      Get.snackbar('Google Sign-In Failed', 'Something went wrong',
          backgroundColor: Color(0xFFD4A574), colorText: Colors.white);
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}