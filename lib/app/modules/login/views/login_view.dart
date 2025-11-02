import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_button.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login to continue your journey",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email
                  buildInputField(
                    label: 'Email',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!GetUtils.isEmail(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password with eye icon 👁️
                  Obx(
                    () => buildInputField(
                      label: 'Password',
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          controller.isPasswordHidden.toggle();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Get.dialog(
                        //   ForgotPasswordDialog(),
                        // );
                        Get.toNamed(Routes.FORGET_PASSWORD);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Login Button
                  CustomLoginButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.login();
                      }
                    },
                    text: Obx(
                      () => controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white,padding: EdgeInsets.all(8),)
                          : Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Signup Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontFamily: 'Inter'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.SIGNUP);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
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
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
