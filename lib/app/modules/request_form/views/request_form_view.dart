import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../widgets/custom_elevated_button.dart';
import '../controllers/request_form_controller.dart';

class RequestFormView extends GetView<RequestFormController> {
  const RequestFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Form'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300,
                  child: TextFormField(
                    controller: controller.requestRaceNameController,
                    decoration: InputDecoration(
                      hintText: "Write your request...",
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.40),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF3F4F6),
                    ),
                    maxLines: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevatedButton(
                  level: "Send a Request",
                  onTap: () {
                    controller.submitRaceRequest();
                    controller.requestRaceNameController.clear();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
