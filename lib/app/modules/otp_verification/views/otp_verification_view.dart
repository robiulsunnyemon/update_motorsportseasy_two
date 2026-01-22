// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:motor_sport_easy/app/data/constants/app_color.dart';
// import 'package:pinput/pinput.dart';
// import 'package:get/get.dart';
// import '../../login/widgets/login_button.dart';
// import '../controllers/otp_verification_controller.dart';
//
//
//
// class OtpVerificationView extends GetView<OtpVerificationController> {
//   const OtpVerificationView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final args=Get.arguments;
//     return Scaffold(
//       body:  Center(
//         child:Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Verification',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: const Color(0xFF1A1A1A),
//                   fontSize: 32,
//                   fontFamily: 'PlayfairDisplay',
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'We sent Verification code to your email',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12,
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const SizedBox(height: 40),
//
//               Pinput(
//                 onCompleted: (pin) => log(pin),
//                 length: 5,
//                 defaultPinTheme: PinTheme(
//                   width: 45,
//                   height: 45,
//                   textStyle: TextStyle(fontSize: 20, color: AppColor.white, fontWeight: FontWeight.w600),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: AppColor.primaryColor.withValues(alpha: .9)
//                   ),
//                 ),
//                 controller: controller.otpController,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: CustomLoginButton(onTap: (){
//                   controller.verifyOtp(email: args["email"],isResetPassword: args["isResetPassword"]);
//                 }, text:Obx(
//                       () => controller.isLoading.value
//                       ? CircularProgressIndicator(color: Colors.white,padding: EdgeInsets.all(8),)
//                       : Text(
//                     "Verify",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't receive code?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: (){
//                       controller.resendOtp(email: args["email"]);
//                     },
//                     child: Text(
//                     "Resend",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColor.primaryColor,
//                       fontSize: 14,
//                       fontFamily: 'Inter',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),)
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//



import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/data/constants/app_color.dart';
import 'package:pinput/pinput.dart';
import '../../login/widgets/login_button.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final email = args?["email"] ?? "";
    final isResetPassword = args?["isResetPassword"] ?? false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verification',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 32,
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'We sent a verification code to your email',
                style: TextStyle(
                  color: AppColor.greyColor,
                  fontSize: 12,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 40),

              Pinput(
                controller: controller.otpController,
                length: 5,
                onCompleted: (pin) => log(pin),
                defaultPinTheme: PinTheme(
                  width: 45,
                  height: 45,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.primaryColor.withValues(alpha: .9),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Obx(() {
                return CustomLoginButton(
                  onTap: () {
                    controller.verifyOtp(
                      email: email,
                      isResetPassword: isResetPassword,
                    );
                  },
                  text: controller.isLoading.value
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "Verify",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code?",
                    style: TextStyle(
                      color: AppColor.greyColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.resendOtp(email: email);
                    },
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
