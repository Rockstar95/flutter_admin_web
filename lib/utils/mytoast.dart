import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import 'my_print.dart';

class MyToast {
  static void showToast(BuildContext context, String text) {
    try {
      FToast fToast = FToast();
      fToast.init(context);
      fToast.showToast(
        child: CommonToast(displaymsg: text),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in showToast:$e");
      MyPrint.printOnConsole(s);
    }
  }

  static void showToastWithIcon({required BuildContext context, required String text, required IconData iconData}) {
    try {
      FToast fToast = FToast();
      fToast.init(context);
      fToast.showToast(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black,
          ),
          child: Row(
            children: [
              Icon(iconData, color: Colors.white, size: 24.h,),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.h,
                  ),
                ),
              ),
            ],
          ),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in showToastWithIcon:$e");
      MyPrint.printOnConsole(s);
    }
  }
}