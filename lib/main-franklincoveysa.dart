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

import 'main.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // Set orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));

  await runZoned<Future<Null>>(() async {
    LogUtil().printLog(message: 'Showing main');
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize();
    await Firebase.initializeApp();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await NotificationController().initializeNotification();

    //For Franklyn Coveysa Site
    runApp(App(
      mainSiteUrl: "https://tfr.franklincoveysa.co.za/",
      appAuthURL: "https://masterapilive.instancy.com/api/",
      appWebApiUrl: "https://tfrapi.franklincoveysa.co.za/api/",
      splashScreenLogo: "assets/images/playgroundlogo.png",
    ));
  },
      onError: (error, stackTrace) async {
        print(stackTrace);
      });
}