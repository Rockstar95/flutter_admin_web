import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/common/device_config.dart';

// class MessagesHeader extends StatelessWidget {
//   final User friend;
//   const MessagesHeader({Key key, @required this.friend}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final deviceData = DeviceData.init(context);
//
//     return Padding(
//       padding: EdgeInsets.only(
//         top: deviceData.screenHeight * 0.06,
//         bottom: deviceData.screenHeight * 0.005,
//         left: deviceData.screenWidth * 0.05,
//         right: deviceData.screenWidth * 0.05,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           BackIcon(),
//           Row(
//             children: [
//               AvatarIcon(
//                 user: friend,
//                 radius: 0.05,
//               ),
//               SizedBox(width: deviceData.screenWidth * 0.035),
//               Text(
//                 Functions.getFirstName('friend.name'),
//               ),
//             ],
//           ),
//           //PopUpMenu(),
//         ],
//       ),
//     );
//   }
// }

class Functions {
  // static void transition(context, Widget screen, [Duration duration]) {
  //   Future.delayed(duration ?? Duration(milliseconds: 300), () async {
  //     await Navigator.pushReplacement(context,
  //         PageTransition(child: screen, type: PageTransitionType.fade));
  //   });
  // }

  static List<String> getAvatarsPaths() {
    return [
      'assets/images/avatars/avatar5.png',
      'assets/images/avatars/avatar3.png',
      'assets/images/avatars/avatar4.png',
      'assets/images/avatars/avatar1.jpg',
      'assets/images/avatars/avatar2.png',
    ];
  }

  static final String femaleAvaterPath = 'assets/images/avatars/avatar3.png';

  static bool modalIsShown = false;

  static void showBottomMessage(BuildContext context, String message,
      {bool isDismissible = true}) async {
    final deviceData = DeviceData.init(context);
    print("message : " + message);

    showModalBottomSheet(
        isDismissible: isDismissible,
        backgroundColor: Colors.black,
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return isDismissible;
            },
            child: Padding(
              padding: EdgeInsets.all(deviceData.screenWidth * 0.05),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: deviceData.screenHeight * 0.018,
                    color: Colors.white),
              ),
            ),
          );
        }).then((value) {
      modalIsShown = false;
    });
    modalIsShown = true;
  }

  static Future<bool> getNetworkStatus({required Duration duration}) async {
    await Future.delayed(duration);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
    on SocketException catch (e, s) {
      print("SocketException in messages_header.getNetworkStatus():${e}");
      print(s);
      return false;
    }
    catch(e, s) {
      print("Error in messages_header.getNetworkStatus():${e}");
      print(s);
      return false;
    }
  }

  // static String convertDate(String timestamp) {
  //   int hour = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
  //       .toDate()
  //       .hour;
  //   int min = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
  //       .toDate()
  //       .minute;
  //   int day =
  //       Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp)).toDate().day;
  //   int month = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
  //       .toDate()
  //       .month;
  //   int year = Timestamp.fromMillisecondsSinceEpoch(int.parse(timestamp))
  //       .toDate()
  //       .year;
  //   int currentDay = Timestamp.now().toDate().day;
  //   int currentMonth = Timestamp.now().toDate().month;
  //   int currentYear = Timestamp.now().toDate().year;
  //   if (day == currentDay && month == currentMonth && year == currentYear) {
  //     String afternoon = "AM";
  //     if (hour >= 12) {
  //       afternoon = "PM";
  //       hour = hour - 12;
  //     }
  //     if (min < 10) {
  //       return hour.toString() + ":" + "0" + min.toString() + " " + afternoon;
  //     }
  //     return hour.toString() + ":" + min.toString() + " " + afternoon;
  //   } else {
  //     return month.toString() + "/" + day.toString();
  //   }
  // }

  static String shortenMessage(String value, int maxLetters) {
    if (value.length > maxLetters) {
      return value.substring(0, maxLetters) + '...';
    }
    return value;
  }

  static String getFirstName(String value) {
    return value.split(" ")[0];
  }

  static String shortenName(String value, int maxLetters) {
    return value.split(" ")[0];
  }
}
