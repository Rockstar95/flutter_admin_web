import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/session_event_response.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class SessionEvent extends StatefulWidget {
  final EvntModuleBloc? evntModuleBloc;
  final String contentId;

  const SessionEvent({Key? key, this.evntModuleBloc, this.contentId = ""})
      : super(key: key);

  @override
  _SessionEventState createState() => _SessionEventState();
}

class _SessionEventState extends State<SessionEvent> {
  late EvntModuleBloc evntModuleBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late FToast flutterToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    evntModuleBloc = EvntModuleBloc(
        eventModuleRepository: EventRepositoryBuilder.repository());
    evntModuleBloc.add(EventSession(contentid: widget.contentId));
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    return BlocConsumer<EvntModuleBloc, EvntModuleState>(
      bloc: evntModuleBloc,
      listener: (context, state) {
        if (state is GetSessionEventState) {
          if (state.status == Status.ERROR) {
            if (state.message == '401') {
              AppDirectory.sessionTimeOut(context);
            } else {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: appBloc
                        .localstr.mylearningAlertsubtitleArchivedsuccesfully),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 2),
              );
            }
          }
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
          ),
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          title: Text(
            appBloc.localstr.detailsLabelSessionstitlelable,
            style: TextStyle(
                fontSize: 18,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
          ),
        ),
        body: (state.status == Status.LOADING)
            ? Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: Center(
                  child: AbsorbPointer(
                    child: SpinKitCircle(
                      color: Colors.grey,
                      size: 70.h,
                    ),
                  ),
                ),
              )
            : Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: Container(
                  margin: EdgeInsets.all(10.h),
                  child: evntModuleBloc.sessionCourseList.isNotEmpty
                      ? ResponsiveWidget(
                          mobile: ListView.builder(
                            itemBuilder: (context, i) {
                              return widgetMyEventItems(
                                  evntModuleBloc.sessionCourseList[i]);
                            },
                            itemCount: evntModuleBloc.sessionCourseList.length,
                          ),
                          tab: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width / 800,
                            ),
                            itemBuilder: (context, i) {
                              return widgetMyEventItems(
                                  evntModuleBloc.sessionCourseList[i]);
                            },
                            itemCount: evntModuleBloc.sessionCourseList.length,
                          ),
                          web: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, i) {
                              return widgetMyEventItems(
                                  evntModuleBloc.sessionCourseList[i]);
                            },
                            itemCount: evntModuleBloc.sessionCourseList.length,
                          ),
                        )
                      : Container(),
                ),
              ),
      ),
    );
  }

  Widget widgetMyEventItems(CourseList table2) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    //print("Image Url:${table2.thumbnailImagePath}");

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
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
                        color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5),
                        child: Center(
                            heightFactor: ScreenUtil().setWidth(20),
                            widthFactor: ScreenUtil().setWidth(20),
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.orange),
                            ))),
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
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
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
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
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
                            color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                .withOpacity(0.5)),
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
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        Text(
                          table2.eventStartDateTime.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
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
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        Text(
                          table2.eventEndDateTime.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
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
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        Text(
                          table2.timeZone,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
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
