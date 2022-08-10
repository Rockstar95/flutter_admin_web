import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_admin_web/controllers/notification_controller.dart';
import 'package:flutter_admin_web/ui/appModule/app.dart';
import 'package:flutter_admin_web/ui/common/log_util.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // Set orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));

  await runZoned<Future<void>>(() async {
    LogUtil().printLog(message: 'Showing main');
    WidgetsFlutterBinding.ensureInitialized();
    //await FlutterDownloader.initialize();
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
    runApp(const App(
      // mainSiteUrl: "https://upgradedenterprise.instancy.com/",
      mainSiteUrl: "https://upgradedenterprise.instancy.com/",
      appAuthURL: "https://masterapilive.instancy.com/api/",
      appWebApiUrl: "https://upgradedenterpriseapi.instancy.com/api/",
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
