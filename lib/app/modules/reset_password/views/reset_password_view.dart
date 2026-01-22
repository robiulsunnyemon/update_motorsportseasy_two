import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/constants/app_color.dart';
import '../../../routes/app_pages.dart';
import '../../login/widgets/login_button.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                  Text(
                    "Reset Your Password",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Join us and explore your passion",
                    style: TextStyle(
                      color: AppColor.greyColor,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 16),
                  Obx(
                        () => buildInputField(
                      label: 'Confirm Password',
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmHidden.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        }else if(value!=controller.passwordController.text){
                          return "confirm password not match";
                        }
                          else if (value.length < 6) {
                          return 'Confirm Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          controller.isConfirmHidden.toggle();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomLoginButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                    text: Obx(
                          () => controller.isLoading.value
                          ? CircularProgressIndicator(color: AppColor.white,padding: EdgeInsets.all(8),)
                          : Text(
                        "Signup",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: (){
                    Get.offAllNamed(Routes.LOGIN);

                  }, child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.grey.shade600, size: 20),
                      SizedBox(width: 5),
                      Text(
                          'Back to Login',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                          )
                      ),
                    ],
                  ))
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
        color: AppColor.white,
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
