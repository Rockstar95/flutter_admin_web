import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardLeaderboardScreen extends StatefulWidget {
  final UserAchievementResponse achievementResponse;
  final LeaderBoardResponse leaderBoardResponse;
  final String levels;
  final String badges;
  final String points;

  const DashboardLeaderboardScreen({
    required this.achievementResponse,
    required this.leaderBoardResponse,
    required this.levels,
    required this.badges,
    required this.points,
  });

  @override
  State<DashboardLeaderboardScreen> createState() => DashboardLeaderboard();
}

class DashboardLeaderboard extends State<DashboardLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  String imgUrl =
      "https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg";
  final kCellThumbHeight = 40;
  LeaderBoardResponse leaderBoardResponse =
      new LeaderBoardResponse(leaderBoardList: []);
  String dropdownValue = '';

  List<UserLevel> userlevelslist = [];

  DateFormat formatter = DateFormat('MM/dd/yyyy');

  final DateFormat format = DateFormat('d MMM , yyyy');

  String dropDowngameID = '1';

  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    Color colorcode = Colors.white;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: EdgeInsets.all(4),
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  widget.leaderBoardResponse.leaderBoardList == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Card(
                            color: Colors.white,
                            elevation: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Center(
                                        child: Text(
                                          'Colleague',
                                          style: TextStyle(
                                            color: Color(int.parse(
                                                "0xFF808080")),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          'Points',
                                          style: TextStyle(
                                            color: Color(int.parse(
                                                "0xFF808080")),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          'Badges',
                                          style: TextStyle(
                                            color: Color(int.parse(
                                                "0xFF808080")),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: widget.leaderBoardResponse
                                      .leaderBoardList.length,
                                  itemBuilder: (context, i) {
                                    LeaderBoardList leaderobj = widget
                                        .leaderBoardResponse.leaderBoardList[i];
                                    return Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16.0,right: 16.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Container(//color: Colors.pink,
                                                        child: Stack(clipBehavior: Clip.none,
                                                          children: [
                                                            ClipOval(
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: MyUtils.getSecureUrl(leaderobj.userPicturePath.isNotEmpty ? leaderobj.userPicturePath : imgUrl),
                                                                width: 52,
                                                                height: 52,
                                                                fit: BoxFit.cover,
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        ClipOval(
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 45,
                                                                    foregroundColor:
                                                                        Colors.red,
                                                                    child: Text(
                                                                      leaderobj.userDisplayName ==
                                                                              null
                                                                          ? ''
                                                                          : leaderobj
                                                                              .userDisplayName[0],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color: Color(
                                                                              int.parse(
                                                                                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                                                    ),
                                                                    backgroundColor:
                                                                        Color(int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                                                                  ),
                                                                ),
                                                                errorWidget:
                                                                    (context, url,
                                                                            error) =>
                                                                        ClipOval(
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 45,
                                                                    child: Text(
                                                                      leaderobj.userDisplayName ==
                                                                              null
                                                                          ? ''
                                                                          : leaderobj
                                                                              .userDisplayName[0],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              30,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color: Color(
                                                                              int.parse(
                                                                                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
                                                                    ),
                                                                    backgroundColor:
                                                                        Color(int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(top: -3,right: 35,
                                                              child: ClipOval(
                                                                child: CircleAvatar(
                                                                    radius: 10,
                                                                    child: Text(
                                                                      leaderobj.rank ==
                                                                              null
                                                                          ? ''
                                                                          : '${leaderobj.rank}',
                                                                      style: TextStyle(
                                                                          fontSize: 10,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w400,
                                                                          color: Colors
                                                                              .black),
                                                                    ),
                                                                    backgroundColor:
                                                                        Color(0xFFCACACA)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Column(mainAxisAlignment:MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Align(
                                                            child: Container(//color: Colors.blue,
                                                              child: Text(
                                                                '${leaderobj.userDisplayName.toString().trim()}',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Align(
                                                            child: Container(//color: Colors.pink,
                                                              child: Text(
                                                                '${leaderobj.levelName.toString().trim()}',
                                                                style: TextStyle(
                                                                  color: Color(
                                                                      int.parse(
                                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      '${leaderobj.points}',
                                                      style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      '${leaderobj.badges}',
                                                      style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 7,
                  ),
                  widget.achievementResponse.userBadges == null
                      ? Container()
                      : Container(
                          color: Colors.white,
                          child: Card(
                            color: Colors.white,
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.only(top:16,left: 10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Badges',
                                      style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            'Badge',
                                            style: TextStyle(
                                              color: Color(int.parse(
                                                  "0xFF808080")),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Center(
                                          child: Text(
                                            'Description',
                                            style: TextStyle(
                                              color: Color(int.parse(
                                                  "0xFF808080")),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            'Awarded On',
                                            style: TextStyle(
                                              color: Color(int.parse(
                                                  "0xFF808080")),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .achievementResponse.userBadges.length,
                                    itemBuilder: (context, i) {
                                      Color colorcode = Colors.white;
                                      UserBadges userbadges = widget
                                          .achievementResponse.userBadges[i];
                                      String displaydate = format.format(
                                          DateFormat('MM/dd/yyyy').parse(
                                              userbadges.badgeReceivedDate));
                                      return Container(
                                        padding: EdgeInsets.all(4),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                  width: 52.0,height: 52.0,
                                                  //color: Colors.pink,
                                                    // height: ScreenUtil()
                                                    //     .setHeight(
                                                    //         kCellThumbHeight),
                                                    child: CachedNetworkImage(
                                                      imageUrl: MyUtils.getSecureUrl(userbadges
                                                              .badgeImage
                                                              .startsWith(
                                                                  'http')
                                                          ? userbadges
                                                              .badgeImage
                                                          : ApiEndpoints
                                                                  .strBaseUrl +
                                                              userbadges
                                                                  .badgeImage),
                                                      // width:
                                                      //     MediaQuery.of(context)
                                                      //         .size
                                                      //         .width,
                                                      //placeholder: (context, url) => CircularProgressIndicator(),
                                                      placeholder:
                                                          (context, url) =>
                                                          ClipOval(
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 25,
                                                                    foregroundColor:
                                                                        Colors.red,
                                                                    child:  Image.asset(
                                                        'assets/cellimage.jpg',
                                                        // width: MediaQuery.of(
                                                        //         context)
                                                        //     .size
                                                        //     .width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                                    backgroundColor:
                                                                        Color(int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                                                                  ),
                                                                ),
                                                                errorWidget:
                                                                    (context, url,
                                                                            error) =>
                                                                        ClipOval(
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 45,
                                                                    child:    Image.asset(
                                                        'assets/cellimage.jpg',
                                                        // width: MediaQuery.of(
                                                        //         context)
                                                        //     .size
                                                        //     .width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                                    backgroundColor:
                                                                        Color(int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                                                                  )),
                                                      //         Image.asset(
                                                      //   'assets/cellimage.jpg',
                                                      //   // width: MediaQuery.of(
                                                      //   //         context)
                                                      //   //     .size
                                                      //   //     .width,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                      // errorWidget: (context,
                                                      //         url, error) =>
                                                      //     Image.asset(
                                                      //   'assets/cellimage.jpg',
                                                      //   // width: MediaQuery.of(
                                                      //   //         context)
                                                      //   //     .size
                                                      //   //     .width,
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                     // fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        userbadges.badgeName,
                                                        style: TextStyle(
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          Text(
                                                            '${userbadges.badgeDescription}',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Align(
                                                    child: Text(
                                                      '$displaydate',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 7,
                  ),
                  widget.achievementResponse.userLevel == null
                      ? Container()
                      : Container(
                          color: Colors.white,
                          child: Card(
                            color: Colors.white,
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'U POINT LEVELS',
                                      style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .achievementResponse.userLevel.length,
                                    itemBuilder: (context, i) {
                                      Color colorcode = Colors.white;
                                      UserLevel userlevel = widget
                                          .achievementResponse.userLevel[i];
                                      int useroverallpoints = widget
                                              .achievementResponse
                                              .userOverAllData
                                              ?.neededPoints ??
                                          0;
                                      List<UserLevel> levels =
                                          widget.achievementResponse.userLevel;

                                      return Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    child: Text(
                                                      '${userlevel.levelPoints.toString().trim()}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topRight,
                                                  ),
                                                ),SizedBox(width: 10,),
                                                Expanded(
                                                  flex: 6,
                                                  child: Align(
                                                    child: Column(
                                                      children: [
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black87,
                                                        ),
                                                        Container(
                                                          height: 45,
                                                          color: Colors.yellow,
                                                        ),
                                                        Divider(
                                                          height: 0,
                                                          color: Colors.black87,
                                                        ),
                                                      ],
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                ),SizedBox(width: 10,),
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    child: Text(
                                                      '${userlevel.levelName}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 7,
                  ),
                  widget.achievementResponse.userPoints == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Card(
                            elevation: 25,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'POINTS EARNED',
                                      style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            'Points',
                                            style: TextStyle(
                                              color: Color(0xFF808080),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Align(
                                          child: Text(
                                            'Activity',
                                            style: TextStyle(
                                              color: Color(0xFF808080),
                                              fontSize: 11,
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            'Date',
                                            style: TextStyle(
                                              color: Color(0xFF808080),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: widget
                                        .achievementResponse.userPoints.length,
                                    itemBuilder: (context, i) {
                                      UserPoints leaderobj = widget
                                          .achievementResponse.userPoints[i];
                                      String displaydate = format.format(
                                          DateFormat('MM/dd/yyyy').parse(
                                              leaderobj.userReceivedDate));
                                      return Container(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      '${leaderobj.points.toString().trim()}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Align(
                                                    child: Text(
                                                      '${leaderobj.actionName}',
                                                      style: TextStyle(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                        fontSize: 16,fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Center(
                                                    child: Text(
                                                      '$displaydate',
                                                      style: TextStyle(
                                                        color: Color(0xFF808080),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
