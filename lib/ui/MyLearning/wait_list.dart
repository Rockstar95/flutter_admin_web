import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';

import '../../configs/constants.dart';

class WaitListScreen extends StatefulWidget {
  @override
  _WaitListScreenState createState() => _WaitListScreenState();
}

class _WaitListScreenState extends State<WaitListScreen> {
  int pageWaitNumber = 1;
  int totalPage = 10;
  bool isGetWaitListEvent = false;
  ScrollController _scWait = new ScrollController();

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scWait.addListener(() {
      if (_scWait.position.pixels == _scWait.position.maxScrollExtent) {
        print("Last isGetWaitListEvent Postion $isGetWaitListEvent");
        if (isGetWaitListEvent &&
            myLearningBloc.listWaitTotalCount >
                myLearningBloc.listWait.length) {
          setState(() {
            isGetWaitListEvent = false;
          });
          myLearningBloc
              .add(GetWaitListEvent(pageNumber: pageWaitNumber, pageSize: 10));
        }
      }
    });
    myLearningBloc.isWaitFirstLoading = true;
    myLearningBloc
        .add(GetWaitListEvent(pageNumber: pageWaitNumber, pageSize: 10));
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _scWait.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(
        int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
      ),
      appBar: AppBar(
        backgroundColor: Color(
          int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
        ),
        title: Text(
          "Waitlist",
          style: TextStyle(
              fontSize: 18,
              color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
              )),
        ),
        elevation: 2,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            color: InsColor(appBloc).appIconColor,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: BlocConsumer<MyLearningBloc, MyLearningState>(
          bloc: myLearningBloc,
          listener: (context, state) {
            if (state is GetWaitListState) {
              if (state.status == Status.COMPLETED) {
                print("List size ${state.list.length}");
                setState(() {
                  isGetWaitListEvent = true;
                  pageWaitNumber++;
                });
              } else if (state.status == Status.ERROR) {
                print("listner Error ${state.message}");
                if (state.message == "401") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginCommonPage()),
                      (route) => false);
                }
              }
            }
          },
          builder: (context, state) {
            if (state.status == Status.LOADING &&
                myLearningBloc.isWaitFirstLoading == true) {
              return Center(
                child: AbsorbPointer(
                  child: AppConstants().getLoaderWidget(iconSize: 70)
                ),
              );
            } else if (state.status == Status.ERROR) {
              return noDataFound(true);
            } else {
              return myLearningBloc.listWait.length == 0
                  ? noDataFound(true)
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: myLearningBloc.listWait.length + 1,
                      itemBuilder: (context, i) {
                        if (i == myLearningBloc.listWait.length) {
                          if (state.status == Status.LOADING) {
                            print("gone in _buildProgressIndicator");
                            return _buildProgressIndicator();
                          } else {
                            return Container();
                          }
                        } else {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: widgetMyCourceListItems(
                                  myLearningBloc.listWait[i], false),
                            ),
                          );
                        }
                      },
                      controller: _scWait,
                    );
            }
          },
        ),
      ),
    );
  }

  Widget widgetMyCourceListItems(
      DummyMyCatelogResponseTable2 table2, bool isArchive) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    String contentIconPath = table2.iconpath;

    if (appBloc.uiSettingModel.azureRootPath != null &&
        appBloc.uiSettingModel.azureRootPath.length > 0) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.azureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(100),
                    child: CachedNetworkImage(
                      imageUrl: table2.siteurl.trim() +
                          table2.thumbnailimagepath.trim(),
                      width: MediaQuery.of(context).size.width,
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      placeholder: (context, url) => Container(
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                              heightFactor: ScreenUtil().setWidth(20),
                              widthFactor: ScreenUtil().setWidth(20),
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ))),
                      errorWidget: (context, url, error) => Container(),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Visibility(
                          visible: kShowContentTypeIcon,
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            color: Colors.white,
                            child: CachedNetworkImage(
                              height: 30,
                              imageUrl: contentIconPath,
                              width: 30,
                              fit: BoxFit.contain,
                            ),
                          )),
                      // Container(
                      //   child: Icon(
                      //     table2.objecttypeid == 14
                      //         ? Icons.picture_as_pdf
                      //         : (table2.objecttypeid == 11
                      //             ? Icons.video_library
                      //             : Icons.format_align_justify),
                      //     color: Colors.white,
                      //     size: ScreenUtil().setHeight(30),
                      //   ),
                      // )
                    ),
                  ),
                  Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(5),
                            bottom: ScreenUtil().setWidth(5),
                            left: ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(10)),
                        child: Text(
                          table2.corelessonstatus.toString(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: Colors.white),
                        ),
                      )),
                ],
              ),
              /* LinearProgressIndicator(
                value: double.parse(table2.percentcompleted),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                backgroundColor: Colors.grey,
              ),*/
              Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
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
                                table2.description,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Text(
                                table2.name.toUpperCase(),
                                style: TextStyle(
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
                          table2.authordisplayname,
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
                    Row(
                      children: <Widget>[
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: (v) {},
                            starCount: 5,
                            rating: table2.ratingid,
                            size: ScreenUtil().setHeight(20),
                            // filledIconData: Icons.blur_off,
                            // halfFilledIconData: Icons.blur_on,
                            color: Colors.orange,
                            borderColor: Colors.orange,
                            spacing: 0.0),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Text(
                      table2.shortdescription,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                              .withOpacity(0.5)),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noDataFound(val) {
    return val
        ? Container(
            child: Center(
              child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                  style: TextStyle(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      fontSize: 24)),
            ),
          )
        : new Container();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
