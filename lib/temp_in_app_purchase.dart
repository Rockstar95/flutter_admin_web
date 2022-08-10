import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:flutter_admin_web/consumable_store.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';

class TempInAppPurchasePage extends StatefulWidget {
  @override
  _TempInAppPurchasePageState createState() => _TempInAppPurchasePageState();
}

class _TempInAppPurchasePageState extends State<TempInAppPurchasePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  bool _kAutoConsume = true;

  String _kConsumableId = 'consumable';
  String _kUpgradeId = 'upgrade';
  String _kSilverSubscriptionId = 'com.instancy.silveronemonth';
  String _kGoldSubscriptionId = 'com.instancy.goldyearplan';
  /*'com.instancy.pdf1doller',
    'com.instancy.pdf5doller',
    "my_first_test_product",
    "com.instancy.silveronemonth",
    "com.instancy.goldyearplan",*/
  List<String> _kProductIds = <String>[
    'com.instancy.pdf1doller',
    'com.instancy.pdf5doller',
    "product_1",
    "product_2",
    "com.instancy.product3",
    "sub_1",
    "sub2",
    "com.instancy.testsub1",
    "com.instancy.silveronemonth",
    "com.instancy.goldyearplan",
    "com.instancy.lm_flutter_ecommerce",
    "com.instancy.test_flutter_ecommerce",
    "com.instancy.platinumplan1_1year"
  ];
  List<String> consumableProductIds = [
    "product_1",
    "product_2",
    "sub_1"
  ];

  @override
  void initState() {
    /*final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (Object error) {
      // handle error here.
    });*/
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    print("Is Available:$isAvailable");

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    print("Product Details Response Error:${productDetailResponse.error?.code}");
    print("Product Details Response Not Found Ids:${productDetailResponse.notFoundIDs}");
    print("Product Details Response Products Length:${productDetailResponse.productDetails.length}");
    productDetailResponse.productDetails.forEach((element) {
      print("Product Id:${element.id}, Name:${element.title}, Price:${element.price}");
    });

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    }
    else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<void> confirmPriceChange(BuildContext context, PurchaseDetails purchaseDetails) async {
    if (Platform.isAndroid) {
      if(purchaseDetails.productID.isEmpty) {
        print("Purchase Id is Null Or Empty:${purchaseDetails.productID}");
        return;
      }

      final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult = await androidAddition.launchPriceChangeConfirmationFlow(
        sku: purchaseDetails.productID,
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Price change accepted'),
        ));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ?? 'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
          ),
        ));
      }
    }
    else if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == _kSilverSubscriptionId && purchases[_kGoldSubscriptionId] != null) {
      oldSubscription = purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    else if (productDetails.id == _kGoldSubscriptionId && purchases[_kSilverSubscriptionId] != null) {
      oldSubscription = purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_purchases list:$_purchases");

    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: <Widget>[
            _buildConnectionCheckTile(),
            _buildProductList(),
            _buildConsumableBox(),
            _buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IAP Example'),
        ),
        body: Stack(
          children: stack,
        ),
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable ? Colors.green : ThemeData.light().errorColor),
      title: Text(
          'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll(<Widget>[
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...')));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    final List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases = Map<String, PurchaseDetails>.fromEntries(
      _purchases.map((PurchaseDetails purchase) {
        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      })
    );
    productList.addAll(_products.map((ProductDetails productDetails) {
        final PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productDetails.description,
                ),
                if(previousPurchase != null) Text("Purchased:${previousPurchase.purchaseID}"),
              ],
            ),
            trailing: /*previousPurchase != null
                ? IconButton(
                onPressed: () => confirmPriceChange(context, previousPurchase),
                icon: const Icon(Icons.upgrade))
                : */TextButton(
              child: Text(productDetails.price),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[800],
                primary: Colors.white,
              ),
              onPressed: () async {
                showPendingUI();

                GooglePlayPurchaseDetails? oldSubscription;

                if(Platform.isAndroid) {
                  oldSubscription = _getOldSubscription(productDetails, purchases);
                }
                PurchaseDetails? purchaseDetails = await InAppPurchaseController().buyProduct(
                  productDetails,
                  oldSubscription: oldSubscription,
                  isConsumable: consumableProductIds.contains(productDetails.id),
                );
                print("Product Details in Page:$productDetails");

                if(purchaseDetails != null) {
                  if([PurchaseStatus.purchased, PurchaseStatus.restored].contains(purchaseDetails.status)) {
                    print("Purchase Completed:${purchaseDetails.purchaseID}");
                    MyToast.showToast(context, "Purchase Success");
                    deliverProduct(purchaseDetails);
                  }
                  else if(purchaseDetails.status == PurchaseStatus.error) {
                    print("Purchase Failed");

                    MyToast.showToast(context, "Purchase Failed");
                  }
                  else if(purchaseDetails.status == PurchaseStatus.canceled) {
                    print("Purchase Canceled");

                    MyToast.showToast(context, "Purchase Canceled");
                  }
                  else if(purchaseDetails.status == PurchaseStatus.pending) {
                    print("Purchase Pending");

                    MyToast.showToast(context, "Purchase Pending");
                  }
                }

                setState(() {
                  _purchasePending = false;
                });

                /*late PurchaseParam purchaseParam;

                if (Platform.isAndroid) {
                  // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                  // verify the latest status of you your subscription by using server side receipt validation
                  // and update the UI accordingly. The subscription purchase status shown
                  // inside the app may not be accurate.
                  final GooglePlayPurchaseDetails? oldSubscription = _getOldSubscription(productDetails, purchases);

                  purchaseParam = GooglePlayPurchaseParam(
                      productDetails: productDetails,
                      applicationUserName: null,
                      changeSubscriptionParam: (oldSubscription != null)
                          ? ChangeSubscriptionParam(
                        oldPurchaseDetails: oldSubscription,
                        prorationMode: ProrationMode
                            .immediateWithTimeProration,
                      )
                          : null);
                }
                else {
                  purchaseParam = PurchaseParam(
                    productDetails: productDetails,
                    applicationUserName: null,
                  );
                }

                _inAppPurchase.buyConsumable(
                  purchaseParam: purchaseParam,
                  autoConsume: true,
                );*/
                /*if (productDetails.id == _kConsumableId) {
                  _inAppPurchase.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume: true,
                  );
                }
                else {
                  _inAppPurchase.buyNonConsumable(
                      purchaseParam: purchaseParam);
                }*/
              },
            ));
      },
    ));

    return Card(
      child: Column(
        children: <Widget>[
          productHeader,
          const Divider(),
        ] + productList,
      ),
    );
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...')));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return const Card();
    }
    const ListTile consumableHeader =
    ListTile(title: Text('Purchased consumables'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: const Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
          consumableHeader,
          const Divider(),
          GridView.count(
            crossAxisCount: 5,
            children: tokens,
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
          )
        ]));
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: const Text('Restore purchases'),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              primary: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
          ),
        ],
      ),
    );
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
