
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../routes/app_pages.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = ['premium_plan'];

  var products = <ProductDetails>[].obs;
  var isStoreAvailable = false.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();
    initializeIAP();
    _iap.purchaseStream.listen(_handlePurchaseUpdates);
  }

  Future<void> initializeIAP() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      isStoreAvailable.value = await _iap.isAvailable();
      if (!isStoreAvailable.value) {
        errorMessage.value = 'Store unavailable';
        return;
      }

      final response = await _iap.queryProductDetails(_productIds.toSet());
      if (response.error != null) {
        errorMessage.value = "Error loading products: ${response.error}";
      } else {
        products.value = response.productDetails;
      }
    } catch (e) {
      errorMessage.value = "Failed to initialize store: $e";
    } finally {
      isLoading.value = false;
    }
  }


  void purchaseProduct(ProductDetails product) {
    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      Get.snackbar(
        'Purchase Error',
        'Failed to initiate purchase: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }






  void _navigateToPremiumPage() {
    Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
  }


  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        final token = purchase.verificationData.serverVerificationData;

        try {
          // Send token to backend
          final response = await http.post(
            Uri.parse("https://your-backend.com/verify-subscription"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "user_id": "123",
              "purchase_token": token,
              "product_id": purchase.productID,
            }),
          );

          if (response.statusCode == 200) {
            Get.snackbar(
              'Success',
              'Premium subscription activated!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            _navigateToPremiumPage();
          } else {
            throw Exception('Backend verification failed');
          }
        } catch (e) {
          Get.snackbar(
            'Verification Error',
            'Failed to verify purchase: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (purchase.status == PurchaseStatus.error) {
        Get.snackbar(
          'Purchase Failed',
          'An error occurred during purchase',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  ProductDetails? get firstProduct => products.isNotEmpty ? products.first : null;
  String get formattedPrice => products.isNotEmpty ? products.first.price : '£3';
}