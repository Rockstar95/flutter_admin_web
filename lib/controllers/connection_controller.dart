import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:provider/provider.dart';

import '../providers/connection_provider.dart';
import 'navigation_controller.dart';

class ConnectionController {
  static ConnectionController? _instance;

  factory ConnectionController() {
    return _instance ?? ConnectionController._();
  }

  ConnectionController._();

  bool checkConnection({bool isShowErrorSnakbar = true, BuildContext? context}) {
    ConnectionProvider connectionProvider = Provider.of<ConnectionProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);

    if(!connectionProvider.isInternet && isShowErrorSnakbar && context != null) {
      MyToast.showToastWithIcon(context: context, text: "You are currently offline", iconData: Icons.wifi_off);
    }

    return connectionProvider.isInternet;
  }
}