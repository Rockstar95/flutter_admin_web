import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_leaderboardresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mydashboard/model/mydashboard_userachivmentsresponse.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/widgets/DashboardCalendarScreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/widgets/DashboardGridScreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/myLearnPlus/widgets/DashboardLeaderboardScreen.dart';

class MyLearnPlusDashboard extends StatefulWidget {
  final UserAchievementResponse achievementResponse;
  final LeaderBoardResponse leaderBoardResponse;
  final List<DummyMyCatelogResponseTable2> mylearningplusdashdayWishlist;
  final List<DummyMyCatelogResponseTable2> mylearningplusDashWeeklist;
  final List<DummyMyCatelogResponseTable2> mylearningplusDashMonthlist;

  MyLearnPlusDashboard({
    required this.achievementResponse,
    required this.leaderBoardResponse,
    required this.mylearningplusdashdayWishlist,
    required this.mylearningplusDashWeeklist,
    required this.mylearningplusDashMonthlist,
  });

  @override
  State<MyLearnPlusDashboard> createState() => MyPlusDashHeader();
}

class MyPlusDashHeader extends State<MyLearnPlusDashboard> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  String dashtitle = 'Your Schedule';
  Color statusthickcolor = Color(0xff000000);
  Color statusLightcolor = Color(0xff000000);

  String globalCondition = 'grid';
  bool gridcond = false;
  bool calendarcond = true;
  bool leadercond = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      '$dashtitle',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                gridcond = true;
                                calendarcond = false;
                                leadercond = false;
                                globalCondition = 'grid';
                                dashtitle = 'Your Schedule';
                              });
                            },
                            child: Icon(Icons.grid_view,
                                color: gridcond == true
                                    ? statusthickcolor
                                    : Colors.grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                gridcond = false;
                                calendarcond = true;
                                leadercond = false;
                                globalCondition = 'cal';
                                dashtitle = 'Your Schedule';
                              });
                            },
                            child: Icon(Icons.calendar_today,
                                color: calendarcond == true
                                    ? statusthickcolor
                                    : Colors.grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                gridcond = false;
                                calendarcond = false;
                                leadercond = true;
                                globalCondition = 'lead';
                                dashtitle = 'Leaderboard';
                              });
                            },
                            child: Icon(Icons.stars,
                                color: leadercond == true
                                    ? statusthickcolor
                                    : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.black),
            Expanded(
              child: clickWiseScreen(globalCondition),
            ),
          ],
        ),
      ),
    );
  }

  Widget clickWiseScreen(String selectedicon) {
    try {
      switch (selectedicon) {
        case 'grid':
          return DashboardGridScreen(
            mylearningplusdashdayWishlist: widget.mylearningplusdashdayWishlist,
            mylearningplusDashMonthlist: widget.mylearningplusDashMonthlist,
            mylearningplusDashWeeklist: widget.mylearningplusDashWeeklist,
          );
        case 'cal':
          return DashboardCalendarScreen(getEventresourcelist: [], myLearningPlusContext: context,);
        case 'lead':
          return DashboardLeaderboardScreen(
            leaderBoardResponse: widget.leaderBoardResponse,
            achievementResponse: widget.achievementResponse,
            levels: "",badges: "",points: "",
          );
        default:
          return comingSoon();
      }
    } catch (e) {
      print("repo Error $e");
    }
    return SizedBox();
  }

  Widget comingSoon() {
    return Container(
      child: Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}
