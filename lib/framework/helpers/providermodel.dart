import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class ProviderModel with ChangeNotifier {
  InAppPurchase _iap = InAppPurchase.instance;
  bool available = true;
  StreamSubscription? subscription;

  final String myiOSProductID = 'com.instancy.flutterinapptesting';

  final String myAndroidProductID = 'com.instancy.flutterinapptesting';

  bool _isPurchased = false;

  bool get isPurchased => _isPurchased;

  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }

  List _purchases = [];

  List get purchases => _purchases;

  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }

  List _products = [];

  List get products => _products;

  set products(List value) {
    _products = value;
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();

    if (available) {
      await _getProducts();
      await _getPastPurchases();
      verifyPurchase();
      verifyPurchase1();
      subscription = _iap.purchaseStream.listen(
        (data) {
          purchases.addAll(data);
          verifyPurchase();
          verifyPurchase1();
        },
        // onDone: () {},
        // onError: (error) {
        //   print(error);},
      );
    }
  }

  void verifyPurchase() {
    PurchaseDetails? purchase = hasPurchased(myiOSProductID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        isPurchased = true;
      }
    }
  }

  void verifyPurchase1() {
    PurchaseDetails? purchase = hasPurchased(myAndroidProductID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        isPurchased = true;
      }
    }
  }

  PurchaseDetails? hasPurchased(String productID) {
    return purchases.firstWhere((purchase) => purchase.productID == productID, orElse: () => null);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([
      myiOSProductID,
      myAndroidProductID,
      'com.instancy.goldyearplan',
      'com.instancy.silveronemonth',
      'com.instancy.noncancelsilver',
      'com.instancy.pdf1doller',
      'com.instancy.pdf5doller'
    ]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }

  Future<void> _getPastPurchases() async {
    await _iap.restorePurchases();

    List<PurchaseDetails> purchaseDetailsList = await _iap.purchaseStream.first;

    for (PurchaseDetails purchase in purchaseDetailsList) {
      if (Platform.isIOS) {
        _iap.completePurchase(purchase);
      }
      else if (Platform.isAndroid) {
        _iap.completePurchase(purchase);
      }
    }
    purchases = purchaseDetailsList;
  }
}
