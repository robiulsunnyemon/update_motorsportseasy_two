import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_color.dart';
import '../../../routes/app_pages.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Section
            _buildProfileHeader(),
            SizedBox(height: 24),

            SizedBox(height: 8,),
            _buildListTile(
              title: 'Setting & Privacy',
              icon: Icons.settings,
              onTap: () {
                Get.toNamed(Routes.PRIVACY);
              },
            ),


            Obx((){
              return _buildListTile(
                title: controller.isActiveNotification.value?'Stop Send Notification':"Start Send Notification",
                icon: controller.isActiveNotification.value?Icons.notifications_off:Icons.notifications,
                onTap: () async {
                  final isTermsAccepted =await SharedPrefHelper.getIsTermsAccepted();
                  if(isTermsAccepted==true){
                    controller.disableNotifications();
                  }else{
                    controller.notificationActive();
                  }
                },
              );
            }),

            _buildListTile(
              title: 'Cancel Subscription',
              icon: Icons.cancel,
              onTap: () {
                _showCancelSubscriptionDialog(context);
              },
            ),

            _buildListTile(
              title: 'Request a Race',
              icon: Icons.flag,
              onTap: () {
                Get.toNamed(Routes.REQUEST_FORM);
              },
            ),
            _buildListTile(
              title: 'Submission Report',
              icon: Icons.assignment,
              onTap: () {
                Get.toNamed(Routes.REPORT_FORM);
              },
            ),

            _buildListTile(
              title: 'Delete my account',
              icon: Icons.delete,
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),


            _buildListTile(
              title: 'Logout',
              icon: Icons.logout,
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),


          ],
        ),
      ),
    );
  }



  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColor.primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }





  Widget _buildProfileHeader() {
    return Obx(
          () => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Avatar
            GestureDetector(
              onTap: () {

                controller.pickAndSaveProfileImage();
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primaryColor,
                    width: 3,
                  ),
                ),
                child: controller.profileImagePath.value != null
                    ? CircleAvatar(

                  backgroundImage: FileImage(File(controller.profileImagePath.value!)),
                  backgroundColor: Colors.white,
                )
                    : const CircleAvatar(

                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_box_outlined, size: 40),
                ),
              ),
            ),
            SizedBox(width: 16),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    controller.userEmail.value,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F5E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Premium Member',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.signOut();
                Get.back();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }


  void _showCancelSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Cancel Subscription'),
          content: const Text('Are you sure you want to cancel your subscription?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Keep Subscription'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                SharedPrefHelper.saveSubscriptionState(false);
                Get.offAllNamed(Routes.LOGIN);
              },
              child: const Text(
                'Cancel Subscription',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account permanently?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.deleteAccount(); // ← Delete function call
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

}