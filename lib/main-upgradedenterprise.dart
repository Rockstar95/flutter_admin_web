import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_admin_web/controllers/notification_controller.dart';
import 'package:flutter_admin_web/ui/appModule/app.dart';
import 'package:flutter_admin_web/ui/common/log_util.dart';

import 'firebase_options.dart';
import 'main.dart';

void main() async {
  runZoned<Future<Null>>(() async {
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();

    // Set orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));

    LogUtil().printLog(message: 'Showing main');
    WidgetsFlutterBinding.ensureInitialized();
    if(!kIsWeb) {
      await FlutterDownloader.initialize();
    }
    
    if(kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    else {
      await Firebase.initializeApp();
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await NotificationController().initializeNotification();

    runApp(App(
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