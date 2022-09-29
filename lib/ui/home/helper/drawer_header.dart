import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/states/app_state.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/bloc/mydashboard_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/events/mydashboard_event.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/states/mydashboard_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/repository/mydashboard/mydashboard_repositry_builder.dart';

class DrawerHeaderWidget extends StatefulWidget {
  final Function signOutFunc;

  const DrawerHeaderWidget({Key? key, required this.signOutFunc})
      : super(key: key);

  @override
  _DrawerHeaderWidgetState createState() => _DrawerHeaderWidgetState();
}

class _DrawerHeaderWidgetState extends State<DrawerHeaderWidget> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  String userimageUrl = "";
  String username = "";
  String imgUrl =
      "https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg";
  bool isDashboardEnabled = false;

  late MyDashBoardBloc myDashBoardBloc;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    //print('hlllo_thereeeee_drawer');

    myDashBoardBloc = MyDashBoardBloc(
      myDashboardRepository: MyDashboardRepositoryBuilder.repository(),
    );

    // isDashboardEnabled ? getUserAchievementDataEvent() : print("object");
    //
    // isDashboardEnabled = (appBloc.uiSettingModel.EnableGamification != null &&
    //         appBloc.uiSettingModel.EnableGamification.toLowerCase() == "false")
    //     ? false
    //     : true;
  }

  void getUserAchievementDataEvent() {
    myDashBoardBloc.add(GetUserAchievementDataEvent(
      gameID: '3',
      locale: 'en-us',
      componentID: '-1',
      componentInsID: '-1',
      siteID: '374',
      userID: '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    //print("isDashboardEnabled:${isDashboardEnabled}");
    //print("userimageUrl:${userimageUrl}");

    List<String> nameinfo = username.split(" ");
    String shortName = "";
    if (nameinfo.length > 1) {
      for (int i = 0; i < nameinfo.length; i++) {
        shortName += nameinfo[i][0];
      }
    }
    /*print("nameinfo length:${nameinfo.length}");
    print("nameinfo:${nameinfo}");
    print("username:${username}");*/
    if (nameinfo.length == 1) {
      shortName += username.isNotEmpty ? username[0] : "";
    }
    else {}
    appBloc.profilePic = userimageUrl;
    appBloc.userName = shortName;
    MyPrint.printOnConsole("appBloc.profilePic ${userimageUrl}");
    return BlocConsumer<MyDashBoardBloc, MyDashboardState>(
      bloc: myDashBoardBloc,
      listener: (context, state) {
        if (state is ProfileImageState) {
          //print('imageurll_bloc ${appBloc.imageUrl}');
          setState(() {
            userimageUrl = appBloc.imageUrl;
            appBloc.profilePic = userimageUrl;
            appBloc.userName = shortName;
            MyPrint.printOnConsole("appBloc.profilePic in listener ${userimageUrl}");
          });
        }
        if (state.status == Status.COMPLETED) {
          if (state is GetUserAchievementDataState) {
            if (state.userAchievementResponse != null &&
                    state.userAchievementResponse.userLevel != null ||
                state.userAchievementResponse.userBadges != null ||
                state.userAchievementResponse.userPoints != null) {}
          }
        }
      },
      builder: (context, state) => Container(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        width: MediaQuery.of(context).size.width,
        child: isDashboardEnabled
            ? Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: returnDashboardCard(shortName),
              )
            : Padding(
                // padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: userimageUrl.isEmpty
                                      ? imgUrl
                                      : userimageUrl,
                                  width: 50.h,
                                  height: 50.h,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => ClipOval(
                                    child: CircleAvatar(
                                      radius: 25.h,
                                      backgroundColor: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                      child: Text(
                                       shortName,
                                        style: TextStyle(
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w600,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      ClipOval(
                                    child: CircleAvatar(
                                      radius: 25.h,
                                      backgroundColor: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                      child: Text(
                                        shortName,
                                        style: TextStyle(
                                            fontSize: 20.h,
                                            fontWeight: FontWeight.w600,
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(children: [
                                InkWell(
                                  onTap: () {
                                    widget.signOutFunc();
                                  },
                                  child: Icon(Icons.logout,
                                      color: appBloc.uiSettingModel
                                              .appHeaderTextColor.isEmpty
                                          ? Colors.grey
                                          : Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))
                                      //color: GlobalColor.secondaryAppColor,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text("Sign Out",
                                      style: TextStyle(
                                          fontSize: 10.h,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")))),
                                ),
                              ])
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              username,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            height: 3,
                          ),
                        ],
                      ),
                    ]),
              ),
      ),
    );
  }

  Widget returnDashboardCard(String shortName) {
    String overallPoints = "";

    String pointsString = "";

    String badgesString = "";

    var userLevel = "";

    if (myDashBoardBloc.userAchievementResponse.userOverAllData != null) {
      int points =
          myDashBoardBloc.userAchievementResponse.userOverAllData != null
              ? myDashBoardBloc
                  .userAchievementResponse.userOverAllData!.neededPoints
              : 0;

      String pointslevel =
          myDashBoardBloc.userAchievementResponse.userOverAllData != null
              ? myDashBoardBloc
                  .userAchievementResponse.userOverAllData!.neededLevel
              : "Beginner";

      overallPoints = "$points Points to $pointslevel";

      pointsString =
          "${myDashBoardBloc.userAchievementResponse.userOverAllData?.overAllPoints ?? ""}";

      badgesString =
          "${myDashBoardBloc.userAchievementResponse.userOverAllData?.badges ?? ""}";

      userLevel =
          myDashBoardBloc.userAchievementResponse.userOverAllData?.userLevel ?? "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: userimageUrl.isEmpty ? imgUrl : userimageUrl,
                width: 50.h,
                height: 50.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => ClipOval(
                  child: CircleAvatar(
                    radius: 25.h,
                    backgroundColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    child: Text(
                      shortName,
                      style: TextStyle(
                          fontSize: 20.h,
                          fontWeight: FontWeight.w600,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => ClipOval(
                  child: CircleAvatar(
                    radius: 25.h,
                    backgroundColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    child: Text(
                      shortName,
                      style: TextStyle(
                          fontSize: 30.h,
                          fontWeight: FontWeight.w600,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  "Points",
                  style: TextStyle(
                      fontSize: 13.h,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                ),
                Text(
                  pointsString,
                  style: TextStyle(
                      fontSize: 10.h,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "Rewards",
                  style: TextStyle(
                      fontSize: 13.h,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                ),
                Text(
                  badgesString,
                  style: TextStyle(
                      fontSize: 10.h,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Container(
          child: Text(
            username,
            maxLines: 1,
            style: TextStyle(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                fontWeight: FontWeight.bold,
                fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
            value: 0.8,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                userLevel,
                style: TextStyle(
                    fontSize: 10.h,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              ),
              Text(
                overallPoints,
                style: TextStyle(
                    fontSize: 10.h,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 3,
        ),
      ],
    );
  }

  Future<void> getUserDetails() async {
    String name = await sharePrefGetString(sharedPref_LoginUserName);
    String imageurl = await sharePrefGetString(sharedPref_tempProfileImage);
    print("image =- $imageurl");

    setState(() {
      userimageUrl = imageurl;
      username = name;
    });
  }
}
