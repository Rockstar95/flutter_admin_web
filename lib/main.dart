import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_admin_web/controllers/notification_controller.dart';
import 'package:flutter_admin_web/ui/appModule/app.dart';
import 'package:flutter_admin_web/ui/common/log_util.dart';

import 'framework/helpers/parsing_helper.dart';

// ?site=https://upgradedenterprise.instancy.com/
// ?site=https://learning.instancy.com/
// ?site=https://tfr.franklincoveysa.co.za/
// ?site=https://enterprisedemo.instancy.com/

// ?site=https://upgradedenterprise.instancy.com&authToken=eaaf0fa5-d6b4-4553-91f2-8cc1defb50f8

void main() async {
  MyPrint.printOnConsole("Void Main called");

  await runZoned<Future<void>>(() async {
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();

    String myurl = Uri.base.toString();
    print("My Url:${myurl}");
    print("Query Parameters:${Uri.base.queryParameters}");
    print("Site Type:${Uri.base.queryParameters['site'].runtimeType}");
    print("Site Url:${Uri.base.queryParameters['site']}");

    dynamic site = Uri.base.queryParameters['site'];
    dynamic appAuthURL = Uri.base.queryParameters['appAuthURL'];
    dynamic authToken = Uri.base.queryParameters['authToken'];
    print("Before collectionName:${ApiEndpoints.syncCollection}");

    String collectionName = ParsingHelper.parseStringMethod(Uri.base.queryParameters['collection'],defaultValue: ApiEndpoints.syncCollection);
    ApiEndpoints.syncCollection = collectionName;
    print("After assign collectionName:${ApiEndpoints.syncCollection}");


    print("Before assign documentName:${ApiEndpoints.syncDocument}");

    String documentName = ParsingHelper.parseStringMethod(Uri.base.queryParameters['document'],defaultValue: ApiEndpoints.syncDocument);
    ApiEndpoints.syncDocument = documentName;
    print("After documentName:${ApiEndpoints.syncDocument}");

    if(authToken is String && authToken.isNotEmpty){
      ApiEndpoints.authToken = authToken;
    }

    if(site is String && site.isNotEmpty && (site.startsWith("http://") || site.startsWith("https://"))) {
      ApiEndpoints.mainSiteURL = site;
    }
   if(appAuthURL is String && appAuthURL.isNotEmpty && (appAuthURL.startsWith("http://") || appAuthURL.startsWith("https://"))) {
        ApiEndpoints.appAuthURL = appAuthURL;
      }

    // Set orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));

    LogUtil().printLog(message: 'Showing main');

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAmLZF_hQ_YZPK81xK5duPt-j8eaDIgs-k",
        appId: "1:639139368781:web:2236bbfe2020e38f447104",
        messagingSenderId: "639139368781",
        projectId: "instancy-f241d",
        authDomain: "instancy-f241d.firebaseapp.com",
        databaseURL: "https://instancy-f241d.firebaseio.com",
        storageBucket: "instancy-f241d.appspot.com",
      ),
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await NotificationController().initializeNotification();

    //For Upgraded Enterprise Site
    runApp(App(
      // mainSiteUrl: "https://upgradedenterprise.instancy.com/ appAuthURL",
      mainSiteUrl: site is String && site.isNotEmpty ? site : "https://upgradedenterprise.instancy.com/",
      appAuthURL: appAuthURL is String && appAuthURL.isNotEmpty ? appAuthURL : "https://masterapilive.instancy.com/api/",
      appWebApiUrl: site is String && site.isNotEmpty ? "" : "https://upgradedenterpriseapi.instancy.com/api/",
      splashScreenLogo: "assets/images/playgroundlogo.png",
    ));
  },
  onError: (error, stackTrace) async {
    print(stackTrace);
  });
}

//This is to avoid handshake exception during api call
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
