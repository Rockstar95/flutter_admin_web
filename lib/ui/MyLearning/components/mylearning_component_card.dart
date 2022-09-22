import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/models/my_learning/download_feature/mylearning_download_model.dart';
import 'package:flutter_admin_web/packages/percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/providers/my_learning_download_provider.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../configs/constants.dart';
import '../../common/app_colors.dart';

class MyLearningComponentCard extends StatefulWidget {
  final DummyMyCatelogResponseTable2 table2;
  final DummyMyCatelogResponseTable2? trackModel;
  final String trackContentId, trackContentName;
  final bool isArchive, isDownloadCard, isTrackContent, isShowTrackName, isShowLock, isShowMoreOption;
  final void Function()? onArchievedTap, onMoreTap, onReviewTap, onViewTap, onDownloadPaused, onDownloading, onDownloaded, onNotDownloaded;

  const MyLearningComponentCard({
    Key? key,
    required this.table2,
    this.trackModel,
    this.trackContentId = "",
    this.trackContentName = "",
    this.isArchive = false,
    this.isDownloadCard = false,
    this.isTrackContent = false,
    this.isShowTrackName = false,
    this.isShowLock = false,
    this.isShowMoreOption = true,
    this.onArchievedTap,
    this.onMoreTap,
    this.onReviewTap,
    this.onViewTap,
    this.onDownloadPaused,
    this.onDownloading,
    this.onDownloaded,
    this.onNotDownloaded,
  }) : super(key: key);

  @override
  State<MyLearningComponentCard> createState() => _MyLearningComponentCardState();
}

class _MyLearningComponentCardState extends State<MyLearningComponentCard> {
  bool isFirst = true;
  late AppBloc appBloc;

  bool isDownloaded = false;
  bool isDownloading = false;
  bool isDownloadPaused = false;
  bool isZipFile = false;
  bool isDownloadFileExtracted = false;
  double downloadprogress = 1;

  GlobalKey widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    //MyPrint.printOnConsole("New Size in Callback:${newSize}");
    //if(newSize != null) MyPrint.printOnConsole("New Size in Callback:{Width:${newSize.width}, Height:${newSize.height}}");
    //if(newSize != null) MyPrint.printOnConsole("Old Size in Callback:{Width:${oldSize?.width}, Height:${oldSize?.height}}");
    /*if(widget.userModel.id == "XQFFkZlFQRGYrgjl7sRl") {
      MyPrint.printOnConsole("New Size in Callback:${newSize}");
      if(newSize != null) MyPrint.printOnConsole("New Size in Callback:{Width:${newSize.width}, Height:${newSize.height}");
    }*/

    if(newSize == null) {
      return;
    }

    if (oldSize != null && oldSize!.height == newSize.height && oldSize!.width == newSize.width) return;

    MyPrint.printOnConsole("Going To Resize");
    oldSize = Size(newSize.width, newSize.height);
    setState(() {});
  }

  bool isValidString(String val) {
//    print('validstrinh $val');
    if (val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  void checkRelatedContent(DummyMyCatelogResponseTable2 table2) {
    if (isValidString(table2.viewprerequisitecontentstatus ?? "")) {
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      String status = table2.viewprerequisitecontentstatus?.toString() ?? "";
      String prerequisite = appBloc.localstr.prerequistesalerttitle5Alerttitle7;
      alertMessage = '$alertMessage \"$status\" $prerequisite';

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            appBloc.localstr.detailsAlerttitleStringalert,
            style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            alertMessage,
            style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
            ),
          ),
          backgroundColor: InsColor(appBloc).appBGColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
              style: getButtonStyle(),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => EventTrackList(
            table2,
            false,
            [],
          ),
        ),
      )
          .then((value) {
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    appBloc = BlocProvider.of<AppBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*if(isFirst) {
      isFirst = false;
      downloadPercentage = 0;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        while(downloadPercentage.toInt() != 1) {
          print("old downloadPercentage:${downloadPercentage}");
          downloadPercentage = roundTo(downloadPercentage + 0.1, 10);
          print("new downloadPercentage:${downloadPercentage}");
          setState(() {});
          await Future.delayed(Duration(seconds: 1));
        }
      });
    }*/

    if(isFirst) {
      isFirst = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        postFrameCallback(null);
      });
    }

    return Consumer<MyLearningDownloadProvider>(
      builder: (BuildContext context, MyLearningDownloadProvider myLearningDownloadProvider, Widget? child) {
        String authorImageUrl = 'https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg';

        int objecttypeId = widget.table2.objecttypeid;
        String actualstatus = widget.table2.actualstatus;

        bool isratingbarVissble = false;
        bool isReviewVissble = false;

        double ratingRequired = 0;
        Color statuscolor = Color(0xff5750da);

        //MyPrint.printOnConsole("Content Id:${widget.table2.contentid}, Name:${widget.table2.name}, Status:${widget.table2.corelessonstatus}");
        //widget.table2.corelessonstatus = "Not Started";
        //MyPrint.printOnConsole("Is Failed:${widget.table2.corelessonstatus.toString() == 'Completed (failed)'}");

        if (widget.table2.corelessonstatus.toString().toLowerCase() == 'completed') {
          statuscolor = Color(0xff4ad963);
        }
        else if (['completed(passed)', 'completed (passed)'].contains(widget.table2.corelessonstatus.toString().toLowerCase())) {
          statuscolor = Color(0xff4ad963);
        }
        else if (['completed(failed)', 'completed (failed)'].contains(widget.table2.corelessonstatus.toString().toLowerCase())) {
          MyPrint.printOnConsole("Got In Completed (failed)");
          statuscolor = Color(0xfffe2c53);
        }
        else if (widget.table2.corelessonstatus.toString().toLowerCase() == 'not started') {
          statuscolor = Color(0xfffe2c53);
        }
        else if (widget.table2.corelessonstatus.toString().toLowerCase() == 'in progress') {
          statuscolor = Color(0xffff9503);
        }

        try {
          ratingRequired = double.parse(appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
        }
        catch (e) {
          ratingRequired = 0;
        }

        if (widget.table2.totalratings >= int.parse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) && widget.table2.ratingid >= ratingRequired) {
          isReviewVissble = false;
          isratingbarVissble = true;
        }

        if (objecttypeId != 70 && actualstatus.toLowerCase().contains('completed') || actualstatus == 'passed' || actualstatus == 'failed') {
          isratingbarVissble = true;
          isReviewVissble = true;
        }
        else if (actualstatus.toLowerCase().contains('completed') && objecttypeId == 70) {
          isratingbarVissble = false;
          isReviewVissble = false;
        }
        else if (actualstatus == 'attended' && objecttypeId == 70) {
          isratingbarVissble = false;
          isReviewVissble = true;
        }

        bool isExpired = false;
        if (widget.table2.expirydate != null) {
          DateTime tempDate = DateTime.now();
          try {
            tempDate = DateFormat('yyyy-MM-ddThh:mm:ss').parse(widget.table2.expirydate);
          }
          catch(e, s) {
            print("Error in Parsing Date in MyLearningComponent Card:$e");
            print(s);
          }
          String dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDate);
          try {
            dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDate);
          }
          catch(e, s) {
            print("Error in Parsing Date in MyLearningComponent Card:$e");
            print(s);
          }

          //var isExpire = tempDate.isAfter(DateTime.now());
          isExpired = tempDate.isBefore(DateTime.now());
          print(dateStr);
          print(DateTime.now());
          print(isExpired);
          if (isExpired) {
            statuscolor = Color(0xfffe2c53);
          }
          //print(isExpire);
        }

        String contentIconPath = widget.table2.iconpath;

        if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
          contentIconPath = contentIconPath.startsWith('http')
              ? widget.table2.iconpath
              : appBloc.uiSettingModel.azureRootPath + widget.table2.iconpath;

          contentIconPath = contentIconPath.toLowerCase().trim();
        }
        else {
          contentIconPath = widget.table2.siteurl + contentIconPath;
        }

        //region download related tasks
        isDownloaded = widget.table2.isdownloaded;
        isDownloading = widget.table2.isDownloading;
        isDownloadPaused = false;
        isZipFile = false;
        isDownloadFileExtracted = false;
        downloadprogress = 1;

        List<MyLearningDownloadModel> downloadsList = myLearningDownloadProvider.downloads.where((element) {
          String contentId = widget.table2.contentid;
          if(widget.isTrackContent) {
            contentId = "${widget.trackContentId}_${widget.table2.contentid}";
          }
          return element.contentId == contentId && element.isTrackContent == widget.isTrackContent;
        }).toList();
        /*if(widget.table2.contentid == "28875c3e-0c07-4618-8d9a-5b425365f629") {
          MyPrint.printOnConsole("downloadsList length:${downloadsList.length}");
          MyPrint.printOnConsole("isDownloaded:${isDownloaded}");
        }*/

        // MyPrint.printOnConsole("isFileDownloaded for contentId:${widget.table2.contentid}, ${widget.table2.name}, objectType:${widget.table2.objecttypeid}");
        if(downloadsList.isNotEmpty) {
          MyLearningDownloadModel myLearningDownloadModel = downloadsList.first;

          // MyPrint.printOnConsole("isFileDownloaded for contentId:${myLearningDownloadModel.contentId}, ${myLearningDownloadModel.table2.name}, objectType:${myLearningDownloadModel.table2.objecttypeid}:${myLearningDownloadModel.isFileDownloaded}");

          isDownloaded = myLearningDownloadModel.isFileDownloaded;
          isZipFile = myLearningDownloadModel.isZip && myLearningDownloadModel.taskId.isNotEmpty;
          isDownloadFileExtracted = isZipFile && myLearningDownloadModel.isFileExtracted;
          /*if(!myLearningDownloadModel.isFileDownloading) {
            isDownloading = myLearningDownloadModel.isFileDownloading;
          }*/
          isDownloading = myLearningDownloadModel.isFileDownloading;
          if(isDownloading) {
            isDownloading = myLearningDownloadModel.taskId.isNotEmpty;
          }
          isDownloadPaused = myLearningDownloadModel.isFileDownloadingPaused && myLearningDownloadModel.taskId.isNotEmpty;
          /*if(myLearningDownloadModel.taskId == "c7a85690-c966-4285-89c2-4798e02b3277") {
              isDownloadPaused = true;
            }*/
          downloadprogress = myLearningDownloadModel.taskId.isNotEmpty ? MyUtils.roundTo(myLearningDownloadModel.downloadPercentage / 100, 100) : 1;
          downloadprogress = downloadprogress < 0 ? 0 : downloadprogress;

          /*if(myLearningDownloadModel.table2.contentid == "cc75fbcc-7f84-45c1-a737-f4022dc6a242") {
            MyPrint.printOnConsole("----\ntable2.isdownloaded:${widget.table2.isdownloaded}");
            MyPrint.printOnConsole("table2.isDownloading:${widget.table2.isDownloading}");
            MyPrint.printOnConsole("myLearningDownloadModel.isFileDownloading:${myLearningDownloadModel.isFileDownloading}");
            MyPrint.printOnConsole("myLearningDownloadModel.isFileDownloaded:${myLearningDownloadModel.isFileDownloaded}");
            MyPrint.printOnConsole("myLearningDownloadModel.isFileDownloadingPaused:${myLearningDownloadModel.isFileDownloadingPaused}\n-----");
          }*/

          // print("Download Status:${myLearningDownloadModel.downloadStatus}");
          // print("isDownloaded:$isDownloaded, Name:${widget.table2.name}");

          //table2.isdownloaded = isDownloaded;
          //table2.isDownloading = isDownloading;
        }
        //endregion download related tasks

        if(widget.isDownloadCard) {
          return Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            height: 150.h + (widget.trackContentName.isEmpty ? 0 : 20.h),
            child: Card(
              color: InsColor(appBloc).appBGColor,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(int.parse('0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),),
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: Column(
                  children: [
                    getTrackName(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getContentImageWidget(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  InkWell(
                                    onTap: isExpired
                                        ? null
                                        : () async {
                                      if(widget.onViewTap != null) {
                                        widget.onViewTap!();
                                      }
                                    },
                                    child: Text(
                                      widget.table2.name,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          color: Color(int.parse(
                                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(5),),
                                  getContentTypeWidget(widget.table2.medianame),
                                  SizedBox(height: ScreenUtil().setHeight(5),),
                                  Expanded(child: getContentShortDescriptionWidget()),
                                  SizedBox(height: ScreenUtil().setHeight(5),),
                                  getContentAuthorNameWidget(),
                                  SizedBox(height: ScreenUtil().setHeight(5),),
                                ],
                              ),
                            ),
                            SizedBox(width: 5,),
                            getMoreButton(isExpired),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else {
          return Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Card(
              color: InsColor(appBloc).appBGColor,
              elevation: 4,
              child: Container(
                child: Stack(
                  // fit: StackFit.expand,
                  fit: StackFit.loose,
                  children: [
                    Container(
                      key: widgetKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          getTrackName(),
                          getHeaderWidget(),
                          Stack(
                            children: [
                              Container(
                                //color: Colors.red,
                                child: Column(
                                  children: [
                                    getCourseProgressIndicatorWidget(statuscolor),
                                    Stack(
                                      children: <Widget>[
                                        getContentThumbnailImageWidget(isExpired),
                                        Positioned.fill(
                                          child: getContentTypeIcon(contentIconPath),
                                        ),
                                        Positioned(
                                          top: 15,
                                          left: 15,
                                          child: getContentStatusWidget(statuscolor, isExpired),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30.w,),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 10,
                                child: displayDownloadButton(widget.table2),
                              ),
                            ],
                          ),
                          Container(
                            color: isExpired
                                ? Color(int.parse('0xFF${appBloc.uiSettingModel.expiredBGColor.substring(1, 7).toUpperCase()}')).withOpacity(0.8)
                                : Color(int.parse('0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
                            padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                getContentNameAndMoreActionWidget(isExpired),
                                SizedBox(height: ScreenUtil().setHeight(10),),
                                getContentAuthorDetailsWidget(
                                  authorImageUrl: authorImageUrl,
                                  authorName: widget.table2.objecttypeid == 70
                                      ? (widget.table2.presenter?.toString() ?? "")
                                      : (widget.table2.author.isNotEmpty
                                          ? widget.table2.author
                                          : (widget.table2.authordisplayname.isNotEmpty ? widget.table2.authordisplayname : widget.table2.contentauthordisplayname)
                                        ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(3),),
                                getContentReviewAndRatingWidget(
                                  isExpired: isExpired,
                                  isratingbarVissble: isratingbarVissble,
                                  isReviewVissble: isReviewVissble,
                                ),
                                SizedBox(height: ScreenUtil().setHeight(2),),
                                getContentSiteNameWidget(),
                                SizedBox(height: ScreenUtil().setHeight(2),),
                                getContentShortDescriptionWidget(),
                                SizedBox(height: ScreenUtil().setHeight(10),),
                                isExpired ? Container() : getContentActionPanel(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(widget.isShowLock && widget.table2.wstatus == "disabled") getLockWidget(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget getLockWidget() {
    double margin = 20;

    Size size = Size(0, 430);

    return Container(
      color: Colors.white24.withOpacity(0.4),
      alignment: Alignment.topRight,
      height: (oldSize ?? size).height,
      padding: EdgeInsets.only(top: margin, right: margin,),
      child: Icon(Icons.lock_outline, size: 30,),
    );
  }

  //region My Learning Card Normal
  Widget getHeaderWidget() {
    if(widget.isArchive || (widget.table2.headerlocationname == '')) {
      return Container();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.table2.headerlocationname,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  //region Image Stack
  Widget getContentThumbnailImageWidget(bool isExpired) {
    return InkWell(
      onTap: isExpired
          ? null
          : () async {
        print('ontitemtapp ${widget.table2.objecttypeid} ${widget.table2.relatedconentcount}');
        if (isValidString(widget.table2.viewprerequisitecontentstatus ?? '')) {
//                        print('ifdataaaaa');
          String alertMessage = appBloc
              .localstr.prerequistesalerttitle6Alerttitle6;
          alertMessage = alertMessage +
              '  \"' +
              appBloc
                  .localstr.prerequisLabelContenttypelabel +
              '\" ' +
              appBloc.localstr
                  .prerequistesalerttitle5Alerttitle7;

          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  appBloc.localstr
                      .detailsAlerttitleStringalert,
                  style: TextStyle(
                      color: Color(
                        int.parse(
                            '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                      ),
                      fontWeight: FontWeight.bold),
                ),
                content: Text(
                  alertMessage,
                  style: TextStyle(
                      color: Color(
                        int.parse(
                            '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                      )),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(5)),
                actions: <Widget>[
                  TextButton(
                    child: Text(appBloc.localstr
                        .eventsAlertbuttonOkbutton),
                    style: getButtonStyle(),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
        }
        else {
          if(widget.onViewTap != null) {
            widget.onViewTap!();
          }
        }
      },
      child: Container(
        height: ScreenUtil().setHeight(kCellThumbHeight),
        child: CachedNetworkImage(
          imageUrl: widget.table2.thumbnailimagepath.startsWith('http')
              ? widget.table2.thumbnailimagepath
              : widget.table2.siteurl + widget.table2.thumbnailimagepath,
          width: MediaQuery.of(context).size.width,
          //placeholder: (context, url) => CircularProgressIndicator(),
          placeholder: (context, url) => Image.asset(
            'assets/cellimage.jpg',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/cellimage.jpg',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        ),

        /*child: Image.network(
                      'https://qa.instancy.com'+widget.table2.thumbnailimagepath,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),*/

        /*decoration:  BoxDecoration(

                        image:  DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          image: AssetImage(
                            'https://qa.instancy.com'+widget.table2.thumbnailimagepath,
                          ),
                        )
                    ),*/
      ),
    );
  }

  Widget getContentTypeIcon(String contentIconPath) {
    return Align(
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
              )
            //     Icon(
            //   widget.table2.objecttypeid == 14
            //       ? Icons.picture_as_pdf
            //       : (widget.table2.objecttypeid == 11
            //           ? Icons.video_library
            //           : Icons.format_align_justify),
            //   color: Colors.white,
            //   size: ScreenUtil().setHeight(30),
            // ),
          ),
        ));
  }

  Widget getContentStatusWidget(Color statuscolor, bool isExpired) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF007BFF),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(5),
          bottom: ScreenUtil().setWidth(5),
          left: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10)),
      child: Text(
        isExpired
            ? 'Expired'
            : widget.table2.corelessonstatus.toString(),
        style: TextStyle(
            fontSize: ScreenUtil().setSp(10),
            color: Colors.white),
      ),
    );
  }
  //endregion Image Stack

  Widget getCourseProgressIndicatorWidget(Color statuscolor) {
    return LinearProgressIndicator(
      value: isValidString(widget.table2.progress)
          ? double.parse(widget.table2.progress) / 100
          : 0.0,
      valueColor: AlwaysStoppedAnimation<Color>(statuscolor),
      backgroundColor: Colors.grey,
    );
  }

  Widget getContentNameAndMoreActionWidget(bool isExpired) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.table2.medianame,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(13),
                    color: AppColors.getAppTextColor().withOpacity(0.5) ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              InkWell(
                onTap: isExpired
                    ? null
                    : () async {
                  if(widget.onViewTap != null) {
                    widget.onViewTap!();
                  }
                },
                child: Text(
                  widget.table2.name,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(15),
                      color: Color(int.parse(
                          '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))),
                ),
              ),
            ],
          ),
        ),
        widget.isArchive && isExpired
            ? GestureDetector(
                onTap: isExpired
                    ? null
                    : () {
                  if(widget.onArchievedTap != null) {
                    widget.onArchievedTap!();
                  }
                  /*myLearningBloc.add(RemovetoArchiveCall(
                                    isArchive: false,
                                    strContentID: widget.table2.contentid));*/
                },
                child: Icon(
                  Icons.archive,
                  color: InsColor(appBloc).appIconColor,
                  size: ScreenUtil().setHeight(30),
                ),
              )
            : getMoreButton(isExpired),
      ],
    );
  }

  Widget getContentAuthorDetailsWidget({required String authorImageUrl, required String authorName}) {
    return Row(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(20),
          height: ScreenUtil().setWidth(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(authorImageUrl),
            ),
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(5),),
        Text(
          authorName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(13),
            color: AppColors.getAppTextColor().withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget getContentReviewAndRatingWidget({required bool isratingbarVissble, required bool isReviewVissble, required bool isExpired}) {
    return Row(
      children: <Widget>[
        isratingbarVissble
            ? SmoothStarRating(
            allowHalfRating: false,
            onRatingChanged: (v) {},
            starCount: 5,
            rating: widget.table2.ratingid,
            size: ScreenUtil().setHeight(20),
            // filledIconData: Icons.blur_off,
            // halfFilledIconData: Icons.blur_on,
            color: Colors.orange,
            borderColor: Colors.orange,
            spacing: 0.0)
            : Container(),
        SizedBox(
          width: ScreenUtil().setWidth(5),
        ),
        isReviewVissble
            ? Expanded(
          child: GestureDetector(
            onTap: isExpired
                ? null
                : () {
              if(widget.onReviewTap != null) {
                widget.onReviewTap!();
              }
            },
            child: Text(
              appBloc.localstr.mylearningButtonReviewbutton,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(12),
                  color: Color(int.parse(
                      '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}'))),
            ),
          ),
        )
            : Container()
      ],
    );
  }

  Widget getContentSiteNameWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 1.0, right: 1.0),
      child: Text(
        widget.table2.sitename,
        style: TextStyle(
          color: Color(0xff34aadc),
        ),
      ),
    );
  }

  Widget getContentShortDescriptionWidget() {
    return Text(
      widget.table2.shortdescription,
      maxLines: 2,
      style: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          color: Color(int.parse(
              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'))
              .withOpacity(0.5)),
    );
  }

  Widget getContentActionPanel() {
    return Row(
      children: <Widget>[
        displayViewTile(widget.table2),
        SizedBox(
          width: 10.w,
        ),
        displayPlayTile(widget.table2)
      ],
    );
  }
  //endregion My Learning Card Normal

  //region My Learning Download Card
  Widget getContentImageWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, ),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(right: 10),
      height: ScreenUtil().setHeight(100),
      child: AspectRatio(
        aspectRatio: 11/9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              InkWell(
                onTap: () {
                  if(isDownloaded && widget.onViewTap != null) {
                    widget.onViewTap!();
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: widget.table2.thumbnailimagepath.startsWith('http')
                      ? widget.table2.thumbnailimagepath
                      : widget.table2.siteurl + widget.table2.thumbnailimagepath,
                  //placeholder: (context, url) => CircularProgressIndicator(),
                  placeholder: (context, url) => Image.asset(
                    'assets/cellimage.jpg',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/cellimage.jpg',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              displayDownloadButton(widget.table2),
            ],
          ),
        ),
      ),

      /*child: Image.network(
                      'https://qa.instancy.com'+widget.table2.thumbnailimagepath,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),*/

      /*decoration:  BoxDecoration(

                        image:  DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          image: AssetImage(
                            'https://qa.instancy.com'+widget.table2.thumbnailimagepath,
                          ),
                        )
                    ),*/
    );
  }

  Widget getContentTypeWidget(String type) {
    return Container(
      child: Text(
        type,
        maxLines: 1,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(12),
            color: Color(int.parse(
                '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')).withOpacity(0.5)),
      ),
    );
  }

  Widget getContentAuthorNameWidget() {
    String authorName = widget.table2.objecttypeid == 70
        ? widget.table2.presenter
        : (widget.table2.author.isNotEmpty
        ? widget.table2.author
        : (widget.table2.authordisplayname.isNotEmpty ? widget.table2.authordisplayname : widget.table2.contentauthordisplayname)
    );

    return Container(
      child: Text(
        "By $authorName",
        maxLines: 1,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            color: Color(int.parse(
                '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}')).withOpacity(0.5)),
      ),
    );
  }

  Widget getMoreButton(bool isExpired) {
    if(!widget.isShowMoreOption) {
      return SizedBox();
    }
    return GestureDetector(
      onTap: isExpired
          ? null
          : () {
        if(widget.onMoreTap != null) {
          widget.onMoreTap!();
        }
        //_settingMyCourceBottomSheet(context, widget.table2, i);
      },
      child: isExpired
          ? Container()
          : Icon(
        Icons.more_vert,
        color: InsColor(appBloc).appIconColor,
      ),
    );
  }
  //endregion My Learning Download Card


  Widget getTrackName() {
    if(widget.isShowTrackName && widget.trackContentName.isNotEmpty) {
      return Container(
        // margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Color(int.parse('0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.trackContentName,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(11.h),
                color: Color(int.parse('0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
    else {
      return SizedBox();
    }
  }

  //region Action Panel
  Widget displayDownloadButton(DummyMyCatelogResponseTable2 table2) {
    //table2.isdownloaded = false;
    //table2.isDownloading = false;
    //Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false).downloads.clear();
    //print('isdownloaded ${table2.isdownloaded}');

    // String buttonText = appBloc.localstr.mylearningActionsheetDownloadoption.toUpperCase();
    // if (table2.isdownloaded) {
    //   buttonText = 'DOWNLOADED';
    // }
    // else if (table2.isDownloading) {
    //   buttonText = 'DOWNLOADING';
    // }

    //if ([8, 9, 10, 26, 52, 102].contains(table2.objecttypeid) || (table2.objecttypeid == 11)) {
    if (AppConstants.downloadableContentIds.contains(table2.objecttypeid)) {
      IconData iconData;
      Function? callback;
      Color color;

      if(isDownloadPaused) {
        iconData = Icons.play_arrow;
        callback = widget.onDownloadPaused;
      }
      else {
        if(isDownloading) {
          iconData = Icons.pause;
          callback = widget.onDownloading;
        }
        else {
          if(isDownloaded) {
            iconData = Icons.download_done_outlined;
            callback = widget.onDownloaded;
          }
          else {
            if(isZipFile) {
              if(isDownloadFileExtracted) {
                iconData = Icons.download_rounded;
                callback = widget.onNotDownloaded;
              }
              else {
                iconData = Icons.folder_zip;
              }
            }
            else {
              iconData = Icons.download_rounded;
              callback = widget.onNotDownloaded;
            }
          }
        }
      }

      if(isDownloading || isDownloaded) {
        color = Color(int.parse('0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}'));
      }
      else {
        color = Colors.grey;
      }

      if(widget.isDownloadCard) {
        if(isDownloaded) {
          return SizedBox();
        }

        return Container(
          color: Colors.black45,
          child: Center(
            child: InkWell(
              onTap: () async {
                if(callback != null) {
                  callback();
                }
              },
              child: CircularPercentIndicator(
                radius: 24.0,
                lineWidth: 2.0,
                percent: downloadprogress,
                center: Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    iconData,
                    size: 22.w,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.white,
                progressColor: color,
              ),
            ),
          ),
        );
      }
      else {
        return InkWell(
          onTap: () async {
            MyPrint.printOnConsole("Download Tapped in MyLearning Card");
            if(callback != null) {
              callback();
            }
            /*if(isDownloaded) {
                *//*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OfflineContentLauncherInAppWebview(
                      table2: table2,
                    ),
                  ),
                );*//*
              }
              else {
                if(isDownloading) {

                }
                else {
                  setState(() {
                    table2.isDownloading = true;
                  });

                  bool isDownloaded = await MyLearningController().storeMyLearningContentOffline(context, table2, appBloc.userid);
                  setState(() {
                    table2.isdownloaded = isDownloaded;
                    table2.isDownloading = false;
                  });
                }
              }*/
          },
          child: CircularPercentIndicator(
            radius: 26.0,
            lineWidth: 4.0,
            percent: downloadprogress,
            center: Container(
              padding: EdgeInsets.all(10.w),
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                /*border: Border.all(
              width: 2,
              color: Color(int.parse('0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
            ),*/
              ),
              child: Icon(
                iconData,
                size: 26.w,
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            progressColor: color,
          ),
        );
      }
      /*return Expanded(
        child: GestureDetector(
          child: Container(
            height: 38,
            width: 1.0.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: table2.isdownloaded
                  ? Color(int.parse(
                  '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}'))
                  .withOpacity(0.5)
                  : Color(int.parse(
                  '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                table2.isDownloading
                    ? SpinKitRing(
                  color: Color(
                    int.parse(
                        '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}'),
                  ),
                  size: 18,
                  lineWidth: 2.0,
                )
                    : Icon(
                  Icons.cloud_download,
                  color: Color(int.parse(
                      '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                  size: 25,
                ),
                SizedBox(width: 8.0.w),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color(int.parse(
                        '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                  ),
                ),
              ],
            ),
          ),
          onTap: (table2.isdownloaded)
              ? () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) =>
            //         OfflineContentLauncherInAppWebview(
            //       table2: table2,
            //     ),
            //   ),
            // );
          }
              : () async {
            if (!table2.isdownloaded) {
              setState(() {
                table2.isDownloading = true;
              });

              bool isDownloaded = await MyLearningController()
                  .storeMyLearningContentOffline(
                  context, table2, appBloc.userid);
              setState(() {
                table2.isdownloaded = isDownloaded;
                table2.isDownloading = false;
              });
            }
          },
        ),
      );*/
    }
    else {
      return SizedBox(width: 0.0);
    }
  }

  Widget displayViewTile(DummyMyCatelogResponseTable2 table2) {
    if ([11, 14, 20, 21, 28, 36, 52].contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 && (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return Container();
      }
      else {
        return viewOption(table2, appBloc.localstr.mylearningActionsheetViewoption);
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      return Container();
    }
    else {
      return viewOption(table2, appBloc.localstr.mylearningActionsheetViewoption);
    }
  }

  Widget displayPlayTile(DummyMyCatelogResponseTable2 table2) {
    var objectTypeIds1 = [11, 14, 36, 28, 20, 21, 52];
    if (objectTypeIds1.contains(table2.objecttypeid)) {
      if (table2.objecttypeid == 11 && (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return viewOption(table2, appBloc.localstr.mylearningActionsheetPlayoption);
      }
    }

    return Container();
  }

  Widget viewOption(DummyMyCatelogResponseTable2 table2, String mylearningActionsheetViewoption) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 38,
          width: 1.0.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Color(int.parse(
                '0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}')),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.remove_red_eye,
                color: Color(int.parse(
                    '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                size: 24,
              ),
              SizedBox(width: 8.0.w),
              Text(
                mylearningActionsheetViewoption,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                  color: Color(int.parse(
                      '0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}')),
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          if(widget.onViewTap != null) {
            widget.onViewTap!();
          }
        },
      ),
    );
  }
  //endregion Action Panel

  //Helper Methods
  ButtonStyle getButtonStyle() {
    return TextButton.styleFrom(
      primary: Colors.blue,
    );
  }
}
