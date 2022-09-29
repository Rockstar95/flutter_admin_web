import 'package:flutter/material.dart';
import 'package:flutter_admin_web/backend/data_controller.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/platform_alert_dialog.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';
import 'package:flutter_admin_web/utils/shared_pref_manager.dart';

import '../ui/TrackList/event_track_list.dart';

class NavigationController {
  static NavigationController? _instance;
  factory NavigationController() => _instance ??= NavigationController._();
  NavigationController._();

  GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> actbaseScaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> sessionTimeOut() async {
    final didiReqestSignOut = await PlatformAlertDialog(
      defaultActionText: 'OK',
      title: 'Alert',
      content: "Parallel session detected,this session will logout",
      cancelActionText: '',
    ).show(mainNavigatorKey.currentContext!);

    if (didiReqestSignOut == true) {
      print("Logout");
      SharedPrefManager().setString('login', 'false');
      DataController().clearControllersData();

      Navigator.of(mainNavigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginCommonPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<dynamic> navigateToCommonDetailsScreen({required BuildContext context, required DummyMyCatelogResponseTable2 table2,
    required MyLearningDetailsBloc detailsBloc,ScreenType screenType = ScreenType.MyLearning, bool isFromReschedule = false, bool isShowShedule = false,
    int pos = 0, Map<String, String> filterMenus = const <String, String>{},
  }) async {
    dynamic value = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommonDetailScreen(
        screenType: screenType,
        contentid: table2.contentid,
        objtypeId: table2.objecttypeid,
        detailsBloc: detailsBloc,
        table2: table2,
        isFromReschedule: isFromReschedule,
        isShowShedule: isShowShedule,
        pos: pos,
        mylearninglist: [],
        filterMenus: filterMenus,
      )));

    return value;
  }

  Future<dynamic> navigateToShareWithConnectionsScreen({required BuildContext context, bool isFromForum = false,
    bool isFromQuesion = false, String contentName = "", String contentId = "",}) async {
    dynamic value = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShareWithConnections(isFromForum, isFromQuesion, contentName, contentId)));

    return value;
  }

  Future<dynamic> navigateToShareMainScreen({required BuildContext context,bool isPeople = false, bool isFromForum = false,
    bool isFromQuestion = false, String contentName = "", String contentId = "",}) async {
    dynamic value = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShareMainScreen(
      isPeople,
      isFromForum,
      isFromQuestion,
      contentId,
      contentName,
    )));

    return value;
  }
  Future<dynamic> navigateToEventTrackListScreen({required BuildContext context, required DummyMyCatelogResponseTable2 myLearningModel, required bool isTraxkList,}) async {
    dynamic value = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventTrackList(
      myLearningModel,
      isTraxkList,
      [],
    )));

    return value;
  }
}