import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher_string.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("message $message");
  await Firebase.initializeApp();
  print('ActBAase Handling a background message ${message.messageId}');
}

class NotificationController {
  static NotificationController? _instance;

  var notificationsPlugin = FlutterLocalNotificationsPlugin();
  String? contentID;
  String urlToLaunch = '';
  //  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationController() {
    if (_instance == null) {
      _instance = NotificationController._();
    }
    return _instance!;
  }

  NotificationController._();

  Future<void> initializeNotification() async {
    await _requestNotificationPermission();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // notificationsPlugin.initialize(initializationSettings);
    //
    onMessageListener(); //foreground listenerr

    FirebaseMessaging.onBackgroundMessage(
        backgroundMessageHandler); //background listener

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? value) => {
              //if(value != null && value)
              print(
                  "ActBASE Get Initail message callaed after push notification received ${value?.data}"),
              urlToLaunch = value?.data["launchUrl"] ?? "",

              if (urlToLaunch.isNotEmpty) {
                _launchInBrowser(urlToLaunch),
              }
            });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //when messages is clicked or tapped.

      print('ActBASE A new onMessageOpenedApp event was published!');
      urlToLaunch = message.data["launchUrl"];
      contentID = message.data["contentid"] ?? '';

      // if(appNavigatorKey.currentContext != null){
      // AppBloc  appBloc = BlocProvider.of<AppBloc>(appNavigatorKey.currentContext);

      // ActBaseProvider actBaseProvider = Provider.of(appNavigatorKey.currentContext);

      //  if (message.data["contextmenuid"] != null &&
      //     message.data["contentid"] != '') {
      //   appBloc.listNativeModel.asMap().forEach((index, element) {
      //     if (element.contextmenuId == widget.notification) {
      //       print("#### : " +
      //           appBloc.nativeMenuModel.menuid +
      //           " : " +
      //           appBloc.nativeMenuModel.displayname);

      //       _selectedDrawerIndex = index;
      //       actBaseProvider.selectedDrawerIndex = index;
      //       switch (message.data["contextmenuid"].toString()) {
      //         case "2":
      //           appBloc.listNativeModel.forEach((element) {
      //             if (element.contextmenuId == message.data["contextmenuid"]) {
      //               selectedmenu = element.contextmenuId;
      //               appBarTitle = element.displayname;
      //               contentID = message.data["contentid"];
      //               _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
      //                   true, selectedmenu);
      //             }
      //           });
      //           break;
      //         case "1":
      //           appBloc.listNativeModel.forEach((element) {
      //             if (element.contextmenuId == message.data["contextmenuid"]) {
      //               selectedmenu = element.contextmenuId;
      //               appBarTitle = element.displayname;
      //               contentID = message.data["contentid"];
      //               _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
      //                   true, selectedmenu);
      //             }
      //           });

      //           break;
      //         case "3":
      //           appBloc.listNativeModel.forEach((element) {
      //             if (element.contextmenuId == message.data["contextmenuid"]) {
      //               selectedmenu = element.contextmenuId;
      //               appBarTitle = element.displayname;
      //               contentID = message.data["contentid"];
      //               _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
      //                   true, selectedmenu);
      //             }
      //           });
      //           break;
      //         case "4":
      //           appBloc.listNativeModel.forEach((element) {
      //             if (element.contextmenuId == message.data["contextmenuid"]) {
      //               selectedmenu = element.contextmenuId;
      //               appBarTitle = element.displayname;
      //               contentID = message.data["contentid"];
      //               _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
      //                   true, selectedmenu);
      //             }
      //           });
      //           break;
      //         case "5":
      //           appBloc.listNativeModel.forEach((element) {
      //             if (element.contextmenuId == message.data["contextmenuid"]) {
      //               selectedmenu = element.contextmenuId;
      //               appBarTitle = element.displayname;
      //               contentID = message.data["contentid"];
      //               _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex,
      //                   true, selectedmenu);
      //             }
      //           });
      //           break;
      //       }
      //     }
      //   });
      // }
      // }

      if (urlToLaunch.isNotEmpty) {
        _launchInBrowser(urlToLaunch);
      }
    });

    await notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value) => onSelectNotification(value));
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> onSelectNotification(String? payload) async {
    print("On select notification callled with $payload");
    // setState(() {
    //   widget.isFromNotification = false;
    //   appBloc.uiSettingModel.setIsFromPush(true);
    // });
    switch (payload) {
      case "0":
        if (urlToLaunch.length > 0) {
          _launchInBrowser(urlToLaunch);
        }
        break;
      // case "2":
      //   appBloc.listNativeModel.forEach((element) {
      //     if (element.contextmenuId == payload) {
      //       setState(() {
      //         selectedmenu = element.contextmenuId;
      //         appBarTitle = element.displayname;
      //       });
      //     }
      //   });
      //   break;
      // case "1":
      //   appBloc.listNativeModel.forEach((element) {
      //     print('content id $contentID');
      //     if (element.contextmenuId == payload) {
      //       setState(() {
      //         selectedmenu = element.contextmenuId;
      //         appBarTitle = element.displayname;
      //         _setContainer(_selectedDrawerIndex, _currentBottomMenuIndex, true,
      //             selectedmenu);
      //       });
      //     }
      //   });
      //   break;
      // case "3":
      //   appBloc.listNativeModel.forEach((element) {
      //     if (element.contextmenuId == payload) {
      //       setState(() {
      //         selectedmenu = element.contextmenuId;
      //         appBarTitle = element.displayname;
      //       });
      //     }
      //   });
      //   break;
      // case "4":
      //   appBloc.listNativeModel.forEach((element) {
      //     if (element.contextmenuId == payload) {
      //       setState(() {
      //         selectedmenu = element.contextmenuId;
      //         appBarTitle = element.displayname;
      //       });
      //     }
      //   });
      //   break;
      // case "5":
      //   appBloc.listNativeModel.forEach((element) {
      //     if (element.contextmenuId == payload) {
      //       setState(() {
      //         selectedmenu = element.contextmenuId;
      //         appBarTitle = element.displayname;
      //       });
      //     }
      //   });
      //   break;
    }

    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> _launchInBrowser(String url) async {
    bool isLaunch = await canLaunchUrlString(url);
    print("isLaunch for $url $isLaunch");
    if (isLaunch) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      //fcmResponse = fcmResponseFromJson(message.toString());
      //this.data = messetState(() {
      // data = message.data["contextmenuid"];
      contentID = message.data["contentid"] ?? "";
      urlToLaunch = message.data["launchUrl"] ?? "";
      // doGetData(data, contentId);

      if (notification != null && android != null) {
        notificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: message.data['contextmenuid']);
      }

      print('ActBASE Message data: ${message.data}');
    });
  }
}
