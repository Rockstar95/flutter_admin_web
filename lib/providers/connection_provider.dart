import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/helpers/sync_helper.dart';

import '../utils/mytoast.dart';

//To Detect Changes in Connection
class ConnectionProvider extends ChangeNotifier {
  bool isInternet = false;
  StreamSubscription<ConnectivityResult>? subscription;
  bool _isFirst = true;
  ConnectivityResult? previousResult;
  bool _isSyncing = false;
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(NavigationController().mainNavigatorKey.currentContext!);

  ConnectionProvider() {
    print("ConnectionProvider constructor called");
    isInternet = kIsWeb ? true : (Platform.isIOS);
    try {
      Connectivity().checkConnectivity().then((ConnectivityResult result) {
        print("Connectivity Result:$result");
        isInternet = result == ConnectivityResult.none ? false : true;

        /* if(NavigationController.mainScreenNavigator.currentContext != null) {
          if(isInternet) {
            if(NavigationController.isNoInternetScreenShown) {
              Navigator.pop(NavigationController.mainScreenNavigator.currentContext!);
            }
          }
          else {
            Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!, NoInternetScreen.routeName);
          }
        }*/
      });

      print("Connection Subscription Started");
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
        print("Connectivity Result:$result");
        print("Previous Result:$previousResult");
        isInternet = result == ConnectivityResult.none ? false : true;

        if (previousResult != result) {
          if(NavigationController().actbaseScaffoldKey.currentContext != null) {
            if(isInternet) {
              MyToast.showToastWithIcon(context: NavigationController().actbaseScaffoldKey.currentContext!, text: "Your Internet Connection has been restored", iconData: Icons.wifi);
            }
            else {
              MyToast.showToastWithIcon(context: NavigationController().actbaseScaffoldKey.currentContext!, text: "You are currently offline", iconData: Icons.wifi_off);
            }
          }

          if(previousResult == ConnectivityResult.none) {
            if(_isSyncing) return;

            _isSyncing = true;
            if (NavigationController().mainNavigatorKey.currentContext != null) {
              SnackBar snackBar = SnackBar(content: Text('Syncing data with server'));
              ScaffoldMessenger.of(NavigationController().mainNavigatorKey.currentContext!).showSnackBar(snackBar);
            }
            await SyncData().syncData();
            refreshContent();
            _isSyncing = false;
          }
        }

        previousResult = result;

        /*if(NavigationController.mainScreenNavigator.currentContext != null) {
          if(isInternet) {
            if(NavigationController.isNoInternetScreenShown) {
              Navigator.pop(NavigationController.mainScreenNavigator.currentContext!);
            }
          }
          else {
            Navigator.pushNamed(NavigationController.mainScreenNavigator.currentContext!, NoInternetScreen.routeName);
          }
        }*/

        if (_isFirst) {
          _isFirst = false;
          await Future.delayed(Duration(milliseconds: 500));
        }
        print("Connection Status Changed:$isInternet");
        notifyListeners();
      });
    } catch (E, s) {
      print("Error in Connectivity Subscription:  $E");
      print(s);
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    subscription = null;
  }

  void refreshContent() {
    refreshMyLearningArchieveContents();
    refreshMyLearningContents();
  }

  void refreshMyLearningContents() {
    myLearningBloc.isFirstLoading = true;
    myLearningBloc.add(
      GetListEvent(
        pageNumber: 1,
        pageSize: 10,
        searchText: myLearningBloc.searchMyCourseString,
        isRefresh: true,
      ),
    );
  }

  void refreshMyLearningArchieveContents() {
    myLearningBloc.isArchiveFirstLoading = true;
    myLearningBloc.add(
      GetArchiveListEvent(
        pageNumber: 1,
        pageSize: 10,
        searchText: myLearningBloc.searchArchiveString,
      ),
    );
  }
}
