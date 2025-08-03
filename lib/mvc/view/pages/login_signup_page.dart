import 'package:todoro/import_export/todoro_import_export.dart';

class AuthPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f1eb), // Nude/cream background
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        // Top section
                        Container(
                          height: constraints.maxHeight * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Todo Icon with nude accent
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF89A8B2),
                                      Color(0xFF336D82),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFD0DDD0).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'TODORO',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF336D82),
                                ),
                              ),
                              SizedBox(height: 8),
                              Obx(
                                () => Text(
                                  controller.isLogin.value
                                      ? 'Welcome back to your tasks'
                                      : 'Join to organize your life',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF5F99AE),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Form section
                        Expanded(
                          child: Container(
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF5F99AE).withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),

                                  Obx(
                                    () => Center(
                                      child: Text(
                                        controller.isLogin.value
                                            ? 'Sign In'
                                            : 'Sign Up',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5F99AE),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 25),

                                  // Name field (only for signup) - Capital letters only
                                  Obx(
                                    () => controller.isLogin.value
                                        ? SizedBox.shrink()
                                        : Column(
                                            children: [
                                              _buildTextField(
                                                controller:
                                                    controller.nameController,
                                                hint: 'Username',
                                                icon: Icons.person_outline,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                  ),

                                  // Email field
                                  _buildTextField(
                                    controller: controller.emailController,
                                    hint: 'Email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                  ),

                                  SizedBox(height: 15),

                                  // Password field with toggle
                                  Obx(
                                    () => _buildTextField(
                                      controller: controller.passwordController,
                                      hint: 'Password',
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                      obscureText:
                                          controller.hidePassword.value,
                                      textInputAction: TextInputAction.done,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.hidePassword.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Color(0xFF5F99AE),
                                          size: 20,
                                        ),
                                        onPressed:
                                            controller.togglePasswordVisibility,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 30),

                                  // Submit Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Obx(
                                      () => ElevatedButton(
                                        onPressed: controller.isLoading.value
                                            ? null
                                            : () {
                                                if (controller.isLogin.value) {
                                                  controller.login();
                                                } else {
                                                  controller.register();
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF5F99AE),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 2,
                                          shadowColor: Color(
                                            0xFF5F99AE,
                                          ).withOpacity(0.3),
                                        ),
                                        child: controller.isLoading.value
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Obx(
                                                () => Text(
                                                  controller.isLogin.value
                                                      ? 'Sign In'
                                                      : 'Sign Up',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  // Divider with "OR"
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Color(0xFFE5D5C8),
                                          thickness: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Text(
                                          'OR',
                                          style: TextStyle(
                                            color: Color(0xFF9B8B7A),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Color(0xFFE5D5C8),
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20),

                                  // Google Sign In Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Obx(
                                      () => OutlinedButton.icon(
                                        onPressed:
                                            controller.isGoogleLoading.value
                                            ? null
                                            : controller.signInWithGoogle,
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Color(0xFFE5D5C8),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        icon: controller.isGoogleLoading.value
                                            ? SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Color(0xFF5F99AE),
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              'lib/assests/goggle_image.jpeg',
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                        ,
                                        label: Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            color: Color(0xFF5F99AE),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 25),

                                  // Toggle Login/Register
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => Text(
                                          controller.isLogin.value
                                              ? "Don't have an account? "
                                              : "Already have an account? ",
                                          style: TextStyle(
                                            color: Color(0xFF5F99AE),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: controller.toggleMode,
                                        child: Obx(
                                          () => Text(
                                            controller.isLogin.value
                                                ? 'Sign Up'
                                                : 'Sign In',
                                            style: TextStyle(
                                              color: Color(0xFF336D82),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: TextStyle(
          color: Color(0xFF5F99AE),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF5F99AE), fontSize: 14),
          prefixIcon: Icon(icon, color: Color(0xFF5F99AE), size: 20),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFE5D5C8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFBED7DC), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFBED7DC)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }
}
