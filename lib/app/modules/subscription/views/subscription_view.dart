import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/data/constants/app_color.dart';
import '../controllers/subscription_controller.dart';
import '../../../utils/custom_snackbar.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscribe',
          style: TextStyle(
            color: AppColor.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColor.blackColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColor.primaryColor,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.initializeIAP(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!controller.isStoreAvailable.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_mall_directory,
                  color: Colors.orange,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'Store unavailable',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColor.blackColor),
                child: Image.asset("assets/images/logo_image.jpg"),

                /*Column(
                  children: [
                    // Icon(Icons.star, color: Colors.amber, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'MotorSportEasy',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Never miss a race again',
                      style: TextStyle(color: Colors.white70, fontSize: 16,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),*/
              ),

              // Price Section
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      // controller.formattedPrice,
                      "Free for 14 days then",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          // controller.formattedPrice,
                          "Only £3.19",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          // controller.formattedPrice,
                          "/month",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Cancel anytime',
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Features List
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      icon: Icons.workspace_premium,
                      title: 'The ultimate race calendar',
                      description:
                          'Never miss a race with our comprehensive calendar',
                    ),
                    _buildFeatureItem(
                      icon: Icons.speed,
                      title: 'No adverts ever!',
                      description: 'Enjoy uninterrupted, smooth experience',
                    ),
                    _buildFeatureItem(
                      icon: Icons.security,
                      title: 'Only the notifications you want.',
                      description:
                          'Customize alerts for your favorite races and events',
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.firstProduct != null) {
                      controller.purchaseProduct(controller.firstProduct!);
                    } else {
                      CustomSnackbar.show(
                        'Warning',
                        'Product not available',
                        backgroundColor: AppColor.primaryColor,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: AppColor.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rocket_launch),
                      SizedBox(width: 10),
                      Text(
                        'SUBSCRIBE NOW - ${controller.formattedPrice}/month',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Terms and Conditions
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'By subscribing, you agree to our Terms of Service and Privacy Policy. '
                  'Payment will be charged to your account upon confirmation. '
                  'Subscription automatically renews unless canceled at least 24 hours before the end of the current period.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
