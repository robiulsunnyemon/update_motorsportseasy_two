import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_color.dart';
import '../../../routes/app_pages.dart';
import '../../login/widgets/login_button.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                      fontFamily: 'PlayfairDisplay',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 38),
                  Text(
                    "No worries! It happens. Please enter the email address linked with your account",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

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

                  const SizedBox(height: 20),
                  CustomLoginButton(
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.resendOtp();
                      }
                    },
                    text: Obx(
                      () => controller.isLoading.value
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              padding: EdgeInsets.all(8),
                            )
                          : Text(
                              "Submit",
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
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Back to Login',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                        ),
                      ],
                    ),
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
