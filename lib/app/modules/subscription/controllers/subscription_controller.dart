import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../routes/app_pages.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../../../utils/custom_snackbar.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = ['premium_plan'];

  var products = <ProductDetails>[].obs;
  var isStoreAvailable = false.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  // Temporary variable to keep track of purchased state
  var isPremium = false.obs;

  @override
  void onInit() {
    super.onInit();
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () {},
      onError: (error) {
        CustomSnackbar.show('IAP Stream Error', '$error');
      },
    );
    initializeIAP();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
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
      } else if (response.productDetails.isEmpty) {
        errorMessage.value = "No products found in store";
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
      CustomSnackbar.show('Purchase Error', 'Failed to initiate purchase: $e');
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        CustomSnackbar.show(
          'Purchase Pending',
          'Your purchase is pending...',
          backgroundColor: Colors.orange,
        );
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Temporary client-side verification
        _verifyPurchaseLocally(purchase);

        // -------------------------
        // Backend verification (uncomment for production)
        // await _verifyPurchaseBackend(purchase);
        // -------------------------
      } else if (purchase.status == PurchaseStatus.error) {
        CustomSnackbar.show(
          'Purchase Failed',
          'An error occurred during purchase',
        );
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Client-side temporary verification
  void _verifyPurchaseLocally(PurchaseDetails purchase) {
    // Warning: This does NOT confirm purchase with App Store / Play Store
    final token = purchase.verificationData.serverVerificationData;

    if (token.isNotEmpty) {
      isPremium.value = true; // temporarily unlock premium
      CustomSnackbar.show('Success', 'Premium features temporarily unlocked!');
      _navigateToPremiumPage();
    } else {
      CustomSnackbar.show(
        'Verification Failed',
        'Could not verify purchase token locally',
      );
    }
  }

  /// Backend verification (for production use)
  /*
  Future<void> _verifyPurchaseBackend(PurchaseDetails purchase) async {
    final token = purchase.verificationData.serverVerificationData;

    try {
      // Replace "123" with the logged-in user's actual ID
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
        isPremium.value = true; // unlock premium after server verification
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
  }
  */

  Future<void> _navigateToPremiumPage() async {
    await SharedPrefHelper.saveSubscriptionState(true);
    Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
  }

  ProductDetails? get firstProduct =>
      products.isNotEmpty ? products.first : null;

  String get formattedPrice {
    if (products.isEmpty) return '£3';
    final p = products.first;
    return '${p.price} ${p.currencyCode}';
  }
}
