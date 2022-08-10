import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MembershipSignUpWebView extends StatefulWidget {
  @override
  _MembershipSignUpWebViewState createState() =>
      _MembershipSignUpWebViewState();
}

class _MembershipSignUpWebViewState extends State<MembershipSignUpWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    super.initState();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    var mciLoginURL = appBloc.uiSettingModel.enableAzureSSOForLearner;
    var urlToLoad = '';
    if (mciLoginURL == "true") {
      urlToLoad = '${ApiEndpoints.mainSiteURL}/nativemobile/Sign in';
    } else {
//            urlToLoad = "\(websiteURL)/nativemobile/Sign Up/nativesignup/true"
      // 19-jun-2019
//           urlToLoad = "http://angular6.instancysoft.com/Sign Up/profiletype/selfregistration"

      urlToLoad =
          "${ApiEndpoints.mainSiteURL}Sign%20Up/profiletype/selfregistration/nativeapp/true";
    }
    return WebView(
      initialUrl: urlToLoad,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      // onProgress: (int progress) {
      //   print("WebView is loading (progress : $progress%)");
      // },
      javascriptChannels: <JavascriptChannel>{
        //_toasterJavascriptChannel(context),
      },
      debuggingEnabled: true,
      onWebResourceError: (WebResourceError error) {
        print('Web Error $error');
      },

      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }
}
//
// class InAppPurchaseModel {
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//
//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _connection.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _purchases = [];
//         // _isAvailable = isAvailable;
//         // _products = [];
//         // _notFoundIds = [];
//         _consumables = [];
//         // _purchasePending = false;
//         // _loading = false;
//       });
//       return;
//     }
//
//     ProductDetailsResponse productDetailResponse =
//         await _connection.queryProductDetails(_consumables.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         // _queryProductError = productDetailResponse.error.message;
//         // _isAvailable = isAvailable;
//         // _products = productDetailResponse.productDetails;
//         _purchases = [];
//         // _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         // _purchasePending = false;
//         // _loading = false;
//       });
//       return;
//     }
//
//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         // _queryProductError = null;
//         // _isAvailable = isAvailable;
//         // _products = productDetailResponse.productDetails;
//         _purchases = [];
//         // _notFoundIds = productDetailResponse.notFoundIDs;
//         _consumables = [];
//         // _purchasePending = false;
//         // _loading = false;
//       });
//       return;
//     }
//
//     final QueryPurchaseDetailsResponse purchaseResponse =
//         await _connection.queryPastPurchases();
//     if (purchaseResponse.error != null) {
//       // handle query past purchase error..
//     }
//     final List<PurchaseDetails> verifiedPurchases = [];
//     for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//       if (await _verifyPurchase(purchase)) {
//         verifiedPurchases.add(purchase);
//       }
//     }
//     List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       // _isAvailable = isAvailable;
//       // _products = productDetailResponse.productDetails;
//       _purchases = verifiedPurchases;
//       // _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = consumables;
//       // _purchasePending = false;
//       // _loading = false;
//     });
//   }
//
//   Future<void> consume(String id) async {
//     await ConsumableStore.consume(id);
//     final List<String> consumables = await ConsumableStore.load();
//     setState(() {
//       _consumables = consumables;
//     });
//   }
//
//   void showPendingUI() {
//     setState(() {
//       // _purchasePending = true;
//     });
//   }
//
//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
//     if (purchaseDetails.productID == _kConsumableId) {
//       await ConsumableStore.save(purchaseDetails.purchaseID);
//       List<String> consumables = await ConsumableStore.load();
//       setState(() {
//         // _purchasePending = false;
//         _consumables = consumables;
//       });
//     } else {
//       setState(() {
//         _purchases.add(purchaseDetails);
//         // _purchasePending = false;
//       });
//     }
//
//     var deviceType = Platform.isAndroid ? "Android" : "IOS";
//
//     catalogBloc.add(
//       SaveInAppPurchaseEvent(
//           siteURl: dummyMyCatelogResponseTable.siteurl,
//           contentID: dummyMyCatelogResponseTable.contentid,
//           orderId: purchaseDetails.purchaseID,
//           purchaseToken: purchaseDetails.billingClientPurchase.purchaseToken,
//           productId: purchaseDetails.productID,
//           purchaseTime: await getCurrentDateTimeInStr(),
//           deviceType: deviceType),
//     );
//   }
//
//   void handleError(IAPError error) {
//     setState(() {
//       // _purchasePending = false;
//     });
//   }
// }
