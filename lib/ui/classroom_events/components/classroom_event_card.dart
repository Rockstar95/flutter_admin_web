import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../backend/app_controller.dart';
import '../../../framework/bloc/app/bloc/app_bloc.dart';
import '../../../framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import '../../../framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import '../../../framework/common/constants.dart';
import '../../../framework/common/enums.dart';
import '../../../framework/helpers/utils.dart';
import '../../../packages/smooth_star_rating.dart';
import '../../MyLearning/common_detail_screen.dart';
import '../../common/app_colors.dart';

enum ClassroomEventCardType {
  NORMAL, SCHEDULE
}

class ClassroomEventCard extends StatefulWidget {
  final DummyMyCatelogResponseTable2 table2;
  final MyLearningDetailsBloc detailsBloc;
  final String tabVal;
  final ClassroomEventCardType classroomEventCardType;
  final void Function(BuildContext, DummyMyCatelogResponseTable2)? onMoreTap;
  final void Function(DummyMyCatelogResponseTable2)? onBuyTap, onEnrollTap, onViewTap;

  const ClassroomEventCard({
    Key? key,
    required this.table2,
    required this.detailsBloc,
    this.tabVal = "",
    this.classroomEventCardType = ClassroomEventCardType.NORMAL,
    this.onMoreTap,
    this.onBuyTap,
    this.onEnrollTap,
    this.onViewTap,
  }) : super(key: key);

  @override
  State<ClassroomEventCard> createState() => _ClassroomEventCardState();
}

class _ClassroomEventCardState extends State<ClassroomEventCard> {
  late DummyMyCatelogResponseTable2 table2;
  late MyLearningDetailsBloc detailsBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  bool returnEventCompleted(String eventDate) {
    if (eventDate.isEmpty) return false;

    bool isCompleted = false;

    DateFormat sdf = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime? strDate;
    DateTime? currentdate;

    currentdate = sdf.parse(DateTime.now().toString());

    if (!AppDirectory.isValidString(eventDate)) return false;

    try {
      var temp = new DateFormat("yyyy-MM-dd").parse(eventDate.split("T")[0]);
      strDate = sdf.parse(temp.toString());
    }
    catch (e) {
      print("catch");
      isCompleted = false;
    }
    if (strDate == null) {
      return false;
    }

    if (currentdate.isAfter(strDate)) {
      isCompleted = true;
    }
    else {
      isCompleted = false;
    }

    return isCompleted;
  }

  String checkAvailableSeats(DummyMyCatelogResponseTable2 table2) {
    int avaliableSeats = 0;
    String seatVal = "";

    try {
      avaliableSeats = table2.availableseats;
    } catch (nf) {
      avaliableSeats = 0;
      //nf.printStackTrace();
    }
    if (avaliableSeats > 0) {
      seatVal = 'Available seats ${table2.availableseats}';
    } else if (avaliableSeats <= 0) {
      if (table2.enrollmentlimit == table2.noofusersenrolled &&
              table2.waitlistlimit == 0 ||
          (table2.waitlistlimit != -1 &&
              table2.waitlistlimit == table2.waitlistenrolls)) {
        seatVal = 'Enrollment Closed';
      } else if (table2.waitlistlimit != -1 &&
          table2.waitlistlimit != table2.waitlistenrolls) {
        int waitlistSeatsLeftout =
            (table2.waitlistlimit ?? 0) - (table2.waitlistenrolls);

        if (waitlistSeatsLeftout > 0) {
          seatVal = 'Full | Waitlist seats $waitlistSeatsLeftout';
        }
      }
    }

    return seatVal;
  }

  @override
  void initState() {
    this.table2 = widget.table2;
    this.detailsBloc = widget.detailsBloc;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    this.table2 = widget.table2;
    this.detailsBloc = widget.detailsBloc;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startTempDate = DateTime.now();
    try {
      //print("Date:${table2.eventstartdatedisplay}");
      if((table2.eventstartdatedisplay?.toString() ?? "").isNotEmpty) {
        startTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventstartdatedisplay);
      }
    }
    catch(e, s) {
      print("Error in Date Format Parsing:$e");
      print(s);
    }

    DateTime endTempDate = DateTime.now();
    try {
      //print("Date:${table2.eventenddatedisplay}");
      if((table2.eventenddatedisplay?.toString() ?? "").isNotEmpty) {
        endTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventenddatedisplay);
      }
    }
    catch(e, s) {
      print("Error in Date Format Parsing:$e");
      print(s);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      decoration: BoxDecoration(
        color: AppColors.getAppBGColor(),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: widget.classroomEventCardType == ClassroomEventCardType.NORMAL
          ? getNormalCard(startTempDate, endTempDate)
          : getScheduleCard(startTempDate, endTempDate),
    );
  }

  Widget getNormalCard(DateTime startDateTime, DateTime endDateTime) {
    String dateFormat = "MM/dd/yyyy hh:mm a";
    // MyPrint.printOnConsole('appBloc.uiSettingModel.dateFormat:${appBloc.uiSettingModel.eventDateTimeFormat}');
    // MyPrint.printOnConsole('appBloc.uiSettingModel.dateFormat:${DateFormat("MM/dd/yyyy hh:mm aa").format(DateTime.now())}');
    if(appBloc.uiSettingModel.eventDateTimeFormat.isNotEmpty) {
      dateFormat = appBloc.uiSettingModel.eventDateTimeFormat.replaceAll("tt", "a");
    }

    String startDate = DateFormat(dateFormat).format(startDateTime);
    String endDate = DateFormat(dateFormat).format(endDateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getImageWidget(),
        Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getContentNameDescriptionAndMoreOptionsRow(),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              getAuthorDetailsAndAvailableSeatsRow(),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              getRatingsAndReviewWidget(),
              getShortDescriptionWidget(),
              getDateWidget("Start Date :  ", startDate.toUpperCase()),
              SizedBox(height: 8),
              getDateWidget("End Date :    ", endDate.toUpperCase()),
              /*SizedBox(height: 8),
              getDateWidget("Time Zone : ", ParsingHelper.parseStringMethod(table2.timezone)),
              SizedBox(height: 8),
              getDateWidget("Location :     ", table2.locationname),*/
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              getPrimaryActionWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget getScheduleCard(DateTime startDateTime, DateTime endDateTime) {
    String dateFormat = "MM/dd/yyyy hh:mm a";
    //MyPrint.printOnConsole('appBloc.uiSettingModel.dateFormat:${appBloc.uiSettingModel.dateFormat}');
    // if(appBloc.uiSettingModel.dateFormat.isNotEmpty) {
    //   dateFormat = appBloc.uiSettingModel.dateFormat;
    // }

    String startDate = DateFormat(dateFormat).format(startDateTime);
    String endDate = DateFormat(dateFormat).format(endDateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //getImageWidget(),
        Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              getContentNameDescriptionAndMoreOptionsRow(),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              getAuthorDetailsAndAvailableSeatsRow(),
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              getRatingsAndReviewWidget(),
              getShortDescriptionWidget(),
              getDateWidget("Start Date :  ", startDate),
              SizedBox(height: 8),
              getDateWidget("End Date :    ", endDate.toUpperCase()),
              /*SizedBox(height: 8),
              getDateWidget("Time Zone : ", ParsingHelper.parseStringMethod(table2.timezone)),
              SizedBox(height: 8),
              getDateWidget("Location :     ", table2.locationname),*/
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              getPrimaryActionWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget getImageWidget() {
    String thumbnailPath = table2.thumbnailimagepath.startsWith("http")
        ? table2.thumbnailimagepath.trim()
        : table2.siteurl + table2.thumbnailimagepath.trim();

    String contentIconPath = table2.iconpath;

    if (AppDirectory.isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.azureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    }
    else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    bool isCheckEventRelatedContent = false;
    bool isDetailsOptionEnabled = false;

    print("relatedconentcount ${table2.relatedconentcount}");
    print("isaddedtomylearning ${table2.isaddedtomylearning}");
    if (table2.isaddedtomylearning == 1) {
      if (table2.relatedconentcount != 0) {
        isCheckEventRelatedContent = true;
      }
      isDetailsOptionEnabled = true;
    }
    else {
      if (table2.viewtype == 1) {
        isCheckEventRelatedContent = false;
        isDetailsOptionEnabled = true;

        print('actionwaitlist ${table2.viewtype} ${table2.actionwaitlist}');
      }
      else if (table2.viewtype == 2) {
        isCheckEventRelatedContent = false;
        isDetailsOptionEnabled = true;
      }
      else if (table2.viewtype == 3) {
        isCheckEventRelatedContent = false;
        isDetailsOptionEnabled = true;
      }
    }
    print("isaddedtomylearning upendra ${table2.isaddedtomylearning}");

    print("isaddedtomylearning om ${table2.isaddedtomylearning}");
    print("returnEventCompleted om ${returnEventCompleted(table2.eventenddatetime ?? "")}");
    print("AllowExpiredEventsSubscription om ${appBloc.uiSettingModel.allowExpiredEventsSubscription}");

    // expired event functionality
    if (AppDirectory.isValidString(table2.eventenddatetime ?? "") && returnEventCompleted(table2.eventenddatetime ?? "")) {
      if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
        if (table2.isaddedtomylearning == 1) {
          if (table2.relatedconentcount != 0) {
            isCheckEventRelatedContent = true;
          }
        }
        isDetailsOptionEnabled = true; //detail
      }
    }

    return Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(kCellThumbHeight),
          child: InkWell(
            onTap: () {
              if (isCheckEventRelatedContent) {
                AppController().checkRelatedContent(context: context, table2: table2, isTrackList: false);
              }
              else if (isDetailsOptionEnabled) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommonDetailScreen(
                      screenType: ScreenType.Events,
                      contentid: table2.contentid,
                      objtypeId: table2.objecttypeid,
                      detailsBloc: detailsBloc,
                      table2: table2,
                      isFromReschedule: false,
                    ),
                ));
              }
            },
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
              errorWidget: (context, url, error) => Image.asset(
                'assets/cellimage.jpg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            ),
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
                    )),
              ),
          ),
        ),
      ],
    );
  }

  Widget getContentNameDescriptionAndMoreOptionsRow() {
    return Row(
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
                table2.name,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if(widget.onMoreTap != null) {
              widget.onMoreTap!(context, table2);
            }
          },
          child: Icon(
            Icons.more_vert,
            color: AppColors.getAppTextColor(),
          ),
        ),
      ],
    );
  }

  Widget getAuthorDetailsAndAvailableSeatsRow() {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
    //print("Id:${table2.contentid}, isWishlist:${table2.iswishlistcontent}");

    return Row(
      children: <Widget>[
        new Container(
            width: ScreenUtil().setWidth(20),
            height: ScreenUtil().setWidth(20),
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(imgUrl),
                ),
            ),
        ),
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
        SizedBox(
          width: ScreenUtil().setWidth(5),
        ),
        Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
          height: 10.h,
          width: 1.h,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(5),
        ),
        Expanded(
          child: Text(checkAvailableSeats(table2),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
                color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                    .withOpacity(0.5),
              ),
          ),
        )
      ],
    );
  }

  Widget getRatingsAndReviewWidget() {
    bool isratingbarVissble = false;
    bool isReviewVissble = false;

    double ratingRequired = double.tryParse(appBloc.uiSettingModel.minimumRatingRequiredToShowRating) ?? 0;

    if (table2.totalratings >= (int.tryParse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) ?? 0) && table2.ratingid >= ratingRequired) {
      isReviewVissble = false;
      isratingbarVissble = true;
    }

    return Row(
      children: <Widget>[
        isratingbarVissble
            ? SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {},
                starCount: 5,
                rating: table2.ratingid,
                size: ScreenUtil().setHeight(16),
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
                    /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReviewScreen(
                            table2.contentid,
                            false,
                            myLearningDetailsBloc)));*/
                  },
                  child: Text(
                    "See Reviews".toUpperCase(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
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
    );
  }

  Widget getShortDescriptionWidget() {
    if(table2.shortdescription.trim().isEmpty) {
      return SizedBox();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        table2.shortdescription,
        maxLines: 2,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(13),
            color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                .withOpacity(0.5)),
      ),
    );
  }

  Widget getDateWidget(String title, String date) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
                color: AppColors.getAppTextColor().withOpacity(0.8),
            ),
          ),
          Text(
            date,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
          )
        ],
      ),
    );
  }

  Widget getPrimaryActionWidget() {
    if(table2.isaddedtomylearning == 1) {
      return getViewButton();
    }
    else {
      if(table2.viewtype == 3) {
        return getBuyButton();
      }
      else if(AppDirectory.isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
        return getEnrollButton();
      }
      else {
        return getViewButton();
      }
    }
  }

  Widget getViewButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FlatButton.icon(
              color: AppColors.getAppButtonBGColor(),
              padding: EdgeInsets.symmetric(vertical: 10),
              icon: Icon(
                IconDataSolid(int.parse('0xf570')),
                color: AppColors.getAppButtonTextColor(),
                size: 20.h,
              ),
              label: Text(
                appBloc.localstr.eventsActionsheetDetailsoption,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  color: AppColors.getAppButtonTextColor(),
                ),
              ),
              onPressed: () async {
                if(widget.onViewTap != null) {
                  widget.onViewTap!(table2);
                }
              },
            ),
          ),
        ],
      );
  }

  Widget getBuyButton() {
    return Row(
      children: <Widget>[
        // commented till offline integration done
        Text(
          " ${table2.saleprice} \$",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.normal,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(140),
        ),
        Expanded(
          child: FlatButton.icon(
            color: AppColors.getAppButtonBGColor(),
            icon: Icon(
              IconDataSolid(int.parse('0x${"f155"}')),
              color: AppColors.getAppButtonTextColor(),
            ),
            label: Text(
              appBloc.localstr.detailsButtonBuybutton.toUpperCase(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: AppColors.getAppButtonTextColor(),
              ),
            ),
            onPressed: () async {
              if(widget.onBuyTap != null) {
                widget.onBuyTap!(table2);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget getEnrollButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FlatButton.icon(
            color: AppColors.getAppButtonBGColor(),
            padding: EdgeInsets.symmetric(vertical: 10),
            icon: Icon(
              IconDataSolid(int.parse('0x${"f271"}')),
              color: AppColors.getAppButtonTextColor(),
              size: 20.h,
            ),
            label: Text(
              "Enroll Now",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: AppColors.getAppButtonTextColor(),
              ),
            ),
            onPressed: () async {
              if(widget.onEnrollTap != null) {
                widget.onEnrollTap!(table2);
              }
            },
          ),
        ),
      ],
    );
  }
}
