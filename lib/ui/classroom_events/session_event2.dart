import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/session_event_response.dart';
import 'package:flutter_admin_web/ui/common/common_widgets.dart';

import '../common/app_colors.dart';

class SessionEvent2 extends StatefulWidget {
  final ClassroomEventsController? classroomEventsController;
  final String contentId;

  const SessionEvent2({Key? key, this.classroomEventsController, this.contentId = ""}) : super(key: key);

  @override
  _SessionEvent2State createState() => _SessionEvent2State();
}

class _SessionEvent2State extends State<SessionEvent2> {
  bool pageMounted = false;

  late ClassroomEventsController classroomEventsController;
  late Future<List<CourseList>> getCourseListFuture;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late FToast flutterToast;

  void mySetState() {
    if(!mounted) {
      return;
    }

    if(pageMounted) {
      setState(() {});
    }
    else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.classroomEventsController != null) {
      classroomEventsController = widget.classroomEventsController!;
    }
    else {
      classroomEventsController = ClassroomEventsController(mainMapOfEvents: {});
    }
    getCourseListFuture = classroomEventsController.getEventSessionCoursesList(contentId: widget.contentId);
  }

  @override
  void didUpdateWidget(covariant SessionEvent2 oldWidget) {
    bool isUpdated = false;
    if(oldWidget.classroomEventsController != widget.classroomEventsController) {
      classroomEventsController = widget.classroomEventsController ?? ClassroomEventsController(mainMapOfEvents: {});
      isUpdated = true;
    }
    if(widget.contentId != oldWidget.contentId) {
      isUpdated = true;
    }

    if(isUpdated) {
      getCourseListFuture = classroomEventsController.getEventSessionCoursesList(contentId: widget.contentId);
      mySetState();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    pageMounted = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageMounted = true;
    });

    flutterToast = FToast();
    flutterToast.init(context);

    return Scaffold(
      appBar: getAppBar(),
      body: FutureBuilder<List<CourseList>>(
        future: getCourseListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<CourseList>> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return getCoursesListWidget(snapshot.data ?? []);
          }
          else {
            return getCommonLoading();
          }
        },
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 0,
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Icon(Icons.arrow_back, color: AppColors.getAppHeaderTextColor()),
      ),
      backgroundColor: AppColors.getAppHeaderColor(),
      title: Text(
        appBloc.localstr.detailsLabelSessionstitlelable,
        style: TextStyle(
            fontSize: 18,
            color: AppColors.getAppHeaderTextColor(),
        ),
      ),
    );
  }

  Widget getCoursesListWidget(List<CourseList> courses) {
    return Container(
      color: AppColors.getAppBGColor(),
      child: Container(
        margin: EdgeInsets.all(10.h),
        child: ResponsiveWidget(
          mobile: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, i) {
              return getCourseCard(courses[i]);
            },
          ),
          tab: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width / 800,
            ),
            itemCount: courses.length,
            itemBuilder: (context, i) {
              return getCourseCard(courses[i]);
            },
          ),
          web: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
            ),
            itemCount: courses.length,
            itemBuilder: (context, i) {
              return getCourseCard(courses[i]);
            },
          ),
        ),
      ),
    );
  }

  Widget getCourseCard(CourseList table2) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    //print("Image Url:${table2.thumbnailImagePath}");

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        color: AppColors.getAppBGColor(),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(kCellThumbHeight),
                  child: CachedNetworkImage(
                    imageUrl: table2.thumbnailImagePath.contains("http") || table2.thumbnailImagePath.contains("https") ? table2.thumbnailImagePath : ApiEndpoints.strSiteUrl + table2.thumbnailImagePath.trim(),
                    width: MediaQuery.of(context).size.width,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    placeholder: (context, url) => Container(
                        color: AppColors.getAppTextColor().withOpacity(0.5),
                        child: Center(
                            heightFactor: ScreenUtil().setWidth(20),
                            widthFactor: ScreenUtil().setWidth(20),
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                        ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              table2.contentType,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: AppColors.getAppTextColor(),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              table2.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(15),
                                  color: AppColors.getAppTextColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Row(
                    children: <Widget>[
                      new Container(
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(20),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(imgUrl)))),
                      SizedBox(
                        width: ScreenUtil().setWidth(5),
                      ),
                      Text(
                        table2.authorDisplayName,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: AppColors.getAppTextColor().withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(3),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Start Date : ".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(12),
                              color: AppColors.getAppTextColor(),
                          ),
                        ),
                        Text(
                          table2.eventStartDateTime.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: AppColors.getAppTextColor(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "End Date : ".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(12),
                              color: AppColors.getAppTextColor(),
                          ),
                        ),
                        Text(
                          table2.eventEndDateTime.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: AppColors.getAppTextColor(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Time Zone : ".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(12),
                              color: AppColors.getAppTextColor(),
                          ),
                        ),
                        Text(
                          table2.timeZone,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: AppColors.getAppTextColor(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
