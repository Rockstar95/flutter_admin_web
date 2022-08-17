import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/get_review_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/mylearning_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/bloc/theme/bloc/change_theme_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/theme/states/change_theme_state.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/download_course.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/model/subsitelogin_response.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/Catalog/gotoCoursePreview.dart';
import 'package:flutter_admin_web/ui/Events/session_event.dart';
import 'package:flutter_admin_web/ui/MyLearning/Assignmentcontentweb.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/progress_report.dart';
import 'package:flutter_admin_web/ui/MyLearning/qr_code_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/MyLearning/view_certificate.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../controllers/connection_controller.dart';
import '../../controllers/my_learning_download_controller.dart';
import '../../controllers/mylearning_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/my_learning/download_feature/mylearning_download_model.dart';
import '../../packages/percent_indicator/circular_percent_indicator.dart';
import '../../providers/my_learning_download_provider.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../common/bottomsheet_drager.dart';
import 'SendviaEmailMylearning.dart';
import 'helper/advanced_webcourse_launch.dart';
import 'helper/gotoCourseLaunchContenisolation.dart';

class CommonDetailScreen extends StatefulWidget {
  final String contentid;
  final int objtypeId;
  final MyLearningDetailsBloc detailsBloc;
  final DummyMyCatelogResponseTable2 table2;
  final int pos;
  final List<DummyMyCatelogResponseTable2> mylearninglist;
  final ScreenType screenType;
  final bool isShowShedule, isFromReschedule;
  final Map<String, String> filterMenus;

  //final bool isFromMyLearning;

  CommonDetailScreen({
    this.contentid = "",
    this.objtypeId = 0,
    required this.detailsBloc,
    required this.table2,
    this.pos = 0,
    this.mylearninglist = const [],
    this.screenType = ScreenType.MyLearning,
    this.isShowShedule = false,
    this.isFromReschedule = false,
    this.filterMenus = const {},
    //this.isFromMyLearning
  });

  @override
  _CommonDetailScreenState createState() => _CommonDetailScreenState();
}

class _CommonDetailScreenState extends State<CommonDetailScreen> with SingleTickerProviderStateMixin {
  bool isReportEnabled = true;

  //MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  EvntModuleBloc get eventModuleBloc =>
      BlocProvider.of<EvntModuleBloc>(context);

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late MyLearningDetailsBloc detailsBloc;
  late MyLearningBloc myLearningBloc;

  String assignmenturl = "";

  //EvntModuleBloc eventModuleBloc;
  late TabController _tabController;
  List<Tab> tabList = [];
  List<EditRating> reviewList = [];
  bool isFromCatalog = false, isReschdule = false;
  String typeFrom = "";
  int ratingCount = 0;
  var strUserID = '';
  bool isEditRating = false;
  int skippedRows = 0;
  MyLearningDetailsResponse? data;
  late FToast flutterToast;
  DownloadCourse? downloadCourse;
  GotoCourseLaunch? courseLaunch;
  GotoCourseLaunchCatalog? courseLaunchCatalog;
  int downloadedProgess = 0;
  String downloadDestFolderPath = "";
  bool loaderEnroll = false;
  String contentID = '';
  StreamController<int> streamController = StreamController();
  late GeneralRepository generalRepository;
  bool reviewMoreButtonEnabled = true;
  bool download = false;
  bool isConsolidated = false;

  String eventstartDate = '';
  String eventendDate = '';
  late ProfileBloc profileBloc;

  String contentIconPath = '';

  int bottomButton1Tag = 0;
  int bottomButton2Tag = 0;

  String bottomButton1Text = '';
  String bottomButton2Text = '';

  IconData icon1 = Icons.add_circle;
  IconData icon2 = Icons.add_circle;
  bool enablePlay = false;

  String imgUrl =
      "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

  bool isLoading = false;

  /// Consumable credits the user can buy
  int credits = 0;
  String preqContentNames = "";
  String preqContentTitle = "";
  String inappKey =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxZKOgrgA0BACsUqzZ49Xqj1SEWSx/VNSQ7e/WkUdbn7Bm2uVDYagESPHd7xD6cIUZz9GDKczG/fkoShHZdMCzWKiq07BzWnxdSaWa4rRMr+uylYAYYvV5I/R3dSIAOCbbcQ1EKUp5D7c2ltUpGZmHStDcOMhyiQgxcxZKTec6YiJ17X64Ci4adb9X/ensgOSduwQwkgyTiHjklCbwyxYSblZ4oD8WE/Ko9003VrD/FRNTAnKd5ahh2TbaISmEkwed/TK4ehosqYP8pZNZkx/bMsZ2tMYJF0lBUl5i9NS+gjVbPX4r013Pjrnz9vFq2HUvt7p26pxpjkBTtkwVgnkXQIDAQAB";

  var thumbnailImgHeight = 150;

  ButtonStyle textButtonStyle = TextButton.styleFrom(
    primary: Colors.blue,
  );

  //Variables For Download process
  bool isDownloaded = false;
  bool isDownloading = false;
  bool isDownloadPaused = false;
  bool isZipFile = false;
  bool isDownloadFileExtracted = false;
  double downloadprogress = 1;

  void handleError(IAPError? error) {
    setState(() {
      // _purchasePending = false;
    });
  }

  Future<String> getCurrentDateTimeInStr() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
    String formatted = formatter.format(now);

    return formatted;
  }

  void deliverProduct(DummyMyCatelogResponseTable2 dummyMyCatelogResponseTable,
      PurchaseDetails purchaseDetails) async {
    var deviceType = Platform.isAndroid ? "Android" : "IOS";

    catalogBloc.add(
      SaveInAppPurchaseEvent(
          siteURl: dummyMyCatelogResponseTable.siteurl == "null"
              ? ApiEndpoints.strSiteUrl
              : dummyMyCatelogResponseTable.siteurl,
          contentID: dummyMyCatelogResponseTable.contentid,
          orderId: purchaseDetails.purchaseID ?? "",
          purchaseToken: purchaseDetails.productID,
          // purchaseToken: purchaseDetails.billingClientPurchase.purchaseToken ?? "",
          productId: purchaseDetails.productID,
          purchaseTime: await getCurrentDateTimeInStr(),
          deviceType: deviceType),
    );
  }

  void handlePurchaseError(IAPError? error) {
    if (error != null) {
      MyToast.showToast(
          context, "Error in Buying Content : '${error.message}'");
    } else {
      MyToast.showToast(context, "Error in Buying Content");
    }
  }

  Future<void> handlePurchase(DummyMyCatelogResponseTable2 product,
      PurchaseDetails? purchaseDetails) async {
    if (purchaseDetails == null) {
      MyToast.showToast(context, "Purchase Failed");
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      MyToast.showToast(context, "Purchase Pending");
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        handlePurchaseError(purchaseDetails.error);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        deliverProduct(product, purchaseDetails);
      }
    }
  }

  /// InApp purchase implementation
  Future<void> _buyProduct(DummyMyCatelogResponseTable2 product) async {
    print("Content Id:${product.contentid}");

    String productId = "";

    if (Platform.isAndroid) {
      productId = product.googleproductid?.toString() ?? "";
    } else if (Platform.isIOS) {
      productId = product.itunesproductid?.toString() ?? "";
    }

    print("Product Id:$productId");
    if (productId.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      Map<String, ProductDetails> map =
          await InAppPurchaseController().getProductDetails([productId]);
      print("Product Details Map:$map");

      if (map[productId] != null) {
        ProductDetails productDetails = map[productId]!;

        PurchaseDetails? purchaseDetails =
            await InAppPurchaseController().buyProduct(productDetails);
        await handlePurchase(product, purchaseDetails);
      } else {
        MyToast.showToast(context, "Product Details Not Available");
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void initializeParentModelDataFromResponse(
      DummyMyCatelogResponseTable2 table2, MyLearningDetailsResponse data) {
    /*print("IsAddedToMyLearning:${table2.isaddedtomylearning}");
    print("New IsContentEnrolled:${data.isContentEnrolled}");
    print("New View Type:${data.viewType}");
    print("Is Int:${data.viewType is int}");
    print("ViewType Type:${data.viewType.runtimeType}");
    print("Try Parse ViewType Type:${int.tryParse(data.viewType?.toString() ?? table2.viewtype.toString())}");*/
    table2.viewtype =
        int.tryParse(data.viewType?.toString() ?? table2.viewtype.toString()) ??
            table2.viewtype;
    table2.isaddedtomylearning =
        (data.isContentEnrolled?.toString() ?? "").isNotEmpty
            ? (data.isContentEnrolled!.toString() == "true" ? 1 : 0)
            : table2.isaddedtomylearning;
    table2.googleproductid = data.googleProductID;
    table2.itunesproductid = data.itunesProductID;
    /*print("Updated View Type:${table2.viewtype}");
    print("Updated isaddedtomylearning:${table2.isaddedtomylearning}");*/
  }

  //region content download functions
  void _onViewTap(DummyMyCatelogResponseTable2 table2) async {
    bool isValidate = isValidString(table2.viewprerequisitecontentstatus ?? '');
    print('isValidate:$isValidate');

    if (isValidate) {
      print('ifdataaaaa');
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = '$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}';

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Pre-requisite Sequence',
              style: TextStyle(
                  color: Color(
                    int.parse(
                        '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                  ),
                  fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alertMessage,
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        ))),
                Text(
                    '\n${table2.viewprerequisitecontentstatus
                            .toString()
                            .split('#%')[1]
                            .split('\$;')[0]}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                    )),
                Text(
                    table2.viewprerequisitecontentstatus
                        .toString()
                        .split('#%')[1]
                        .split('\$;')[1],
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                        )))
              ],
            ),
            backgroundColor: InsColor(appBloc).appBGColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            actions: <Widget>[
              TextButton(
                child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                style: textButtonStyle,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }
    else {
      // covered
      bool result = await MyLearningController().decideCourseLaunchMethod(
        context: context,
        table2: table2,
        isContentisolation: false,
      );
      if (!result) {
        table2.isdownloaded = false;
        setState(() {});
      }
    }
  }

  void onDownloadPaused(MyLearningDownloadModel? downloadModel) {
    MyPrint.printOnConsole("onDownloadPaused called:$downloadModel, Task Id:${downloadModel?.taskId}");
    if(downloadModel != null && downloadModel.taskId.isNotEmpty) {
      MyLearningDownloadController().resumeDownload(downloadModel);
    }
  }

  void onDownloading(MyLearningDownloadModel? downloadModel) {
    MyPrint.printOnConsole("onDownloading called");
    if(downloadModel != null && downloadModel.taskId.isNotEmpty) {
      MyLearningDownloadController().pauseDownload(downloadModel);
    }
  }

  void _onDownloadTap(DummyMyCatelogResponseTable2 table2) async {
    MyPrint.printOnConsole("_onDownloadTap called");

    if (table2.isdownloaded) {
      return;
    }

    if(ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
      setState(() {
        table2.isDownloading = true;
        //isLoading = true;
      });

      //bool isDownloaded = await MyLearningController().storeMyLearningContentOffline(context, table2, appBloc.userid);
      bool isDownloaded = await MyLearningDownloadController().storeMyLearningContentOffline(
        context,
        table2, appBloc.userid,
        /*checkFileOnServerCallback: () {
          isLoading = false;
          setState(() {});

          //Snakbar().show_info_snakbar(context, "Download Started...");
        },*/
      );
      setState(() {
        table2.isdownloaded = isDownloaded;
        table2.isDownloading = false;
      });
    }
  }
  //endregion

  @override
  void initState() {
    super.initState();

    profileBloc =
        ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());

    myLearningBloc =
        MyLearningBloc(myLearningRepository: MyLearningRepositoryPublic());

    detailsBloc = widget.detailsBloc;
    detailsBloc.userRatingDetails.clear();
    detailsBloc.add(GetDetailsReviewEvent(
        contentId: widget.contentid, skippedRows: skippedRows));
    // eventModuleBloc = EvntModuleBloc(
    //     eventModuleRepository: EventRepositoryBuilder.repository());
    print(
        'contentidd ${widget.table2.contentid}, objectypeid ${widget.objtypeId.toString()}, bit5:${widget.table2.bit5}');
    print(
        'reschduleparentid:${widget.table2.reschduleparentid}, eventscheduletype ${widget.table2.eventscheduletype}');

    if (widget.table2.objecttypeid == 70) {
      if (widget.table2.eventscheduletype == 1) {
        refresh(widget.contentid);
      }
      else if (widget.table2.eventscheduletype == 2) {
        if(widget.table2.reschduleparentid != null) {
          refresh(widget.table2.reschduleparentid);
        }
      }
    }

    if (widget.filterMenus != null && widget.filterMenus.containsKey("Type")) {
      String consolidatedType = widget.filterMenus["Type"] ?? "";
      print("consolidatedType $consolidatedType");
      if (consolidatedType != null &&
          consolidatedType != '' &&
          consolidatedType.toLowerCase() == "consolidate") {
        isConsolidated = true;
      } else {
        isConsolidated = false;
      }
    } else {
      // No such key
      isConsolidated = false;
    }
//    widget.table2
//        .setobjecttypeid(widget.objtypeId.toString());
    generalRepository = GeneralRepositoryBuilder.repository();

    tabList.add(const Tab(
      text: 'Sessions',
    ));
    tabList.add(const Tab(
      text: 'Resource',
    ));
    tabList.add(const Tab(
      text: 'Glossary',
    ));
    _tabController = TabController(length: tabList.length, vsync: this);
    getUserId();

    if (isValidString(widget.table2.eventstartdatetime ?? "")) {
      DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(widget.table2.eventstartdatetime);

      String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);
      eventstartDate = date;

      print('checkmydateva; $date');
    }

    if (isValidString(widget.table2.eventenddatetime ?? "")) {
      DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss")
          .parse(widget.table2.eventenddatetime);

      String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(tempDate);
      eventendDate = date;

      print('checkmydateva; $date');
    }

    downloadPath(widget.table2.contentid, widget.table2);
    // download = displayDownload(widget.table2); commented till offline implemented
    //checkReportEnabled();
    setTag1();

    contentIconPath = widget.table2.iconpath;

    if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? widget.table2.iconpath
          : (appBloc.uiSettingModel.azureRootPath) + (widget.table2.iconpath);

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = widget.table2.siteurl + contentIconPath;
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  void downloadPath(
      String contentid, DummyMyCatelogResponseTable2 table2) async {
    String path = "${await AppDirectory.getDocumentsDirectory()}/.Mydownloads/Contentdownloads/$contentid";

    setState(() {
      downloadDestFolderPath = path;
    });

    checkFile(downloadDestFolderPath, table2);
  }

  void checkFile(String path, DummyMyCatelogResponseTable2 table2) async {
    final savedDir = Directory(path);
    if (await savedDir.exists()) {
      setState(() {
        table2.isdownloaded = true;
      });
    } else {
      setState(() {
        table2.isdownloaded = false;
      });
    }
  }

  void doSomething(int i, DummyMyCatelogResponseTable2 table2, int progress) {
    /* ... */
    print('dosomethingofdata $progress');

    try {
      if (i != null) {
        if (progress == -1) {
          setState(() {
            table2.isdownloaded = false;
            table2.isDownloading = false;
          });

          flutterToast.showToast(
            child: CommonToast(displaymsg: 'Error while downloading'),
            gravity: ToastGravity.BOTTOM,
            toastDuration: const Duration(seconds: 2),
          );
        }
        if (progress == 100) {
          setState(() {
            table2.isdownloaded = true;
            table2.isDownloading = false;
          });
        } else {
          setState(() {
//        myLearningBloc.list[i].isdownloaded = true;
            downloadedProgess = progress;
            table2.isDownloading = true;
          });
        }
      }
    } catch (e) {
      setState(() {
        table2.isdownloaded = false;
        table2.isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //widget.table2.isaddedtomylearning = 0;

    flutterToast = FToast();
    flutterToast.init(context);

    //print("Object Id:${widget.table2.objecttypeid}");

    //basicDeviceHeightWidth(context, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    thumbnailImgHeight = useMobileLayout ? 160 : 440;

    Color statuscolor = const Color(0xff5750da);

    //print("Common Details Called");

    if (widget.table2.corelessonstatus.toString().contains("Completed")) {
      statuscolor = const Color(0xff4ad963);
    } else if (widget.table2.corelessonstatus.toString() == "Not Started") {
      statuscolor = const Color(0xfffe2c53);
    } else if (widget.table2.corelessonstatus.toString() == "In Progress") {
      statuscolor = const Color(0xffff9503);
    }

    return BlocConsumer<MyLearningBloc, MyLearningState>(
      bloc: myLearningBloc,
      listener: (BuildContext context, MyLearningState state) async {
        print("In Listener, State:$state. Status:${state.status}");

        if (state is CourseTrackingState) {
          if (state.status == Status.COMPLETED) {
            //print(state.response);
            if (isValidString(state.response)) {
              myLearningBloc.add(TokenFromSessionIdEvent(
                  table2: state.table2,
                  contentID: state.table2.contentid,
                  objecttypeId: "${state.table2.objecttypeid}",
                  userID: "${state.table2.objecttypeid}",
                  courseName: "${state.table2.name}",
                  courseURL: state.courseUrl,
                  learnerSCOID: "${state.table2.scoid}",
                  learnerSessionID: state.response.toString()));
            }
          } else if (state.status == Status.ERROR) {
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        } else if (state is TokenFromSessionIdState) {
          if (state.status == Status.COMPLETED) {
            if (isValidString(state.response) && state.response.contains('failed')) {
              bool result = await MyLearningController().decideCourseLaunchMethod(
                context: context,
                table2: state.table2,
                isContentisolation: false,
              );
            }
            else {
              launchCourseContentisolation(
                  state.table2, context, state.response.toString());
            }
          } else if (state.status == Status.ERROR) {
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
      },
      builder: (BuildContext context, MyLearningState state) {
        return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                return !isLoading;
              },
              child: ModalProgressHUD(
                inAsyncCall: isLoading,
                progressIndicator: getProgressIndicator(),
                child: Scaffold(
                  backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
                  bottomNavigationBar: getBottomNavigationBar(),
                  appBar: getAppBar(),
                  body: BlocConsumer<MyLearningDetailsBloc, MyLearningDetailsState>(
                    bloc: detailsBloc,
                    listener: (context, state) {
                      if (state.status == Status.COMPLETED) {
                        if (state is GetReviewsDetailstate) {
                          reviewList = detailsBloc.userRatingDetails;
                          print('reviewlistdata $reviewList');
                          ratingCount = state.review.recordCount;
                          if (state.review.editRating == null) {
                            isEditRating = false;
                          } else {
                            isEditRating = true;
                          }
                          print('getreviewdata $skippedRows');
//                      reviewList = data;
                          if (skippedRows == 0) {
                            getDetailsApiCall(widget.contentid);
                          }
                        } else if (state is GetLearningDetailsState) {
                          data = state.data;
                          initializeParentModelDataFromResponse(
                              widget.table2, state.data);
                        } else if (state is SetCompleteState) {
                          print('hello completeddd');
                          setState(() {
                            widget.table2.percentcompleted = '100.00';
                            widget.table2.progress = '100';
                            widget.table2.corelessonstatus = 'Completed';
                          });
                        } else if (state is GetContentStatusState) {
                          print(
                              'getcontentstatusvl ${state.contentstatus.name} ${state.contentstatus.progress} ${state.contentstatus.contentStatus}');
                          setState(() {
                            widget.table2.actualstatus =
                                state.contentstatus.name;
                            widget.table2.progress =
                                state.contentstatus.progress;
                            if (state.contentstatus.progress != null ||
                                state.contentstatus.progress != '0') {
                              widget.table2.percentcompleted =
                                  state.contentstatus.progress;
                            }
                            widget.table2.corelessonstatus =
                                state.contentstatus.contentStatus;
                          });
                        }
                      }
                      else if (state.status == Status.ERROR) {
                        if (state.message == '401') {
                          AppDirectory.sessionTimeOut(context);
                        } else {
                          print('dont do navigation');
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state.status == Status.LOADING) {
                        return getProgressIndicator();
                      }

//                if (state is GetLearningDetailsState &&
//                    state.status == Status.COMPLETED) {
                      print('titlename ${widget.table2.siteurl}, ${widget.table2.qrcodeimagepath}');

                      //Logger logger = Logger();

                      //logger.e(".......longDescription....${ removeAllHtmlTags(data.longDescription)}");
                      //logger.e(".......shortDescription....${ removeAllHtmlTags(data.shortDescription)}");

                      return BlocConsumer(
                        bloc: eventModuleBloc,
                        listener: (context, state) {
                          if (state is GetPeopleListingTabState) {
                            if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              } else {
                                flutterToast.showToast(
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: const Duration(seconds: 2),
                                    child: CommonToast(
                                        displaymsg:
                                            'Something went wrong'));
                              }
                            }
                          }
                          else if (state is GetTabContentState) {
                            if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              } else {
                                flutterToast.showToast(
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: const Duration(seconds: 2),
                                    child: CommonToast(
                                        displaymsg:
                                            'Something went wrong'));
                              }
                            }
                          }
                          else if (state is CancelEnrollmentState) {
                            if (state.status == Status.COMPLETED) {
                              if (state.data == 'true') {
                                setState(() {
                                  widget.table2.isaddedtomylearning = 0;
                                  setTag1();
                                });

                                Future.delayed(const Duration(seconds: 1),
                                    () {
                                  // 5s over, navigate to a new page
                                  flutterToast.showToast(
                                    child: CommonToast(
                                        displaymsg:
                                            'Enrollment cancelled successfully'),
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: const Duration(seconds: 1),
                                  );
                                  if (widget.screenType ==
                                      ScreenType.MyLearning) {
                                    Navigator.of(context).pop(true);
                                  }
                                });

                                setState(() {
                                  // state.table2.isaddedtomylearning = 0;
                                  // state.table2.availableseats =
                                  //     state.table2.availableseats + 1;
                                });
                              } else {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg:
                                          'Something went wrong'),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );
                              }
                            } else if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is BadCancelEnrollmentState) {
                            if (state.status == Status.COMPLETED) {
                              showCancelEnrollDialog(
                                  state.table2, state.isSucces);
                            } else if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is ExpiryEventState) {
                            if (state.status == Status.COMPLETED) {
                              print("om  ${state.isSucces}");
                              if (state.isSucces.contains("true")) {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: "${appBloc.localstr
                                              .eventsAlertsubtitleThiseventitemhasbeenaddedto} ${appBloc.localstr
                                              .mylearningHeaderMylearningtitlelabel}"),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );

                                setState(() {
                                  state.table2.isaddedtomylearning = 1;
                                });
                              } else {
                                print("else  ${state.isSucces}");
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg:
                                          'Something went wrong'),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );
                              }
                            } else if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          else if (state is WaitingListState) {
                            if (state.status == Status.COMPLETED) {
                              if (state.waitingListResponse.isSuccess) {
                                Future.delayed(const Duration(seconds: 1),
                                    () {
                                  // 5s over, navigate to a new page
                                  flutterToast.showToast(
                                    child: CommonToast(
                                        displaymsg: state
                                            .waitingListResponse
                                            .message),
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: const Duration(seconds: 2),
                                  );
                                });

                                setState(() {
                                  state.table2.waitlistenrolls =
                                      state.table2.waitlistenrolls + 1;
                                  state.table2.actionwaitlist = '';
                                });
                              } else {
                                Future.delayed(const Duration(seconds: 1),
                                    () {
                                  // 5s over, navigate to a new page
                                  flutterToast.showToast(
                                    child: CommonToast(
                                        displaymsg: state
                                            .waitingListResponse
                                            .message),
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: const Duration(seconds: 2),
                                  );
                                });
                              }
                            } else if (state.status == Status.ERROR) {
                              if (state.message == '401') {
                                AppDirectory.sessionTimeOut(context);
                              } else {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg:
                                          'Something went wrong'),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: const Duration(seconds: 2),
                                );
                              }
                            }
                          }

                          setState(() {
                            setTag1();
                          });
                        },
                        builder: (context, state) {
                          return BlocConsumer<CatalogBloc, CatalogState>(
                            bloc: catalogBloc,
                            listener: (context, state) {
                              if (state is GetCategoryWisecatalogState) {
                                if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");
                                  setState(() {
                                    //isGetCatalogListEvent = true;
                                    //pageNumber++;
                                  });
                                } else if (state.status ==
                                    Status.ERROR) {
//                print("listner Error ${state.message}");
                                  if (state.message == "401") {
                                    AppDirectory.sessionTimeOut(
                                        context);
                                  }
                                }
                              }
                              if ([AddToWishListState, RemoveFromWishListState, AddToMyLearningState].contains(state.runtimeType) ) {
                                if (state.status == Status.COMPLETED) {
                                  //catalogBloc.isFirstLoadingCatalog = true;

                                  if (state is AddToWishListState) {
                                    widget.table2.iswishlistcontent = 1;
                                    flutterToast.showToast(
                                      child: CommonToast(
                                          displaymsg: appBloc.localstr
                                              .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration:
                                          const Duration(seconds: 2),
                                    );
                                  }
                                  if (state
                                      is RemoveFromWishListState) {
                                    widget.table2.iswishlistcontent = 0;
                                    flutterToast.showToast(
                                      child: CommonToast(
                                          displaymsg: appBloc.localstr
                                              .catalogAlertsubtitleItemremovedtowishlistsuccesfully),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration:
                                          const Duration(seconds: 2),
                                    );
                                  }
                                  if (state is AddToMyLearningState) {
                                    widget.table2.isaddedtomylearning =
                                        1;
                                    flutterToast.showToast(
                                      child: CommonToast(
                                          displaymsg: appBloc.localstr
                                              .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration:
                                          const Duration(seconds: 2),
                                    );
                                  }
                                }
                              }
                              if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
                                if (state.message == "401") {
                                  AppDirectory.sessionTimeOut(context);
                                }
                              }
                              if (state is GetPrequisiteDetailsState) {
                                if (state.status == Status.COMPLETED) {
                                  print(
                                      "prequisitePopupresponse size ${state.prequisitePopupresponse.prerequisteData.table.length}");
                                } else if (state.status ==
                                    Status.ERROR) {
                                  if (state.message == "401") {
                                    AppDirectory.sessionTimeOut(
                                        context);
                                  }
                                }
                              }

                              if (state is SaveInAppPurchaseState) {
                                if (state.status == Status.COMPLETED) {
                                  if (isValidString(state.response) &&
                                      state.response
                                          .contains('success')) {
                                    print("inapp purchase  success ");
                                    setState(() {
                                      widget.table2
                                          .isaddedtomylearning = 1;
                                    });
                                    //MyToast.show_toast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);
                                  } else {}
                                } else if (state.status ==
                                    Status.ERROR) {
                                  if (state.message == "401") {
                                    AppDirectory.sessionTimeOut(
                                        context);
                                  }
                                }
                              }

                              setState(() {
                                setTag1();
                              });
                            },
                            builder: (context, state) {
                              print("Content Status:${data?.contentStatus}");

                              return Stack(
                                children: <Widget>[
                                  (data != null)
                                      ? getMainBody(table2: widget.table2, statuscolor: statuscolor,)
                                      : Container(),
                                  (state.status == Status.LOADING) ? getProgressIndicator2() : Container()
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget getProgressIndicator() {
    return Center(
      child: AbsorbPointer(
        child: SpinKitCircle(
          color: Colors.grey,
          size: 70.h,
        ),
      ),
    );
  }

  Widget getProgressIndicator2() {
    return Container(
      color: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      child: Center(
        child: AbsorbPointer(
          child: SpinKitCircle(
            color: Color(
              int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
            ),
            size: 70.h,
          ),
        ),
      ),
    );
  }

  Widget getBottomNavigationBar() {
    if(bottomButton1Text.isEmpty && bottomButton2Text.isEmpty) {
      return SizedBox(height: 1.h,);
    }
    else {
      return Container(
          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          child: (bottomButton1Text.isNotEmpty && bottomButton2Text.isNotEmpty)
              ? Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: bottomButton2Text.isNotEmpty
                    ? EdgeInsets.only(right: 5.h)
                    : const EdgeInsets.all(0.0),
                child: FlatButton(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  onPressed: () {
                    onBottom1tap();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon1,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        bottomButton1Text,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                      ),
                    ],
                  ),
                ),
              ),
              (bottomButton1Text.isNotEmpty &&
                  bottomButton2Text.isNotEmpty)
                  ? Container(
                width: 1.h,
                height: 20.h,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
              )
                  : SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: bottomButton1Text.isNotEmpty
                    ? EdgeInsets.only(left: 5.h)
                    : const EdgeInsets.all(0.0),
                child: FlatButton(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  onPressed: () {
                    onBottom2tap();
                  },
                  child: Row(
                    children: <Widget>[
                      bottomButton2Tag == 13
                          ? SvgPicture.asset(
                        'assets/education.svg',
                        width: 25.h,
                        height: 25.h,
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                      )
                          : Icon(icon2),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        bottomButton2Text,
                        style: TextStyle(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
              : bottomButton1Text.isNotEmpty
                ? FlatButton(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                onPressed: () {
                  onBottom1tap();
                },
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon1,
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    Text(
                      bottomButton1Text,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                  ],
                ))
                : FlatButton(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
              onPressed: () {
                onBottom2tap();
              },
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon2,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                  SizedBox(
                    width: 5.h,
                  ),
                  Text(
                    bottomButton2Text,
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                  ),
                ],
              ),
            ),
      );
    }
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        'Course Details',
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
      ),
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
      leading: InkWell(
        // onTap: () {
        //   int count = 0;
        //   Navigator.of(context).popUntil((_) => count++ >= 2);
        // },
        onTap: () => Navigator.of(context).pop(true),
        child: Icon(Icons.arrow_back,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
      ),
      actions: <Widget>[
//
        SizedBox(
          width: 10.h,
        ),
//              contextList.isNotEmpty ?
        GestureDetector(
          onTap: () {
            print("Screen Type:${widget.screenType}");
            switch (widget.screenType) {
              case ScreenType.MyLearning:
              // TODO: MyLearning Action Sheet
                _settingMyLearningBottomSheet(context);
                break;
              case ScreenType.Catalog:
              // TODO: Catalog Action Sheet.
                _settingCatalogBottomSheet(context);
                break;
              case ScreenType.Events:
              // TODO: Handle this case.
                _settingMyEventBottomSheet(
                    context, widget.table2);
                break;
            }
          },
          child: Icon(Icons.more_vert,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
//                  :Container(),
        SizedBox(
          width: 10.h,
        ),
      ],
    );
  }

  Widget getMainBody({DummyMyCatelogResponseTable2? table2, required Color statuscolor}) {
    return Consumer(
      builder: (BuildContext context, MyLearningDownloadProvider myLearningDownloadProvider, Widget? child) {
        //region download related tasks
        isDownloaded = widget.table2.isdownloaded;
        isDownloading = widget.table2.isDownloading;
        isDownloadPaused = false;
        isZipFile = false;
        isDownloadFileExtracted = false;
        downloadprogress = 1;

        List<MyLearningDownloadModel> downloadsList = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == widget.table2.contentid).toList();
        if(downloadsList.isNotEmpty) {
          MyLearningDownloadModel myLearningDownloadModel = downloadsList.first;
          isDownloaded = myLearningDownloadModel.isFileDownloaded;
          isZipFile = myLearningDownloadModel.isZip && myLearningDownloadModel.taskId.isNotEmpty;
          isDownloadFileExtracted = isZipFile && myLearningDownloadModel.isFileExtracted;
          if(!myLearningDownloadModel.isFileDownloading) {
            isDownloading = myLearningDownloadModel.isFileDownloading;
          }
          if(isDownloading) {
            isDownloading = myLearningDownloadModel.taskId.isNotEmpty;
          }
          isDownloadPaused = myLearningDownloadModel.isFileDownloadingPaused && myLearningDownloadModel.taskId.isNotEmpty;
          /*if(myLearningDownloadModel.taskId == "c7a85690-c966-4285-89c2-4798e02b3277") {
              isDownloadPaused = true;
            }*/
          downloadprogress = myLearningDownloadModel.taskId.isNotEmpty ? MyUtils.roundTo(myLearningDownloadModel.downloadPercentage / 100, 100) : 1;
          downloadprogress = downloadprogress < 0 ? 0 : downloadprogress;

          /*if(myLearningDownloadModel.taskId == "88be1eba-e7d4-44ac-b92d-363d8b19a1bf") {
            MyPrint.printOnConsole("----\ntable2.isdownloaded:${widget.table2.isdownloaded}");
            MyPrint.printOnConsole("table2.isDownloading:${widget.table2.isDownloading}");
            MyPrint.printOnConsole("myLearningDownloadModel.isFileDownloading:${myLearningDownloadModel.isFileDownloading}");
            MyPrint.printOnConsole("myLearningDownloadModel.isFileDownloaded:${myLearningDownloadModel.isFileDownloaded}");
            MyPrint.printOnConsole("myLearningDownloadModel.isFileDownloadingPaused:${myLearningDownloadModel.isFileDownloadingPaused}\n-----");
          }*/

          print("Download Status:${myLearningDownloadModel.downloadStatus}");
          print("isDownloaded:$isDownloaded, Name:${widget.table2.name}");

          //table2.isdownloaded = isDownloaded;
          //table2.isDownloading = isDownloading;
        }
        //endregion

        return Container(
          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getContentImageWidget(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        getContentNameWidget(),
                        SizedBox(height: 5.h,),
                        GestureDetector(
                          onTap: () {
                            if(table2 != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile(
                                  isFromProfile: false,
                                  isMyProfile: appBloc.userid == table2.createduserid.toString(),
                                  connectionUserId: table2.createduserid.toString(),
                                ),
                              ));
                            }
                          },
                          child: Row(
                            children: <
                                Widget>[
                              ClipOval(
                                child: Image
                                    .network(
                                  imgUrl,
                                  width:
                                  25.h,
                                  height:
                                  25.h,
                                  fit: BoxFit
                                      .cover,
                                ),
                              ),
                              SizedBox(
                                width:
                                5.h,
                              ),
                              Text(
                                  data?.authorName ??
                                      '',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                      color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        data?.contentTypeId != 70
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <
                              Widget>[
                            Flexible(
                              flex:
                              9,
                              child:
                              Container(
                                height: 7.h,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey.shade400,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    statuscolor,
                                  ),
                                  value: isValidString(widget.table2.progress) ? double.parse(widget.table2.progress) / 100 : 0.0,
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 2,
                                child: Text(
                                  '${widget.table2.progress.toString()} %',
                                  style: TextStyle(
                                      color: Color(
                                        int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                      )),
                                ))
                          ],
                        )
                            : Container(),
                        data?.eventStartDateTimeWithoutConvert !=
                            null
                            ? Row(
                          children: <
                              Widget>[
                            const Icon(
                              Icons.timelapse,
                              color:
                              Colors.grey,
                            ),
                            SizedBox(
                              width:
                              10.h,
                            ),
                            Flexible(
                              child:
                              Text(
                                'From ${data?.eventStartDateTimeWithoutConvert} to ${data?.eventEndDateTimeTimeWithoutConvert}',
                                style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                            )
                          ],
                        )
                            : Container(),
                        Padding(
                          padding:
                          EdgeInsets
                              .all(8
                              .h),
                          child: Text(
                            !isValidString(widget.table2.progress) &&
                                widget.table2.percentcompleted ==
                                    "0.0"
                                ? '${data?.actualStatus}'
                                : '',
                            style: TextStyle(
                                color: Color(
                                    int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          ),
                        ),
                        widget.table2
                            .keywords !=
                            ""
                            ? Text(
                          'Keywords',
                          style: TextStyle(
                              fontSize:
                              17.h,
                              fontWeight: FontWeight.bold),
                        )
                            : Container(),
                        widget.table2
                            .keywords !=
                            ""
                            ? SizedBox(
                          height:
                          5.h,
                        )
                            : Container(),
                        widget.table2
                            .keywords !=
                            ""
                            ? Text(
                          widget
                              .table2
                              .keywords,
                          style: TextStyle(
                              fontSize:
                              14.h,
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                            : Container(),
                        widget.table2
                            .keywords !=
                            ""
                            ? SizedBox(
                          height:
                          10.h,
                        )
                            : Container(),
                        data?.learningObjectives !=
                            ""
                            ? Text(
                          "What you'll learn",
                          style: TextStyle(
                              fontSize:
                              17.h,
                              fontWeight: FontWeight.bold,
                              color: InsColor(appBloc).appTextColor),
                        )
                            : Container(),
                        data?.learningObjectives !=
                            ""
                            ? SizedBox(
                          height:
                          5.h,
                        )
                            : Container(),
                        data?.learningObjectives !=
                            ""
                            ? Container(
                          padding:
                          EdgeInsets.only(right: 10.h),
                          child:
                          Html(
                            onLinkTap:
                                (
                                String?
                                url,
                                RenderContext
                                context,
                                Map<String, String>
                                attributes,
                                element,
                                ) async {
                              if (await canLaunchUrlString(url ??
                                  "")) {
                                await launchUrlString(url!);
                              }
                            },
                            style: {
                              "body":
                              Style(color: InsColor(appBloc).appTextColor)
                            },
                            data:
                            data?.learningObjectives,
                          ),
                        )
                            : Container(),
                        widget.table2
                            .objecttypeid !=
                            70
                            ? SizedBox(
                          height:
                          20.h,
                        )
                            : Container(),
                        (removeAllHtmlTags(data?.longDescription ??
                            "")
                            .isNotEmpty ||
                            removeAllHtmlTags(data?.shortDescription ??
                                "")
                                .isNotEmpty)
                            ? Text(
                          appBloc
                              .localstr
                              .detailsLabelDescriptionlabel,
                          style: TextStyle(
                              fontSize:
                              17.h,
                              fontWeight: FontWeight.bold,
                              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                            : Container(),
                        SizedBox(
                          height: 5.h,
                        ),
                        widget.table2
                            .objecttypeid !=
                            70
                            ? Container(
                          color: InsColor(appBloc)
                              .appBGColor,
                          padding:
                          EdgeInsets.only(right: 10.h),
                          child:
                          Html(
                            onLinkTap:
                                (String? url, RenderContext context, Map<String, String> attributes, element) async {
                              if (await canLaunchUrlString(url ??
                                  "")) {
                                await launchUrlString(url!);
                              }
                            },
                            style: {
                              "body":
                              Style(color: InsColor(appBloc).appTextColor)
                            },
                            shrinkWrap:
                            true,
                            data: (data?.longDescription?.toString() ?? "").isNotEmpty
                                ? data!.longDescription
                                : (data?.shortDescription?.toString() ?? "").isNotEmpty
                                ? data!.shortDescription
                                : '',
                          ),
                        )
                            : Container(
                          color: InsColor(appBloc)
                              .appBGColor,
                          padding:
                          EdgeInsets.only(right: 10.h),
                          child:
                          Text(
                            (data?.longDescription?.toString() ?? "").isNotEmpty
                                ? data!.longDescription
                                : (data?.shortDescription?.toString() ?? "").isNotEmpty
                                ? data!.shortDescription
                                : '',
                            style: TextStyle(
                                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                fontSize: 14.0),
                          ),
                        ),
                        widget.table2
                            .objecttypeid !=
                            70
                            ? SizedBox(
                          height:
                          20.h,
                        )
                            : Container(),
                        data?.tableofContent !=
                            ""
                            ? Text(
                          "Program Outline",
                          style: TextStyle(
                              color:
                              Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 17.h,
                              fontWeight: FontWeight.bold),
                        )
                            : Container(),
                        data?.tableofContent !=
                            ""
                            ? SizedBox(
                          height:
                          5.h,
                        )
                            : Container(),
                        data?.tableofContent !=
                            ""
                            ? Container(
                          padding:
                          EdgeInsets.only(right: 10.h),
                          child:
                          Html(
                            onLinkTap:
                                (
                                String?
                                url,
                                RenderContext
                                context,
                                Map<String, String>
                                attributes,
                                element,
                                ) async {
                              if (await canLaunchUrlString(url ??
                                  "")) {
                                await launchUrlString(url!);
                              }
                            },
                            style: {
                              "body":
                              Style(color: InsColor(appBloc).appTextColor)
                            },
                            data:
                            data?.tableofContent,
                          ),
                        )
                            : Container(),
                        // data.eventStartDateTimeWithoutConvert !=
                        //         null
                        //     ? Row(
                        //         children: <
                        //             Widget>[
                        //           Icon(
                        //             Icons
                        //                 .timelapse,
                        //             color: Colors
                        //                 .grey,
                        //           ),
                        //           SizedBox(
                        //             width: 10.h,
                        //           ),
                        //           Flexible(
                        //             child: Text(
                        //               'From ${data.eventStartDateTimeWithoutConvert} to ${data.eventEndDateTimeTimeWithoutConvert}',
                        //               style: TextStyle(
                        //                   color: Color(
                        //                       int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        //             ),
                        //           )
                        //         ],
                        //       )
                        //     : Container(),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          'Rate and Review',
                          style: TextStyle(
                              fontSize:
                              17.h,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: <
                              Widget>[
                            SmoothStarRating(
                                allowHalfRating:
                                false,
                                onRatingChanged:
                                    (v) {},
                                starCount:
                                5,
                                rating: widget
                                    .table2
                                    .ratingid,
                                // filledIconData: Icons.blur_off,
                                // halfFilledIconData: Icons.blur_on,
                                color: Colors
                                    .orange,
                                borderColor:
                                Colors
                                    .orange,
                                spacing:
                                3.h),
                            SizedBox(
                              width:
                              5.h,
                            ),
                            Text(
                              widget
                                  .table2
                                  .ratingid
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 22
                                      .h,
                                  fontWeight: FontWeight
                                      .bold,
                                  color:
                                  Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                            Text(
                                '($ratingCount)',
                                textAlign:
                                TextAlign
                                    .end,
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.w600,
                                    color: Colors.grey))
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        (widget.table2.status ==
                            'completed' ||
                            widget.table2.status ==
                                'Completed')
                            ? InkWell(
                            onTap:
                                () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => ReviewScreen(widget.contentid, true, widget.detailsBloc)));
                            },
                            child:
                            Row(
                              children: <
                                  Widget>[
                                Text(
                                  isEditRating ? appBloc.localstr.detailsButtonEdityourreviewbutton : appBloc.localstr.detailsButtonWriteareviewbutton,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                ),
                                SizedBox(
                                  width: 5.h,
                                ),
                                Icon(
                                  Icons.edit,
                                  size: 15.h,
                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                ),
                              ],
                            ))
                            : Container(),
                        SizedBox(
                          height: 15.h,
                        ),

                        ListView
                            .builder(
                            shrinkWrap:
                            true,
                            physics:
                            const ScrollPhysics(),
                            itemCount:
                            reviewList
                                .length,
                            itemBuilder:
                                (context,
                                pos) {
                              return Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 8.h),
                                child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipOval(
                                      child: Image.network(
                                        reviewList[pos].picture.contains('http') ? reviewList[pos].picture : ApiEndpoints.strSiteUrl + reviewList[pos].picture,
                                        width: 25.h,
                                        height: 25.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                reviewList[pos].userName,
                                                style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")), fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              SizedBox(
                                                width: 2.h,
                                              ),
                                              SizedBox(
                                                width: 5.h,
                                              ),
                                              SmoothStarRating(
                                                  allowHalfRating: false,
                                                  onRatingChanged: (v) {},
                                                  starCount: 5,
                                                  rating: reviewList[pos].ratingId.toDouble(),
                                                  size: 15.h,
                                                  // filledIconData: Icons.blur_off,
                                                  // halfFilledIconData: Icons.blur_on,
                                                  color: Colors.orange,
                                                  borderColor: Colors.orange,
                                                  spacing: 0.0),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  reviewList[pos].description,
                                                  style: TextStyle(color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: (reviewList[pos].ratingUserId.toString() == strUserID)
                                                      ? IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewScreen(widget.contentid, true, widget.detailsBloc)));
                                                    },
                                                    iconSize: 20.h,
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                      : Container()),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        ratingCount >
                            reviewList.length
                            ? Center(
                          child:
                          AbsorbPointer(
                            absorbing:
                            !reviewMoreButtonEnabled,
                            child:
                            InkWell(
                              onTap:
                                  () {
                                skippedRows = reviewList.length;
                                setState(() {
                                  detailsBloc.add(GetDetailsReviewEvent(contentId: widget.contentid, skippedRows: reviewList.length));
                                  reviewMoreButtonEnabled = false;
                                });
                              },
                              child:
                              Text(
                                appBloc.localstr.detailsButtonLoadmorebutton,
                                style: TextStyle(
                                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                ),
                              ),
                            ),
                          ),
                        )
                            : Container(),
                        SizedBox(
                          height: 20.h,
                        ),

                        widget.screenType != ScreenType.Events
                            ? bottomActionButtonLogic()
                            : Container(),
                        // buildViewButton(data),
                        // buildPlayButton(data),

                        SizedBox(
                          height: 10.h,
                        ),
//                                    Container(
//                                        width:
//                                            MediaQuery.of(context).size.width,
//                                        height: 50.h,
//                                        child: OutlineButton(
//                                          onPressed: () {},
//                                          child: Text('Mark as complete'),
//                                          borderSide: BorderSide(
//                                              color: Color(int.parse(
//                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
//                                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),

                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ((widget.table2.objecttypeid == 70 && widget.table2.eventscheduletype == 1 || widget.table2.objecttypeid == 70 && widget.table2.eventscheduletype == 2) && widget.isShowShedule)
                      /*&& appBloc.uiSettingModel.EnableMultipleInstancesforEvent ==
                                                    'true'*/
                          ? scheduleWidget()
                          : Container()),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget getContentImageWidget() {
    double extraHeightForDownloadButton = 30.w;

    return Container(
      height: thumbnailImgHeight.h + extraHeightForDownloadButton,
      width: MediaQuery.of(
          context).size.width,
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: thumbnailImgHeight.h,
                width: MediaQuery.of(
                    context).size.width,
                child: CachedNetworkImage(
                  placeholder: (context, url) {
                    return Image.asset(
                      'assets/cellimage.jpg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      'assets/cellimage.jpg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  },
                  // imageUrl:
                  //     widget?.table2?.imageData ??
                  //         '',
                  imageUrl: (widget.table2.thumbnailimagepath.startsWith('http'))
                    ? widget.table2.thumbnailimagepath
                    : (widget.table2.siteurl.trim()) + (widget.table2.thumbnailimagepath.trim()),
                  fit: BoxFit.cover,
                ),
//                                    Image.network(
//                                      'https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg',
//                                      fit: BoxFit.fitWidth,
//                                    )
              ),
              SizedBox(height: extraHeightForDownloadButton,),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: kShowContentTypeIcon,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  color: Colors.white,
                  child: CachedNetworkImage(
                    height: 30,
                    imageUrl: contentIconPath,
                    width: 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          isValidString(data!.qrImageName ?? "")
            ? Positioned(
                bottom: 10.h,
                right: 60.h,
                child:
                Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrCodeScreen(ApiEndpoints.strSiteUrl + widget.table2.qrcodeimagepath)));
                    },
                    child: isValidString(data!.qrImageName ?? "")
                        ? Image.network(ApiEndpoints.strSiteUrl + data!.qrImageName,)
                        : SizedBox(height: 1.h,),
                  ),
                ),
              )
            : Container(),
          Positioned(
            bottom: 4,
            right: 15,
            child: displayDownloadButton(widget.table2),
          ),
        ],
      ),
    );
  }

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
    if ([8, 9, 11, 14, 21, 26, 36].contains(table2.objecttypeid)) {
      IconData iconData;
      Function? callback;
      Color color;

      MyLearningDownloadModel? downloadModel;
      if(downloadModel == null) {
        MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
        List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == table2.contentid).toList();
        //MyPrint.printOnConsole("Downloads Length:${downloads.length}");
        if(downloads.isNotEmpty) {
          downloadModel = downloads.first;
        }
      }

      if(isDownloadPaused) {
        iconData = Icons.play_arrow;
        callback = () {
          onDownloadPaused(downloadModel);
        };
      }
      else {
        if(isDownloading) {
          iconData = Icons.pause;
          callback = () {
            onDownloading(downloadModel);
          };
        }
        else {
          if(isDownloaded) {
            iconData = Icons.download_done_outlined;
            callback = () async {
              MyPrint.printOnConsole("onDownloaded called");
            };
          }
          else {
            if(isZipFile) {
              if(isDownloadFileExtracted) {
                iconData = Icons.download_rounded;
                callback = () => _onDownloadTap(table2);
              }
              else {
                iconData = Icons.folder_zip;
              }
            }
            else {
              iconData = Icons.download_rounded;
              callback = () => _onDownloadTap(table2);
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
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
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
    else {
      return const SizedBox(width: 0.0);
    }
  }

  Widget getContentNameWidget() {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            data?.titleName ?? "",
            style: TextStyle(
              color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              fontSize: 17.h,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _myList(String tabName) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(10)),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, i) => Container(
                        child: getTabList(tabName, i),
                      )),
            ],
          ),
        ),
      ],
    );
  }

  Widget getTabList(String tabName, int position) {
    if (tabName == "Sessions") {
      return widgetSessionsListItems(position);
    }
    if (tabName == "Resource") {
      return widgetResourceListItems(position);
    } else {
      return widgetGlosaryListItems(position);
    }
  }

  Widget widgetGlosaryListItems(int position) {
    return ExpansionTile(
      title: Text(
        "A",
        style: TextStyle(
          fontSize: 17.h,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: <Widget>[
        Column(
          children: _buildExpandableContent(),
        ),
      ],
//
//
    );
  }

  _buildExpandableContent() {
    List<Widget> columnContent = [];

    for (int i = 0; i < 3; i++) {
      columnContent.add(const Padding(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text("Content"),
        ),
      ));
    }

    return columnContent;
  }

  Widget widgetSessionsListItems(int position) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
    String videoUrl1 =
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
    String videoUrl =
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
    String pdfUrl =
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
    String htmlUrl = "https://www.google.com/";
    //print("table2.siteurl + table2.thumbnailimagepath : ${table2.siteurl + table2.thumbnailimagepath}");

    String contentIconPath = widget.table2.iconpath;

    if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? widget.table2.iconpath
          : appBloc.uiSettingModel.azureRootPath + widget.table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = widget.table2.siteurl + contentIconPath;
    }

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CommonDetailScreen(
                table2: widget.table2,
                detailsBloc: detailsBloc,
              )));
        },
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(thumbnailImgHeight),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      width: MediaQuery.of(context).size.width,
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      placeholder: (context, url) => Container(
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                              heightFactor: ScreenUtil().setWidth(20),
                              widthFactor: ScreenUtil().setWidth(20),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ))),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        )),
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
                          "in Progress",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: Colors.white),
                        ),
                      )),
                ],
              ),
              const LinearProgressIndicator(
                value: 80,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                backgroundColor: Colors.grey,
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
                                "ClassRoom",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Text(
                                "Office ergonomics review and observation",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.more_vert,
                            color: InsColor(appBloc).appIconColor,
                          ),
                        ),

                        /*PopupMenuButton<String>(
                          // onSelected: handleClick,
                          itemBuilder: (BuildContext context) {
                            return {'Progress Report', 'Delete'}
                                .map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: GestureDetector(
                                  onTap: (){

                                  },
                                    child: Text(choice)),
                              );
                            }).toList();
                          },
                        ),*/
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            width: ScreenUtil().setWidth(20),
                            height: ScreenUtil().setWidth(20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imgUrl)))),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(
                          "Henk Fortuin, Tony Finny",
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
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: (v) {},
                            starCount: 5,
                            rating: 3,
                            size: ScreenUtil().setHeight(10),
                            // filledIconData: Icons.blur_off,
                            // halfFilledIconData: Icons.blur_on,
                            color: Colors.orange,
                            borderColor: Colors.orange,
                            spacing: 0.0),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Expanded(
                          child: Text(
                            "See Reviews".toUpperCase(),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Table(
                        columnWidths: {
                          0: const FractionColumnWidth(.2),
                          1: const FractionColumnWidth(.5)
                        },
                        children: [
                          TableRow(children: [
                            Text(
                              "Start Date",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey),
                            ),
                            Text(
                              "03 NOV 2020 12:40 Am".toUpperCase(),
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Table(
                        columnWidths: {
                          0: const FractionColumnWidth(.2),
                          1: const FractionColumnWidth(.5)
                        },
                        children: [
                          TableRow(children: [
                            Text(
                              "End Date",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey),
                            ),
                            Text(
                              "10 NOV 2020 12:40 Am".toUpperCase(),
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black),
                            ),
                          ])
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Table(
                        columnWidths: {
                          0: const FractionColumnWidth(.2),
                          1: const FractionColumnWidth(.5)
                        },
                        children: [
                          TableRow(children: [
                            Text(
                              "TimeZone",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey),
                            ),
                            Text(
                              "Greenwich Mean Time",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black),
                            ),
                          ])
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Table(
                        columnWidths: {
                          0: const FractionColumnWidth(.2),
                          1: const FractionColumnWidth(.5)
                        },
                        children: [
                          TableRow(children: [
                            Text(
                              "Location".toUpperCase(),
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey),
                            ),
                            Text(
                              "Bangkok Thailand",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black),
                            ),
                          ])
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetResourceListItems(int position) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
    String videoUrl1 =
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
    String videoUrl =
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
    String pdfUrl =
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
    String htmlUrl = "https://www.google.com/";
    //print("table2.siteurl + table2.thumbnailimagepath : ${table2.siteurl + table2.thumbnailimagepath}");

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CommonDetailScreen(
                table2: widget.table2,
                detailsBloc: detailsBloc,
              )));
        },
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(thumbnailImgHeight),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      width: MediaQuery.of(context).size.width,
                      //placeholder: (context, url) => CircularProgressIndicator(),
                      placeholder: (context, url) => Container(
                          color: Colors.grey.withOpacity(0.5),
                          child: Center(
                              heightFactor: ScreenUtil().setWidth(20),
                              widthFactor: ScreenUtil().setWidth(20),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ))),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),

                    /*child: Image.network(
                      "https://qa.instancy.com"+table2.thumbnailimagepath,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),*/

                    /*decoration: new BoxDecoration(

                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.darken),
                          image: AssetImage(
                            "https://qa.instancy.com"+table2.thumbnailimagepath,
                          ),
                        )
                    ),*/
                  ),
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        )),
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
                          "in Progress",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(10),
                              color: Colors.white),
                        ),
                      )),
                ],
              ),
              const LinearProgressIndicator(
                value: 80,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                backgroundColor: Colors.grey,
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
                                "ClassRoom",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Text(
                                "Office ergonomics review and observation",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
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
                        Container(
                            width: ScreenUtil().setWidth(20),
                            height: ScreenUtil().setWidth(20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(imgUrl)))),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(
                          "Henk Fortuin, Tony Finny",
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
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: (v) {},
                            starCount: 5,
                            rating: 3,
                            size: ScreenUtil().setHeight(10),
                            // filledIconData: Icons.blur_off,
                            // halfFilledIconData: Icons.blur_on,
                            color: Colors.orange,
                            borderColor: Colors.orange,
                            spacing: 0.0),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Expanded(
                          child: Text(
                            "See Reviews".toUpperCase(),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Colors.black.withOpacity(0.5)),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: FlatButton.icon(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          icon: const Icon(
                            Icons.cloud_download,
                            color: Colors.white,
                            size: 25,
                          ),
                          label: Text(
                            "Download".toUpperCase(),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.white),
                          ),
                          onPressed: () {},
                        )),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Expanded(
                            child: FlatButton.icon(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                          icon: const Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: 25,
                          ),
                          label: Text(
                            "View".toUpperCase(),
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.white),
                          ),
                          onPressed: () {},
                        ))
                      ],
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

//  menu.getItem(4).setTitle(getLocalizationValue(JsonLocalekeys.mylearning_actionbutton_rescheduleactionbutton));
  // TODO: MyLearning Methods
  _settingMyLearningBottomSheet(context) {
    print("_settingMyLearningBottomSheet called");

    MyLearningDownloadModel myLearningDownloadModel = MyLearningDownloadModel(table2: widget.table2);

    MyLearningDownloadProvider myLearningDownloadProvider = Provider.of<MyLearningDownloadProvider>(context, listen: false);
    List<MyLearningDownloadModel> downloads = myLearningDownloadProvider.downloads.where((element) => element.table2.contentid == widget.table2.contentid).toList();
    if(downloads.isNotEmpty) {
      myLearningDownloadModel = downloads.first;
    }

    showModalBottomSheet(
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const BottomSheetDragger(),
                  displayPauseDownload(widget.table2, myLearningDownloadModel),
                  displayResumeDownload(widget.table2, myLearningDownloadModel),
                  displayCancelDownload(widget.table2, myLearningDownloadModel),
                  displayRemoveFromDownload(widget.table2, myLearningDownloadModel),
                  displayPlay(widget.table2),
                  displayView(widget.table2),
                  //displayDetails(table2, i),
                  //displayJoin(widget.table2),
                  // displayDownload(table2, i), commented for till offline implementation
                  displayReport(),
                  !widget.isShowShedule ? displayaddToCalendar() : Container(),
                  displaySetComplete(),
                  displayRelatedContent(),
                  displayCancelEnrollemnt(),
                  displayDelete(widget.table2),
                  myLearningBloc.showArchieve == "true"
                      ? displayArchive(widget.table2)
                      : Container(),
                  displayUnArachive(widget.table2),
                  //displayRemove(widget.table2),
                  !widget.isFromReschedule ? displayReschedule() : Container(),
                  displayCertificate(),
                  displayQRCode(),
                  displayEventRecording(),
                  displayShare(widget.table2),
                  displayShareConnection(widget.table2),
                  //sreekanth commented
                  //  displaySendViaEmail(widget.table2),
//                  displayCancelEnrollemnt()
                ],
              ),
            ),
          );

          /*return BlocConsumer(
              bloc: myLearningBloc,
              builder: (context, state) {
                if (state is CourseTrackingState) {
                  if (state.status == Status.COMPLETED) {
                    print(state.response);
                    if (isValidString(state.response)) {
                      myLearningBloc.add(TokenFromSessionIdEvent(
                          table2: state.table2,
                          contentID: state.table2.contentid,
                          objecttypeId: "${state.table2.objecttypeid}",
                          userID: "${state.table2.objecttypeid}",
                          courseName: "${state.table2.name}",
                          courseURL: state.courseUrl,
                          learnerSCOID: "${state.table2.scoid}",
                          learnerSessionID: state.response.toString()));
                    }
                  } else if (state.status == Status.ERROR) {
                    if (state.message == "401") {
                      AppDirectory.sessionTimeOut(context);
                    }
                  }
                }
                else if (state is TokenFromSessionIdState) {
                  if (state.status == Status.COMPLETED) {
                    if (isValidString(state.response) &&
                        state.response.contains('failed')) {
                      launchCourse(state.table2, context, true);
                    } else {
                      launchCourseContentisolation(state.table2, context, state.response.toString());
                    }
                  } else if (state.status == Status.ERROR) {
                    if (state.message == "401") {
                      AppDirectory.sessionTimeOut(context);
                    }
                  }
                }

              },
              listener: (context, state) {});*/
        });
  }

  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1349) {
        return true;
      }
    }
    return false;
  }

  Widget displaySendViaEmail(DummyMyCatelogResponseTable2 table2) {
    // if ((table2?.ShareContentwithUser?.length ?? 0) > 0) {
    if (privilegeCreateForumIdExists()) {
      if (table2.objecttypeid == 14) {
        return ListTile(
          leading: Icon(
            Icons.email,
            //IconDataSolid(int.parse('0xf06e')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningsendviaemailnewoption == null
                  ? 'Share via Email'
                  : appBloc.localstr.mylearningsendviaemailnewoption,
              style: TextStyle(
                  color: Color(
                int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
              ))),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SendviaEmailMylearning(
                      table2,
                      true,
                      myLearningBloc.list,
                    )));
          },
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }

//    return Container();
  }

  void getDetailsApiCall(String contentid) {
    MyLearningDetailsRequest detailsRequest = MyLearningDetailsRequest();
    detailsRequest.locale = 'en-us';
    detailsRequest.contentId = contentid;
    detailsRequest.metadata = '1';
    detailsRequest.intUserId = strUserID;
    detailsRequest.iCms = false;
    detailsRequest.componentId = '';
    detailsRequest.siteId = ApiEndpoints.siteID;
    detailsRequest.eRitems = '';
    detailsRequest.detailsCompId = '107';
    detailsRequest.detailsCompInsId = '3291';
    detailsRequest.componentDetailsProperties = '';
    detailsRequest.hideAdd = 'false';
    detailsRequest.objectTypeId = '-1';
    detailsRequest.scoId = '';
    detailsRequest.subscribeErc = false;

    detailsBloc
        .add(GetLearningDetails(myLearningDetailsRequest: detailsRequest));

    print("om--------${detailsRequest.toString()}");
  }

  Future<void> launchCourse(DummyMyCatelogResponseTable2 table2, BuildContext context, bool isContentisolation) async {
    print('helllllllllloooooo:$isContentisolation');

    bool isValid = isValidString(table2.viewprerequisitecontentstatus ?? "");
    print("isValid:$isValid");
    print("Object Id:${table2.objecttypeid}");

    if (isValid) {
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Pre-requisite Sequence',
                style: TextStyle(
                    color: Color(
                      int.parse(
                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                    ),
                    fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alertMessage,
                      style: TextStyle(
                          color: Color(
                            int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                          ))),
                  Text(
                      '\n${table2.viewprerequisitecontentstatus
                              .toString()
                              .split('#%')[1]
                              .split('\$;')[0]}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      )),
                  Text(
                      table2.viewprerequisitecontentstatus
                          .toString()
                          .split('#%')[1]
                          .split('\$;')[1],
                      style: TextStyle(
                          color: Color(
                            int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                          )))
                ],
              ),
              backgroundColor: InsColor(appBloc).appBGColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              actions: <Widget>[
                FlatButton(
                  child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                  textColor: Colors.blue,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
      );
    }
    else {
      bool result = await MyLearningController().decideCourseLaunchMethod(
        context: context,
        table2: table2,
        isContentisolation: false,
      );
      if (!result) {
        table2.isdownloaded = false;
        setState(() {});
      }
    }
  }

  Future<void> launchCourse2(DummyMyCatelogResponseTable2 table2, BuildContext context, bool isContentisolation) async {
    print('helllllllllloooooo:$isContentisolation');

    bool isValid = isValidString(table2.viewprerequisitecontentstatus ?? "");
    print("isValid:$isValid");
    print("Object Id:${table2.objecttypeid}");

    if (isValid) {
//            print('ifdataaaaa');
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage;
      // "  \"" +
      // appBloc.localstr.prerequisLabelContenttypelabel +
      // "\" " +
      // appBloc.localstr.prerequistesalerttitle5Alerttitle7;

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  'Pre-requisite Sequence',
                  style: TextStyle(
                      color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      ),
                      fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alertMessage,
                        style: TextStyle(
                            color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ))),
                    Text(
                        '\n${table2.viewprerequisitecontentstatus
                                .toString()
                                .split('#%')[1]
                                .split('\$;')[0]}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.blue,
                        )),
                    Text(
                        table2.viewprerequisitecontentstatus
                            .toString()
                            .split('#%')[1]
                            .split('\$;')[1],
                        style: TextStyle(
                            color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        )))
                  ],
                ),
                backgroundColor: InsColor(appBloc).appBGColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                actions: <Widget>[
                  FlatButton(
                    child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                    textColor: Colors.blue,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
    else {
      //TODO: Course Launch -- Start ---
      /// content isolation only for 8,9,10,11,26,27
      if (!isContentisolation) {
        if (table2.objecttypeid == 8 ||
            table2.objecttypeid == 9 ||
            (table2.objecttypeid == 10 && !table2.bit5) ||
            table2.objecttypeid == 26 ||
            table2.objecttypeid == 102) {
          /// remove after normal course launch
          GotoCourseLaunchContentisolation courseLaunch =
              GotoCourseLaunchContentisolation(
                  context, table2, appBloc.uiSettingModel, myLearningBloc.list);

          String courseUrl = await courseLaunch.getCourseUrl();

          print("courseUrl:$courseUrl");

          myLearningBloc.add(CourseTrackingEvent(
            courseUrl: courseUrl,
            table2: table2,
            userID: table2.userid.toString(),
            objecttypeId: "${table2.objecttypeid}",
            siteIDValue: "${table2.siteid}",
            scoId: "${table2.scoid}",
            contentID: table2.contentid,
          ));
          return;
        }
      }

      /// Need Some value
      if (table2.objecttypeid == 102) {
        executeXAPICourse(table2);
      }
      else if (table2.objecttypeid == 10 && table2.bit5) {
        // Need to open EventTrackListTabsActivity

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventTrackList(
                  table2,
                  true,
                  myLearningBloc.list,
                )));
      }
      else if (table2.objecttypeid == 694) {
        assignmenturl = '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}/ismobilecontentview/true';
        print('assignmenturl is : $assignmenturl');

        Navigator.pop(context);
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => Assignmentcontentweb(
                      url: assignmenturl,
                      myLearningModel: table2,
                    )))
            .then((value) => {
                  if (value)
                    {
                      myLearningBloc.add(GetListEvent(
                          pageNumber: 1, pageSize: 10, searchText: ""))
                    }
                });

        String ss = "";
      }
      else if ([8, 9, 10, 102, 26].contains(table2.objecttypeid)) {
        String paramsString = "";
        if (table2.objecttypeid == 10 && table2.bit5) {
          paramsString = "userID=${table2.userid}&scoid=${table2.scoid}&TrackObjectTypeID=${table2.objecttypeid}&TrackContentID=${table2.contentid}&TrackScoID=${table2.scoid}&SiteID=${table2.siteid}&OrgUnitID=${table2.siteid}&isonexist=onexit";
        } else {
          paramsString = "userID=${table2.userid}&scoid=${table2.scoid}";
        }

        String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

        String url =
            "$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString";

        print('launchCourseUrl $url');

        detailsBloc.add(GetContentStatus(url: url, table2: table2));
      }
      else {
        courseLaunch = GotoCourseLaunch(context, table2, false,
            appBloc.uiSettingModel, myLearningBloc.list);
        String url = await courseLaunch!.getCourseUrl();

        print('urldataaaaa $url');
        if (url.isNotEmpty) {
          if (table2.objecttypeid == 26) {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AdvancedWebCourseLaunch(url, table2.name)));
          } else {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InAppWebCourseLaunch(url, table2)));
          }
          print(".....Refresh Me....$url");

          /// Refresh Content Of My Learning

        }
      }

      //sreekanth commented
      //  Assignment content webview

      //sreekanth commented

      //TODO: Course Launch -- End ---

    }
  }

  /*Future<void> launchCourseOffline(DummyMyCatelogResponseTable2 table2) async {
    bool fileCheck = await myLearningBloc.fileExistCheck(table2, appBloc.userid);
    print("launchCourseOffline called with isDownloaded:$fileCheck");

    if (!fileCheck) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
                color: Color(
                  int.parse(
                      '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
                ),
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            'This course has not been downloaded. Please download in order to view it.',
            style: TextStyle(
              color: Color(
                int.parse(
                    '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
              ),
            ),
          ),
          backgroundColor: InsColor(appBloc).appBGColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          actions: <Widget>[
            TextButton(
              child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
              style: textButtonStyle,
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OfflineContentLauncherInAppWebview(
          table2: table2,
        ),
      ),
    );
    return;
  }*/

  // Future<void> launchCourse(DummyMyCatelogResponseTable2 table2,
  //     BuildContext context, bool isContentisolation) async {
  //   /// Need Some value
  //   if (table2.objecttypeid == 102) {
  //     executeXAPICourse(table2);
  //   }
  //
  //   courseLaunch = GotoCourseLaunch(
  //       context, table2, false, appBloc.uiSettingModel, widget.mylearninglist);
  //   String url = await courseLaunch.getCourseUrl();
  //   if (url.isNotEmpty) {
  //     //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
  //     await Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => InAppWebCourseLaunch(url, table2)));
  //   }
  //
  //   if (table2.objecttypeid == 8 ||
  //       table2.objecttypeid == 9 ||
  //       table2.objecttypeid == 10 ||
  //       table2.objecttypeid == 28 ||
  //       table2.objecttypeid == 102 ||
  //       table2.objecttypeid == 26) {
  //     String paramsString = "";
  //     if (table2.objecttypeid == 10 && table2.bit5) {
  //       paramsString = "userID=" +
  //           table2.userid.toString() +
  //           "&scoid=" +
  //           table2.scoid.toString() +
  //           "&TrackObjectTypeID=" +
  //           table2.objecttypeid.toString() +
  //           "&TrackContentID=" +
  //           table2.contentid +
  //           "&TrackScoID=" +
  //           table2.scoid.toString() +
  //           "&SiteID=" +
  //           table2.siteid.toString() +
  //           "&OrgUnitID=" +
  //           table2.siteid.toString() +
  //           "&isonexist=onexit";
  //     } else {
  //       paramsString = "userID=" +
  //           table2.userid.toString() +
  //           "&scoid=" +
  //           table2.scoid.toString();
  //     }
  //
  //     String webApiUrl = await sharePref_getString(sharedPref_webApiUrl);
  //
  //     String url =
  //         webApiUrl + "/MobileLMS/MobileGetContentStatus?" + paramsString;
  //
  //     print('launchCourseUrl $url');
  //
  //     detailsBloc.add(GetContentStatus(url: url));
  //   }
  // }

  Future<void> launchCourseContentisolation(DummyMyCatelogResponseTable2 table2, BuildContext context, String token) async {
    print(
        'launchCourseContentisolation ${table2.objecttypeid}, table2.bit5:${table2.bit5}');
    if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 26) {
      String paramsString = "";
      if (table2.objecttypeid == 10 && table2.bit5) {
        /*paramsString = "userID=" +
            table2.userid.toString() +
            "&scoid=" +
            table2.scoid.toString() +
            "&TrackObjectTypeID=" +
            table2.objecttypeid.toString() +
            "&TrackContentID=" +
            table2.contentid +
            "&TrackScoID=" +
            table2.scoid.toString() +
            "&SiteID=" +
            table2.siteid.toString() +
            "&OrgUnitID=" +
            table2.siteid.toString() +
            "&isonexist=onexit";*/

        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventTrackList(
                  table2,
                  true,
                  myLearningBloc.list,
                )));
        return;
      } else {
        paramsString = "userID=${table2.userid}&scoid=${table2.scoid}";
      }

      if (token.isNotEmpty) {
        String courseUrl;
        if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
          courseUrl = "${appBloc.uiSettingModel.azureRootPath}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}";
        }
        else {
          courseUrl = "${ApiEndpoints.strSiteUrl}content/index.html?coursetoken=$token&TokenAPIURL=${ApiEndpoints.appAuthURL}";
        }

        if (table2.objecttypeid == 26) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  AdvancedWebCourseLaunch(courseUrl, table2.name)));
        }
        else {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(courseUrl, table2)));
        }

        /// Refresh Content Of My Learning

      }

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url =
          "$webApiUrl/MobileLMS/MobileGetContentStatus?$paramsString";

      print('launchCourseUrl $url');

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
    }
  }


  //region Bottomsheet Options
  Widget displayPauseDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || !downloadModel.table2.isDownloading) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.pause,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Pause Download",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        Navigator.of(context).pop();

        onDownloading(downloadModel);
      },
    );
  }

  Widget displayResumeDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading || downloadModel.table2.isDownloading) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.play_arrow,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Resume Download",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        Navigator.of(context).pop();

        onDownloadPaused(downloadModel);
      },
    );
  }

  Widget displayCancelDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(downloadModel.taskId.isEmpty || downloadModel.isFileDownloaded || !downloadModel.isFileDownloading) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.delete,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Cancel Download",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        MyPrint.printOnConsole('Cancel Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        await MyLearningDownloadController().cancelDownload(downloadModel);
        setState(() {});
      },
    );
  }

  Widget displayRemoveFromDownload(DummyMyCatelogResponseTable2 table2, MyLearningDownloadModel downloadModel) {
    if(!downloadModel.isFileDownloaded) {
      return const SizedBox();
    }

    return ListTile(
      leading: Icon(
        Icons.delete,
        color: InsColor(appBloc).appIconColor,
      ),
      title: Text(
        "Remove from Downloads",
        style: TextStyle(
            color: Color(
              int.parse(
                  '0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}'),
            )),
      ),
      onTap: () async {
        MyPrint.printOnConsole('Cancel Download Called:${downloadModel.taskId}');

        Navigator.of(context).pop();

        await MyLearningDownloadController().removeFromDownload(downloadModel);
        setState(() {});
      },
    );
  }

  Widget displayPlay(DummyMyCatelogResponseTable2 table2) {
    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        return ListTile(
            leading: Icon(
              IconDataSolid(int.parse('0xf144')),
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(
              appBloc.localstr.mylearningActionsheetPlayoption,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            onTap: () async {
              Navigator.of(context).pop();

              if (table2.objecttypeid == 102) {
                executeXAPICourse(table2);
              }

              bool result = await MyLearningController().decideCourseLaunchMethod(
                context: context,
                table2: table2,
                isContentisolation: false,
              );
            });
      }
    }

    return Container();
  }

  Widget displayView(DummyMyCatelogResponseTable2 table2) {
    print("Display View Called");

    if (table2.objecttypeid == 11 ||
        table2.objecttypeid == 14 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 21 ||
        table2.objecttypeid == 52) {
      if (table2.objecttypeid == 11 &&
          (table2.mediatypeid == 3 || table2.mediatypeid == 4)) {
        print("View Displayed1");
        return Container();
      } else {
        print("View Displayed2");

        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf06e')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetViewoption,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
          onTap: () async {
            Navigator.of(context).pop();

            if (isValidString(table2.viewprerequisitecontentstatus ?? "")) {
//              print('ifdataaaaa');
              String alertMessage =
                  appBloc.localstr.prerequistesalerttitle6Alerttitle6;
              alertMessage = "$alertMessage  \"${appBloc.localstr.prerequisLabelContenttypelabel}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          appBloc.localstr.detailsAlerttitleStringalert,
                          style: TextStyle(
                              color: InsColor(appBloc).appTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Text(alertMessage,
                            style: TextStyle(
                              color: InsColor(appBloc).appTextColor,
                            )),
                        backgroundColor: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                                appBloc.localstr.eventsAlertbuttonOkbutton),
                            textColor: Colors.blue,
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            } else {
//              print('elsedataaaa');

              if (table2.objecttypeid == 102) {
                executeXAPICourse(table2);
              }

              bool result = await MyLearningController().decideCourseLaunchMethod(
                context: context,
                table2: table2,
                isContentisolation: false,
              );
            }
          },
        );
      }
    } else if (table2.objecttypeid == 688 || table2.objecttypeid == 70) {
      print("View Displayed4");

      return Container();
    } else {
      print("View Displayed3");

      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf06e')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(
          appBloc.localstr.mylearningActionsheetViewoption,
          style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        onTap: () async {
          Navigator.of(context).pop();
          if (table2.objecttypeid == 102) {
            executeXAPICourse(table2);
          }

          bool result = await MyLearningController().decideCourseLaunchMethod(
            context: context,
            table2: table2,
            isContentisolation: false,
          );
        },
      );
    }
//    return Container();
  }

  Widget displayReport() {
    if (widget.table2.objecttypeid == 11 ||
        widget.table2.objecttypeid == 14 ||
        widget.table2.objecttypeid == 36 ||
        widget.table2.objecttypeid == 28 ||
        widget.table2.objecttypeid == 20 ||
        widget.table2.objecttypeid == 21 ||
        widget.table2.objecttypeid == 52) {
      return Container();
    } else if (widget.table2.objecttypeid == 70) {
      return Container();
    } else if (widget.table2.objecttypeid == 688) {
      return Container();
    } else {
      if (widget.table2.objecttypeid == 27) {
        return Container();
      } else {
        if (!isReportEnabled) {
          return Container();
        }

        return ListTile(
            leading: SvgPicture.asset(
              'assets/Report.svg',
              width: 25.h,
              height: 25.h,
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(appBloc.localstr.mylearningActionsheetReportoption,
                style: TextStyle(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProgressReport(widget.table2, detailsBloc, "", "-1")));
            });
      }
    }
  }

  Widget displayaddToCalendar() {
    if (!isFromCatalog) {
      if (isValidString(widget.table2.eventenddatetime ?? "") &&
          !returnEventCompleted(widget.table2.eventenddatetime ?? "")) {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf271')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetAddtocalendaroption,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
          onTap: () {
            DateTime startDate = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(widget.table2.eventstartdatetime);
            DateTime endDate = DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(widget.table2.eventenddatetime);

//            print(
//                'event start-end time ${table2.eventstartdatetime}  ${table2.eventenddatetime}');
            Event event = Event(
              title: widget.table2.name,
              description: widget.table2.shortdescription,
              location: widget.table2.locationname,
              startDate: startDate,
              endDate: endDate,
              allDay: false,
            );

            Add2Calendar.addEvent2Cal(event).then((success) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: success
                        ? 'Event added successfully'
                        : 'Error occured while adding event'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            });
          },
        );
      }

      if (widget.table2.eventscheduletype == 1 &&
          appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
        return Container();
      }
    }

    return Container();
  }

  Widget displaySetComplete() {
    if (isValidString(widget.table2.objecttypeid.toString()) &&
        (widget.table2.objecttypeid == 11 ||
            widget.table2.objecttypeid == 14 ||
            widget.table2.objecttypeid == 36 ||
            widget.table2.objecttypeid == 28 ||
            widget.table2.objecttypeid == 20 ||
            widget.table2.objecttypeid == 21 ||
            widget.table2.objecttypeid == 52)) {
      if (isValidString(widget.table2.actualstatus) &&
          ((widget.table2.actualstatus != 'completed'))) {
        return ListTile(
            leading: SvgPicture.asset(
              'assets/SetComplete.svg',
              width: 25.h,
              height: 25.h,
              color: InsColor(appBloc).appIconColor,
            ),
            title: Text(
                appBloc.localstr.mylearningActionsheetSetcompleteoption,
                style: TextStyle(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
            onTap: () {
              Navigator.pop(context);
              detailsBloc.add(SetCompleteEvent(table2: widget.table2));
            });
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget displayRelatedContent() {
    return Container();

//    new ListTile(
////                  leading: new Icon(Icons.share),
//      title: new Text(appBloc
//          .localstr.mylearningActionsheetRelatedcontentoption),
//      onTap: () => {
//        Share.share(
//          'text',
//          subject: 'subject',
//        )
//      },
//    ),
  }

  Widget displayCancelEnrollemnt() {
    if (widget.table2.objecttypeid == 70) {
      // returnEventCompleted
      if (isValidString(
          widget.table2.eventstartdatetime ??
              "")) if (!returnEventCompleted(
          widget.table2.eventstartdatetime ?? "")) {
//
        if (widget.table2.bit2 != null && widget.table2.bit2) {
          return ListTile(
              leading: Icon(
                IconDataSolid(int.parse('0xf410')),
                color: InsColor(appBloc).appIconColor,
              ),
              title: Text(
                  appBloc.localstr.mylearningActionsheetCancelenrollmentoption,
                  style: TextStyle(
                      color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      ))),
              onTap: () {
                checkCancellation(widget.table2, context);
              });
        }
// for schedule events
        if (widget.table2.eventscheduletype == 1 &&
            appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
          return ListTile(
              leading: const Icon(Icons.cancel),
              title: Text(
                  appBloc.localstr.mylearningActionsheetCancelenrollmentoption,
                  style: TextStyle(
                      color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      ))),
              onTap: () {
                checkCancellation(widget.table2, context);
              });
        }
      }
    }

    return Container();
  }

  Widget displayDelete(DummyMyCatelogResponseTable2 table2) {
    downloadPath(table2.contentid, table2);

    if (table2.isdownloaded && table2.objecttypeid != 70) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf1f8')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetDeleteoption,
              style: TextStyle(
                  color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  ))),

          /// TODO : Sagar sir - delete offline file
          onTap: () async {
            Navigator.pop(context);

            bool fileDel = await deleteFile(downloadDestFolderPath);

            print('filedeleted $downloadDestFolderPath ${table2.contentid}');
            if (fileDel) {
              setState(() {
                //isDownloaded = false;
                //isDownloading = false;
                downloadedProgess = 0;
                table2.isdownloaded = false;
                table2.isDownloading = false;
              });
            }
          });
    }

    return Container();
  }

  Widget displayArchive(DummyMyCatelogResponseTable2 table2) {
    if (detailsBloc.myLearningDetailsModel.isArchived != null &&
        !detailsBloc.myLearningDetailsModel.isArchived) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf187')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetArchiveoption,
              style: TextStyle(
                  color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  ))),
          onTap: () {
            myLearningBloc.add(AddToArchiveCall(isArchive: true, strContentID: table2.contentid, table2: table2));
            Navigator.pop(context);
          });
    } else {
      return Container();
    }
  }

  Widget displayUnArachive(DummyMyCatelogResponseTable2 table2) {
    if (detailsBloc.myLearningDetailsModel.isArchived != null &&
        detailsBloc.myLearningDetailsModel.isArchived) {
      return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf187')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetUnarchiveoption,
              style: TextStyle(
                  color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  ))),
          onTap: () {
            myLearningBloc.add(RemoveToArchiveCall(isArchive: false, strContentID: table2.contentid, table2: table2));
            Navigator.pop(context);
          });
    } else {
      return Container();
    }
  }

  Widget displayReschedule() {
    if (isValidString(widget.table2.reschduleparentid ?? "")) {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf783')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text(
            appBloc.localstr.mylearningActionbuttonRescheduleactionbutton,
            style: TextStyle(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
        onTap: () => {},
      );
    } else {
      return Container();
    }
  }

  Widget displayCertificate() {
    if (isValidString(widget.table2.certificateaction)) {
      return ListTile(
          leading: SvgPicture.asset(
            'assets/Certificate.svg',
            width: 25.h,
            height: 25.h,
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(
              appBloc.localstr.mylearningActionsheetViewcertificateoption,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
          onTap: () {
            if (widget.table2.certificateaction == 'notearned') {
              Navigator.of(context).pop();

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      appBloc.localstr
                          .mylearningActionsheetViewcertificateoption,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                    content: Text(
                      appBloc.localstr
                          .mylearningAlertsubtitleForviewcertificate,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    ),
                    backgroundColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(appBloc.localstr
                            .mylearningClosebuttonactionClosebuttonalerttitle),
                        textColor: Colors.blue,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ViewCertificate(detailsBloc: detailsBloc)));
            }
          });
    } else {
      return Container();
    }
  }

  Widget displayQRCode() {
    if (widget.table2.objecttypeid.toString() == "70") {
      if (isValidString(widget.table2.qrimagename ?? "") &&
          isValidString(widget.table2.qrcodeimagepath ?? "") &&
          !widget.table2.bit4) {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf029')),
            color: InsColor(appBloc).appIconColor,
          ),
          title: Text(appBloc.localstr.mylearningActionsheetViewqrcode,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QrCodeScreen(
                    ApiEndpoints.strSiteUrl + widget.table2.qrcodeimagepath)))
          },
        );
      }
    }

    return Container();
  }

  Widget displayEventRecording() {
    if (widget.table2.eventrecording != null && widget.table2.eventrecording) {
      if (widget.table2.isaddedtomylearning == 1 ||
          (typeFrom == 'event' || typeFrom == 'track')) {
        return ListTile(
          leading: Icon(
            IconDataSolid(int.parse('0xf8d9')),
            color: InsColor(appBloc).appIconColor,
          ),
          title:
          Text(appBloc.localstr.learningtrackLabelEventviewrecording),
          onTap: () => {},
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget displayShare(DummyMyCatelogResponseTable2 table2) {
    if (table2.suggesttoconnlink != null ||
        table2.suggesttoconnlink.isNotEmpty) {
      return ListTile(
        leading: Icon(
          IconDataSolid(int.parse('0xf1e0')),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text('Share with Connection',
            style: TextStyle(
                color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ))),
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShareWithConnections(
                  false, false, table2.name, table2.contentid)));
        },
      );
    }

    return Container();
  }

  Widget displayShareConnection(DummyMyCatelogResponseTable2 table2) {
    if (table2.suggestwithfriendlink != null ||
        table2.suggestwithfriendlink.isNotEmpty) {
      return ListTile(
        leading: Icon(
          IconDataSolid(
            int.parse('0xf079'),
          ),
          color: InsColor(appBloc).appIconColor,
        ),
        title: Text("Share with People",
            style: TextStyle(
                color: Color(
                  int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                ))),
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShareMainScreen(
                  true, false, false, table2.contentid, table2.name)));
        },
      );
    }

    return Container();
  }
  //endregion Bottomsheet Options

  bool displayDownload(DummyMyCatelogResponseTable2 table2) {
    print('obttypeid ${table2.objecttypeid}  ${table2.isdownloaded}');
    downloadPath(table2.contentid, table2);

    if ((table2.objecttypeid == 10 && table2.bit5) ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 20 ||
        table2.objecttypeid == 688 ||
        table2.objecttypeid == 693 ||
        table2.objecttypeid == 36 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 27 ||
        table2.objecttypeid == 70) {
      print('download if');
      download = false;
      return download;
    } else if (table2.isdownloaded && table2.objecttypeid != 70) {
      print('download else if');
      download = false;
      return download;
    } else {
      download = true;
      return download;
    }
  }

  bool isValidString(String val) {
    //print('validstrinh $val');
    if (val == null || val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  bool returnEventCompleted(String eventDate) {
    if (eventDate == null) return false;
//
    bool isCompleted = false;
//

    DateTime? fromDate;
    var difference;

    if (!isValidString(eventDate)) return false;

    try {
      fromDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(eventDate);

      final date2 = DateTime.now();
      difference = date2.difference(fromDate).inDays;
    } catch (e) {
      //e.printStackTrace();
      isCompleted = false;
    }
    if (fromDate == null) return false;

//    print('fiffenrecedays $difference');
    if (difference != null && difference < 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }

    return isCompleted;
  }


  Future<bool> deleteFile(String downloadDestFolderPath) async {
    try {
      final savedDir = Directory(downloadDestFolderPath);
      if (await savedDir.exists()) {
        await savedDir.delete(recursive: true);
        print('dir existes');
        return true;
      } else {
        print('dir does not existes');
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  void checkCancellation(DummyMyCatelogResponseTable2 table2, BuildContext context) {
    print('checkcancellation ${table2.isbadcancellationenabled}');

    Navigator.of(context).pop();
    if (table2.isbadcancellationenabled) {
      badCancelEnrollmentMethod(table2);

      // bad cancel
    } else {
      showCancelEnrollDialog(
          table2, table2.isbadcancellationenabled.toString());
    }
  }

  void getUserId() async {
    strUserID = await sharePrefGetString(sharedPref_userid);
  }

  // Widget buildViewButton(MyLearningDetailsResponse data) {
  //   if (widget.screenType != catalog) {
  //     if (widget.table2.objecttypeid == 11 ||
  //         widget.table2.objecttypeid == 14 ||
  //         widget.table2.objecttypeid == 36 ||
  //         widget.table2.objecttypeid == 28 ||
  //         widget.table2.objecttypeid == 20 ||
  //         widget.table2.objecttypeid == 21 ||
  //         widget.table2.objecttypeid == 52) {
  //       if (widget.table2.objecttypeid == 11 &&
  //           (widget.table2.mediatypeid == 3 ||
  //               widget.table2.mediatypeid == 4)) {
  //         return Container();
  //       } else {
  //         return displayButton(
  //             appBloc.localstr.mylearningActionsheetViewoption);
  //       }
  //     } else if (widget.table2.objecttypeid == 688 ||
  //         widget.table2.objecttypeid == 70) {
  //       return Container();
  //     } else {
  //       return displayButton(appBloc.localstr.mylearningActionsheetViewoption);
  //     }
  //   }
  // }

  // Widget buildPlayButton(MyLearningDetailsResponse data) {
  //   if (widget.table2.objecttypeid == 11 ||
  //       widget.table2.objecttypeid == 14 ||
  //       widget.table2.objecttypeid == 36 ||
  //       widget.table2.objecttypeid == 28 ||
  //       widget.table2.objecttypeid == 20 ||
  //       widget.table2.objecttypeid == 21 ||
  //       widget.table2.objecttypeid == 52) {
  //     if (widget.table2.objecttypeid == 11 &&
  //         (widget.table2.mediatypeid == 3 || widget.table2.mediatypeid == 4)) {
  //       return displayButton(appBloc.localstr.mylearningActionsheetPlayoption);
  //     }
  //   }
  //
  //   return Container();
  // }

  // Widget buildPlayButton(MyLearningDetailsResponse data) {
  //   if (widget.table2.objecttypeid == 11 ||
  //       widget.table2.objecttypeid == 14 ||
  //       widget.table2.objecttypeid == 36 ||
  //       widget.table2.objecttypeid == 28 ||
  //       widget.table2.objecttypeid == 20 ||
  //       widget.table2.objecttypeid == 21 ||
  //       widget.table2.objecttypeid == 52) {
  //     if (widget.table2.objecttypeid == 11 &&
  //         (widget.table2.mediatypeid == 3 || widget.table2.mediatypeid == 4)) {
  //       return displayButton(appBloc.localstr.mylearningActionsheetPlayoption);
  //     }
  //   }
  //
  //   return Container();
  // }

  Widget displayBottomButton(String label, dynamic onTap) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50.h,
        child: FlatButton(
            onPressed: () => {onTap()},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Icon(
                //   (label == appBloc.localstr.mylearningActionsheetViewoption)
                //       ? IconDataSolid(int.parse('0xf06e'))
                //       : IconDataSolid(int.parse('0xf144')),
                //   color: Color(int.parse(
                //       "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                //   size: 25.h,
                // ),
                SizedBox(
                  width: 5.h,
                ),
                Text(
                  label,
                  style: TextStyle(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                ),
              ],
            ),
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))));
  }

/*
  Future<void> executeXAPICourse(
      DummyMyCatelogResponseTable2 learningModel) async {
    /*String paramsString = "strContentID=" + learningModel.contentid +
        "&UserID=" + appUserModel.getUserIDValue()
        + "&SiteID="
        + appUserModel.getSiteIDValue()
        + "&SCOID=" + learningModel.scoid.toString() + "&CanTrack=true";*/
  }
  */

  String removeAllHtmlTags(String htmlText) {
    String parsedString = "";

    if (htmlText != null) {
      var document = parse(htmlText);

      parsedString =
          parse(document.body?.text ?? "").documentElement?.text ?? "";
    }

    return parsedString;
  }

  _settingCatalogBottomSheet(context) {
    print('bottomsheetobjit ${widget.table2.objecttypeid}');
    var dummyMyCatelogResponseTable = widget.table2;
    bool menu0 = false,
        menu1 = false,
        menu2 = false,
        menu3 = false,
        menu4 = false,
        menu5 = false,
        menu6 = false,
        menu7 = false,
        menu8 = false;

    print("isaddedtomylearning ---- ${widget.table2.isaddedtomylearning}");
    if (widget.table2.isaddedtomylearning == 1) {
      menu0 = true;
      menu1 = false;
      menu2 = false;
      menu3 = true;

      if (widget.table2.objecttypeid == 70) {
        int relatedCount =
            int.parse(widget.table2.relatedconentcount.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      }
    } else {
      print("table2.viewtype---- ${widget.table2.viewtype}");
      if (widget.table2.viewtype == 1) {
        if (widget.table2.isaddedtomylearning == 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
        menu1 = true;
        menu2 = false;
        menu3 = true;

        if (widget.table2.objecttypeid == 70 &&
            isValidString(widget.table2.eventstartdatetime() ?? "")) {
          menu1 = false;
        }

        if (appBloc.uiSettingModel.catalogContentDownloadType == "1" ||
            appBloc.uiSettingModel.catalogContentDownloadType == "2") {
          if (appBloc.uiSettingModel.catalogContentDownloadType == "0") {
            menu4 = false;
          }
        }
      } else if (widget.table2.viewtype == 2) {
        menu0 = false;
        menu1 = true;
        menu3 = true;
//
      } else if (widget.table2.viewtype == 3) {
        menu1 = false;
        menu2 = true;
        menu3 = true;
      }

      if (widget.table2.viewtype == 5) {
        // for ditrect view
        menu0 = true;
        menu3 = true;
        menu1 = false;

        if (widget.table2.isaddedtomylearning == 0) {
          menu1 = true;
        }
      }
    }

    if (appBloc.uiSettingModel.catalogContentDownloadType == "0") {
      menu5 = false;
    }

    if (appBloc.uiSettingModel.enableWishlist == "true") {
      if (widget.table2.isaddedtomylearning == 0 ||
          widget.table2.isaddedtomylearning == 2) {
        if (widget.table2.iswishlistcontent == 1) {
          menu7 = true; //isWishListed
        } else {
          menu6 = true; //removeWishListed
        }
      }
    }

    if (widget.table2.objecttypeid == 10 ||
        widget.table2.objecttypeid == 28 ||
        widget.table2.objecttypeid == 688 ||
        widget.table2.objecttypeid == 102 ||
        appBloc.uiSettingModel.catalogContentDownloadType == "0") {
      menu5 = false;
    }

    if (isValidString(widget.table2.eventrecording.toString()) &&
        widget.table2.eventrecording == true) {
      if (widget.table2.isaddedtomylearning == 1) {
        menu8 = true;
      }
    }
    showModalBottomSheet(
        backgroundColor: Color(
          int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const BottomSheetDragger(),
                  menu0
                      ? ListTile(
                          title: Text(
                            appBloc.localstr.catalogActionsheetViewoption,
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            )),
                          ),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf06e')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () async {
                            //print("imageurl---${table2.imageData}");
                            Navigator.pop(context);
                            if (widget.table2.isaddedtomylearning == 1) {
                              bool result = await MyLearningController().decideCourseLaunchMethod(
                                context: context,
                                table2: widget.table2,
                                isContentisolation: false,
                              );
                            } else {
                              launchCoursePreview(widget.table2, context);
                            }
                          },
                        )
                      : Container(),
                  menu1
                      ? isConsolidated && widget.table2.siteid != 374
                          ? Container()
                          : ListTile(
                              title: Text(
                                  appBloc.localstr
                                      .catalogActionsheetAddtomylearningoption,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                Icons.add_circle,
                                color: InsColor(appBloc).appIconColor,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                print(widget.table2.userid);
                                if (widget.table2.userid != null &&
                                    widget.table2.userid != "-1") {
                                  if (widget.table2.isaddedtomylearning == 2) {
                                    catalogBloc.add(
                                      GetPrequisiteDetailsEvent(
                                          contentId: widget.table2.contentid,
                                          userID: widget.table2.userid),
                                    );
                                  } else {
                                    /*setState(() {
                                      //selectedIndexOfAddedMyLearning = i;
                                    });*/
                                    //catalogBloc.add(
                                    /*((widget.table2.objecttypeid == 70 && widget.table2.eventscheduletype == 1) || (widget.table2.objecttypeid == 70 && widget.table2.eventscheduletype == 2))
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                      create: (context) =>
                                                          ProviderModel(),
                                                      child: CommonDetailScreen(
                                                        contentid: widget
                                                            .table2.contentid,
                                                        objtypeId: widget.table2
                                                            .objecttypeid,
                                                        detailsBloc:
                                                            detailsBloc,
                                                        table2: widget.table2,
                                                        screenType:
                                                            ScreenType.Catalog,
                                                        isFromReschedule: false,
                                                        // nativeModel:
                                                        //     widget.nativeMenuModel,
                                                      ),
                                                    )))
                                        : */
                                    catalogBloc.add(
                                      AddToMyLearningEvent(
                                          contentId: widget.table2.contentid,
                                          table2: widget.table2),
                                    );
                                  }
                                } else {
                                  flutterToast.showToast(
                                    child: CommonToast(
                                        displaymsg:
                                            'Not a member of ${widget.table2.sitename}'),
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: const Duration(seconds: 2),
                                  );
                                  checkUserLogin(widget.table2);
                                }
                              },
                            )
                      : Container(),
                  menu2
                      ? BlocConsumer(
                          bloc: catalogBloc,
                          builder: (context, state) {
                            if (state is SaveInAppPurchaseState) {
                              if (state.status == Status.COMPLETED) {
                                if (isValidString(state.response) &&
                                    state.response.contains('success')) {
                                  print("inapp purchase  success ");
                                  setState(() {
                                    widget.table2.isaddedtomylearning = 1;
                                  });
                                  MyToast.showToast(
                                      context,
                                      appBloc.localstr
                                          .catalogAlertsubtitleThiscontentitemhasbeenaddedto);
                                } else {}
                              } else if (state.status == Status.ERROR) {
                                if (state.message == "401") {
                                  AppDirectory.sessionTimeOut(context);
                                }
                              }
                            }
                            return isConsolidated && widget.table2.siteid != 374
                                ? Container()
                                : ListTile(
                                    title: Text(
                                        appBloc.localstr
                                            .catalogActionsheetBuyoption,
                                        style: TextStyle(
                                            color: Color(
                                          int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                        ))),
                                    leading: Icon(
                                      IconDataSolid(int.parse('0xf144')),
                                      color: InsColor(appBloc).appIconColor,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      buyCourse();
                                      /* flutterToast.showToast(
                                child:
                                    CommonToast(displaymsg: 'Work in Progress'),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 2),
                              );*/
                                    },
                                  );
                          },
                          listener: (context, state) {
//                             if (state is GetCategoryWisecatalogState) {
//                               if (state.status == Status.COMPLETED) {
// //            print("List size ${state.list.length}");
//                                 setState(() {
//                                   //isGetCatalogListEvent = true;
//                                   //pageNumber++;
//                                 });
//                               } else if (state.status == Status.ERROR) {
// //                print("listner Error ${state.message}");
//                                 if (state.message == "401") {
//                                   AppDirectory.sessionTimeOut(context);
//                                 }
//                               }
//                             }
//                             if (state is AddToWishListState ||
//                                 state is RemoveFromWishListState ||
//                                 state is AddToMyLearningState) {
//                               if (state.status == Status.COMPLETED) {
//                                 //catalogBloc.isFirstLoadingCatalog = true;
//
//                                 if (state is AddToWishListState) {
//                                   flutterToast.showToast(
//                                     child: CommonToast(
//                                         displaymsg: appBloc.localstr
//                                             .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
//                                     gravity: ToastGravity.BOTTOM,
//                                     toastDuration: Duration(seconds: 2),
//                                   );
//                                 }
//                                 if (state is RemoveFromWishListState) {
//                                   flutterToast.showToast(
//                                     child: CommonToast(
//                                         displaymsg: appBloc.localstr
//                                             .catalogAlertsubtitleItemremovedtowishlistsuccesfully),
//                                     gravity: ToastGravity.BOTTOM,
//                                     toastDuration: Duration(seconds: 2),
//                                   );
//                                 }
//                                 if (state is AddToMyLearningState) {
//                                   flutterToast.showToast(
//                                     child: CommonToast(
//                                         displaymsg: appBloc.localstr
//                                             .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
//                                     gravity: ToastGravity.BOTTOM,
//                                     toastDuration: Duration(seconds: 2),
//                                   );
//                                 }
//                               }
//                             }
//                             if (state.status == Status.ERROR) {
// //            print("listner Error ${state.message}");
//                               if (state.message == "401") {
//                                 AppDirectory.sessionTimeOut(context);
//                               }
//                             }
//
//                             if (state is GetPrequisiteDetailsState) {
//                               if (state.status == Status.COMPLETED) {
//                                 print(
//                                     "prequisitePopupresponse size ${state.prequisitePopupresponse.prerequisteData.table.length}");
//                               } else if (state.status == Status.ERROR) {
//                                 if (state.message == "401") {
//                                   AppDirectory.sessionTimeOut(context);
//                                 }
//                               }
//                             }
                          },
                        )
                      : Container(),
                  // menu3
                  //     ? ListTile(
                  //         title: Text(
                  //             appBloc.localstr.catalogActionsheetDetailsoption,
                  //             style: TextStyle(
                  //                 color: Color(
                  //               int.parse(
                  //                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  //             ))),
                  //         leading: Icon(
                  //           IconDataSolid(int.parse('0xf570')),
                  //           color: InsColor(appBloc).appIconColor,
                  //         ),
                  //         onTap: () {
                  //           Navigator.of(context).pop();
                  //           Navigator.of(context).push(MaterialPageRoute(
                  //               builder: (context) => CommonDetailScreen(
                  //                     contentid: widget.table2?.contentid,
                  //                     objtypeId: widget.table2?.objecttypeid,
                  //                     detailsBloc: detailsBloc,
                  //                     table2: widget.table2,
                  //                     screenType: ScreenType.Catalog,
                  //                     //nativeModel: widget.nativeMenuModel,
                  //                   )));
                  //
                  //           // Navigator.of(context).push(MaterialPageRoute(
                  //           //     builder: (context) => ChangeNotifierProvider(
                  //           //         create: (context) => InAppPurchase(),
                  //           //         child: CatalogDetailScreen(
                  //           //           contentid: table2.contentid,
                  //           //           objtypeId: table2.objecttypeid,
                  //           //           detailsBloc: detailsBloc,
                  //           //           table2: table2,
                  //           //           nativeModel: widget.nativeMenuModel,
                  //           //         ))));
                  //         },
                  //       )
                  //     : Container(),
                  menu4
                      ? ListTile(
                          title: Text(
                              appBloc.localstr.catalogActionsheetDeleteoption,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf144')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                        )
                      : Container(),
                  menu5
                      ? ListTile(
                          title: Text(
                              appBloc
                                  .localstr.mylearningActionsheetDownloadoption,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf144')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                        )
                      : Container(),
                  menu6
                      ? ListTile(
                          title: Text(
                              appBloc.localstr.catalogActionsheetWishlistoption,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          leading: Icon(
                            Icons.favorite_border,
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            catalogBloc.add(AddToWishListEvent(
                                contentId: widget.table2.contentid));
                            widget.table2.iswishlistcontent = 1;
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                  menu7
                      ? ListTile(
                          title: Text(
                              appBloc.localstr
                                  .catalogActionsheetRemovefromwishlistoption,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          leading: Icon(
                            Icons.favorite,
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            catalogBloc.add(RemoveFromWishListEvent(
                                contentId: widget.table2.contentid));
                            widget.table2.iswishlistcontent = 0;
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                  menu8
                      ? ListTile(
                          title: Text(
                              appBloc.localstr
                                  .learningtrackLabelEventviewrecording,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf144')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                        )
                      : Container(),
                  /*(table2.suggesttoconnlink != null)
                      ?(table2.suggesttoconnlink.isNotEmpty)?*/
                  ListTile(
                    leading: Icon(
                      IconDataSolid(int.parse('0xf1e0')),
                      color: InsColor(appBloc).appIconColor,
                    ),
                    title: Text('Share with Connection',
                        style: TextStyle(
                            color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ))),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShareWithConnections(
                              false,
                              false,
                              widget.table2.name,
                              widget.table2.contentid)));
                    },
                  ) /*: Container()
                      : Container()*/
                  ,
                  /*table2.suggestwithfriendlink != null
                      ?(table2.suggestwithfriendlink.isNotEmpty)
                      ?*/
                  ListTile(
                    leading: Icon(
                      IconDataSolid(int.parse('0xf079')),
                      color: InsColor(appBloc).appIconColor,
                    ),
                    title: Text("Share with People",
                        style: TextStyle(
                            color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ))),
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShareMainScreen(
                              true,
                              false,
                              false,
                              widget.table2.contentid,
                              widget.table2.name)));
                    },
                  )
                  /*: Container()
                      : Container()*/
                ],
              ),
            ),
          );
        });
  }

  Future<void> launchCoursePreview(
      DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    courseLaunchCatalog = GotoCourseLaunchCatalog(context, table2, false,
        appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
    String url = await courseLaunchCatalog!.getCourseUrl();
    if (url.isNotEmpty) {
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InAppWebCourseLaunch(url, table2)));
    }
  }

  Future<void> catalogLaunchCourse(DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    /// Need Some value
    if (table2.objecttypeid == 102) {
      executeXAPICourse(table2);
    }

    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventTrackList(table2, true, [])));
    } else {
      courseLaunch = GotoCourseLaunch(context, table2, false,
          appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
      String url = await courseLaunch!.getCourseUrl();

      if (url.isNotEmpty) {
        if (table2.objecttypeid == 26) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
        } else {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(url, table2)));
        }
      }
    }
  }

  Future<void> executeXAPICourse(DummyMyCatelogResponseTable2 learningModel) async {
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = "strContentID=${learningModel.contentid}&UserID=$strUserID&SiteID=$strSiteID&SCOID=${learningModel.scoid}&CanTrack=true";

    String url = "${webApiUrl}CourseTracking/TrackLRSStatement?$paramsString";

    ApiResponse? apiResponse = await generalRepository.executeXAPICourse(url);
  }

  checkUserLogin(DummyMyCatelogResponseTable2 table2) async {
    String userId = await sharePrefGetString(sharedPref_LoginUserID);
    String password = await sharePrefGetString(sharedPref_LoginPassword);

    catalogBloc.add(LoginSubsiteEvent(
        table2: table2,
        email: userId,
        password: password,
        localStr: appBloc.localstr,
        subSiteId: '${table2.siteid}',
        subSiteUrl: table2.siteurl));
  }

  checkSubsiteLoading(String response, DummyMyCatelogResponseTable2 table2) {
    SubsiteLoginResponse subsiteLoginResponse =
        SubsiteLoginResponse(failedUserLogin: [], successFullUserLogin: []);
    Map<String, dynamic> userloginAry = jsonDecode(response);
    try {
      String succesMessage =
          '${appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto}' +
              '${appBloc.localstr.eventsAlertsubtitleYouhavesuccessfullyjoinedcommunity}' +
              table2.sitename;

      if (userloginAry.containsKey("faileduserlogin")) {
        subsiteLoginResponse = subsiteLoginResponse =
            loginFaildeResponseFromJson(response.toString());

        subsiteLoginResponse.failedUserLogin[0].userstatus == 'Login Failed'
            ? flutterToast.showToast(
                child:
                    CommonToast(displaymsg: 'Login Failed ${table2.sitename}'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4),
              )
            : flutterToast.showToast(
                child: CommonToast(displaymsg: 'Pending Registration'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 4),
              );
      } else if (userloginAry.containsKey("successfulluserlogin")) {
        subsiteLoginResponse = subsiteLoginResponse =
            loginSuccessResponseFromJson(response.toString());

        flutterToast.showToast(
          child: CommonToast(displaymsg: succesMessage),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 4),
        );
        table2.userid =
            '${subsiteLoginResponse.successFullUserLogin[0].userid}';
        catalogBloc.add(
            AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget scheduleWidget() {
    print("scheduleWidget called");
    return BlocConsumer<CatalogBloc, CatalogState>(
      bloc: catalogBloc,
      listener: (context, state) {
        if (state is GetScheduleDataState) {
          if (state.status == Status.COMPLETED) {
            setState(() {
              loaderEnroll = false;
            });
          }
        } else if (state is AddEnrollState) {
          if (state.status == Status.COMPLETED) {
            loaderEnroll = false;
            if (catalogBloc.addToMyLearningRes.isSuccess) {
              flutterToast.showToast(
                  child: CommonToast(
                      displaymsg:
                          'The subscribed item has been added to your My Learning. Please click on My Learning, and then click on View to launch the content.'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: const Duration(seconds: 2));
              getDetailsApiCall(contentID);
              refresh(contentID);
            } else {
              flutterToast.showToast(
                  child: CommonToast(
                      displaymsg: catalogBloc.addToMyLearningRes.message),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: const Duration(seconds: 2));
            }
          }
        }

        if (state is GetCategoryWisecatalogState) {
          if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");

          } else if (state.status == Status.ERROR) {
//                print("listner Error ${state.message}");
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
        if (state is AddToWishListState ||
            state is RemoveFromWishListState ||
            state is AddToMyLearningState) {
          if (state.status == Status.COMPLETED) {
            if (state is AddToWishListState) {
              widget.table2.iswishlistcontent = 1;
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: appBloc.localstr
                        .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            }
            if (state is RemoveFromWishListState) {
              widget.table2.iswishlistcontent = 0;
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: appBloc.localstr
                        .catalogAlertsubtitleItemremovedtowishlistsuccesfully),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            }
            if (state is AddToMyLearningState) {
              flutterToast.showToast(
                child: CommonToast(
                    displaymsg: appBloc.localstr
                        .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            }
          }
        }
        if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
          if (state.message == "401") {
            AppDirectory.sessionTimeOut(context);
          }
        }

        if (state is GetPrequisiteDetailsState) {
          if (state.status == Status.COMPLETED) {
            print(
                "prequisitePopupresponse size ${state.prequisitePopupresponse.prerequisteData.table.length}");
          } else if (state.status == Status.ERROR) {
            if (state.message == "401") {
              AppDirectory.sessionTimeOut(context);
            }
          }
        }
      },
      builder: (context, state) {
        return Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible:
                        catalogBloc.eventEnrollmentResponse.courseList.length !=
                                0
                            ? true
                            : false,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          'Teaching Schedule',
                          style: TextStyle(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ))),
                Container(
                    child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount:
                      catalogBloc.eventEnrollmentResponse.courseList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {},
                      child: Padding(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                          child: Card(
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                            elevation: 4,
                            child: Container(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(5)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, bottom: 5.0),
                                                child: Text(
                                                  DateFormat('EEEE, d MMM')
                                                      .format(DateFormat(
                                                              'MM/dd/yyyy HH:mm a')
                                                          .parse(catalogBloc
                                                              .eventEnrollmentResponse
                                                              .courseList[index]
                                                              .eventStartDateTime)),
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20, top: 5.0),
                                                  child: Container(
                                                    height: 14,
                                                    width: 14,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: Color(int.parse(
                                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")))),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20, top: 5.0),
                                                    child: Text(
                                                      catalogBloc
                                                          .eventEnrollmentResponse
                                                          .courseList[index]
                                                          .contentType,
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 14.0),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 20,
                                                    ),
                                                    child: Text(
                                                      '(${DateFormat('h:mm a').format(DateFormat(
                                                                  'dd/MM/yyyy HH:mm')
                                                              .parse(catalogBloc
                                                                  .eventEnrollmentResponse
                                                                  .courseList[
                                                                      index]
                                                                  .eventStartDateTime))}-${DateFormat('h:mm a').format(DateFormat(
                                                                  'dd/MM/yyyy HH:mm')
                                                              .parse(catalogBloc
                                                                  .eventEnrollmentResponse
                                                                  .courseList[
                                                                      index]
                                                                  .eventEndDateTime))})',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 14.0),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20, top: 10.0),
                                                    child: Text(
                                                      catalogBloc
                                                          .eventEnrollmentResponse
                                                          .courseList[index]
                                                          .title,
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20, top: 5.0),
                                                    child: Text(
                                                      catalogBloc
                                                          .eventEnrollmentResponse
                                                          .courseList[index]
                                                          .shortDescription,
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 14.0),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20, top: 5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          catalogBloc
                                                              .eventEnrollmentResponse
                                                              .courseList[index]
                                                              .duration,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 14.0),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  7.0),
                                                          child: Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 1.5,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade700)),
                                                          ),
                                                        ),
                                                        Text(
                                                          ' by ${catalogBloc
                                                                  .eventEnrollmentResponse
                                                                  .courseList[
                                                                      index]
                                                                  .presenterDisplayName}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 14.0),
                                                        )
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20, top: 5.0),
                                                    child: Text(
                                                      catalogBloc
                                                          .eventEnrollmentResponse
                                                          .courseList[index]
                                                          .locationName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 14.0),
                                                    )),
                                                Visibility(
                                                    visible: catalogBloc
                                                                .eventEnrollmentResponse
                                                                .courseList[
                                                                    index]
                                                                .isContentEnrolled ==
                                                            '1'
                                                        ? false
                                                        : true,
                                                    child: Container(
                                                      margin: const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20.0),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      //height: 50.h,
                                                      child: MaterialButton(
                                                        disabledColor: Color(
                                                                int.parse(
                                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                            .withOpacity(0.5),
                                                        color: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text('Enroll',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                        int.parse(
                                                                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            loaderEnroll = true;
                                                            contentID = catalogBloc
                                                                .eventEnrollmentResponse
                                                                .courseList[
                                                                    index]
                                                                .contentID;
                                                          });
                                                          catalogBloc.add(AddEnrollEvent(
                                                              selectedContent:
                                                                  catalogBloc
                                                                      .eventEnrollmentResponse
                                                                      .courseList[
                                                                          index]
                                                                      .addLink,
                                                              componentID: 107,
                                                              componentInsID:
                                                                  3291,
                                                              additionalParams:
                                                                  '',
                                                              targetDate: '',
                                                              rescheduleenroll:
                                                                  widget.isFromReschedule
                                                                      ? 'rescheduleenroll'
                                                                      : ''));
                                                        },
                                                      ),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 20,
                                                        top: 5.0,
                                                        bottom: 5.0),
                                                    child: Text(
                                                      '${catalogBloc
                                                              .eventEnrollmentResponse
                                                              .courseList[index]
                                                              .availableSeats} Seats Remain',
                                                      style: TextStyle(
                                                          color: Color(int.parse(
                                                              "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ],
                                )),
                          )),
                    );
                  },
                ))
              ],
            ));
      },
    );
  }

  refresh(String contentId) {
    print("refresh called with content Id:$contentID");
    if (widget.table2.objecttypeid == 70 &&
        widget.table2.eventscheduletype == 1) {
      catalogBloc.add(GetScheduleEvent(
          eventID: contentId, multiInstanceEventEnroll: '', multiLocation: ''));
    } else if (widget.table2.objecttypeid == 70 &&
        widget.table2.eventscheduletype == 2) {
      catalogBloc.add(GetScheduleEvent(
          eventID: contentId, multiInstanceEventEnroll: '', multiLocation: ''));
    }
  }

  void _settingMyEventBottomSheet(BuildContext context, DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.viewtype}');

    bool menu0 = false,
        menu1 = false,
        menu2 = false,
        menu3 = false,
        menu4 = false,
        menu5 = false,
        menu6 = false,
        menu7 = false;

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

        print('actionwaitlist ${table2.viewtype} ${table2.actionwaitlist}');

        if (isValidString(table2.eventenddatetime ?? "") &&
            !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (isValidString(table2.actionwaitlist) &&
              table2.actionwaitlist == "true") {
            menu1 = true;
            menu1Title = appBloc.localstr.eventsActionsheetWaitlistoption;
          } else if (table2.availableseats > 0) {
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
        menu1 = false;
        menu3 = true;
        if (table2.eventscheduletype == 2) {
          menu1 = false;
        }
        if (isValidString(table2.eventenddatetime ?? "") &&
            !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (isValidString(table2.actionwaitlist) &&
              table2.actionwaitlist == "true") {
            menu1 = true;
            menu1Title = appBloc.localstr.eventsActionsheetWaitlistoption;
          } else if (table2.availableseats > 0) {
            menu1 = true;
          }
        } else if (appBloc.uiSettingModel.allowExpiredEventsSubscription ==
                "true" &&
            returnEventCompleted(table2.eventenddatetime ?? "")) {
          menu1 = false;
        }
      } else if (table2.viewtype == 3) {
        menu0 = false;
        menu3 = true;
        menu1 = false;
        //TODO: Commenting for Buy Option
        menu2 = true;
        // if (returnEventCompleted(table2.eventenddatetime) &&
        //     appBloc.uiSettingModel.AllowExpiredEventsSubscription == "true") {
        //   // uncomment here if required
        //   menu2 = true;
        // }
      }
    }
    print("isaddedtomylearning upendra ${table2.isaddedtomylearning}");
    if (table2.isaddedtomylearning == 0 || table2.isaddedtomylearning == 2) {
      if (table2.iswishlistcontent == 1) {
        menu6 = true; //removeWishListed
      } else {
        menu5 = true; //isWishListed
      }
    } else if (table2.isaddedtomylearning == 1) {
      menu5 = false;
      menu6 = false;
    }

    print("isaddedtomylearning om ${table2.isaddedtomylearning}");
    print(
        "returnEventCompleted om ${returnEventCompleted(table2.eventenddatetime ?? "")}");
    print(
        "AllowExpiredEventsSubscription om ${appBloc.uiSettingModel.allowExpiredEventsSubscription}");

    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true" &&
        returnEventCompleted(table2.eventenddatetime ?? "")) {
      if (table2.isaddedtomylearning != 1) {
        if (table2.viewtype == 2) {
          if (table2.availableseats > 0) {
            menu7 = true;
          }
        }
      }
    }
    // expired event functionality
    if (isValidString(table2.eventenddatetime ?? "") &&
        returnEventCompleted(table2.eventenddatetime ?? "")) {
      if (appBloc.uiSettingModel.allowExpiredEventsSubscription == "true") {
        if (table2.isaddedtomylearning == 1) {
          if (table2.relatedconentcount != 0) {
            menu0 = true;
            menu1 = false; //enroll
          }
        } else {
          if (table2.viewtype == 2) {
            // menu1 = true; //enroll

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
          return BlocConsumer(
            bloc: eventModuleBloc,
            listener: (context, state) {},
            // listener: (context, state) {
            //   if (state is GetPeopleListingTabState) {
            //     if (state.status == Status.ERROR) {
            //       if (state.message == '401') {
            //         AppDirectory.sessionTimeOut(context);
            //       } else {
            //         flutterToast.showToast(
            //             gravity: ToastGravity.BOTTOM,
            //             toastDuration: Duration(seconds: 2),
            //             child: CommonToast(displaymsg: 'Something went wrong'));
            //       }
            //     }
            //   } else if (state is GetTabContentState) {
            //     if (state.status == Status.ERROR) {
            //       if (state.message == '401') {
            //         AppDirectory.sessionTimeOut(context);
            //       } else {
            //         flutterToast.showToast(
            //             gravity: ToastGravity.BOTTOM,
            //             toastDuration: Duration(seconds: 2),
            //             child: CommonToast(displaymsg: 'Something went wrong'));
            //       }
            //     }
            //   } else if (state is CancelEnrollmentState) {
            //     if (state.status == Status.COMPLETED) {
            //       if (state.isSuccess == 'true') {
            //         Future.delayed(Duration(seconds: 1), () {
            //           // 5s over, navigate to a new page
            //           flutterToast.showToast(
            //             child: CommonToast(
            //                 displaymsg: 'Enrollment cancelled successfully'),
            //             gravity: ToastGravity.BOTTOM,
            //             toastDuration: Duration(seconds: 1),
            //           );
            //         });
            //
            //         setState(() {
            //           // state.table2.isaddedtomylearning = 0;
            //           // state.table2.availableseats =
            //           //     state.table2.availableseats + 1;
            //         });
            //       } else {
            //         flutterToast.showToast(
            //           child: CommonToast(displaymsg: 'Something went wrong'),
            //           gravity: ToastGravity.BOTTOM,
            //           toastDuration: Duration(seconds: 2),
            //         );
            //       }
            //     } else if (state.status == Status.ERROR) {
            //       if (state.message == '401') {
            //         AppDirectory.sessionTimeOut(context);
            //       }
            //     }
            //   } else if (state is BadCancelEnrollmentState) {
            //     if (state.status == Status.COMPLETED) {
            //       showCancelEnrollDialog(state.table2, state.isSuccess);
            //     } else if (state.status == Status.ERROR) {
            //       if (state.message == '401') {
            //         AppDirectory.sessionTimeOut(context);
            //       }
            //     }
            //   } else if (state is ExpiryEventState) {
            //     if (state.status == Status.COMPLETED) {
            //       print("om  ${state.isSuccess}");
            //       if (state.isSuccess.contains("true")) {
            //         flutterToast.showToast(
            //           child: CommonToast(
            //               displaymsg: appBloc.localstr
            //                       .eventsAlertsubtitleThiseventitemhasbeenaddedto +
            //                   " " +
            //                   appBloc.localstr
            //                       .mylearningHeaderMylearningtitlelabel),
            //           gravity: ToastGravity.BOTTOM,
            //           toastDuration: Duration(seconds: 2),
            //         );
            //
            //         setState(() {
            //           state.table2.isaddedtomylearning = 1;
            //         });
            //       } else {
            //         print("else  ${state.isSuccess}");
            //         flutterToast.showToast(
            //           child: CommonToast(displaymsg: 'Something went wrong'),
            //           gravity: ToastGravity.BOTTOM,
            //           toastDuration: Duration(seconds: 2),
            //         );
            //       }
            //     } else if (state.status == Status.ERROR) {
            //       if (state.message == '401') {
            //         AppDirectory.sessionTimeOut(context);
            //       }
            //     }
            //   } else if (state is WaitingListState) {
            //     if (state.status == Status.COMPLETED) {
            //       if (state.waitingListResponse.isSuccess) {
            //         Future.delayed(Duration(seconds: 1), () {
            //           // 5s over, navigate to a new page
            //           flutterToast.showToast(
            //             child: CommonToast(
            //                 displaymsg: state.waitingListResponse.message),
            //             gravity: ToastGravity.BOTTOM,
            //             toastDuration: Duration(seconds: 2),
            //           );
            //         });
            //
            //         setState(() {
            //           state.table2.waitlistenrolls =
            //               state.table2.waitlistenrolls + 1;
            //           state.table2.actionwaitlist = '';
            //         });
            //       } else {
            //         Future.delayed(Duration(seconds: 1), () {
            //           // 5s over, navigate to a new page
            //           flutterToast.showToast(
            //             child: CommonToast(
            //                 displaymsg: state.waitingListResponse.message),
            //             gravity: ToastGravity.BOTTOM,
            //             toastDuration: Duration(seconds: 2),
            //           );
            //         });
            //       }
            //     } else if (state.status == Status.ERROR) {
            //       if (state.message == '401') {
            //         AppDirectory.sessionTimeOut(context);
            //       } else {
            //         flutterToast.showToast(
            //           child: CommonToast(displaymsg: 'Something went wrong'),
            //           gravity: ToastGravity.BOTTOM,
            //           toastDuration: Duration(seconds: 2),
            //         );
            //       }
            //     }
            //   }
            // },
            builder: (context, state) {
              return Container(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const BottomSheetDragger(),
                      menu0
                          ? ListTile(
                              onTap: () {
                                Navigator.of(context).pop();
                                checkRelatedContent(table2);
                              },
                              title: Text(
                                  appBloc.localstr
                                      .eventsActionsheetRelatedcontentoption,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                Icons.content_copy,
                                color: InsColor(appBloc).appIconColor,
                              ),
                            )
                          : Container(),
                      menu1
                          ? ListTile(
                              title: Text(menu1Title,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                IconDataSolid(int.parse('0xf271')),
                                color: InsColor(appBloc).appIconColor,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                addToEnroll(table2);
                              })
                          : Container(),
                      menu2
                          ? ListTile(
                              title: Text(
                                  appBloc
                                      .localstr.eventsActionsheetBuynowoption,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                IconDataSolid(int.parse('0xf53d')),
                                color: InsColor(appBloc).appIconColor,
                              ),
                              onTap: () {
                                buyCourse();
                              },
                            )
                          : Container(),
                      // menu3
                      //     ? ListTile(
                      //         title: Text(
                      //             appBloc.localstr.eventsActionsheetDetailsoption,
                      //             style: TextStyle(
                      //                 color: Color(
                      //               int.parse(
                      //                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      //             ))),
                      //         leading: Icon(
                      //           IconDataSolid(int.parse('0xf53d')),
                      //           color: InsColor(appBloc).appIconColor,
                      //         ),
                      //         onTap: () {
                      //           Navigator.of(context).pop();
                      //           Navigator.of(context).push(MaterialPageRoute(
                      //               builder: (context) => EventDetailScreen(
                      //                     contentid: table2.contentid,
                      //                     objtypeId: table2.objecttypeid,
                      //                     detailsBloc: detailsBloc,
                      //                     table2: table2,
                      //                   )));
                      //         },
                      //       )
                      //     : Container(),
                      menu4
                          ? ListTile(
                              onTap: () {
                                Navigator.of(context).pop();
                                if (table2.isbadcancellationenabled) {
                                  badCancelEnrollmentMethod(table2);

                                  // bad cancel
                                } else {
                                  showCancelEnrollDialog(
                                      table2,
                                      table2.isbadcancellationenabled
                                          .toString());
                                }
                              },
                              title: Text(
                                  appBloc.localstr
                                      .eventsActionsheetCancelenrollmentoption,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                IconDataSolid(int.parse('0xf410')),
                                color: InsColor(appBloc).appIconColor,
                              ),
                            )
                          : Container(),
                      menu5
                          ? ListTile(
                              title: Text(
                                  appBloc.localstr
                                      .catalogActionsheetWishlistoption,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                IconDataRegular(int.parse('0xf004')),
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
                              title: Text(
                                  appBloc.localstr
                                      .catalogActionsheetRemovefromwishlistoption,
                                  style: TextStyle(
                                      color: Color(
                                    int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  ))),
                              leading: Icon(
                                IconDataSolid(int.parse('0xf004')),
                                color: InsColor(appBloc).appIconColor,
                              ),
                              onTap: () {
                                catalogBloc.add(RemoveFromWishListEvent(
                                    contentId: table2.contentid));
                                Navigator.of(context).pop();
                              },
                            )
                          : Container(),
                      menu7
                          ? isConsolidated && widget.table2.siteid != 374
                              ? Container()
                              : ListTile(
                                  title: Text(
                                      appBloc.localstr
                                          .catalogActionsheetAddtomylearningoption,
                                      style: TextStyle(
                                          color: Color(
                                        int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                      ))),
                                  leading: Icon(
                                    Icons.add_circle,
                                    color: InsColor(appBloc).appIconColor,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    try {
                                      addExpiryEvets(table2, 0);
                                    } catch (e) {
                                      e.toString();
                                    }
                                  },
                                )
                          : Container(),
                      /*(table2.suggesttoconnlink != null)
                      ? (table2.suggesttoconnlink.isNotEmpty)
                          ? */
                      ListTile(
                        leading: Icon(
                          IconDataSolid(int.parse('0xf1e0')),
                          color: InsColor(appBloc).appIconColor,
                        ),
                        title: Text('Share with Connection',
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ))),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareWithConnections(false,
                                  false, table2.name, table2.contentid)));
                        },
                      ),
                      /*: Container()
                      : Container()*/
                      /*table2.suggestwithfriendlink != null
                      ? (table2.suggestwithfriendlink.isNotEmpty)*/
                      /*?*/
                      ListTile(
                        leading: Icon(
                          IconDataSolid(int.parse('0xf079')),
                          color: InsColor(appBloc).appIconColor,
                        ),
                        title: Text("Share with People",
                            style: TextStyle(
                                color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ))),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShareMainScreen(true, false,
                                  false, table2.contentid, table2.name)));
                        },
                      )
                      /*: Container()
                      : Container()*/
                      ,
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void checkRelatedContent(DummyMyCatelogResponseTable2 table2) {
    if (isValidString(table2.viewprerequisitecontentstatus ?? "")) {
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = "${alertMessage +
          " \"" +
          table2.viewprerequisitecontentstatus}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  appBloc.localstr.detailsAlerttitleStringalert,
                  style: TextStyle(
                      color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      ),
                      fontWeight: FontWeight.bold),
                ),
                content: Text(
                  alertMessage,
                  style: TextStyle(
                      color: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                  )),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                actions: <Widget>[
                  FlatButton(
                    child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                    textColor: Colors.blue,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventTrackList(
                table2,
                false,
                myLearningBloc.list,
              )));
    }
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
            table2.waitlistlimit - table2.waitlistenrolls;

        if (waitlistSeatsLeftout > 0) {
          seatVal = 'Full | Waitlist seats $waitlistSeatsLeftout';
        }
      }
    }

    return seatVal;
  }

  void badCancelEnrollmentMethod(DummyMyCatelogResponseTable2 table2) {
    eventModuleBloc.add(BadCancelEnrollment(
        contentid: widget.table2.contentid, table2: widget.table2));
  }

  void showCancelEnrollDialog(DummyMyCatelogResponseTable2 table2, String isSuccess) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                appBloc.localstr.mylearningAlerttitleStringareyousure,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.apply(color: InsColor(appBloc).appTextColor),
              ),
              content: Text(
                appBloc.localstr
                    .mylearningAlertsubtitleDoyouwanttocancelenrolledevent,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.apply(color: InsColor(appBloc).appTextColor),
              ),
              backgroundColor: InsColor(appBloc).appBGColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              actions: <Widget>[
                FlatButton(
                  child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
                  textColor: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                  textColor: InsColor(appBloc).appTextColor,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    cancelEnrollment(table2, isSuccess);
                  },
                ),
              ],
            ));
  }

  void cancelEnrollment(DummyMyCatelogResponseTable2 table2, String bool) {
    eventModuleBloc.add(TrackCancelEnrollment(
        isBadCancel: bool, strContentID: table2.contentid, table2: table2));
  }

  void addExpiryEvets(DummyMyCatelogResponseTable2 table2, int position) {
    eventModuleBloc
        .add(AddExpiryEvent(table2: table2, strContentID: table2.contentid));
  }

  void addToEnroll(DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.availableseats}');
    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == 'true' &&
        returnEventCompleted(table2.eventenddatetime ?? "")) {
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
        if (isValidString(table2.eventenddatetime ?? "") &&
            !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (isValidString(table2.actionwaitlist) &&
              table2.actionwaitlist == "true") {
            String alertMessage = appBloc.localstr
                .eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        appBloc.localstr.eventsActionsheetEnrolloption,
                        style: TextStyle(
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                            ),
                            fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        alertMessage,
                        style: TextStyle(
                            color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        )),
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(appBloc
                              .localstr.mylearningAlertbuttonCancelbutton),
                          textColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
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
    eventModuleBloc.add(WaitingListEvent(
        strContentID: catalogModel.contentid, table2: catalogModel));
  }

  void onBottom1tap() {
    switch (bottomButton1Tag) {
      case 0:
        break;

      case 1:
        if (isValidString(widget.table2.viewprerequisitecontentstatus ?? "")) {
          String alertMessage =
              appBloc.localstr.prerequistesalerttitle6Alerttitle6;
          alertMessage = "${alertMessage +
              " \"" +
              widget.table2.viewprerequisitecontentstatus}\" ${appBloc.localstr.prerequistesalerttitle5Alerttitle7}";

          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      appBloc.localstr.detailsAlerttitleStringalert,
                      style: TextStyle(
                          color: Color(
                            int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                          ),
                          fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      alertMessage,
                      style: TextStyle(
                          color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                      )),
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                        textColor: Colors.blue,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventTrackList(
                    widget.table2,
                    false,
                    myLearningBloc.list,
                  )));
        }
        break;
      case 3:
        buyCourse();
        break;
      case 4:
        callAddToCalendar();
        break;

      case 6:
        addToEnroll(widget.table2);
        break;

      default:
    }
  }

  void buyCourse() {
    _buyProduct(widget.table2);
  }

  void onBottom2tap() {
    switch (bottomButton2Tag) {
      case 0:
        break;

      case 5:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProgressReport(widget.table2, detailsBloc, "", "-1")));
        break;

      case 13:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SessionEvent(
                  contentId: widget.contentid,
                )));
        break;

      case 14:
        getViewRecordingUrlData(widget.table2);

        break;

      default:
    }
  }

  void setTag1() {
    if (widget.table2.isaddedtomylearning == 1) {
      if ((widget.table2.bit5 != null && widget.table2.bit5) &&
          widget.table2.relatedconentcount.toString() != "0") {
        if (isReportEnabled && widget.table2.objecttypeid != 70) {
          bottomButton2Text =
              appBloc.localstr.mylearningActionsheetReportoption;
          bottomButton2Tag = 5;
        }

        bottomButton1Text =
            appBloc.localstr.mylearningActionsheetRelatedcontentoption;
        bottomButton1Tag = 1;
        icon1 = Icons.content_copy;
      } else {
        if (!returnEventCompleted(widget.table2.eventenddatetime ?? "") &&
            !returnEventCompleted(widget.table2.eventenddatetime ?? "") &&
            widget.table2.isaddedtomylearning == 1 &&
            widget.table2.objecttypeid == 70) {
          if (!(widget.table2.eventscheduletype == 1 ||
              widget.table2.eventscheduletype == 2)) {
            bottomButton1Text =
                appBloc.localstr.mylearningActionsheetAddtocalendaroption;
            bottomButton1Tag = 4;
            icon1 = IconDataSolid(int.parse('0xf271'));
          }
        }
      }
    } else {
      print(
          'viewtypevalll ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.actionwaitlist}');
      if (widget.table2.viewtype == 1 || widget.table2.viewtype == 2) {
        if (isValidString(widget.table2.eventstartdatetime ?? "") &&
            !returnEventCompleted(widget.table2.eventstartdatetime ?? "")) {
          if (isValidString(widget.table2.actionwaitlist) &&
              widget.table2.actionwaitlist == "true") {
            print(
                'view222222 ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.actionwaitlist}');

            bottomButton1Text =
                appBloc.localstr.eventsActionsheetWaitlistoption;
            bottomButton1Tag = 6;
            icon1 = IconDataSolid(int.parse('0xf271'));
          } else if (widget.table2.availableseats > 0 &&
              (widget.screenType != ScreenType.MyLearning)) {
            print(
                'view222222 ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.availableseats}');

            bottomButton1Text = appBloc.localstr.detailsButtonEnrollbutton;
            bottomButton1Tag = 6;
            icon1 = IconDataSolid(int.parse('0xf271'));
          }
        } else if (widget.table2.eventscheduletype == 1) {
          if (appBloc.uiSettingModel.enableMultipleInstancesForEvent ==
              'true') {
            bottomButton1Text =
                appBloc.localstr.mylearningActionbuttonRescheduleactionbutton;
            bottomButton1Tag = 6;
            icon1 = IconDataSolid(int.parse('0xf333'));
          }
        } else {
          if (appBloc.uiSettingModel.allowExpiredEventsSubscription
                  .toString() ==
              'true') {
            print(
                'view222222 expir ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.availableseats}');

            bottomButton1Text = appBloc.localstr.detailsButtonEnrollbutton;
            bottomButton1Tag = 6;
            icon1 = IconDataSolid(int.parse('0xf271'));
          } else {
            print(
                'view222222 else ${widget.table2.viewtype}  ${widget.table2.eventstartdatetime} ${widget.table2.availableseats}');
            if (isValidString(widget.table2.eventenddatetime ?? "") &&
                !returnEventCompleted(widget.table2.eventenddatetime ?? "")) {
              bottomButton1Text = appBloc.localstr.detailsButtonEnrollbutton;
              bottomButton1Tag = 6;
              icon1 = IconDataSolid(int.parse('0xf271'));
            }
          }
        }
      } else if (widget.table2.viewtype == 3) {
        // if (!returnEventCompleted(widget.table2.eventenddatetime)) {
        //   if (appBloc.uiSettingModel.AllowExpiredEventsSubscription
        //           .toString() ==
        //       'true') {
        //     bottomButton1Text = appBloc.localstr.eventsActionsheetBuynowoption;
        //     bottomButton1Tag = 3;
        //     icon1 = IconDataSolid(int.parse('0xf53d'));
        //   }
        // }
        //bottomButton1Text = appBloc.localstr.eventsActionsheetBuynowoption;
        //bottomButton1Tag = 3;
        //icon1 = IconDataSolid(int.parse('0xf155'));
      }
    }

    print('viewrecordingg ${widget.table2.eventrecording}');

    if (widget.table2.eventtype == 2 && widget.table2.objecttypeid == 70) {
      bottomButton2Text = appBloc.localstr.detailsLabelSessionstitlelable;
      bottomButton2Tag = 13;
      icon2 = IconDataSolid(int.parse('0xf63d'));
    } else if (widget.table2.isaddedtomylearning == 1 &&
        widget.table2.eventtype == 1 &&
        widget.table2.objecttypeid == 70 &&
        !returnEventCompleted(widget.table2.eventenddatetime ?? "")) {
      if (!(widget.table2.eventscheduletype == 1 ||
          widget.table2.eventscheduletype == 2)) {
        bottomButton1Text =
            appBloc.localstr.mylearningActionsheetAddtocalendaroption;
        bottomButton1Tag = 4;
        icon2 = IconDataSolid(int.parse('0xf333'));
      }
    } else if ((widget.table2.eventrecording != null &&
        widget.table2.eventrecording)) {
      if (widget.table2.isaddedtomylearning == 1) {
        bottomButton2Text =
            appBloc.localstr.learningtrackLabelEventviewrecording;
        bottomButton2Tag = 14;
        icon2 = IconDataSolid(int.parse('0xf0c1'));
        enablePlay = true;
      } else {
        enablePlay = false;
      }
    }
    setState(() {});
  }

  void callAddToCalendar() {
    DateTime startDate = DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(widget.table2.eventstartdatetime);
    DateTime endDate = DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(widget.table2.eventenddatetime);

//            print(
//                'event start-end time ${table2.eventstartdatetime}  ${table2.eventenddatetime}');
    Event event = Event(
      title: widget.table2.name,
      description: widget.table2.shortdescription,
      location: widget.table2.locationname,
      startDate: startDate,
      endDate: endDate,
      allDay: false,
    );

    Add2Calendar.addEvent2Cal(event).then((success) {
      flutterToast.showToast(
        child: CommonToast(
            displaymsg: success
                ? 'Event added successfully'
                : 'Error occured while adding event'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    });
  }

  void checkReportEnabled() async {
    if (widget.table2.siteid.toString() ==
            await sharePrefGetString(sharedPref_siteid) &&
        widget.table2.userid.toString() ==
            await sharePrefGetString(sharedPref_userid) &&
        await sharePrefGetBool(sharedPref_previlige)) {
      isReportEnabled = true;
    } else {
      isReportEnabled = true;
    }
  }

  void getViewRecordingUrlData(DummyMyCatelogResponseTable2 learningModel) async {
    eventModuleBloc.add(ViewRecordingEvent(
        strContentID: learningModel.contentid, table2: learningModel));
  }

  //Not implemented
  // ignore: missing_return
  Widget bottomActionButtonLogic() {
    print("widget.table2.viewtype:${widget.table2.viewtype}");
    print(
        "widget.table2.isaddedtomylearning:${widget.table2.isaddedtomylearning}");
    print("widget.table2.objecttypeid:${widget.table2.objecttypeid}");

    if (widget.table2.viewtype == 1) {
      if (widget.table2.isaddedtomylearning == 0) {
        if (widget.table2.objecttypeid == 70) {
//           funn() {
// //              Navigator.of(context).pop();
//
//             if (isValidString(widget.table2.viewprerequisitecontentstatus)) {
// //              print('ifdataaaaa');
//               String alertMessage =
//                   appBloc.localstr.prerequistesalerttitle6Alerttitle6;
//               alertMessage = alertMessage +
//                   "  \"" +
//                   appBloc.localstr.prerequisLabelContenttypelabel +
//                   "\" " +
//                   appBloc.localstr.prerequistesalerttitle5Alerttitle7;
//
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) => new AlertDialog(
//                         title: Text(
//                           appBloc.localstr.detailsAlerttitleStringalert,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         content: Text(
//                           alertMessage,
//                           style: TextStyle(
//                               color: Color(int.parse(
//                                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
//                         ),
//                         backgroundColor: Color(int.parse(
//                             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(5)),
//                         actions: <Widget>[
//                           new FlatButton(
//                             child: Text(
//                                 appBloc.localstr.eventsAlertbuttonOkbutton),
//                             textColor: Colors.blue,
//                             onPressed: () async {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ));
//             } else {
// //              print('elsedataaaa');
//
//               if (widget.table2.objecttypeid == 102) {
//                 executeXAPICourse(widget.table2);
//               }
//
//               launchCourse(widget.table2, context);
//             }
//           }

          enroll() {
            addToEnroll(widget.table2);
            Navigator.of(context).pop();
          }

          return widget.table2.eventscheduletype == 2
              ? Container()
              : displayBottomButton(
                  appBloc.localstr.eventsActionsheetEnrolloption, enroll);
          // return displayBottomButton(
          //     appBloc.localstr.catalogActionsheetViewoption,
          //     launchCourse(widget.table2, context));
          // firstBtn.isHidden = false
          // firstBtn.setTitle("  \(NSLocalizedString("details_button_enrollbutton", comment:"Enroll"))", for: .normal)
          // firstBtn.setImage(addImage, for: .normal)
          // //Anvesh we are adding tags to avoid the string comparison incase of localization
          // firstBtn.tag = DetailsScreenButtonsNameTag.AddToMyLearningOrEnrollButton.rawValue
        }
        else {
          addToMyLearning() {
            catalogBloc.add(AddToMyLearningEvent(
                contentId: widget.table2.contentid, table2: widget.table2));
            //Navigator.of(context).pop();
          }

          return isConsolidated && widget.table2.siteid != 374
              ? Container()
              : displayBottomButton(
                  appBloc.localstr.catalogActionsheetAddtomylearningoption,
                  addToMyLearning);
          // firstBtn.isHidden = false
          //
          // firstBtn.setTitle("  \(NSLocalizedString("details_button_addtomylearningbutton", comment:"Add to My Learning"))", for: .normal)
          // firstBtn.setImage(addImage, for: .normal)
          // //Anvesh we are adding tags to avoid the string comparison incase of localization
          // firstBtn.tag = DetailsScreenButtonsNameTag.AddToMyLearningOrEnrollButton.rawValue
        }
      }
      else {
        if (widget.table2.objecttypeid == 70) {
          if (widget.table2.relatedconentcount > 0) {
            // firstBtn.isHidden = false
            //
            // var viewImage = UIImage.init(icon: .FAFile, size: CGSize(width: 20, height: 20))
            // if (appBloc.uiSettingModel.azzuresso == "true") {
            // viewImage = UIImage.init(icon: .FAEye, size: CGSize(width: 20, height: 20))
            // }
            // firstBtn.setTitle("  \(NSLocalizedString("details_button_relatedcontentbutton", comment: "Related Content"))", for: .normal)
            // firstBtn.setImage(viewImage, for: .normal)
            // //Anvesh we are adding tags to avoid the string comparison incase of localization
            // firstBtn.tag = DetailsScreenButtonsNameTag.RelatedContentButton.rawValue
          }
          else {
            // firstBtn.isHidden = true
          }
        }
        else {
          if (widget.table2.objecttypeid == 102) {
            return displayBottomButton(
                appBloc.localstr.catalogActionsheetViewoption,
                () => executeXAPICourse(widget.table2));
          }

          return displayBottomButton(appBloc.localstr.catalogActionsheetViewoption, () async {
            bool result = await MyLearningController().decideCourseLaunchMethod(
              context: context,
              table2: widget.table2,
              isContentisolation: false,
            );
          });
          // firstBtn.isHidden = false

          // if projectName == ProjectNames.MedMentor || projectName ==  ProjectNames.YouNextU{
          // firstBtn.setTitle("  \(NSLocalizedString("globalstart_actionsheet_startoption", comment: "Start"))", for: .normal)
          // }else{
          // firstBtn.setTitle("  \(NSLocalizedString("details_button_viewbutton", comment: "View"))", for: .normal)
          // }
          // firstBtn.setImage(viewImage, for: .normal)
          // //Anvesh we are adding tags to avoid the string comparison incase of localization
          // firstBtn.tag = DetailsScreenButtonsNameTag.ViewOrPlayButton.rawValue
        }
      }
    }
    else if (widget.table2.viewtype == 2) {
      if (widget.table2.isaddedtomylearning == 0) {
        if (widget.table2.objecttypeid == 70) {
          // Mahesh Added to show Schedule Event Button
          if ((widget.table2.eventtype == 1) ||
              (widget.table2.eventtype == 2)) {
            // if (isEnableMultipleInstancesforEvent.lowercased() == "true") {
            // print("succss")
            // firstBtn.isHidden = false
            //
            // let viewImage = UIImage.init(icon: .FACalendar, size: CGSize(width: 20, height: 20))
            // firstBtn.setTitle("  \(NSLocalizedString("details_button_shedulebutton", comment:"Schedule"))", for: .normal)
            // firstBtn.setImage(viewImage, for: .normal)
            // firstBtn.tag = DetailsScreenButtonsNameTag.ScheduleButton.rawValue
            // }
          } else {
            if (widget.table2.actionwaitlist != "false") {
              // firstBtn.isHidden = false
              // firstBtn.setTitle("  \(NSLocalizedString("details_button_waitlistbutton", comment:"Waitlist"))", for: .normal)
              // firstBtn.setImage(addImage, for: .normal)
              //
              // firstBtn.tag = DetailsScreenButtonsNameTag.AddToMyLearningOrEnrollButton.rawValue

            } else if (widget.table2.availableseats > 0) {
              // firstBtn.isHidden = false
              // firstBtn.setTitle("  \(NSLocalizedString("details_button_enrollbutton", comment:"Enroll"))", for: .normal)
              // firstBtn.setImage(addImage, for: .normal)
              // firstBtn.tag = DetailsScreenButtonsNameTag.AlreadyEnrollButton.rawValue
            }
          }
        } else {
          addToMyLearning() {
            catalogBloc.add(AddToMyLearningEvent(
                contentId: widget.table2.contentid, table2: widget.table2));
            //Navigator.of(context).pop();
          }

          return isConsolidated && widget.table2.siteid != 374
              ? Container()
              : displayBottomButton(
                  appBloc.localstr.catalogActionsheetAddtomylearningoption,
                  addToMyLearning);
          // firstBtn.isHidden = false
          //
          // firstBtn.setTitle("  \(NSLocalizedString("details_button_addtomylearningbutton", comment:"Add to My Learning"))", for: .normal)
          // firstBtn.setImage(addImage, for: .normal)
          // //Anvesh we are adding tags to avoid the string comparison incase of localization
          // firstBtn.tag = DetailsScreenButtonsNameTag.AddToMyLearningOrEnrollButton.rawValue
        }
      }
      else {
        if (widget.table2.objecttypeid == 70) {
          if (widget.table2.relatedconentcount > 0) {
            // var viewImage = UIImage.init(icon: .FAFile, size: CGSize(width: 20, height: 20))
            // firstBtn.isHidden = false
            //
            // if mciApp == "true" {
            // viewImage = UIImage.init(icon: .FAEye, size: CGSize(width: 20, height: 20))
            // }
            // firstBtn.setTitle("  \(NSLocalizedString("details_button_relatedcontentbutton", comment: "Related Content"))", for: .normal)
            // firstBtn.setImage(viewImage, for: .normal)
            // //Anvesh we are adding tags to avoid the string comparison incase of localization
            // firstBtn.tag = DetailsScreenButtonsNameTag.RelatedContentButton.rawValue
          } else {
            // Mahesh Added to show Schedule Event Button
//                        secondBtn.isHidden = false

            if ((widget.table2.eventtype == 1) ||
                (widget.table2.eventtype == 2)) {
              // if isEnableMultipleInstancesforEvent.lowercased() == "true" {
              // print("succss")
              // firstBtn.isHidden = false
              //
              // let viewImage = UIImage.init(icon: .FACalendar, size: CGSize(width: 20, height: 20))
              // firstBtn.setTitle("  \(NSLocalizedString("details_button_shedulebutton", comment:"Schedule"))", for: .normal)
              // firstBtn.setImage(viewImage, for: .normal)
              // firstBtn.tag = DetailsScreenButtonsNameTag.ScheduleButton.rawValue
              // }
            } else {
              enroll() {
                addToEnroll(widget.table2);
                Navigator.of(context).pop();
              }

              return displayBottomButton(
                  appBloc.localstr.eventsActionsheetEnrolloption, enroll);
              // secondBtn.isHidden = true
              // firstBtn.isHidden = false
              //
              // firstBtn.setTitle("  \(NSLocalizedString("details_button_enrollbutton", comment:"Enroll"))", for: .normal)
              // firstBtn.setImage(addImage, for: .normal)
              // firstBtn.tag = DetailsScreenButtonsNameTag.AlreadyEnrollButton.rawValue
            }
          }
        }
        else {
          if (widget.table2.objecttypeid == 102) {
            return displayBottomButton(
                appBloc.localstr.catalogActionsheetViewoption,
                () => executeXAPICourse(widget.table2));
          }
          //pasdasdasd

          return displayBottomButton(appBloc.localstr.catalogActionsheetViewoption, () async {
            //print("on tap called");
            bool result = await MyLearningController().decideCourseLaunchMethod(
              context: context,
              table2: widget.table2,
              isContentisolation: false,
            );
          });

          // firstBtn.isHidden = false
          //
          // if projectName == ProjectNames.MedMentor || projectName ==  ProjectNames.YouNextU{
          // firstBtn.setTitle("  \(NSLocalizedString("globalstart_actionsheet_startoption", comment: "Start"))", for: .normal)
          // }else{
          // firstBtn.setTitle("  \(NSLocalizedString("details_button_viewbutton", comment: "View"))", for: .normal)
          // }
          // firstBtn.setImage(viewImage, for: .normal)
          // //Anvesh we are adding tags to avoid the string comparison incase of localization
          // firstBtn.tag = DetailsScreenButtonsNameTag.ViewOrPlayButton.rawValue
        }
      }
    }
    else if (widget.table2.viewtype == 3) {
      if (widget.table2.isaddedtomylearning == 0) {
        return isConsolidated && widget.table2.siteid != 374
            ? Container()
            : displayBottomButton(
                appBloc.localstr.detailsButtonBuybutton, () => buyCourse());
        // if let userMembershipExpiryDate = userMembershipModel?.expiryDate, userMembershipExpiryDate != "" {
        // let convertedUserMembershipExpiryDate = Singleton.sharedInstance.formatTheDateToDefault(userMembershipExpiryDate)
        // if convertedUserMembershipExpiryDate > currentDate && (userMembershipModel?.membershipLevel)! >= widget.table2.membershipLevel {
        // firstBtn.isHidden = false
        //
        // firstBtn.setTitle("  \(NSLocalizedString("details_button_addtomylearningbutton", comment:"Add to My Learning"))", for: .normal)
        // firstBtn.setImage(addImage, for: .normal)
        // //Anvesh we are adding tags to avoid the string comparison incase of localization
        // firstBtn.tag = DetailsScreenButtonsNameTag.AddToMyLearningOrEnrollButton.rawValue
        // } else {
        // firstBtn.isHidden = false
        //
        // firstBtn.setTitle("  \(NSLocalizedString("details_button_buybutton", comment:"Buy"))", for: .normal)
        // let buyImage = UIImage.init(icon: .FAShoppingCart, size: CGSize(width: 20, height: 20))
        // firstBtn.setImage(buyImage, for: .normal)
        // //Anvesh we are adding tags to avoid the string comparison incase of localization
        // firstBtn.tag = DetailsScreenButtonsNameTag.BuyButton.rawValue
        // }
        // } else {
        // firstBtn.isHidden = false
        //
        // firstBtn.setTitle("  \(NSLocalizedString("details_button_buybutton", comment:"Buy"))", for: .normal)
        // let buyImage = UIImage.init(icon: .FAShoppingCart, size: CGSize(width: 20, height: 20))
        // firstBtn.setImage(buyImage, for: .normal)
        // //Anvesh we are adding tags to avoid the string comparison incase of localization
        // firstBtn.tag = DetailsScreenButtonsNameTag.BuyButton.rawValue
        // }
      }
      else {
        if (widget.table2.objecttypeid == 70) {
          if (widget.table2.relatedconentcount > 0) {
            // var viewImage = UIImage.init(icon: .FAFile, size: CGSize(width: 20, height: 20))
            // firstBtn.isHidden = false
            //
            // if mciApp == "true" {
            // viewImage = UIImage.init(icon: .FAEye, size: CGSize(width: 20, height: 20))
            // }
            // firstBtn.setTitle("  \(NSLocalizedString("details_button_relatedcontentbutton", comment: "Related Content"))", for: .normal)
            // firstBtn.setImage(viewImage, for: .normal)
            // //Anvesh we are adding tags to avoid the string comparison incase of localization
            // firstBtn.tag = DetailsScreenButtonsNameTag.RelatedContentButton.rawValue
          } else {
            //firstBtn.isHidden = true
          }
        }
        else {
          if (widget.table2.objecttypeid == 102) {
            return displayBottomButton(
                appBloc.localstr.catalogActionsheetViewoption,
                () => executeXAPICourse(widget.table2));
          }

          return displayBottomButton(appBloc.localstr.catalogActionsheetViewoption, () async {
            bool result = await MyLearningController().decideCourseLaunchMethod(
              context: context,
              table2: widget.table2,
              isContentisolation: false,
            );
          });
          // firstBtn.isHidden = false
          //
          // if projectName == ProjectNames.MedMentor || projectName ==  ProjectNames.YouNextU{
          // firstBtn.setTitle("  \(NSLocalizedString("globalstart_actionsheet_startoption", comment: "Start"))", for: .normal)
          // }else{
          // firstBtn.setTitle("  \(NSLocalizedString("details_button_viewbutton", comment: "View"))", for: .normal)
          // }
          // firstBtn.setImage(viewImage, for: .normal)
          // //Anvesh we are adding tags to avoid the string comparison incase of localization
          // firstBtn.tag = DetailsScreenButtonsNameTag.ViewOrPlayButton.rawValue

        }
      }
    }
    else if ((widget.table2.viewtype == 5) && (widget.table2.isaddedtomylearning == 0) || (widget.table2.isaddedtomylearning == 1)) {
      // Mahesh Added New i.e Direct Add to My Learning
      if (widget.table2.objecttypeid != 70) {
        if (widget.table2.objecttypeid == 102) {
          return displayBottomButton(
              appBloc.localstr.catalogActionsheetViewoption,
              () => executeXAPICourse(widget.table2));
        }

        return displayBottomButton(appBloc.localstr.catalogActionsheetViewoption, () async {
          bool result = await MyLearningController().decideCourseLaunchMethod(
            context: context,
            table2: widget.table2,
            isContentisolation: false,
          );
        });
        // firstBtn.isHidden = false
        // if projectName == ProjectNames.MedMentor || projectName ==  ProjectNames.YouNextU{
        // firstBtn.setTitle("  \(NSLocalizedString("globalstart_actionsheet_startoption", comment: "Start"))", for: .normal)
        // }else{
        // firstBtn.setTitle("  \(NSLocalizedString("details_button_viewbutton", comment: "View"))", for: .normal)
        // }
        //
        // firstBtn.setImage(viewImage, for: .normal)
        // firstBtn.tag = DetailsScreenButtonsNameTag.ViewOrPlayButton.rawValue
      }
    }

    if (widget.screenType == ScreenType.Events) {
      if (isValidString(widget.table2.eventstartdatetime ?? "") &&
          !returnEventCompleted(widget.table2.eventstartdatetime ?? "")) {
        if (widget.table2.isbadcancellationenabled) {
          return displayBottomButton(
              appBloc.localstr.eventsActionsheetCancelenrollmentoption,
              () => showCancelEnrollDialog(widget.table2, 'Success'));
        }

        if (widget.table2.eventscheduletype == 1 &&
            appBloc.uiSettingModel.enableMultipleInstancesForEvent == 'true') {
          return Container();
        }
      }
    }

    return const SizedBox();
  }
}
