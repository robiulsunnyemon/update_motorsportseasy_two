import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../widgets/custom_elevated_button.dart';
import '../controllers/report_form_controller.dart';

class ReportFormView extends GetView<ReportFormController> {
  const ReportFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Form'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300,
                  child: TextFormField(
                    controller: controller.reportMessageController,
                    decoration: InputDecoration(
                      hintText: "Write your report...",
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
                  level: "Submit report",
                  onTap: () {
                    controller.submitReport();
                    controller.reportMessageController.clear();
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
