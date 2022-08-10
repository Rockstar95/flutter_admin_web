import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/bloc/mydashboard_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/events/mydashboard_event.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_creditcertificateresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_gameslistresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/states/mydashboard_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/mydashboard/mydashboard_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';

// https://karthikponnam.medium.com/flutter-loadmore-in-listview-23820612907d

class MyDashBoardScreen extends StatefulWidget {
  final NativeMenuModel nativeMenuModel;

  MyDashBoardScreen({required this.nativeMenuModel});

  @override
  _MyDashBoardScreenState createState() => _MyDashBoardScreenState();
}

class _MyDashBoardScreenState extends State<MyDashBoardScreen> with TickerProviderStateMixin {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late TabController _tabController;
  List<Tab> tabList = [];

  String selectedTitle = "";

  String dropdownValue = '';

  String dropDowngameID = '1';

  MydashboardGameModel? mydashboardGamesmodel;

  late MyDashBoardBloc myDashBoardBloc;

  final ScrollController _scrollController = ScrollController();

  List<Widget> _tabBarWidgets = [];

  late MyLearningDetailsBloc detailsBloc;

  // bool fabButton = false;

  bool isGotAchievement = true, isGotLeaderBoard = true;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: (tabList.length), vsync: this);

    myDashBoardBloc = MyDashBoardBloc(myDashboardRepository: MyDashboardRepositoryBuilder.repository());
    getGameslisting();

    detailsBloc = MyLearningDetailsBloc(myLearningRepository: MyLearningRepositoryBuilder.repository());
  }

  TabController getTabController() {
    _tabController = TabController(length: tabList.length, vsync: this);

    _tabController.addListener(() {
      print("Selected Index: " + _tabController.index.toString());

      switch (_tabController.index) {
        case 0: // LeaderBoard
          if (myDashBoardBloc.leaderBoardResponse.leaderBoardList != null &&
              myDashBoardBloc.leaderBoardResponse.leaderBoardList.length > 6) {
            myDashBoardBloc.fabButtonVisible = true;
          } else {
            myDashBoardBloc.fabButtonVisible = false;
          }
          break;
        case 1: // Points
          if (myDashBoardBloc.userAchievementResponse.userPoints != null &&
              myDashBoardBloc.userAchievementResponse.userPoints.length > 5) {
            myDashBoardBloc.fabButtonVisible = true;
          } else {
            myDashBoardBloc.fabButtonVisible = false;
          }
          break;
        case 2: // Badges
          if (myDashBoardBloc.userAchievementResponse.userBadges != null &&
              myDashBoardBloc.userAchievementResponse.userBadges.length > 5) {
            myDashBoardBloc.fabButtonVisible = true;
          } else {
            myDashBoardBloc.fabButtonVisible = false;
          }
          break;
        case 3: // Levels
          if (myDashBoardBloc.userAchievementResponse.userLevel != null &&
              myDashBoardBloc.userAchievementResponse.userLevel.length > 5) {
            myDashBoardBloc.fabButtonVisible = true;
          } else {
            myDashBoardBloc.fabButtonVisible = false;
          }

          break;
      }
    });
    return _tabController;
  }

  List<Tab> getTabs() {
    tabList.clear();
    tabList.add(new Tab(
      text: 'Leaders',
    ));

    if (myDashBoardBloc.userAchievementResponse != null) {
      if (myDashBoardBloc.userAchievementResponse.showPointSection != null &&
          myDashBoardBloc.userAchievementResponse.showPointSection) {
        tabList.add(new Tab(
          text: 'Points',
        ));
      }

      if (myDashBoardBloc.userAchievementResponse.showBadgeSection != null &&
          myDashBoardBloc.userAchievementResponse.showBadgeSection) {
        tabList.add(new Tab(
          text: 'Badges',
        ));
      }

      if (myDashBoardBloc.userAchievementResponse.showLevelSection != null &&
          myDashBoardBloc.userAchievementResponse.showLevelSection) {
        tabList.add(new Tab(
          text: 'Levels',
        ));
      }
    }

    return tabList;
  }

  List<Widget> getWidgets() {
    _tabBarWidgets.clear();

    for (int i = 0; i < tabList.length; i++) {
      switch (tabList[i].text) {
        case "Leaders":
          _tabBarWidgets.add(returnLeaderBoard());
          break;
        case "Points":
          _tabBarWidgets.add(returnPoints());
          break;
        case "Badges":
          _tabBarWidgets.add(returnBadges());
          break;
        case "Levels":
          _tabBarWidgets.add(returnLevels());
          break;
      }
    }

    // setState(() {
    //   _tabController = getTabController();
    // });
    return _tabBarWidgets;
  }

  @override
  Widget build(BuildContext context) {
    /*print("dropDowngameID:${dropDowngameID}");
    print("tabList:${tabList.length}");
    print("_tabBarWidgets:${_tabBarWidgets.length}");
    print("myDashBoardBloc.leaderBoardResponse.leaderBoardList.length:${myDashBoardBloc.leaderBoardResponse.leaderBoardList.length}");*/

    return Container(
      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
          // floatingActionButton: myDashBoardBloc.fabButtonVisible
          //     ? FloatingActionButton(
          //         child: Icon(Icons.arrow_circle_up),
          //         onPressed: () {
          //           _scrollController.animateTo(
          //               _scrollController.position.minScrollExtent,
          //               duration: Duration(milliseconds: 500),
          //               curve: Curves.fastOutSlowIn);
          //         },
          //       )
          //     : null,
          body: Container(
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
            child: BlocConsumer<MyDashBoardBloc, MyDashboardState>(
              bloc: myDashBoardBloc,
              listener: (context, state) {
                print("MyDashBoardBloc Listenet Called with State:${state.runtimeType} and Status:${state.status}");

                if (state.status == Status.COMPLETED) {
                  if (state is GetGameslistState) {
                    dropdownValue = myDashBoardBloc.gameslist.length > 0
                        ? myDashBoardBloc.gameslist[0].gameName
                        : "Select game";
                    dropDowngameID = myDashBoardBloc.gameslist.length > 0
                        ? "${myDashBoardBloc.gameslist[0].gameID}"
                        : "1";
                    // myDashBoardBloc.gameslist.length > 0
                    //     ? getLeaderboardData()
                    //     : print(state.status);
                    if (dropDowngameID == "-1") {
                      getMyCreditCertificateEvent();
                    }
                    else {
                      isGotAchievement = false;
                      isGotLeaderBoard = false;
                      getLeaderboardData();
                      getUserAchievementDataEvent();
                    }
                  }
                  else if (state is GetMyCreditCertificateaState) {
                    print(state.myCreditCertificateresponse);
                  }
                  else if(state is GetUserAchievementDataState) {
                    isGotAchievement = true;
                  }
                  else if(state is GetLeaderboardDataState) {
                    isGotLeaderBoard = true;
                  }
                }
              },
              builder: (context, state) {
                if (state.status == Status.LOADING || !isGotAchievement || !isGotLeaderBoard) {
                  return Center(
                    child: AbsorbPointer(
                      child: SpinKitCircle(
                        color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ),
                        size: 70.0,
                      ),
                    ),
                  );
                }

                if (isGotAchievement && isGotLeaderBoard) {
                  getTabs();

                  getWidgets();

                  _tabController = getTabController();

                  print("floatbutton icon${myDashBoardBloc.fabButtonVisible}");
                }

                return Column(children: [
                  dropDownMenu(),
                  dropDowngameID != "-1" ? overAllCard() : Container(),
                  dropDowngameID != "-1"
                      ? Expanded(
                          child: (tabList.length > 0)
                              ? Container(
                                  child: TabBarView(
                                    controller: _tabController,
                                    // children: <Widget>[
                                    //   // returnLeaderBoard(),
                                    //   // returnPoints(),
                                    //   // returnBadges(),
                                    //   // returnLevels(),
                                    // ],
                                    children: _tabBarWidgets,
                                  ),
                                )
                              : Container())
                      : returnreditsAndCards(),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownMenu() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
        width: MediaQuery.of(context).size.width,
        height: 45.0,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<MydashboardGameModel>(
            dropdownColor: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
            ),
            hint: new Text(
              dropdownValue,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              )),
            ),
            value: mydashboardGamesmodel,
            elevation: 16,
            style: TextStyle(
                color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ),
                fontSize: 16),
            onChanged: (MydashboardGameModel? newValue) {
              setState(
                () {
                  mydashboardGamesmodel = newValue;
                  dropDowngameID = "${mydashboardGamesmodel?.gameID ?? ""}";
                  if (dropDowngameID == "-1") {
                    getMyCreditCertificateEvent();
                  } else {
                    isGotAchievement = false;
                    isGotLeaderBoard = false;
                    setState(() {});
                    getLeaderboardData();
                    getUserAchievementDataEvent();
                  }
                },
              );
            },
            items: myDashBoardBloc.gameslist
                .map<DropdownMenuItem<MydashboardGameModel>>(
                    (MydashboardGameModel value) {
              return DropdownMenuItem<MydashboardGameModel>(
                value: value,
                child: Text(value.gameName),
              );
            }).toList(),
          ),
        ));
  }

  Widget overAllCard() {
    String overallPoints = "", totalPointsString = "";

    String pointsString = "";
    String badgesString = "";

    double progress = 0;

    if (myDashBoardBloc.userAchievementResponse.userOverAllData != null) {
      int needpoints = myDashBoardBloc.userAchievementResponse.userOverAllData != null
        ? myDashBoardBloc.userAchievementResponse.userOverAllData!.neededPoints
        : 0;
      int currentpoints = myDashBoardBloc.userAchievementResponse.userOverAllData != null
          ? myDashBoardBloc.userAchievementResponse.userOverAllData!.overAllPoints
          : 0;
      int totalpoints = needpoints + currentpoints;

      String pointslevel = myDashBoardBloc.userAchievementResponse.userOverAllData != null
        ? myDashBoardBloc.userAchievementResponse.userOverAllData!.neededLevel
        : "Beginner";
      overallPoints = "$needpoints Points to $pointslevel";
      pointsString = "$currentpoints";
      totalPointsString = "$totalpoints";
      badgesString = "${myDashBoardBloc.userAchievementResponse.userOverAllData?.badges ?? 0}";

      progress = currentpoints / totalpoints;
    }
    print("Progress:$progress");

    return Wrap(
      children: [
        Card(
          color: Color(
            int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: myDashBoardBloc
                                    .userAchievementResponse.userOverAllData !=
                                null
                            ? myDashBoardBloc.userAchievementResponse
                                .userOverAllData!.userProfilePath
                            : "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ClipOval(
                          child: CircleAvatar(
                            radius: 25,
                            child: Text(
                              "",
                              style: TextStyle(
                                  color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          ),
                        ),
                        errorWidget: (context, url, error) => ClipOval(
                          child: CircleAvatar(
                            radius: 25,
                            child: Text(
                              myDashBoardBloc.userAchievementResponse
                                          .userOverAllData !=
                                      null
                                  ? myDashBoardBloc.userAchievementResponse
                                      .userOverAllData!.userDisplayName[0]
                                      .toUpperCase()
                                  : "",
                              style: TextStyle(
                                  color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            myDashBoardBloc.userAchievementResponse
                                        .userOverAllData !=
                                    null
                                ? myDashBoardBloc.userAchievementResponse
                                    .userOverAllData!.userDisplayName
                                : "",
                            // style: TextStyle(
                            //     fontSize: 16,
                            //     color: Color(
                            //       int.parse(
                            //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            //     )),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.apply(color: InsColor(appBloc).appTextColor),
                          ),
                          Text(
                            myDashBoardBloc.userAchievementResponse
                                        .userOverAllData !=
                                    null
                                ? myDashBoardBloc.userAchievementResponse
                                    .userOverAllData!.userLevel
                                : "Beginner",
                            style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Column(
                        children: [
                          Text(
                            'Points',
                            // style: TextStyle(
                            //     fontSize: 16,
                            //     color: Color(
                            //       int.parse(
                            //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            //     )),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.apply(color: InsColor(appBloc).appTextColor),
                          ),
                          Text(
                            pointsString,
                            // style: TextStyle(
                            //   color: Color(
                            //     int.parse(
                            //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            //   ),
                            // ),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.apply(color: InsColor(appBloc).appTextColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Column(
                        children: [
                          Text(
                            'Badges',
                            // style: TextStyle(
                            //     fontSize: 16,
                            //     color: Color(
                            //       int.parse(
                            //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            //     )),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.apply(color: InsColor(appBloc).appTextColor),
                          ),
                          Text(
                            badgesString,
                            // style: TextStyle(
                            //   color: Color(
                            //     int.parse(
                            //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            //   ),
                            // ),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.apply(color: InsColor(appBloc).appTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade400,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"),),
                    ),
                    value: progress,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        overallPoints,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Text(
                        totalPointsString,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                      ),
                    ),
                  ],
                ),
                (_tabController != null &&
                        tabList != null &&
                        tabList.length > 0)
                    ? new TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        indicatorColor: Color(int.parse("0xFF1D293F")),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"),
                        ),
                        tabs: tabList)
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget returnreditsAndCards() {
    return Expanded(
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        primary: false,
        children: [
          creditsAndCertificatesCard(),
          credtisTitle(),
          returnCreditsAndCertificatesList(),
        ],
      ),
    );
  }

  Widget creditsAndCertificatesCard() {
    String certificatecount = "";
    String creditcount = "";

    if (myDashBoardBloc.myCreditCertificateresponse.table != null) {
      certificatecount =
          myDashBoardBloc.myCreditCertificateresponse.table1.isNotEmpty
              ? myDashBoardBloc
                  .myCreditCertificateresponse.table1[0].certificatecount
              : "0";

      creditcount = myDashBoardBloc.myCreditCertificateresponse.table1 != null
          ? myDashBoardBloc.myCreditCertificateresponse.table1[0].creditcount
          : "Beginner";
    }
    return Wrap(
      children: [
        Card(
          color: Color(
            int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) //                 <--- border radius here
                              ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Certificates",
                              // style: TextStyle(
                              //     fontSize: 16,
                              //     color: Color(
                              //       int.parse(
                              //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              //     )),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.apply(
                                      color: InsColor(appBloc).appTextColor),
                            ),
                            Text(
                              myDashBoardBloc
                                          .myCreditCertificateresponse.table !=
                                      null
                                  ? "$certificatecount"
                                  : "0",
                              // style: TextStyle(
                              //     fontSize: 22,
                              //     color: Color(
                              //       int.parse(
                              //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              //     )),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.apply(
                                      color: InsColor(appBloc).appTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(35, 20, 35, 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  5.0) //                 <--- border radius here
                              ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Credits',
                              // style: TextStyle(
                              //     fontSize: 16,
                              //     color: Color(
                              //       int.parse(
                              //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              //     )),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.apply(
                                      color: InsColor(appBloc).appTextColor),
                            ),
                            Text(
                              "$creditcount",
                              // style: TextStyle(
                              //   color: Color(
                              //     int.parse(
                              //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              //   ),
                              //   fontSize: 22,
                              // ),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.apply(
                                      color: InsColor(appBloc).appTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void getGameslisting() {
    myDashBoardBloc.add(GetGameListEvent(
      gameID: '-1',
      locale: 'en-us',
      componentID: '',
      componentInsID: '',
      fromAchievement: true,
      leaderByGroup: '',
      siteID: '',
      userID: '',
    ));
  }

  void getLeaderboardData() {
    myDashBoardBloc.add(GetLeaderboardDataEvent(
      gameID: dropDowngameID,
      locale: 'en-us',
      componentID: '293',
      componentInsID: '50029',
      siteID: '',
      userID: '',
    ));
  }

  void getUserAchievementDataEvent() {
    myDashBoardBloc.add(GetUserAchievementDataEvent(
      gameID: dropDowngameID,
      locale: 'en-us',
      componentID: '293',
      componentInsID: '50029',
      siteID: '374',
      userID: '',
    ));
  }

  void getMyCreditCertificateEvent() {
    myDashBoardBloc.add(GetMyCreditCertificateEvent(
      locale: 'en-us',
      siteID: '374',
      userID: '',
    ));
  }

  Widget returnCreditsAndCertificatesList() {
    return (myDashBoardBloc.myCreditCertificateresponse.table != null &&
            myDashBoardBloc.myCreditCertificateresponse.table.length > 0)
        ? Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount:
                  myDashBoardBloc.myCreditCertificateresponse.table != null
                      ? myDashBoardBloc.myCreditCertificateresponse.table.length
                      : 0,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: creditsAndCertificatesCell(
                    myDashBoardBloc.myCreditCertificateresponse.table[index],
                  ),
                );
              },
            ),
          )
        : Container(
            child: Center(
                child: Text(
            appBloc.localstr.commoncomponentLabelNodatalabel,
            style: TextStyle(
              fontSize: 24,
              color: Color(
                int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}",
                ),
              ),
            ),
          )));
  }

  Widget creditsAndCertificatesCell(Credits credits) {
    return Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    credits != null ? credits.name : "",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        )),
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Text(
                  (credits.creditdecimalvalue != null &&
                          credits.creditdecimalvalue.isNotEmpty)
                      ? "${credits.creditdecimalvalue}"
                      : "0.0",
                  // style: TextStyle(
                  //   color: Color(
                  //     int.parse(
                  //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //   ),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.apply(color: InsColor(appBloc).appTextColor),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: InkWell(
                    onTap: () => {
                      if (credits.certifyviewlink != null &&
                          credits.certifyviewlink.isNotEmpty)
                        {
                          detailsBloc.myLearningDetailsModel
                              .setcontentID(credits.contentID),
                          detailsBloc.myLearningDetailsModel
                              .setCertificateId(credits.certificateID),
                          detailsBloc.myLearningDetailsModel
                              .setCertificatePage(credits.certificatePage),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewCertificate(detailsBloc: detailsBloc))),
                        }
                    },
                    child: (credits.certifyviewlink != null &&
                            credits.certifyviewlink.isNotEmpty)
                        ? Icon(
                            Icons.remove_red_eye,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          )
                        : Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                          ),
                  )),
            ],
          ),
        ]),
      ),
    );
  }

  Widget credtisTitle() {
    // myDashBoardBloc.fabButtonVisible = false;
    return Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Course",
                  // style: TextStyle(
                  //     fontSize: 10,
                  //     color: Color(
                  //       int.parse(
                  //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //     )),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.apply(color: InsColor(appBloc).appTextColor),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Text(
                  "Credits ",
                  // style: TextStyle(
                  //     fontSize: 10,
                  //     color: Color(
                  //       int.parse(
                  //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //     )),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.apply(color: InsColor(appBloc).appTextColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Text(
                  " Certificates",
                  // style: TextStyle(
                  //     fontSize: 10,
                  //     color: Color(
                  //       int.parse(
                  //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //     )),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.apply(color: InsColor(appBloc).appTextColor),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget returnLeaderBoard() {
    print("myDashBoardBloc.leaderBoardResponse.leaderBoardList.length in returnLeaderBoard:${myDashBoardBloc.leaderBoardResponse.leaderBoardList.length}");
    return (myDashBoardBloc.leaderBoardResponse.leaderBoardList.length > 0)
        ? Container(
            color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
            ),
            // width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              itemCount: myDashBoardBloc.leaderBoardResponse.leaderBoardList !=
                      null
                  ? myDashBoardBloc.leaderBoardResponse.leaderBoardList.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: leaderBoardCell(myDashBoardBloc
                      .leaderBoardResponse.leaderBoardList[index]),
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: Text(
                appBloc.localstr.commoncomponentLabelNodatalabel,
                // style: TextStyle(
                //     color: Color(int.parse(
                //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                //     fontSize: 24),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.apply(color: InsColor(appBloc).appTextColor),
              ),
            ),
          );
  }

  Widget returnPoints() {
    return myDashBoardBloc.userAchievementResponse.userPoints != null
        ? Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            // width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              itemCount: myDashBoardBloc.userAchievementResponse.userPoints !=
                      null
                  ? myDashBoardBloc.userAchievementResponse.userPoints.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: achivmentsPointsCell(myDashBoardBloc
                      .userAchievementResponse.userPoints[index]),
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: Text(
                appBloc.localstr.commoncomponentLabelNodatalabel,
                // style: TextStyle(
                //     color: Color(int.parse(
                //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                //     fontSize: 24)),
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.apply(color: InsColor(appBloc).appTextColor),
              ),
            ),
          );
  }

  Widget returnBadges() {
    return myDashBoardBloc.userAchievementResponse.userBadges != null
        ? Container(
            color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
            ),
            //width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              itemCount: myDashBoardBloc.userAchievementResponse.userBadges !=
                      null
                  ? myDashBoardBloc.userAchievementResponse.userBadges.length
                  : 0,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: achivmentsBadgesCell(myDashBoardBloc
                      .userAchievementResponse.userBadges[index]),
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: Text(
                appBloc.localstr.commoncomponentLabelNodatalabel,
                // style: TextStyle(
                //     color: Color(int.parse(
                //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                //     fontSize: 24)),
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.apply(color: InsColor(appBloc).appTextColor),
              ),
            ),
          );
  }

  Widget returnLevels() {
    return myDashBoardBloc.userAchievementResponse.userLevel != null
        ? Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            //  width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              itemCount:
                  myDashBoardBloc.userAchievementResponse.userLevel != null
                      ? myDashBoardBloc.userAchievementResponse.userLevel.length
                      : 0,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: achivmentsLevelCell(
                      myDashBoardBloc.userAchievementResponse.userLevel[index]),
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                  // style: TextStyle(
                  //     color: Color(int.parse(
                  //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  //     fontSize: 24)),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.apply(color: InsColor(appBloc).appTextColor)),
            ),
          );
  }

  Widget leaderBoardCell(LeaderBoardList leaderBoardList) {
    return InkWell(
      onTap: () => {
        print("LeaderBoard list ${leaderBoardList.userDisplayName}"),
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Profile(
              isFromProfile: false,
              connectionUserId: "${leaderBoardList.intUserID}",
            ),
          ),
        ),
      },
      child: Card(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Row(
              children: <Widget>[
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: leaderBoardList != null
                        ? (leaderBoardList.userPicturePath.startsWith('http')
                            ? leaderBoardList.userPicturePath
                            : ApiEndpoints.mainSiteURL +
                                leaderBoardList.userPicturePath)
                        : "",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ClipOval(
                      child: CircleAvatar(
                        radius: 25,
                        child: Text(
                          "",
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipOval(
                      child: CircleAvatar(
                        radius: 25,
                        child: Text(
                          leaderBoardList != null
                              ? leaderBoardList.userDisplayName[0].toUpperCase()
                              : "",
                          style: TextStyle(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ),
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leaderBoardList != null
                            ? leaderBoardList.userDisplayName
                            : "",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                      Text(
                        "${leaderBoardList.levelName}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Text(
                    "${leaderBoardList.points}",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.apply(color: InsColor(appBloc).appTextColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Text(
                    "${leaderBoardList.badges}",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.apply(color: InsColor(appBloc).appTextColor),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget achivmentsPointsCell(UserPoints userPoints) {
    return Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                      child: Text(
                        userPoints != null ? userPoints.actionName : "",
                        // style: TextStyle(
                        //     fontSize: 18,
                        //     color: Color(
                        //       int.parse(
                        //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        //     )),
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                    ),
                    Padding(
                        // padding: const EdgeInsets.all(6.0),
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                        child: Text(
                          "${userPoints.userReceivedDate != null ? userPoints.userReceivedDate : ""}",
                          // style: TextStyle(
                          //   color: Color(
                          //     int.parse(
                          //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                          //   ),
                          // ),
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ))
                  ],
                ),
              ),
              Spacer(),
              ClipOval(
                child: CircleAvatar(
                  radius: 35,
                  child: Text(
                    userPoints != null ? "${userPoints.points}" : "",
                    // style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.w600,
                    //     color: Color(
                    //       int.parse(
                    //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                    //     )),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.apply(color: InsColor(appBloc).appTextColor),
                  ),
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget achivmentsLevelCell(UserLevel userLevel) {
    return Card(
      color: Color(
        int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Row(
            children: <Widget>[
              ClipOval(
                child: CircleAvatar(
                  radius: 25,
                  child: Text(
                    "",
                    // userLevel != null ? userLevel.levelName : "",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userLevel != null ? userLevel.levelName : "",
                      // style: TextStyle(
                      //     fontSize: 18,
                      //     color: Color(
                      //       int.parse(
                      //           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      //     )),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.apply(color: InsColor(appBloc).appTextColor),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 6, 6, 6),
                        child: Text(
                          "Achieved  ${userLevel.levelRecivedDate != null ? userLevel.levelRecivedDate : ""}",
                          // style: TextStyle(
                          //   color: Color(
                          //     int.parse(
                          //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                          //   ),
                          // ),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ))
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Text(
                  "${userLevel.levelPoints}",
                  // style: TextStyle(
                  //   color: Color(
                  //     int.parse(
                  //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //   ),
                  // ),
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.apply(color: InsColor(appBloc).appTextColor),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget achivmentsBadgesCell(UserBadges userBadges) {
    return Card(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      elevation: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: new EdgeInsets.only(right: 15.0),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: userBadges != null ? userBadges.badgeImage : "",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => ClipOval(
                    child: CircleAvatar(
                      radius: 25,
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                  errorWidget: (context, url, error) => ClipOval(
                    child: CircleAvatar(
                      radius: 25,
                      child: Text(
                        userBadges != null
                            ? userBadges.badgeName[0].toUpperCase()
                            : "",
                        style: TextStyle(
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ),
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(2, 5, 5, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 5, 5, 5),
                      child: Text(
                        userBadges != null ? userBadges.badgeName : "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 5, 5, 5),
                      child: Text(
                        "${userBadges.badgeDescription}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 3, 5, 5),
                      child: Text(
                        appBloc.localstr.achievementsLabelAwardedonlabel +
                            " : ${userBadges.badgeReceivedDate}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
