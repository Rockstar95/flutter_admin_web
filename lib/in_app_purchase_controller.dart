import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/src/billing_client_wrappers/billing_client_wrapper.dart';
import 'package:in_app_purchase_android/src/types/change_subscription_param.dart';
import 'package:in_app_purchase_android/src/types/google_play_purchase_details.dart';
import 'package:in_app_purchase_android/src/types/google_play_purchase_param.dart';

class InAppPurchaseController {
  static InAppPurchaseController? _instance;

  factory InAppPurchaseController() {
    return _instance ??= InAppPurchaseController._();
  }
  InAppPurchaseController._();

  bool isStoreAvailable = false;

  Future<bool> checkStoreAvailable() async {
    print("checkStoreAvailable called");
    if(!isStoreAvailable) {
      isStoreAvailable = await InAppPurchase.instance.isAvailable();
    }
    return isStoreAvailable;
  }

  Future<PurchaseDetails?> buyProduct(ProductDetails productDetails, {GooglePlayPurchaseDetails? oldSubscription, bool isConsumable = true}) async {
    print("buyConsumable called with product id:${productDetails.id}, oldSubscription:$oldSubscription");

    bool isStoreAvailable = await checkStoreAvailable();
    if(!isStoreAvailable) return null;

    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: oldSubscription,
                prorationMode: ProrationMode.immediateWithTimeProration,
              )
            : null,
      );
    }
    else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }

    bool isBuyRequestSent;
    //MakeCSure that the product you are buying if it is a subscription, don't call butConsumable for it, it must call buyNonConsumable
    if(isConsumable && !productDetails.id.endsWith(".subscription")) {
      isBuyRequestSent = await InAppPurchase.instance.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    }
    else {
      isBuyRequestSent = await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    }

    print("isBuyRequestSent:$isBuyRequestSent");

    if(isBuyRequestSent) {
      List<PurchaseDetails> purchaseDetails = await InAppPurchase.instance.purchaseStream.first;
      print("purchaseDetails length:${purchaseDetails.length}");

      if(purchaseDetails.isNotEmpty) {
        PurchaseDetails purchaseDetailsModel = purchaseDetails.first;
        print("Purchase Status:${purchaseDetailsModel.status}");
        print("Purchase Error:${purchaseDetailsModel.error?.code} | ${purchaseDetailsModel.error?.message}");

        if([PurchaseStatus.purchased, PurchaseStatus.restored].contains(purchaseDetailsModel.status) && purchaseDetailsModel.pendingCompletePurchase) {
          print("Complete Purchase Started");
          try {
            await InAppPurchase.instance.completePurchase(purchaseDetailsModel);
            purchaseDetailsModel.pendingCompletePurchase = false;
          }
          on InAppPurchaseException catch(e, s) {
            print("InAppPurchaseException when colpleting purchase in InAppPurchaseController().buyConsumable():$e");
            print(s);
          }
          catch(e, s) {
            print("Error when colpleting purchase in InAppPurchaseController().buyConsumable():$e");
            print(s);
          }
          print("Complete Purchase Finished");
        }
        else if(purchaseDetailsModel.status == PurchaseStatus.pending) {
          purchaseDetails = await InAppPurchase.instance.purchaseStream.first;
          print("again purchaseDetails length:${purchaseDetails.length}");

          if(purchaseDetails.isNotEmpty) {
            PurchaseDetails purchaseDetailsModel = purchaseDetails.first;
            print("Again Purchase Status:${purchaseDetailsModel.status}");
            print("Again Purchase Error:${purchaseDetailsModel.error?.code} | ${purchaseDetailsModel.error?.message}");

            if([PurchaseStatus.purchased, PurchaseStatus.restored].contains(purchaseDetailsModel.status) && purchaseDetailsModel.pendingCompletePurchase) {
              print("Complete Purchase Started");
              try {
                await InAppPurchase.instance.completePurchase(purchaseDetailsModel);
                purchaseDetailsModel.pendingCompletePurchase = false;
              }
              on InAppPurchaseException catch(e, s) {
                print("InAppPurchaseException when colpleting purchase in InAppPurchaseController().buyConsumable():$e");
                print(s);
              }
              catch(e, s) {
                print("Error when colpleting purchase in InAppPurchaseController().buyConsumable():$e");
                print(s);
              }
              print("Complete Purchase Finished");
            }
            else if(purchaseDetailsModel.status == PurchaseStatus.pending) {
              return null;
            }

            return purchaseDetailsModel;
          }
          else {
            return null;
          }
        }
        else if(purchaseDetailsModel.status == PurchaseStatus.error) {
          print("handlePurchaseError called:${purchaseDetailsModel.error}");
        }

        return purchaseDetailsModel;
      }
      else {
        return null;
      }
    }
    else {
      return null;
    }
  }

  Future<Map<String, ProductDetails>> getProductDetails(List<String> productIds) async {
    Map<String, ProductDetails> map = {};

    //This Check is
    if(await checkStoreAvailable()) {
      try {
        ProductDetailsResponse productDetailsResponse = await InAppPurchase.instance.queryProductDetails(productIds.toSet());
        productDetailsResponse.productDetails.forEach((element) {
          map[element.id] = element;
        });

        if(productDetailsResponse.notFoundIDs.isNotEmpty) {
          print("Not Found Ids:${productDetailsResponse.notFoundIDs}");
          await Future.delayed(Duration(seconds: 1));
          ProductDetailsResponse productDetailsResponseNew = await InAppPurchase.instance.queryProductDetails(productDetailsResponse.notFoundIDs.toSet());
          productDetailsResponseNew.productDetails.forEach((element) {
            map[element.id] = element;
          });
        }
      }
      catch(e, s) {
        print("Error in Getting Purchase Details in InAppPurchaseController().getProductDetails():$e");
        print(s);
      }
    }

    return map;
  }
}