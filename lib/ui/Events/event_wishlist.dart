import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:intl/intl.dart';

import '../common/bottomsheet_drager.dart';

class EventWishListScreen extends StatefulWidget {
  @override
  _EventWishListScreenState createState() => _EventWishListScreenState();
}

class _EventWishListScreenState extends State<EventWishListScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  EvntModuleBloc get evntModuleBloc => BlocProvider.of<EvntModuleBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  MyLearningDetailsBloc get myLearningDetailsBloc =>
      BlocProvider.of<MyLearningDetailsBloc>(context);

  late FToast flutterToast;

  bool menu0 = false,
      menu1 = false,
      menu2 = false,
      menu3 = false,
      menu4 = false,
      menu5 = false,
      menu6 = false;

  late MyLearningDetailsBloc detailsBloc;

  int pos = 0;

  @override
  void initState() {
    super.initState();
    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());
    evntModuleBloc.add(GetEventWishlistContent(tabVal: "upcoming"));
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    //print("In Event Wishlist");

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
          "Wishlist",
          style: TextStyle(
              fontSize: 18,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            )),
      ),
      body: Container(
        child: BlocConsumer<CatalogBloc, CatalogState>(
          bloc: catalogBloc,
          listener: (context, state) {
            if (state is AddToWishListState ||
                state is RemoveFromWishListState) {
              if (state.status == Status.COMPLETED) {
                evntModuleBloc.add(GetEventWishlistContent(tabVal: "upcoming"));
                if (state is AddToWishListState) {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: appBloc.localstr
                            .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                }
                if (state is RemoveFromWishListState) {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: appBloc.localstr
                            .catalogActionsheetRemovefromwishlistoption),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                }
                if (state is AddToMyLearningState) {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: appBloc.localstr
                            .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                }
              }
            } else if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
              if (state.message == "401") {
                AppDirectory.sessionTimeOut(context);
              }
            } else if (state is AddToMyLearningState) {
              print('addtoenrolllllllll');
              if (state.status == Status.COMPLETED) {
                Future.delayed(Duration(seconds: 1), () {
                  // 5s over, navigate to a new page
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: appBloc.localstr
                            .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 1),
                  );
                });

                setState(() {
                  state.table2.isaddedtomylearning = 1;
                  evntModuleBloc
                      .add(GetEventWishlistContent(tabVal: "upcoming"));
                });
              } else if (state.status == Status.ERROR) {
                if (state.message == '401') {
                  AppDirectory.sessionTimeOut(context);
                } else {
                  flutterToast.showToast(
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: Duration(seconds: 2),
                      child: CommonToast(displaymsg: 'Something went wrong'));
                }
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                BlocConsumer<EvntModuleBloc, EvntModuleState>(
                  bloc: evntModuleBloc,
                  listener: (context, state) {
                    if (state is GetTabContentState) {
                      if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
                        if (state.message == "401") {
                          AppDirectory.sessionTimeOut(context);
                        }
                      }
                    } else if (state is CancelEnrollmentState) {
                      if (state.status == Status.COMPLETED) {
                        if (state.isSucces == 'true') {
                          Future.delayed(Duration(seconds: 1), () {
                            // 5s over, navigate to a new page
                            flutterToast.showToast(
                              child: CommonToast(
                                  displaymsg:
                                      'Your enrollment for the course has been successfully canceled'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 1),
                            );
                          });

                          setState(() {
                            state.table2.isaddedtomylearning = 0;
                          });
                        } else {
                          flutterToast.showToast(
                            child:
                                CommonToast(displaymsg: 'Something went wrong'),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        }
                      } else if (state.status == Status.ERROR) {
                        if (state.message == '401') {
                          AppDirectory.sessionTimeOut(context);
                        }
                      }
                    } else if (state is BadCancelEnrollmentState) {
                      if (state.status == Status.COMPLETED) {
                        showCancelEnrollDialog(state.table2, state.isSucces);
                      } else if (state.status == Status.ERROR) {
                        if (state.message == '401') {
                          AppDirectory.sessionTimeOut(context);
                        }
                      }
                    } else if (state is ExpiryEventState) {
                      if (state.status == Status.COMPLETED) {
                        if (state.isSucces == 'true') {
                          flutterToast.showToast(
                            child: CommonToast(
                                displaymsg: appBloc.localstr
                                        .eventsAlertsubtitleThiseventitemhasbeenaddedto +
                                    " " +
                                    appBloc.localstr
                                        .mylearningHeaderMylearningtitlelabel),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );

                          setState(() {
                            state.table2.isaddedtomylearning = 1;
                          });
                        } else {
                          flutterToast.showToast(
                            child:
                                CommonToast(displaymsg: 'Something went wrong'),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        }
                      } else if (state.status == Status.ERROR) {
                        if (state.message == '401') {
                          AppDirectory.sessionTimeOut(context);
                        }
                      }
                    } else if (state is WaitingListState) {
                      if (state.status == Status.COMPLETED) {
                        if (state.waitingListResponse.isSuccess) {
                          Future.delayed(Duration(seconds: 1), () {
                            // 5s over, navigate to a new page
                            flutterToast.showToast(
                              child: CommonToast(
                                  displaymsg:
                                      state.waitingListResponse.message),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 2),
                            );
                          });

                          setState(() {
                            state.table2.waitlistenrolls =
                                state.table2.waitlistenrolls + 1;
                          });
                        } else if (state.status == Status.ERROR) {
                          if (state.message == '401') {
                            AppDirectory.sessionTimeOut(context);
                          }
                        } else {
                          flutterToast.showToast(
                            child:
                                CommonToast(displaymsg: 'Something went wrong'),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        }
                      }
                    }
                  },
                  builder: (context, state) {
                    print("state -----$state");
                    if (state.status == Status.LOADING) {
                      return Container(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: Center(
                          child: AbsorbPointer(
                            child: SpinKitCircle(
                              color: Colors.grey,
                              size: 70,
                            ),
                          ),
                        ),
                      );
                    } else if (state.status == Status.COMPLETED) {
                      return evntModuleBloc.eventWishlist.length == 0
                          ? noDataFound(true)
                          : Container(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                              child: ListView.builder(
                                  itemCount:
                                      evntModuleBloc.eventWishlist.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: widgetMyEventItems(
                                          evntModuleBloc.eventWishlist[i], i),
                                    );
                                  }),
                            );
                    } else {
                      return noDataFound(true);
                    }
                  },
                ),
                (state.status == Status.LOADING)
                    ? Center(
                        child: AbsorbPointer(
                          child: SpinKitCircle(
                            color: Colors.grey,
                            size: 70,
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget widgetMyEventItems(DummyMyCatelogResponseTable2 table2, [int i = 0]) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    bool isratingbarVissble = false;
    bool isReviewVissble = false;

    double ratingRequired = 0;

    try {
      ratingRequired = double.parse(
          appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
    } catch (e) {
      ratingRequired = 0;
    }

    if (table2.totalratings >=
            int.parse(
                appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) &&
        table2.ratingid >= ratingRequired) {
      isReviewVissble = false;
      isratingbarVissble = true;
    }

    DateTime startTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss")
        .parse(table2.eventstartdatedisplay);

    DateTime endTempDate =
        new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventenddatedisplay);

    String startDate =
        DateFormat("MM/dd/yyyy hh:mm:ss a").format(startTempDate);
    String endDate = DateFormat("MM/dd/yyyy hh:mm:ss a").format(endTempDate);

    String thumbnailPath = table2.thumbnailimagepath.startsWith("http")
        ? table2.thumbnailimagepath.trim()
        : table2.siteurl + table2.thumbnailimagepath.trim();

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  height: ScreenUtil().setHeight(100),
                  child: CachedNetworkImage(
                    imageUrl: thumbnailPath,
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
//
              ],
            ),
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
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Text(
                              table2.name,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _settingMyEventBottomSheet(context, table2, i);
                        },
                        child: Icon(
                          Icons.more_vert,
                          color: InsColor(appBloc).appIconColor,
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
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(3),
                  ),
                  Row(
                    children: <Widget>[
                      isratingbarVissble
                          ? SmoothStarRating(
                              allowHalfRating: false,
                              onRatingChanged: (v) {},
                              starCount: 5,
                              rating: table2.ratingid,
                              size: ScreenUtil().setHeight(20),
                              // filledIconData: Icons.blur_off,
                              // halfFilledIconData: Icons.blur_on,
                              color: Colors.orange,
                              borderColor: Colors.orange,
                              spacing: 0.0)
                          : Container(),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      isReviewVissble
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReviewScreen(
                                          table2.contentid,
                                          false,
                                          myLearningDetailsBloc)));
                                },
                                child: Text(
                                  "See Reviews".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(12),
                                      color: Colors.blue),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                      /*QrImage(
                        data: "1234567890",
                        version: QrVersions.auto,
                        size: 70.h,
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Start Date : ".toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.grey),
                        ),
                        Text(
                          startDate.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.black),
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
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.grey),
                        ),
                        Text(
                          endDate.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.black),
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
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.grey),
                        ),
                        Text(
                          table2.timezone ?? "",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Location : ".toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.grey),
                        ),
                        Text(
                          table2.locationname,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingMyEventBottomSheet(
      BuildContext context, DummyMyCatelogResponseTable2 table2,
      [int i = 0]) {
    menu0 = false;
    menu1 = false;
    menu2 = false;
    menu3 = false;
    menu4 = false;
    menu5 = false;
    menu6 = false;

    String menu1Title = appBloc.localstr.eventsActionsheetEnrolloption;
    print("relatedconentcount ${table2.relatedconentcount}");
    print("isaddedtomylearning ${table2.isaddedtomylearning}");
    if (table2.isaddedtomylearning == 1) {
      if (table2.relatedconentcount != 0) {
        menu0 = true;
      }

      menu1 = false;
      menu2 = false;
      menu3 = true;
      menu4 = true;
    } else {
      if (table2.viewtype == 1) {
        menu0 = false;
        menu2 = false;
        menu3 = true;
        menu4 = false; //cancel enrollment
        if (isValidString(table2.eventstartdatetime) &&
            !returnEventCompleted(table2.eventstartdatetime)) {
          if (isValidString(table2.actionwaitlist) &&
              table2.actionwaitlist == "true") {
            menu1 = true;
            menu1Title = appBloc.localstr.eventsActionsheetWaitlistoption;
          } else {
            menu1 = true;
          }
        } else {
          if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
            menu1 = true;
          } else {
            // btnsLayout.setVisibility(View.GONE ;
            menu1 = true;
          }
        }
      } else if (table2.viewtype == 2) {
        menu0 = false;
        menu1 = true;
        menu3 = true;
        if (table2.eventscheduletype == 2) {
          menu1 = false;
        }
        if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true" &&
            returnEventCompleted(table2.eventenddatetime)) {
          menu1 = false;
        }
      } else if (table2.viewtype == 3) {
        menu0 = false;
        menu3 = true;
        menu1 = false;
        if (returnEventCompleted(table2.eventenddatetime) &&
            appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
          // uncomment here if required
          menu2 = true;
        }
      }
    }

    if (table2.isaddedtomylearning == 0 || table2.isaddedtomylearning == 2) {
      if (table2.iswishlistcontent == 1) {
        menu6 = true; //removeWishListed
      } else {
        menu5 = true; //isWishListed
      }
    }

    // expired event functionality
    if (isValidString(table2.eventenddatetime) &&
        returnEventCompleted(table2.eventenddatetime)) {
      print("expired event functionality");
      if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
        if (table2.isaddedtomylearning == 1) {
          if (table2.relatedconentcount != 0) {
            menu0 = true;
            menu1 = false; //enroll
          }
        } else {
          if (table2.viewtype == 2) {
            menu1 = true; //enroll
          }
        }

//               menu0 =true ;//view

        menu2 = false; //buy
        menu3 = true; //detail
        menu4 = false; //cancel enrollment
      } else {
        menu2 = false; //buy
        menu1 = false; //enroll
        menu4 = false; //cancel enrollment
        menu5 = false; //isWishListed
        menu6 = false; //isWishListed

      }
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  BottomSheetDragger(),
                  menu0
                      ? ListTile(
                          title: Text(appBloc
                              .localstr.eventsActionsheetRelatedcontentoption,
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor)),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf06e')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                        )
                      : Container(),
                  menu1
                      ? ListTile(
                          title: Text(menu1Title, style: TextStyle(
                              color: InsColor(appBloc).appTextColor)),
                          leading: Icon(
                            Icons.add_circle,
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            addToEnroll(table2);
                          },
                        )
                      : Container(),
                  menu2
                      ? ListTile(
                          title: Text(
                              appBloc.localstr.eventsActionsheetBuynowoption,
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor)),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf144')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                        )
                      : Container(),
                  menu3
                      ? ListTile(
                          title: Text(
                              appBloc.localstr.eventsActionsheetDetailsoption,
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor)
                          ),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf570')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            pos = i;

                            print('wishlistposss $pos $i');
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CommonDetailScreen(
                                      screenType: ScreenType.Events,
                                      //isWishlisted: true,
                                      contentid: table2.contentid,
                                      objtypeId: table2.objecttypeid,
                                      detailsBloc: detailsBloc,
                                      table2: table2,
                                      isFromReschedule: false,
                                    )));
                          },
                        )
                      : Container(),
                  menu4
                      ? ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            if (table2.isbadcancellationenabled) {
                              badCancelEnrollmentMethod(table2);

                              // bad cancel
                            } else {
                              showCancelEnrollDialog(table2,
                                  table2.isbadcancellationenabled.toString());
                            }
                          },
                          title: Text(appBloc.localstr.eventsActionsheetCancelenrollmentoption,
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor)
                          ),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf144')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                        )
                      : Container(),
                  menu5
                      ? ListTile(
                          title: Text(appBloc.localstr.catalogActionsheetWishlistoption,
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor)),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf144')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            catalogBloc.add(AddToWishListEvent(
                                contentId: table2.contentid));
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                  menu6
                      ? ListTile(
                          title: Text(appBloc.localstr.catalogActionsheetRemovefromwishlistoption, style: TextStyle(
                              color: InsColor(appBloc).appTextColor)),
                          leading: Icon(
                            Icons.favorite,
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            catalogBloc.add(RemoveFromWishListEvent(
                                contentId: table2.contentid));
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  bool isValidString(String val) {
//    print('validstrinh $val' ;
    if (val == null || val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  void addExpiryEvets(DummyMyCatelogResponseTable2 table2, int position) {
    evntModuleBloc
        .add(AddExpiryEvent(table2: table2, strContentID: table2.contentid));
  }

  void addToEnroll(DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.availableseats}');
    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == 'true' &&
        returnEventCompleted(table2.eventenddatetime)) {
      try {
        addExpiryEvets(table2, 0);
      } catch (e) {
        e.toString();
      }
    } else {
      int avaliableSeats = 0;
      avaliableSeats = table2.availableseats ?? 0;

      if (avaliableSeats > 0) {
        catalogBloc.add(
            AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      } else if (table2.viewtype == 1 || table2.viewtype == 2) {
        if (isValidString(table2.eventenddatetime) &&
            !returnEventCompleted(table2.eventenddatetime)) {
          if (isValidString(table2.actionwaitlist) &&
              table2.actionwaitlist == "true") {
            String alertMessage = appBloc.localstr
                .eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
            showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                      title: Text(
                        appBloc.localstr.eventsActionsheetEnrolloption,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(alertMessage),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5)),
                      actions: <Widget>[
                        new FlatButton(
                          child: Text(appBloc
                              .localstr.mylearningAlertbuttonCancelbutton),
                          textColor: Colors.blue,
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: Text(
                              appBloc.localstr.myskillAlerttitleStringconfirm),
                          textColor: Colors.blue,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            addToWaitList(table2);
                          },
                        ),
                      ],
                    ));
          } else {
            catalogBloc.add(AddToMyLearningEvent(
                contentId: table2.contentid, table2: table2));
          }
        }
//        (isValidString(table2.actionwaitlist) &&
//            table2.actionwaitlist == "true")

      } else {
        catalogBloc.add(
            AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    }
  }

  void addToWaitList(DummyMyCatelogResponseTable2 catalogModel) {
    evntModuleBloc.add(WaitingListEvent(
        strContentID: catalogModel.contentid, table2: catalogModel));
  }

  bool returnEventCompleted(String eventDate) {
    if (eventDate == null) return false;

    bool isCompleted = false;

    DateFormat sdf = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime? strDate;
    DateTime? currentdate;

    currentdate = sdf.parse(DateTime.now().toString());

    if (!isValidString(eventDate)) return false;

    try {
      var temp = new DateFormat("yyyy-MM-dd").parse(eventDate.split("T")[0]);
      strDate = sdf.parse(temp.toString());
    } catch (e) {
      print("catch");
      isCompleted = false;
    }
    if (strDate == null) {
      return false;
    }

    print("currentdate $currentdate");
    print("strDate $strDate");
    if (currentdate.isAfter(strDate)) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }

    return isCompleted;
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontSize: 24)),
                ),
              ),
            ],
          )
        : new Container();
  }

  void showCancelEnrollDialog(
      DummyMyCatelogResponseTable2 table2, String isSuccess) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
              title: Text(
                appBloc.localstr.mylearningAlerttitleStringareyousure,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(appBloc.localstr
                  .mylearningAlertsubtitleDoyouwanttocancelenrolledevent),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              actions: <Widget>[
                new FlatButton(
                  child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    cancelEnrollment(table2, isSuccess);
                  },
                ),
              ],
            ));
  }

  void cancelEnrollment(DummyMyCatelogResponseTable2 table2, String bool) {
    evntModuleBloc.add(TrackCancelEnrollment(
        isBadCancel: bool, strContentID: table2.contentid, table2: table2));
  }

  void badCancelEnrollmentMethod(DummyMyCatelogResponseTable2 table2) {
    evntModuleBloc
        .add(BadCancelEnrollment(contentid: table2.contentid, table2: table2));
  }
}
