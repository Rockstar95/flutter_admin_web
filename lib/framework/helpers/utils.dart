import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/platform_alert_dialog.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDirectory {
  static Future<String> getDocumentsDirectory() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path ?? "";
  }

  static Future<void> sessionTimeOut(BuildContext context) async {
    final didiReqestSignOut = await PlatformAlertDialog(
      defaultActionText: 'OK',
      title: 'Alert',
      content: "Parallel session detected,this session will logout",
      cancelActionText: '',
    ).show(context);

    if (didiReqestSignOut == true) {
      print("Logout");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('login', 'false');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginCommonPage()),
          (Route<dynamic> route) => false);
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }

  static Future<String> getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);
      //return file with file extension
      return path.basename(file.path);
    } else {
      return "";
    }
  }

  static Future<String> randomVersion() async {
    int min = 100; //min and max values act as your 6 digit range
    int max = 999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);

    return '$rNum';
  }

  static bool isValidString(String str) {
    try {
      bool condition = !(str == "" || str == "null" || str == "undefined" || str == "null\n");
      return condition;
    } catch (e) {
      print('isValidString failed $e');
      return false;
    }
  }
}
