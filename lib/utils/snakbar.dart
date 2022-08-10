import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'my_print.dart';

class CustomSnackbar{
  static CustomSnackbar? _instance;

  factory CustomSnackbar() {
    if(_instance == null) {
      _instance = CustomSnackbar._();
    }
    return _instance!;
  }

  CustomSnackbar._();

  void showSuccessSnackbar(BuildContext context, String successMessage){
    try {
      /*showOverlayNotification(
            (context) {
          return SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(MySize.size10!),
                child: CustomSnackBar.success(message: success_message),
              ),
            ),
          );
        },
        duration: Duration(seconds: 3),
        position: NotificationPosition.top,
      );*/
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message:successMessage,
        ),
      );
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Showing Success Snakbar:$e");
      MyPrint.printOnConsole(s);
    }
  }
  void showInfoSnackbar(BuildContext context, String infoMessage){
    try {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:infoMessage,
        ),
      );
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Showing Info Snakbar:$e");
      MyPrint.printOnConsole(s);
    }
  }
  void showErrorSnackbar(BuildContext context, String errorMessage){
    try {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: errorMessage,
        ),
      );
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Showing Error Snakbar:$e");
      MyPrint.printOnConsole(s);
    }
  }
}