import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/catalog_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_state.dart';
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/common/api_response.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/parsing_helper.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/model/subsitelogin_response.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/packages/unicorndialer.dart';
import 'package:flutter_admin_web/ui/Catalog/gotoCoursePreview.dart';
import 'package:flutter_admin_web/ui/Catalog/prepreprerequisite_screen.dart';
import 'package:flutter_admin_web/ui/Catalog/wikiuploadscreen.dart';
import 'package:flutter_admin_web/ui/Catalog/wish_list.dart';
import 'package:flutter_admin_web/ui/MyLearning/Assignmentcontentweb.dart';
import 'package:flutter_admin_web/ui/MyLearning/SendviaEmailMylearning.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunchContenisolation.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/mylearning_filter.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_primary_secondary_button.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/ui/home/ActBase.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../common/bottomsheet_drager.dart';
import '../global_search_screen.dart';

// https://joebirch.co/flutter/adding-in-app-purchases-to-flutter-apps/
// https://toobay.home.blog/2021/01/31/flutter-in-app-purchases-paying-for-app-features-and-unlock-them/
// https://github.com/sunilkrsingh8922/in_app_purchase
// https://github.com/RobertBrunhage/Youtube-Tutorials/tree/master/in_app_purchase
// https://fireship.io/lessons/flutter-inapp-purchases/

class CatalogRefreshScreen extends StatefulWidget {
  final int categaoryID;
  final String categaoryName, searchString;
  final NativeMenuModel nativeMenuModel;
  final String contentID;

  const CatalogRefreshScreen({
    this.categaoryID = 0,
    this.categaoryName = "",
    this.searchString = "",
    required this.nativeMenuModel,
    this.contentID = "",
  });

  @override
  State<CatalogRefreshScreen> createState() => _CatalogRefreshScreenState();
}

class _CatalogRefreshScreenState extends State<CatalogRefreshScreen> with SingleTickerProviderStateMixin {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  Map<String, String> filterMenus = {};
  String assignmenturl = "";

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  ScrollController _sc = ScrollController();

  late MyLearningDetailsBloc detailsBloc;
  bool addToMyLearn = false;

  int selectedIndexOfAddedMyLearning = 0;
  ItemScrollController _scrollController = ItemScrollController();

  int pageNumber = 0;
  bool isGetCatalogListEvent = false;
  DummyMyCatelogResponseTable2 dummyMyCatelogResponseTable = DummyMyCatelogResponseTable2();

  late FToast flutterToast;

  bool menu0 = false,
      menu1 = false,
      menu2 = false,
      menu3 = false,
      menu4 = false,
      menu5 = false,
      menu6 = false,
      menu7 = false,
      menu8 = false;

  bool isWikiEnabled = false;
  bool isConsolidated = false;

  String ddlSortList = 'C.Name asc';
  late ProfileBloc profileBloc;

  GotoCourseLaunch? courseLaunch;
  GotoCourseLaunchCatalog? courseLaunchCatalog;

  GeneralRepository? generalRepository;

  Animation<double>? _animation;
  AnimationController? _animationController;
 String componentId = "";

  /// Consumable credits the user can buy
  int credits = 0;
  String preqContentNames = "";
  String preqContentTitle = "";
  //String inappKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxZKOgrgA0BACsUqzZ49Xqj1SEWSx/VNSQ7e/WkUdbn7Bm2uVDYagESPHd7xD6cIUZz9GDKczG/fkoShHZdMCzWKiq07BzWnxdSaWa4rRMr+uylYAYYvV5I/R3dSIAOCbbcQ1EKUp5D7c2ltUpGZmHStDcOMhyiQgxcxZKTec6YiJ17X64Ci4adb9X/ensgOSduwQwkgyTiHjklCbwyxYSblZ4oD8WE/Ko9003VrD/FRNTAnKd5ahh2TbaISmEkwed/TK4ehosqYP8pZNZkx/bMsZ2tMYJF0lBUl5i9NS+gjVbPX4r013Pjrnz9vFq2HUvt7p26pxpjkBTtkwVgnkXQIDAQAB";

  bool isLoading = false, isCatalogContentsLoading = true;

  void deliverProduct(DummyMyCatelogResponseTable2 dummyMyCatelogResponseTable, PurchaseDetails purchaseDetails) async {
    var deviceType = Platform.isAndroid ? "Android" : "IOS";

    catalogBloc.add(
      SaveInAppPurchaseEvent(
          siteURl: dummyMyCatelogResponseTable.siteurl,
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
    if(error != null) {
      MyToast.showToast(context, "Error in Buying Content : '${error.message}'");
    }
    else {
      MyToast.showToast(context, "Error in Buying Content");
    }
  }

  Future<void> handlePurchase(DummyMyCatelogResponseTable2 product, PurchaseDetails? purchaseDetails) async {
    if(purchaseDetails == null) {
      MyToast.showToast(context, "Purchase Failed");
      return;
    }

    if (purchaseDetails.status == PurchaseStatus.pending) {
      MyToast.showToast(context, "Purchase Pending");
    }
    else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        handlePurchaseError(purchaseDetails.error);
      }
      else if (purchaseDetails.status == PurchaseStatus.purchased) {
        deliverProduct(product, purchaseDetails);
      }
    }
  }

  /// InApp purchase implementation
  Future<void> _buyProduct(DummyMyCatelogResponseTable2 product) async {
    print("Content Id:${product.contentid}");

    String productId = "";

    if(Platform.isAndroid) {
      productId = product.googleproductid?.toString() ?? "";
    }
    else if(Platform.isIOS) {
      productId = product.itunesproductid?.toString() ?? "";
    }

    print("Product Id:$productId");
    if(productId.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      Map<String, ProductDetails> map = await InAppPurchaseController().getProductDetails([productId]);
      print("Product Details Map:$map");

      if(map[productId] != null) {
        ProductDetails productDetails = map[productId]!;

        PurchaseDetails? purchaseDetails = await InAppPurchaseController().buyProduct(productDetails);
        await handlePurchase(product, purchaseDetails);
      }
      else {
        MyToast.showToast(context, "Product Details Not Available");
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => GlobalSearchScreen(menuId: 3091)),
    );

    print(result);

    if (result != null) {
      catalogBloc.isFirstLoadingCatalog = true;
      catalogBloc.isCatalogSearch = true;
      catalogBloc.searchCatalogString = result.toString();
      setState(() {
        pageNumber = 1;
      });
      refresh();
    }
  }

  Future<String> getCurrentDateTimeInStr() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
    String formatted = formatter.format(now);

    return formatted;
  }

  getComponentId() async{
    componentId = await sharePrefGetString(sharedPref_ComponentID);
  }

  void addToLearningClick(DummyMyCatelogResponseTable2 table2,int i){
    // Navigator.pop(context);
    if (table2.userid != null && table2.userid != "-1") {
      if (table2.isaddedtomylearning == 2) {
        catalogBloc.add(
          GetPrequisiteDetailsEvent(
              contentId: table2.contentid,
              userID: table2.userid),
        );
      }
      else {
        setState(() {
          selectedIndexOfAddedMyLearning = i;
        });

        print("table2.eventscheduletype:${table2.eventscheduletype}");
        //catalogBloc.add(
        ((table2.objecttypeid == 70 && table2.eventscheduletype == 1) || (table2.objecttypeid == 70 && table2.eventscheduletype == 2))
            ? Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    CommonDetailScreen(
                      screenType:
                      ScreenType.Catalog,
                      contentid:
                      table2.contentid,
                      objtypeId:
                      table2.objecttypeid,
                      detailsBloc:
                      detailsBloc,
                      table2: table2,
                      isShowShedule: true,
                      isFromReschedule: false,
                      //isFromMyLearning: true
                      // nativeModel:
                      //     widget.nativeMenuModel,
                    )))
            : catalogBloc.add(
          AddToMyLearningEvent(
              contentId: table2.contentid,
              table2: table2),
        );
      }
    } else {
      flutterToast.showToast(
        child: CommonToast(
            displaymsg:
            'Not a member of ${table2.sitename}'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2),
      );
      checkUserLogin(table2);
    }

  }

  void viewOnClick(DummyMyCatelogResponseTable2 table2,int i){
    //print("imageurl---${table2.imageData}");
    // Navigator.pop(context);
    if (isValidString(
        table2.viewprerequisitecontentstatus ?? "")) {
      print('ifdataaaaa');
      Navigator.of(context).pop();
      String alertMessage = appBloc
          .localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage +
          "  \"" +
          appBloc.localstr.prerequisLabelContenttypelabel +
          "\" " +
          appBloc
              .localstr.prerequistesalerttitle5Alerttitle7;

      showDialog(
          context: context,
          builder: (BuildContext context) =>
          AlertDialog(
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
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(alertMessage,
                    style: TextStyle(
                        color: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                        ))),
                Text(
                    '\n' +
                        table2
                            .viewprerequisitecontentstatus
                            .toString()
                            .split('#%')[1]
                            .split('\$;')[0],
                    style: TextStyle(
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
            backgroundColor:
            InsColor(appBloc).appBGColor,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(5)),
            actions: <Widget>[
              FlatButton(
                child: Text(appBloc.localstr
                    .eventsAlertbuttonOkbutton),
                textColor: Colors.blue,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    } else {
      //Navigator.pop(context);
      if (table2.isaddedtomylearning == 1) {
        launchCourse(table2, context, false);
      } else {
        launchCoursePreview(table2, context);
      }
    }
  }

  @override
  void initState() {
    appBloc.add(WishlistCountEvent());
    filterMenus = Map();
    getComponentId();
    log('String:${widget.nativeMenuModel.conditions}');
    filterMenus = getConditionsValue(widget.nativeMenuModel.conditions);

    if (filterMenus.containsKey("DefaultRepositoryID")) {
      String allowAddContentType = filterMenus["DefaultRepositoryID"] ?? "";
      print("DefaultRepositoryID $allowAddContentType");
      if (allowAddContentType != '' && allowAddContentType.toLowerCase() == "true") {
        isWikiEnabled = true;
      }
      else {
        isWikiEnabled = false;
      }
    }
    else {
      // No such key
      isWikiEnabled = false;
    }

    //isWikiEnabled = true;

    profileBloc = ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
    //print("consolidatedType:${filterMenus['Type']}");
    if (filterMenus.containsKey("Type")) {
      String consolidatedType = filterMenus["Type"] ?? "";
      print("consolidatedType $consolidatedType");
      if (consolidatedType != null && consolidatedType != '' && consolidatedType.toLowerCase() == "consolidate") {
        isConsolidated = true;
      }
      else {
        isConsolidated = false;
      }
    }
    else {
      // No such key
      isConsolidated = false;
    }

    if (filterMenus != null && filterMenus.containsKey("ddlSortList")) {
      String ddlSortListS = filterMenus["ddlSortList"] ?? "";
      print("ddlSortList $ddlSortListS");
      if (ddlSortListS != null) {
        ddlSortList = ddlSortListS;
      } else {
        ddlSortList = ddlSortListS;
      }
    } else {
      // No such key
      ddlSortList = 'C.Name asc';
    }

    generalRepository = GeneralRepositoryBuilder.repository();
    if (widget.categaoryID != 0) {
      myLearningBloc.add(SelectCategoriesEvent(
          seletedCategoryID: widget.categaoryID.toString(),
          mainCategory: "subcat",
          categoryDisplayName: "Categories"));
    } else {
      myLearningBloc.add(ResetFilterEvent());
      myLearningBloc.add(GetFilterMenus(
          listNativeModel: appBloc.listNativeModel,
          localStr: appBloc.localstr,
          moduleName: widget.nativeMenuModel != null
              ? widget.nativeMenuModel.displayname
              : ''));
      myLearningBloc.add(GetSortMenus("1"));
    }

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print("Last Postion");
        if (isGetCatalogListEvent &&
            catalogBloc.listCatalogTotalCount >
                catalogBloc.catalogCatgorylist.length) {
          print("Last Postion-----Api call ");
          setState(() {
            isGetCatalogListEvent = false;
          });
          refresh();
        }
      }
    });
    print("Selected Sort ${myLearningBloc.ddlSortList}");
    print("Search String in Init:${widget.searchString}");
    catalogBloc.isFirstLoadingCatalog = true;
    catalogBloc.isCatalogSearch = widget.searchString.isNotEmpty;
    catalogBloc.searchCatalogString = widget.searchString;
    refresh();

    detailsBloc = MyLearningDetailsBloc(myLearningRepository: MyLearningRepositoryBuilder.repository());

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    catalogBloc.add(GetFileUploadControlsEvent(
        compInsId: widget.nativeMenuModel != null
            ? widget.nativeMenuModel.repositoryId
            : '',
        localeId: 'en-us',
        siteId: ApiEndpoints.siteID));

    //provider = Provider.of<ProviderModel>(NavigationController().mainNavigatorKey.currentContext!, listen: false);
    // provider = Provider.of<ProviderModel>(context, listen: false);
    // provider.initialize();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    print("Category Id:${widget.categaoryID}");
    //print("Wishlist Count:${appBloc.wishlistcount}");

    if (widget.categaoryID != 0) {
      return WillPopScope(
        onWillPop: () async {
          return !isLoading;
        },
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: InsColor(appBloc).appIconColor,
                size: 70.h,
              ),
            ),
          ),
          child: Container(
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
                appBar: AppBar(
                  backgroundColor: Color(
                    int.parse(
                        "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
                  ),
                  title: Text(
                    widget.categaoryName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(
                        int.parse(
                            "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Stack(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.favorite),
                            color: InsColor(appBloc).appHeaderTxtColor,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WishList(
                                    categaoryID: widget.categaoryID,
                                    categaoryName: widget.categaoryName,
                                    detailsBloc: detailsBloc,
                                    filterMenus: filterMenus,
                                  )));
                            }),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              appBloc.wishlistcount,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // InkWell(
                    //     onTap: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => ChangeNotifierProvider(
                    //                 create: (context) => ProviderModel(),
                    //                 child: WishList(
                    //                   categaoryID: widget.categaoryID,
                    //                   categaoryName: widget.categaoryName,
                    //                   detailsBloc: detailsBloc,
                    //                   filterMenus: filterMenus,
                    //                 ),
                    //               )));
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(10.0),
                    //       child: Icon(Icons.favorite,
                    //           color: InsColor(appBloc).appIconColor),
                    //     ))
                  ],
                  leading: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back,
                          color: Color(
                            int.parse(
                                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
                          ))),
                ),
                body: Container(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: BlocConsumer<MyLearningBloc, MyLearningState>(
                    bloc: myLearningBloc,
                    listener: (BuildContext context, MyLearningState state) {
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
                      return BlocConsumer<CatalogBloc, CatalogState>(
                        bloc: catalogBloc,
                        listener: (context, state) {
                          if (state is GetCategoryWisecatalogState) {
                            if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");
                              setState(() {
                                isCatalogContentsLoading = false;
                                isGetCatalogListEvent = true;
                                pageNumber++;
                              });

                              if (addToMyLearn) {
                                Timer(Duration(seconds: 1), () {
                                  _scrollController.scrollTo(
                                      index: selectedIndexOfAddedMyLearning,
                                      duration: Duration(seconds: 1));
                                });
                              }

                              if (widget.contentID != null) {
                                catalogBloc.catalogCatgorylist.forEach((element) {
                                  if (element.contentid == widget.contentID) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CommonDetailScreen(
                                          screenType: ScreenType.Catalog,
                                          contentid: element.contentid,
                                          objtypeId: element.objecttypeid,
                                          detailsBloc: detailsBloc,
                                          table2: element,
                                          isShowShedule: true,
                                          isFromReschedule: false,
                                          //nativeModel: widget.nativeMenuModel,
                                        )));
                                  }
                                });
                              }
                            }
                            else if (state.status == Status.ERROR) {
                              isCatalogContentsLoading = false;
                              setState(() {});
//                print("listner Error ${state.message}");
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          if (state is AddToWishListState || state is RemoveFromWishListState || state is AddToMyLearningState) {
                            if (state.status == Status.COMPLETED) {
                              catalogBloc.isFirstLoadingCatalog = true;
                              refresh();
                              if (state is AddToWishListState) {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: appBloc.localstr
                                          .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                                appBloc.add(WishlistCountEvent());
                              }
                              if (state is RemoveFromWishListState) {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: appBloc.localstr
                                          .catalogAlertsubtitleItemremovedtowishlistsuccesfully),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                                appBloc.add(WishlistCountEvent());
                              }
                              if (state is AddToMyLearningState) {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: appBloc.localstr
                                          .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );

                                addToMyLearn = true;
                              }
                            }
                          }
                          if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
                            if (state.message == "401") {
                              AppDirectory.sessionTimeOut(context);
                            }
                          }

                          if (state is SaveInAppPurchaseState) {
                            if (state.status == Status.COMPLETED) {
                              if (isValidString(state.response) && state.response.contains('success')) {
                                dummyMyCatelogResponseTable.isaddedtomylearning = 1;
                                setState(() {});

                                MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

                                Timer(Duration(seconds: 1), () {
                                  _scrollController.scrollTo(
                                      index: selectedIndexOfAddedMyLearning,
                                      duration: Duration(seconds: 1));
                                });
                              }
                              else {}
                            }
                            else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
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
                          print("state -----$state");
                          var _controller;
                          if (catalogBloc.isCatalogSearch) {
                            _controller = TextEditingController(
                                text: catalogBloc.searchCatalogString);
                          }
                          else {
                            _controller = TextEditingController();
                          }
                          if (state.status == Status.LOADING) {
                            return Center(
                              child: AbsorbPointer(
                                child: SpinKitCircle(
                                  color: InsColor(appBloc).appIconColor,
                                  size: 70.h,
                                ),
                              ),
                            );
                          }
                          else if (state.status == Status.COMPLETED) {
                            return catalogBloc.catalogCatgorylist.length == 0
                                ? Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InsSearchTextField(
                                            onTapAction: () {
                                              if (appBloc
                                                      .uiSettingModel.isGlobalSearch ==
                                                  'true') {
                                                _navigateToGlobalSearchScreen(context);
                                              }
                                            },
                                            controller: _controller,
                                            appBloc: appBloc,
                                            suffixIcon: catalogBloc.isCatalogSearch
                                                ? IconButton(
                                                    onPressed: () {
                                                      //search logic
                                                      catalogBloc.isFirstLoadingCatalog = true;
                                                      catalogBloc.isCatalogSearch = false;
                                                      catalogBloc.searchCatalogString = "";
                                                      setState(() {
                                                        pageNumber = 1;
                                                      });
                                                      refresh();
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                    ),
                                                  )
                                                : (myLearningBloc.isFilterMenu)
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          await Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyLearningFilter(componentId: componentId,)));

                                                          catalogBloc.isFirstLoadingCatalog = true;
                                                          refresh();
                                                        },
                                                        icon: Icon(Icons.tune,
                                                            color: AppColors.getFilterIconColor()),
                                                      )
                                                    : null,
                                            onSubmitAction: (value) {
                                              if (value.toString().length > 0) {
                                                catalogBloc.isFirstLoadingCatalog = true;
                                                catalogBloc.isCatalogSearch = true;
                                                catalogBloc.searchCatalogString = value.toString();
                                                setState(() {
                                                  pageNumber = 1;
                                                });
                                                refresh();
                                              }
                                            },
                                          )),
                                      Container(
                                        child: Center(
                                          child: Text(
                                              appBloc.localstr
                                                  .commoncomponentLabelNodatalabel,
                                              style: TextStyle(
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                  fontSize: 24)),
                                        ),
                                      ),
                                    ],
                                  )
                                : ResponsiveWidget(
                                    mobile: ScrollablePositionedList.builder(
                                      //shrinkWrap: true,
                                      itemScrollController: _scrollController,
                                      itemCount: catalogBloc.catalogCatgorylist.length + 2,
                                      itemBuilder: (context, i) {
                                        if (i == catalogBloc.catalogCatgorylist.length + 1) {
                                          if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                            return _buildProgressIndicator();
                                          } else {
                                            return Container();
                                          }
                                        }
                                        else if (i == 0) {
                                          return Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: InsSearchTextField(
                                                onTapAction: () {
                                                  if (appBloc.uiSettingModel
                                                          .isGlobalSearch ==
                                                      'true') {
                                                    _navigateToGlobalSearchScreen(
                                                        context);
                                                  }
                                                },
                                                controller: _controller,
                                                appBloc: appBloc,
                                                suffixIcon: catalogBloc.isCatalogSearch
                                                    ? IconButton(
                                                        onPressed: () {
                                                          //search logic
                                                          catalogBloc.isFirstLoadingCatalog = true;
                                                          catalogBloc.isCatalogSearch = false;
                                                          catalogBloc.searchCatalogString = "";
                                                          setState(() {
                                                            pageNumber = 1;
                                                          });
                                                          refresh();
                                                        },
                                                        icon: Icon(
                                                          Icons.close,
                                                        ),
                                                      )
                                                    : (myLearningBloc.isFilterMenu)
                                                        ? IconButton(
                                                            onPressed: () async {
                                                              await Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MyLearningFilter(componentId: componentId,)));

                                                              catalogBloc
                                                                      .isFirstLoadingCatalog =
                                                                  true;
                                                              refresh();
                                                            },
                                                            icon: Icon(Icons.tune,
                                                                color: AppColors.getFilterIconColor()),
                                                          )
                                                        : null,
                                                onSubmitAction: (value) {
                                                  if (value.toString().length > 0) {
                                                    catalogBloc.isFirstLoadingCatalog = true;
                                                    catalogBloc.isCatalogSearch = true;
                                                    catalogBloc.searchCatalogString = value.toString();
                                                    setState(() {
                                                      pageNumber = 1;
                                                    });
                                                    refresh();
                                                  }
                                                },
                                              ));
                                        }
                                        else {
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              child: widgetMyCatalogListItems(
                                                  catalogBloc.catalogCatgorylist[i],
                                                  false,
                                                  context,
                                                  i),
                                            ),
                                          );
                                        }
                                      },
                                      //controller: _sc,
                                    ),
                                    tab: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width / 860,
                                      ),
                                      //controller: _scrollController,
                                      itemCount:
                                          catalogBloc.catalogCatgorylist.length + 2,
                                      itemBuilder: (context, i) {
                                        if (i ==
                                            catalogBloc.catalogCatgorylist.length + 1) {
                                          if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                            return _buildProgressIndicator();
                                          } else {
                                            return Container();
                                          }
                                        } else if (i == 0) {
                                          return Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: InsSearchTextField(
                                                onTapAction: () {
                                                  if (appBloc.uiSettingModel
                                                          .isGlobalSearch ==
                                                      'true') {
                                                    _navigateToGlobalSearchScreen(
                                                        context);
                                                  }
                                                },
                                                controller: _controller,
                                                appBloc: appBloc,
                                                suffixIcon: catalogBloc.isCatalogSearch
                                                    ? IconButton(
                                                        onPressed: () {
                                                          //search logic
                                                          catalogBloc
                                                                  .isFirstLoadingCatalog =
                                                              true;
                                                          catalogBloc.isCatalogSearch =
                                                              false;
                                                          catalogBloc
                                                              .searchCatalogString = "";
                                                          setState(() {
                                                            pageNumber = 1;
                                                          });
                                                          refresh();
                                                        },
                                                        icon: Icon(
                                                          Icons.close,
                                                        ),
                                                      )
                                                    : (myLearningBloc.isFilterMenu)
                                                        ? IconButton(
                                                            onPressed: () async {
                                                              await Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MyLearningFilter(componentId: componentId,)));

                                                              catalogBloc
                                                                      .isFirstLoadingCatalog =
                                                                  true;
                                                              refresh();
                                                            },
                                                            icon: Icon(Icons.tune,
                                                                color: AppColors.getFilterIconColor()),
                                                          )
                                                        : null,
                                                onSubmitAction: (value) {
                                                  if (value.toString().length > 0) {
                                                    catalogBloc.isFirstLoadingCatalog = true;
                                                    catalogBloc.isCatalogSearch = true;
                                                    catalogBloc.searchCatalogString = value.toString();
                                                    setState(() {
                                                      pageNumber = 1;
                                                    });
                                                    refresh();
                                                  }
                                                },
                                              ));
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              child: widgetMyCatalogListItems(
                                                  catalogBloc.catalogCatgorylist[i],
                                                  false,
                                                  context,
                                                  i),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    web: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 1,
                                      ),
                                      //controller: _scrollController,
                                      itemCount:
                                      catalogBloc.catalogCatgorylist.length + 2,
                                      itemBuilder: (context, i) {
                                        if (i ==
                                            catalogBloc.catalogCatgorylist.length + 1) {
                                          if (state.status == Status.LOADING) {
      //                          print("gone in _buildProgressIndicator");
                                            return _buildProgressIndicator();
                                          } else {
                                            return Container();
                                          }
                                        } else if (i == 0) {
                                          return Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: InsSearchTextField(
                                                onTapAction: () {
                                                  if (appBloc.uiSettingModel
                                                      .isGlobalSearch ==
                                                      'true') {
                                                    _navigateToGlobalSearchScreen(
                                                        context);
                                                  }
                                                },
                                                controller: _controller,
                                                appBloc: appBloc,
                                                suffixIcon: catalogBloc.isCatalogSearch
                                                    ? IconButton(
                                                  onPressed: () {
                                                    //search logic
                                                    catalogBloc
                                                        .isFirstLoadingCatalog =
                                                    true;
                                                    catalogBloc.isCatalogSearch =
                                                    false;
                                                    catalogBloc
                                                        .searchCatalogString = "";
                                                    setState(() {
                                                      pageNumber = 1;
                                                    });
                                                    refresh();
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                  ),
                                                )
                                                    : (myLearningBloc.isFilterMenu)
                                                    ? IconButton(
                                                  onPressed: () async {
                                                    await Navigator.of(
                                                        context)
                                                        .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyLearningFilter(componentId: componentId,)));

                                                    catalogBloc
                                                        .isFirstLoadingCatalog =
                                                    true;
                                                    refresh();
                                                  },
                                                  icon: Icon(Icons.tune,
                                                      color: Color(
                                                        int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                                      )),
                                                )
                                                    : null,
                                                onSubmitAction: (value) {
                                                  if (value.toString().length > 0) {
                                                    catalogBloc.isFirstLoadingCatalog = true;
                                                    catalogBloc.isCatalogSearch = true;
                                                    catalogBloc.searchCatalogString = value.toString();
                                                    setState(() {
                                                      pageNumber = 1;
                                                    });
                                                    refresh();
                                                  }
                                                },
                                              ));
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              child: widgetMyCatalogListItems(
                                                  catalogBloc.catalogCatgorylist[i],
                                                  false,
                                                  context,
                                                  i),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    key: Key(""),
                                  );
                          }
                          else {
                            return noDataFound(true);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    else {
      print("it is 0");
      return WillPopScope(
        onWillPop: () async {
          return !isLoading;
        },
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: Center(
            child: AbsorbPointer(
              child: SpinKitCircle(
                color: InsColor(appBloc).appIconColor,
                size: 70.h,
              ),
            ),
          ),
          child: Container(
            color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
            child: SafeArea(
              child: Scaffold(
                appBar: widget.categaoryName == 'true'
                    ? AppBar(
                        backgroundColor: Color(
                          int.parse(
                              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
                        ),
                        title: Text(
                          widget.nativeMenuModel != null
                              ? widget.nativeMenuModel.displayname
                              : '',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Stack(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.favorite),
                                  color: InsColor(appBloc).appHeaderTxtColor,
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => WishList(
                                          categaoryID: widget.categaoryID,
                                          categaoryName: widget.categaoryName,
                                          detailsBloc: detailsBloc,
                                          filterMenus: filterMenus,
                                        )));
                                  }),
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: Text(
                                    appBloc.wishlistcount,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),

                          // InkWell(
                          //     onTap: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) => ChangeNotifierProvider(
                          //                 create: (context) => ProviderModel(),
                          //                 child: WishList(
                          //                   categaoryID: widget.categaoryID,
                          //                   categaoryName: widget.categaoryName,
                          //                   detailsBloc: detailsBloc,
                          //                   filterMenus: filterMenus,
                          //                 ),
                          //               )));
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Icon(
                          //         Icons.favorite,
                          //         color: InsColor(appBloc).appIconColor,
                          //       ),
                          //     ))
                        ],
                        leading: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.arrow_back,
                                color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"),
                                ))),
                      )
                    : null,
                floatingActionButton: isWikiEnabled ? floatActionUnicornDialer() : null,
                body: Container(
                  color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  child: BlocConsumer<MyLearningBloc, MyLearningState>(
                    bloc: myLearningBloc,
                    listener: (BuildContext context, MyLearningState state) {
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
                          if (isValidString(state.response) && state.response.contains('failed')) {
                            launchCourse(state.table2, context, true);
                          }
                          else {
                            launchCourseContentisolation(
                                state.table2, context, state.response.toString());
                          }
                        }
                        else if (state.status == Status.ERROR) {
                          if (state.message == "401") {
                            AppDirectory.sessionTimeOut(context);
                          }
                        }
                      }
                    },
                    builder: (BuildContext context, MyLearningState state) {
                      print("My Learning Builder Called with State:${state.runtimeType}, Status:${state.status}");
                      return BlocConsumer<CatalogBloc, CatalogState>(
                        bloc: catalogBloc,
                        listener: (context, state) {
                          print("Catalog Listener Called with State:${state.runtimeType}, Status:${state.status}");

                          if (state is GetCategoryWisecatalogState) {
                            if (state.status == Status.COMPLETED) {
                              isCatalogContentsLoading = false;
//            print("List size ${state.list.length}");
                              setState(() {
                                isGetCatalogListEvent = true;
                                pageNumber++;
                              });

                              if (addToMyLearn) {
                                Timer(Duration(seconds: 1), () {
                                  _scrollController.scrollTo(
                                      index: selectedIndexOfAddedMyLearning,
                                      duration: Duration(seconds: 1));
                                });
                              }
                            }
                            else if (state.status == Status.ERROR) {
                              isCatalogContentsLoading = false;
                              setState(() {});
//                print("listner Error ${state.message}");
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          if (state is AddToWishListState || state is RemoveFromWishListState || state is AddToMyLearningState) {
                            if (state.status == Status.COMPLETED) {
                              catalogBloc.isFirstLoadingCatalog = true;
                              refresh();
                              if (state is AddToWishListState) {
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: appBloc.localstr
                                          .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                                appBloc.add(WishlistCountEvent());
                              }
                              if (state is RemoveFromWishListState) {
                                MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
                                appBloc.add(WishlistCountEvent());
                              }
                              if (state is AddToMyLearningState) {
                                flutterToast = FToast();
                                flutterToast.init(context);
                                flutterToast.showToast(
                                  child: CommonToast(
                                      displaymsg: appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                                addToMyLearn = true;
                              }

                              if (state is GetFileUploadControlsState) {}
                            }
                          }

                          if (state is SubSignInState) {
                            if (state.status == Status.COMPLETED) {
                              checkSubsiteLogding(state.response, state.table2);
                            }
                          }

                          if (state is SaveInAppPurchaseState) {
                            if (state.status == Status.COMPLETED) {
                              if (isValidString(state.response) && state.response.contains('success')) {
                                dummyMyCatelogResponseTable.isaddedtomylearning = 1;
                                addToMyLearn = true;
                                setState(() {});

                                MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

                                Timer(Duration(seconds: 1), () {
                                  _scrollController.scrollTo(
                                      index: selectedIndexOfAddedMyLearning,
                                      duration: Duration(seconds: 1));
                                });
                              }
                              else {}
                            }
                            else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
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
                              print("prequisitePopupresponse size ${state.prequisitePopupresponse.prerequisteData.table.length}");
                              preqContentNames = "";
                              preqContentTitle = "";
                              if (state.prequisitePopupresponse != null && (state.prequisitePopupresponse.prerequisteData.table.length) > 0) {
                                state.prequisitePopupresponse.prerequisteData.table1.forEach((element) {
                                  preqContentTitle = element.pathName;
                                });
                                state.prequisitePopupresponse.prerequisteData.table.forEach((element) async {
                                  // print("displayname ${element.name}");
                                  // print("parameterString ${element.name}");

                                  preqContentNames = preqContentNames + "\n" + element.name;
                                });
                                getDetailsApiCall(state.contentId);
                              }
                              else {
                                print("3333 : " +
                                    dummyMyCatelogResponseTable.sitename +
                                    " ; " +
                                    dummyMyCatelogResponseTable.description);
                                catalogBloc.add(
                                  AddToMyLearningEvent(
                                    contentId: dummyMyCatelogResponseTable.contentid,
                                    table2: dummyMyCatelogResponseTable,
                                  ),
                                );
                              }
                            }
                            else if (state.status == Status.ERROR) {
                              if (state.message == "401") {
                                AppDirectory.sessionTimeOut(context);
                              }
                            }
                          }
                          if (state is GetCatalogDetailsState) {
                            if (state.status == Status.COMPLETED) {
                              if (catalogBloc.catalogRes != null) {
                                showAlertDialog(context, preqContentTitle, preqContentNames, catalogBloc.catalogRes);
                              }
                            }
                          }
                        },
                        builder: (context, state) {
                          print("Catalog Bloc Status:${state.status}, State:${state.runtimeType}");
                          var _controller;
                          if (catalogBloc.isCatalogSearch) {
                            _controller = TextEditingController(
                                text: catalogBloc.searchCatalogString);
                          }
                          else {
                            _controller = TextEditingController();
                          }

                          if (state.status == Status.LOADING || isCatalogContentsLoading) {
                            return Center(
                              child: AbsorbPointer(
                                child: SpinKitCircle(
                                  color: InsColor(appBloc).appIconColor,
                                  size: 70.h,
                                ),
                              ),
                            );
                          }
                          else if (state.status == Status.COMPLETED) {
                            return catalogBloc.catalogCatgorylist.length == 0
                                ? Column(
                                    children: <Widget>[
                                      Visibility(
                                        visible: widget.searchString.isEmpty,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InsSearchTextField(
                                              onTapAction: () {
                                                if (appBloc
                                                        .uiSettingModel.isGlobalSearch ==
                                                    'true') {
                                                  _navigateToGlobalSearchScreen(context);
                                                }
                                              },
                                              controller: _controller,
                                              appBloc: appBloc,
                                              suffixIcon: catalogBloc.isCatalogSearch
                                                  ? IconButton(
                                                      onPressed: () {
                                                        //search logic
                                                        catalogBloc
                                                            .isFirstLoadingCatalog = true;
                                                        catalogBloc.isCatalogSearch =
                                                            false;
                                                        catalogBloc.searchCatalogString =
                                                            "";
                                                        setState(() {
                                                          pageNumber = 1;
                                                        });
                                                        refresh();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                      ),
                                                    )
                                                  : (myLearningBloc.isFilterMenu)
                                                      ? IconButton(
                                                          onPressed: () async {
                                                            await Navigator.of(context).push(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        MyLearningFilter(componentId: componentId,)));

                                                            catalogBloc.isFirstLoadingCatalog = true;
                                                            refresh();
                                                          },
                                                          icon: Icon(Icons.tune,
                                                              color: AppColors.getFilterIconColor()),
                                                        )
                                                      : null,
                                              onSubmitAction: (value) {
                                                if (value.toString().length > 0) {
                                                  catalogBloc.isFirstLoadingCatalog = true;
                                                  catalogBloc.isCatalogSearch = true;
                                                  catalogBloc.searchCatalogString = value.toString();
                                                  setState(() {
                                                    pageNumber = 1;
                                                  });
                                                  refresh();
                                                }
                                              },
                                            )),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                              appBloc.localstr
                                                  .commoncomponentLabelNodatalabel,
                                              style: TextStyle(
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                  fontSize: 24)),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Visibility(
                                        visible: widget.searchString.isEmpty,
                                        child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: InsSearchTextField(
                                              onTapAction: () {
                                                if (appBloc
                                                        .uiSettingModel.isGlobalSearch ==
                                                    'true') {
                                                  _navigateToGlobalSearchScreen(context);
                                                }
                                              },
                                              controller: _controller,
                                              appBloc: appBloc,
                                              suffixIcon: catalogBloc.isCatalogSearch
                                                  ? IconButton(
                                                      onPressed: () {
                                                        //search logic
                                                        catalogBloc.isFirstLoadingCatalog = true;
                                                        catalogBloc.isCatalogSearch = false;
                                                        catalogBloc.searchCatalogString = "";
                                                        setState(() {
                                                          pageNumber = 1;
                                                        });
                                                        refresh();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                      ),
                                                    )
                                                  : (myLearningBloc.isFilterMenu)
                                                      ? IconButton(
                                                          onPressed: () async {
                                                            await Navigator.of(context).push(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        MyLearningFilter(componentId: componentId,)));

                                                            catalogBloc.isFirstLoadingCatalog = true;
                                                            refresh();
                                                          },
                                                          icon: Icon(Icons.tune,
                                                              color: AppColors.getFilterIconColor()),
                                                        )
                                                      : null,
                                              onSubmitAction: (value) {
                                                if (value.toString().length > 0) {
                                                  catalogBloc.isFirstLoadingCatalog = true;
                                                  catalogBloc.isCatalogSearch = true;
                                                  catalogBloc.searchCatalogString = value.toString();
                                                  setState(() {
                                                    pageNumber = 1;
                                                  });
                                                  refresh();
                                                }
                                              },
                                            )),
                                      ),
                                      Expanded(
                                        child: ResponsiveWidget(
                                          key: Key(""),
                                          mobile: ScrollablePositionedList.builder(
                                            //shrinkWrap: true,
                                            itemScrollController: _scrollController,
                                            itemCount:
                                                catalogBloc.catalogCatgorylist.length,
                                            itemBuilder: (context, i) {
                                              if (catalogBloc
                                                      .catalogCatgorylist.length ==
                                                  0) {
                                                if (state.status == Status.LOADING) {
//                        print("gone in _buildProgressIndicator");
                                                  return _buildProgressIndicator();
                                                } else {
                                                  return Container();
                                                }
                                              } else {
                                                return Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Container(
                                                    child: widgetMyCatalogListItems(
                                                        catalogBloc
                                                            .catalogCatgorylist[i],
                                                        false,
                                                        context,
                                                        i),
                                                  ),
                                                );
                                              }
                                            },
                                            // controller: _sc,
                                          ),
                                          tab: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  MediaQuery.of(context).size.width /
                                                      860,
                                            ),
                                            //itemScrollController: _scrollController,
                                            itemCount:
                                                catalogBloc.catalogCatgorylist.length,
                                            itemBuilder: (context, i) {
                                              if (catalogBloc
                                                      .catalogCatgorylist.length ==
                                                  0) {
                                                if (state.status == Status.LOADING) {
//                        print("gone in _buildProgressIndicator");
                                                  return _buildProgressIndicator();
                                                } else {
                                                  return Container();
                                                }
                                              } else {
                                                return Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Container(
                                                    child: widgetMyCatalogListItems(
                                                        catalogBloc
                                                            .catalogCatgorylist[i],
                                                        false,
                                                        context,
                                                        i),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          web: GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5,
                                              childAspectRatio: 1
                                            ),
                                            //itemScrollController: _scrollController,
                                            itemCount:
                                            catalogBloc.catalogCatgorylist.length,
                                            itemBuilder: (context, i) {
                                              if (catalogBloc
                                                  .catalogCatgorylist.length ==
                                                  0) {
                                                if (state.status == Status.LOADING) {
//                        print("gone in _buildProgressIndicator");
                                                  return _buildProgressIndicator();
                                                } else {
                                                  return Container();
                                                }
                                              } else {
                                                return Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Container(
                                                    child: widgetMyCatalogListItems(
                                                        catalogBloc
                                                            .catalogCatgorylist[i],
                                                        false,
                                                        context,
                                                        i),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }
                          else {
                            return noDataFound(true);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget noDataFound(val) {
    return val
        ? Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InsSearchTextField(
                    onTapAction: () {
                      if (appBloc.uiSettingModel.isGlobalSearch == 'true') {
                        _navigateToGlobalSearchScreen(context);
                      }
                    },
                    appBloc: appBloc,
                    suffixIcon: (myLearningBloc.isFilterMenu)
                        ? IconButton(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyLearningFilter(componentId: componentId,)));

                              catalogBloc.isFirstLoadingCatalog = true;
                              refresh();
                            },
                            icon: Icon(Icons.tune,
                                color: AppColors.getFilterIconColor()),
                          )
                        : null,
                    onSubmitAction: (value) {
                      if (value.toString().length > 0) {}
                    },
                  )),
              Container(
                child: Center(
                  child: Text(
                      appBloc.localstr.commoncomponentLabelNodatalabel == null
                          ? ''
                          : appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontSize: 24)),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget widgetMyCatalogListItems(DummyMyCatelogResponseTable2 table2, bool bool, BuildContext context, int i) {
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    //MyPrint.printOnConsole("presenterurl:${table2.presenterurl}");
    MyPrint.printOnConsole("author:${table2.createduserid}");

    //print("Description:${table2.description}, View Type: ${table2.viewtype}");

    int objecttypeId = table2.objecttypeid;

    var isratingbarVissble;

    if (table2.totalratings >= int.parse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating)) {
      isratingbarVissble = true;
    }

    if (objecttypeId != 70) {
      isratingbarVissble = true;
    }

    String contentIconPath = table2.iconpath;

    if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.azureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    }
    else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    return Card(
      color: InsColor(appBloc).appBGColor,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {},
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => CommonDetailScreen(
                    //     screenType: ScreenType.Catalog,
                    //     contentid: table2.contentid,
                    //     objtypeId: table2.objecttypeid,
                    //     detailsBloc: detailsBloc,
                    //     table2: table2,
                    //     //nativeModel: widget.nativeMenuModel
                    //   ),
                    // ));
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommonDetailScreen(
                          screenType: ScreenType.Catalog,
                          contentid: table2.contentid,
                          objtypeId: table2.objecttypeid,
                          detailsBloc: detailsBloc,
                          table2: table2,
                          isShowShedule: true,
                          isFromReschedule: false,
                          //nativeModel: widget.nativeMenuModel
                        )));
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(kCellThumbHeight),
                    child: CachedNetworkImage(
                      imageUrl: table2.thumbnailimagepath.startsWith('http')
                          ? table2.thumbnailimagepath.trim()
                          : table2.siteurl + table2.thumbnailimagepath.trim(),
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
                      //
                      fit: BoxFit.cover,
                    ),
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
                      ),
                    ),
                  ),

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
                  // ),
                ),
              ),
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
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              table2.name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // bottom sheet pop menu
                        _settingMyCourceBottomSheet(context, table2, i);
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Profile(
                          isFromProfile: false,
                          isMyProfile: appBloc.userid == table2.createduserid.toString(),
                          connectionUserId: table2.createduserid.toString(),
                        ),
                    ));
                  },
                  child: Container(
                    //color: Colors.red,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                          table2.objecttypeid == 70
                              ? (table2.presenter != null)
                                  ? table2.presenter
                                  : ""
                              : (table2.authordisplayname != null)
                                  ? table2.authordisplayname
                                  : "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 1.0, bottom: 1.0, left: 1.0, right: 1.0),
                  child: Text(
                    table2.sitename,
                    style: TextStyle(
                      color: Color(0xff34aadc),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Text(
                  table2.shortdescription,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                //true
                (table2.viewtype == 3 && table2.isaddedtomylearning == 0)
                    ? Row(
                        children: <Widget>[
                          // commented till offline integration done
                          Text(

                            " \$${ParsingHelper.parseIntMethod(table2.saleprice)}",
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
                          buyOption(table2),
                        ],
                      )
                    : getPrimaryActionButton(table2,i)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getPrimaryActionButton(DummyMyCatelogResponseTable2 table2,int i){

    dummyMyCatelogResponseTable = table2;
    menu0 = false; //View button
    menu1 = false; // add to my learning button.
    bool isAddToMyLearning = false;

    print("isaddedtomylearning ---- ${table2.isaddedtomylearning} ${table2.siteid}");
    if (table2.isaddedtomylearning == 1) {
      print("view button true");
      menu0 = true;
      menu1 = false;
      if (table2.objecttypeid == 70) {
        int relatedCount = int.parse(table2.relatedconentcount.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      }
    }
    else {
      print("table2.viewtype---- ${table2.viewtype}");
      if (table2.viewtype == 1) {
        if (table2.isaddedtomylearning == 0) {
          menu0 = false;
        } else {
          menu0 = false;
        }
        menu1 = true;

        if (table2.objecttypeid == 70 &&
            isValidString(table2.eventstartdatetime() ?? "")) {
          menu1 = false;
        }
      } else if (table2.viewtype == 2) {
        menu0 = false;
        menu1 = true;
      } else if (table2.viewtype == 3) {
        // ecommerce content
        menu1 = false;
      }

      if (table2.viewtype == 5) {
        // for ditrect view
        menu0 = true;
        menu1 = false;
        if (table2.isaddedtomylearning == 0) {
          menu1 = true;
        }
      }
    }
    if(table2.isaddedtomylearning == 0){
      isAddToMyLearning = true;
    }

    if(menu0) {
      return Container(
        width: double.infinity,
        child: CommonPrimarySecondaryButton(
          onPressed: (){
            viewOnClick(table2,i);
          },
          text: appBloc.localstr.catalogActionsheetViewoption,
          isPrimary: true,
        ),
      );
    }
    else {
      if(isAddToMyLearning) {
        if(isConsolidated && table2.siteid != 374) {
          return SizedBox();
        }
        else {
          return Container(
            width: double.infinity,
            child: CommonPrimarySecondaryButton(
              onPressed: (){
                addToLearningClick(table2,i);
              },
              text: appBloc.localstr.catalogActionsheetAddtomylearningoption,
              isPrimary: true,
            ),
          );
        }
      }
      else {
        return SizedBox();
      }
    }
  }

  Widget buyOption(DummyMyCatelogResponseTable2 table2) {
    return isConsolidated && table2.siteid != 374
        ? Container()
        : Expanded(
            child: MaterialButton(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            // icon: Icon(IconDataSolid(int.parse('0x${"f155"}')),
            //     color: InsColor(appBloc).appBtnTextColor),
            child: Text(
              appBloc.localstr.detailsButtonBuybutton.toUpperCase(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: InsColor(appBloc).appBtnTextColor,
              ),
            ),
            onPressed: () async {
              //  buy functionlaity here
              dummyMyCatelogResponseTable = table2;
              _buyProduct(table2);
            },
          ));
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: 1.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _settingMyCourceBottomSheet(
      context, DummyMyCatelogResponseTable2 table2, int i) {
    print('bottomsheetobjit ${table2.objecttypeid}');
    dummyMyCatelogResponseTable = table2;
    menu0 = false;
    menu1 = false;
    menu2 = false;
    menu3 = false;
    menu4 = false;
    menu5 = false;
    menu6 = false;
    menu7 = false;
    menu8 = false;

    print("isaddedtomylearning ---- ${table2.isaddedtomylearning}");
    if (table2.isaddedtomylearning == 1) {
      menu0 = true;
      menu1 = false;
      menu2 = false;
      menu3 = true;

      if (table2.objecttypeid == 70) {
        int relatedCount = int.parse(table2.relatedconentcount.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      }
    } else {
      print("table2.viewtype---- ${table2.viewtype}");
      if (table2.viewtype == 1) {
        if (table2.isaddedtomylearning == 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
        menu1 = true;
        menu2 = false;
        menu3 = true;

        if (table2.objecttypeid == 70 &&
            isValidString(table2.eventstartdatetime() ?? "")) {
          menu1 = false;
        }

        if (appBloc.uiSettingModel.catalogContentDownloadType == "1" ||
            appBloc.uiSettingModel.catalogContentDownloadType == "2") {
          if (appBloc.uiSettingModel.catalogContentDownloadType == "0") {
            menu4 = false;
          }
        }
      } else if (table2.viewtype == 2) {
        menu0 = false;
        menu1 = true;
        menu3 = true;
//
      } else if (table2.viewtype == 3) {
        // ecommerce content
        menu1 = false;
        menu2 = true;
        menu3 = true;
      }

      if (table2.viewtype == 5) {
        // for ditrect view
        menu0 = true;
        menu3 = true;
        menu1 = false;

        if (table2.isaddedtomylearning == 0) {
          menu1 = true;
        }
      }
    }

    if (appBloc.uiSettingModel.catalogContentDownloadType == "0") {
      menu5 = false;
    }

    if (appBloc.uiSettingModel.enableWishlist == "True") {
      if (table2.isaddedtomylearning == 0 || table2.isaddedtomylearning == 2) {
        if (table2.iswishlistcontent == 1) {
          menu7 = true; //isWishListed
        } else {
          menu6 = true; //removeWishListed
        }
      }
    }

    if (table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 688 ||
        table2.objecttypeid == 102 ||
        appBloc.uiSettingModel.catalogContentDownloadType == "0") {
      menu5 = false;
    }

    if (isValidString(table2.eventrecording.toString()) &&
        table2.eventrecording == true) {
      if (table2.isaddedtomylearning == 1) {
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
                  BottomSheetDragger(),
                  if (menu0)
                    ListTile(
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
                      onTap: () {
                        //print("imageurl---${table2.imageData}");
                        Navigator.pop(context);
                        if (isValidString(
                            table2.viewprerequisitecontentstatus ?? "")) {
                          print('ifdataaaaa');
                          Navigator.of(context).pop();
                          String alertMessage = appBloc
                              .localstr.prerequistesalerttitle6Alerttitle6;
                          alertMessage = alertMessage +
                              "  \"" +
                              appBloc.localstr.prerequisLabelContenttypelabel +
                              "\" " +
                              appBloc
                                  .localstr.prerequistesalerttitle5Alerttitle7;

                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(alertMessage,
                                            style: TextStyle(
                                                color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            ))),
                                        Text(
                                            '\n' +
                                                table2
                                                    .viewprerequisitecontentstatus
                                                    .toString()
                                                    .split('#%')[1]
                                                    .split('\$;')[0],
                                            style: TextStyle(
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
                                    backgroundColor:
                                        InsColor(appBloc).appBGColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(appBloc.localstr
                                            .eventsAlertbuttonOkbutton),
                                        textColor: Colors.blue,
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                        } else {
                          //Navigator.pop(context);
                          if (table2.isaddedtomylearning == 1) {
                            launchCourse(table2, context, false);
                          } else {
                            launchCoursePreview(table2, context);
                          }
                        }
                      },
                    )
                  else
                    Container(),
                  menu1
                      ? isConsolidated && table2.siteid != 374
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
                                print(table2.userid);
                                if (table2.userid != null && table2.userid != "-1") {
                                  if (table2.isaddedtomylearning == 2) {
                                    catalogBloc.add(
                                      GetPrequisiteDetailsEvent(
                                          contentId: table2.contentid,
                                          userID: table2.userid),
                                    );
                                  }
                                  else {
                                    setState(() {
                                      selectedIndexOfAddedMyLearning = i;
                                    });

                                    print("table2.eventscheduletype:${table2.eventscheduletype}");
                                    //catalogBloc.add(
                                    ((table2.objecttypeid == 70 && table2.eventscheduletype == 1) || (table2.objecttypeid == 70 && table2.eventscheduletype == 2))
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommonDetailScreen(
                                                      screenType:
                                                          ScreenType.Catalog,
                                                      contentid:
                                                          table2.contentid,
                                                      objtypeId:
                                                          table2.objecttypeid,
                                                      detailsBloc:
                                                          detailsBloc,
                                                      table2: table2,
                                                      isShowShedule: true,
                                                      isFromReschedule: false,
                                                      //isFromMyLearning: true
                                                      // nativeModel:
                                                      //     widget.nativeMenuModel,
                                                    )))
                                        : catalogBloc.add(
                                            AddToMyLearningEvent(
                                                contentId: table2.contentid,
                                                table2: table2),
                                          );
                                  }
                                } else {
                                  flutterToast.showToast(
                                    child: CommonToast(
                                        displaymsg:
                                            'Not a member of ${table2.sitename}'),
                                    gravity: ToastGravity.BOTTOM,
                                    toastDuration: Duration(seconds: 2),
                                  );
                                  checkUserLogin(table2);
                                }
                              },
                            )
                      : Container(),
                  menu2
                      ? isConsolidated && table2.siteid != 374
                          ? Container()
                          : ListTile(
                              title: Text(
                                  appBloc.localstr.catalogActionsheetBuyoption,
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
                                _buyProduct(table2);
                              },
                            )
                      : Container(),
                  menu3
                      ? ListTile(
                          title: Text(
                              appBloc.localstr.catalogActionsheetDetailsoption,
                              style: TextStyle(
                                  color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                              ))),
                          leading: Icon(
                            IconDataSolid(int.parse('0xf570')),
                            color: InsColor(appBloc).appIconColor,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CommonDetailScreen(
                                  screenType: ScreenType.Catalog,
                                  contentid: table2.contentid,
                                  objtypeId: table2.objecttypeid,
                                  detailsBloc: detailsBloc,
                                  table2: table2,
                                  isShowShedule: true,
                                  isFromReschedule: false,
                                  //isFromMyLearning: true
                                  filterMenus: filterMenus,
                                )));

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ChangeNotifierProvider(
                            //         create: (context) => InAppPurchase(),
                            //         child: CatalogDetailScreen(
                            //           contentid: table2.contentid,
                            //           objtypeId: table2.objecttypeid,
                            //           detailsBloc: detailsBloc,
                            //           table2: table2,
                            //           nativeModel: widget.nativeMenuModel,
                            //         ))));
                          },
                        )
                      : Container(),
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
                                contentId: table2.contentid));
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
                                contentId: table2.contentid));
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
                              false, false, table2.name, table2.contentid)));
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
                          builder: (context) => ShareMainScreen(true, false,
                              false, table2.contentid, table2.name)));
                    },
                  ),
                  /*: Container()
                      : Container()*/
                  //sreekanth commented
                  // (table2?.ShareContentwithUser?.length ?? 0) > 0

                  // displaySendViaEmail(table2),
                ],
              ),
            ),
          );
        });
  }

  Widget displaySendViaEmail(DummyMyCatelogResponseTable2 table2) {
    // if ((table2?.ShareContentwithUser?.length ?? 0) > 0) {
    if (privilegeCreateForumIdExists()) {
      if (table2.isaddedtomylearning == 1) {
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

      // if (table2.objecttypeid == 14) {
      //   return new ListTile(
      //     leading: Icon(
      //       Icons.email,
      //       //IconDataSolid(int.parse('0xf06e')),
      //       color: InsColor(appBloc).appIconColor,
      //     ),
      //     title: new Text(
      //         appBloc.localstr.mylearningsendviaemailnewoption == null
      //             ? 'Send via Email'
      //             : appBloc.localstr.mylearningsendviaemailnewoption,
      //         style: TextStyle(
      //             color: Color(
      //               int.parse(
      //                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
      //             ))),
      //     onTap: () {
      //       Navigator.pop(context);
      //       Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => SendviaEmailMylearning(
      //             table2,
      //             true,
      //             myLearningBloc.list,
      //           )));
      //     },
      //   );
      // } else {
      //   return Container();
      // }
    } else {
      return Container();
    }

//    return Container();
  }

  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1349) {
        return true;
      }
    }
    return false;
  }

  bool isValidString(String val) {
//    print('validstrinh $val');
    if (val == null || val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> launchCoursePreview(
      DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    print("launchCoursePreview called}");
    print("Object Id:${table2.objecttypeid}");

    courseLaunchCatalog = GotoCourseLaunchCatalog(context, table2, false,
        appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
    String url = await courseLaunchCatalog!.getCourseUrl();
    if (url.isNotEmpty) {
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InAppWebCourseLaunch(url, table2)));
    }
  }

  Future<void> launchCourse(DummyMyCatelogResponseTable2 table2, BuildContext context, bool isContentisolation) async {
    print("launchCourse called with isContentisolation:$isContentisolation");
    print("Object Id:${table2.objecttypeid}");

    /// Need Some value

    /// content isolation only for 8,9,10,26,27
    if (!isContentisolation) {
      if ((table2.objecttypeid == 8 ||
          table2.objecttypeid == 9 ||
          (table2.objecttypeid == 10 && !table2.bit5) ||
          table2.objecttypeid == 26 ||
          table2.objecttypeid == 27)) {
        GotoCourseLaunchContentisolation courseLaunch =
            GotoCourseLaunchContentisolation(
                context, table2, appBloc.uiSettingModel, myLearningBloc.list);

        String courseUrl = await courseLaunch.getCourseUrl();

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

    if (table2.objecttypeid == 102) {
      executeXAPICourse(table2);
    }

    if (table2.objecttypeid == 10 && table2.bit5) {
      // Need to open EventTrackListTabsActivity

      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventTrackList(
                table2,
                true,
                [],
              )));

      getStatus(table2);
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
                if (value ?? true)
                  {
                    refresh()
                  }
              });

      String ss = "";
    }
    else {
      courseLaunch = GotoCourseLaunch(context, table2, false,
          appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
      String url = await courseLaunch!.getCourseUrl();

      if (url.isNotEmpty) {
        if (table2.objecttypeid == 26) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(url, table2)));
        }
        else {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(url, table2)));
        }
      }

      getStatus(table2);

//      detailsBloc.add(GetContentStatus(url: url));

    }

    //sreekanth commented
    //  Assignment content webview

    //sreekanth commented
  }

  Future<void> launchCourseContentisolation(DummyMyCatelogResponseTable2 table2, BuildContext context, String token) async {
    print('helllllllllloooooo');
    //Navigator.pop(context);
    if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 26) {
      String paramsString = "";
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = "userID=" +
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
            "&isonexist=onexit";
      } else {
        paramsString = "userID=" +
            table2.userid.toString() +
            "&scoid=" +
            table2.scoid.toString();
      }

      if (token.isNotEmpty) {
        String courseUrl;
        if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
          courseUrl = appBloc.uiSettingModel.azureRootPath +
              "content/index.html?coursetoken=" +
              token +
              "&TokenAPIURL=" +
              ApiEndpoints.appAuthURL;
        } else {
          courseUrl = ApiEndpoints.strSiteUrl +
              "content/index.html?coursetoken=" +
              token +
              "&TokenAPIURL=" +
              ApiEndpoints.appAuthURL;
        }

        if (table2.objecttypeid == 26) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(courseUrl, table2)));
        } else {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InAppWebCourseLaunch(courseUrl, table2)));
        }

        /// Refresh Content Of My Learning

      }

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url =
          webApiUrl + "/MobileLMS/MobileGetContentStatus?" + paramsString;

      detailsBloc.add(GetContentStatus(url: url, table2: table2));
    }
  }

  Future<void> executeXAPICourse(
      DummyMyCatelogResponseTable2 learningModel) async {
    var strUserID = await sharePrefGetString(sharedPref_userid);
    var strSiteID = await sharePrefGetString(sharedPref_siteid);
    var webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

    String paramsString = "strContentID=" +
        learningModel.contentid +
        "&UserID=" +
        strUserID +
        "&SiteID=" +
        strSiteID +
        "&SCOID=" +
        learningModel.scoid.toString() +
        "&CanTrack=true";

    String url = webApiUrl + "CourseTracking/TrackLRSStatement?" + paramsString;

    ApiResponse? apiResponse = await generalRepository?.executeXAPICourse(url);
  }

  void getStatus(DummyMyCatelogResponseTable2 table2) async {
    if (table2.objecttypeid == 8 ||
        table2.objecttypeid == 9 ||
        table2.objecttypeid == 10 ||
        table2.objecttypeid == 28 ||
        table2.objecttypeid == 102 ||
        table2.objecttypeid == 26) {
      String paramsString = "";
      if (table2.objecttypeid == 10 && table2.bit5) {
        paramsString = "userID=" +
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
            "&isonexist=onexit";
      } else {
        paramsString = "userID=" +
            table2.userid.toString() +
            "&scoid=" +
            table2.scoid.toString();
      }

      String webApiUrl = await sharePrefGetString(sharedPref_webApiUrl);

      String url = webApiUrl + "/MobileLMS/MobileGetContentStatus?" + paramsString;

      print('launchCourseUrl $url');

      detailsBloc.add(GetContentStatus(url: url));
    }
  }

  Widget floatActionUnicornDialer() {
    return UnicornDialer(
      parentButtonBackground: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.cloud),
      childButtons: _getWikiOption(),
      parentHeroTag: 'heroTag',
    );
  }

  List<UnicornButton> _getWikiOption() {
    List<UnicornButton> children = [];

    // Add Children here
    // children.add(_wikiOption(iconData: Icons.audiotrack, title: 'Audio'));
    // children.add(_wikiOption(iconData: Icons.image, title: 'Image'));
    // children
    //     .add(_wikiOption(iconData: Icons.video_call_rounded, title: 'Video'));
    // children.add(_wikiOption(iconData: Icons.file_copy, title: 'Document'));
    // children.add(_wikiOption(iconData: Icons.link, title: 'Url'));

    print(catalogBloc.fileUploadControlslist.length);

    catalogBloc.fileUploadControlslist.forEach((element) {
      if (element.status == true) {
        switch (element.mediaTypeID) {
          case 1: // image
            children.add(_wikiOption(
                iconData: Icons.image,
                title: element.mediaTypeIdisplayName,
                mediaTypeID: element.mediaTypeID));
            break;
          case 3: // video
            children.add(_wikiOption(
                iconData: Icons.video_call_rounded,
                title: element.mediaTypeIdisplayName,
                mediaTypeID: element.mediaTypeID));
            break;
          case 4: // Audio
            children.add(_wikiOption(
                iconData: Icons.audiotrack,
                title: element.mediaTypeIdisplayName,
                mediaTypeID: element.mediaTypeID));
            break;
          case 9: // pdf
            children.add(_wikiOption(
                iconData: Icons.file_copy,
                title: element.mediaTypeIdisplayName,
                mediaTypeID: element.mediaTypeID));
            break;
          case 13: //
            children.add(_wikiOption(
                iconData: Icons.link,
                title: element.mediaTypeIdisplayName,
                mediaTypeID: element.mediaTypeID));
            break;
        }
      }
    });

    return children;
  }

  UnicornButton _wikiOption(
      {required IconData iconData,
      Function? onPressed,
      required String title,
      required int mediaTypeID}) {
    return UnicornButton(
        labelText: title,
        hasLabel: true,
        labelColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        currentButton: FloatingActionButton(
          heroTag: title,
          foregroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
          mini: true,
          child: Icon(iconData),
          onPressed: () {
            switch (mediaTypeID) {
              case 1:
                clickOnUploadAction('fabImage');
                break;
              case 3:
                clickOnUploadAction('fabVideo');
                break;
              case 4:
                clickOnUploadAction('fabAudio');
                break;
              case 9:
                clickOnUploadAction('fabDocument');
                break;
              case 13:
                clickOnUploadAction('fabWebsiteURL');
                break;
            }
            print('clicked unidialer $title');
          },
        ));
  }

  void clickOnUploadAction(String id) {
    switch (id) {
      case 'fabVideo':
        wikiFileUploadButtonClicked(
            "ContentTypeID/11/MediaTypeID/3", FileType.video, 'Video');
        break;
      case 'fabAudio':
        wikiFileUploadButtonClicked(
            "ContentTypeID/11/MediaTypeID/4", FileType.audio, 'Audio');
        break;
      case 'fabDocument':
        wikiFileUploadButtonClicked("ContentTypeID/14", FileType.custom, 'Document');
        break;
      case 'fabImage':
        wikiFileUploadButtonClicked(
            "ContentTypeID/11/MediaTypeID/1", FileType.image, 'Image');
        break;
      case 'fabWebsiteURL':
        wikiFileUploadButtonClicked(
            "ContentTypeID/11/MediaTypeID/1", FileType.any, 'Url');
        break;
    }
  }

  wikiFileUploadButtonClicked(
      String contentMediaTypeID, FileType typeFile, String titleString) async {
    bool? refreshCatalog = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WikiUploadScreen(titleString, typeFile)));

    if (refreshCatalog ?? true) {
      refresh();
    }
  }

  Map<String, String> getConditionsValue(String strConditions) {
    Map<String, String> filterMenus = {};

    if (strConditions != null && strConditions != "") {
      if (strConditions.contains("#@#")) {
        var conditionsArray = strConditions.split("#@#");
        int conditionCount = conditionsArray.length;
        if (conditionCount > 0) {
          filterMenus = generateHashMap(conditionsArray);
        }
      }
    }

    return filterMenus;
  }

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = Map();
    if (conditionsArray.length != 0) {
      for (int i = 0; i < conditionsArray.length; i++) {
        var filterArray = conditionsArray[i].split("=");
        print(" forvalue   $filterArray");
        if (filterArray.length > 1) {
          map[filterArray[0]] = filterArray[1];
        }
      }
    } else {}
    return map;
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

  checkSubsiteLogding(String response, DummyMyCatelogResponseTable2 table2) {
    SubsiteLoginResponse subsiteLoginResponse =
        SubsiteLoginResponse(successFullUserLogin: [], failedUserLogin: []);
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
                toastDuration: Duration(seconds: 4),
              )
            : flutterToast.showToast(
                child: CommonToast(displaymsg: 'Pending Registration'),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 4),
              );
      } else if (userloginAry.containsKey("successfulluserlogin")) {
        subsiteLoginResponse = subsiteLoginResponse =
            loginSuccessResponseFromJson(response.toString());

        flutterToast.showToast(
          child: CommonToast(displaymsg: succesMessage),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 4),
        );
        table2.userid =
            '${subsiteLoginResponse.successFullUserLogin[0].userid}';
        // catalogBloc.add(
        //     AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    } catch (e) {
      print(e);
    }
  }

  showAlertDialog(
    BuildContext context,
    String preqContnetTitle,
    String preqContentNames,
    CatalogDetailsResponse response,
  ) {
    // Create button
    Widget viewPreButton = Container(
      //width: 140,
      child: MaterialButton(
        onPressed: () => {
          Navigator.of(context).pop(),
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => PrerequisiteScreen(
                      catalogBloc.prequisitePopupresponse,
                      widget.nativeMenuModel,
                      response)))
              .then((value) => {
                    if (value ?? false)
                      {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => ActBase(selectedMenu: "1",)),
                            (_) => false,
                        ),
                        /*
                        refresh()
                        */
                      }
                  }),
        },
        //minWidth: MediaQuery.of(context).size.width,
        disabledColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        child: Text(
          'View Prerequisites',
          style: TextStyle(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
              fontSize: 14.0),
        ),
        textColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
      ),
    );

    Widget cancelButton = Container(
      width: 100,
      child: MaterialButton(
        onPressed: () => {Navigator.of(context).pop()},
        minWidth: MediaQuery.of(context).size.width,
        disabledColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
            .withOpacity(0.5),
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cancel',
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                  fontSize: 14.0),
            ),
          ],
        ),
        textColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
      ),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
      title: Text(
        "Pre-requisite Sequence",
        style: TextStyle(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //position
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "The selected content item has the following pre-requisite content items:",
            style: TextStyle(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
          ),
          Text(
            "\n $preqContentTitle",
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
          ),
          Text(
            "$preqContentNames",
            style: TextStyle(
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
          ),
        ],
      ),
      actions: [
        viewPreButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void getDetailsApiCall(String contentid) {
    MyLearningDetailsRequest detailsRequest = MyLearningDetailsRequest();
    detailsRequest.locale = 'en-us';
    detailsRequest.contentId = contentid;
    detailsRequest.metadata = '1';
    detailsRequest.intUserId = catalogBloc.strUserID;
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

    catalogBloc
        .add(GetCatalogDetails(myLearningDetailsRequest: detailsRequest));

    print("om--------${detailsRequest.toString()}");
  }

  Future<void> refresh({String? sortBy, int? pageIndex, int? categoryId, String? serachString}) async {
    await sharePrefSaveString(sharedPref_ComponentID, widget.nativeMenuModel.componentId);
    await sharePrefSaveString(sharedPref_RepositoryId, widget.nativeMenuModel.repositoryId);

    catalogBloc.add(GetCategoryWisecatalogEvent(
      sortBy: sortBy ?? ddlSortList,
      pageIndex: pageIndex ?? pageNumber,
      categaoryID: categoryId ?? widget.categaoryID,
      serachString: serachString ?? catalogBloc.searchCatalogString,
      myLearningBloc: myLearningBloc,
    ));
  }
}
