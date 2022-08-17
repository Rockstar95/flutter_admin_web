import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
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
import 'package:flutter_admin_web/framework/bloc/profile/bloc/profile_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/profile/events/profile_event.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/general/contract/general_repository.dart';
import 'package:flutter_admin_web/framework/repository/general/provider/general_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/model/mylearning_details_request.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/profile/provider/profile_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/Catalog/gotoCoursePreview.dart';
import 'package:flutter_admin_web/ui/Catalog/prepreprerequisite_screen.dart';
import 'package:flutter_admin_web/ui/Catalog/wish_list.dart';
import 'package:flutter_admin_web/ui/MyLearning/Assignmentcontentweb.dart';
import 'package:flutter_admin_web/ui/MyLearning/SendviaEmailMylearning.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/advanced_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/inapp_webcourse_launch.dart';
import 'package:flutter_admin_web/ui/MyLearning/mylearning_filter.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/bottomsheet_drager.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../common/common_primary_secondary_button.dart';
import '../global_search_screen.dart';

// const bool _kAutoConsume = true;
//
// const String _kConsumableId = 'consumable';
// const List<String> _kProductIds = <String>[
//   'com.instancy.trainingcompany_product01',
//   'com.instancy.flutterinapptesting',
// ];

class CatalogSubScreen extends StatefulWidget {
  final int categaoryID;
  final String categaoryName;
  final NativeMenuModel nativeMenuModel;
  final String contentId;

  const CatalogSubScreen({
    this.categaoryID = 0,
    this.categaoryName = "",
    required this.nativeMenuModel,
    this.contentId = "",
  });

  @override
  State<CatalogSubScreen> createState() => _CatalogSubScreenState();
}

class _CatalogSubScreenState extends State<CatalogSubScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  ScrollController _sc = ScrollController();
  ItemScrollController _scrollController = ItemScrollController();

  int selectedIndexOfAddedMyLearning = 0;

  bool addToMyLearn = false;
  String componentId = "";

  late MyLearningDetailsBloc detailsBloc;

  int pageNumber = 0;
  bool isGetCatalogListEvent = false;
  String preqContentNames = "";
  String preqContentTitle = "";
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

  GotoCourseLaunch? courseLaunch;
  GotoCourseLaunchCatalog? courseLaunchCatalog;

  late GeneralRepository generalRepository;
  DummyMyCatelogResponseTable2 dummyMyCatelogResponseTable2 = DummyMyCatelogResponseTable2();
  late ProfileBloc profileBloc;

  String assignmenturl = "";

  bool isLoading = false;

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

  Future<String> getCurrentDateTimeInStr() async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
    String formatted = formatter.format(now);

    return formatted;
  }

  getComponentId() async{
    componentId = await sharePrefGetString(sharedPref_ComponentID);
  }

  void addToLearningOnClick(DummyMyCatelogResponseTable2 table2,int i){
    if (table2.userid != null && table2.userid != "-1") {
      // Navigator.pop(context);
      if (table2.isaddedtomylearning == 2) {
        catalogBloc.add(
          GetPrequisiteDetailsEvent(
              contentId: table2.contentid,
              userID: table2.userid),
        );
      } else {
        setState(() {
          selectedIndexOfAddedMyLearning = i;
        });
        (table2.objecttypeid == 70 &&
            table2.eventscheduletype == 1) ||
            (table2.objecttypeid == 70 &&
                table2.eventscheduletype == 2)
            ? Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (context) =>
                CommonDetailScreen(
                  screenType:
                  ScreenType.Catalog,
                  contentid: table2.contentid,
                  objtypeId:
                  table2.objecttypeid,
                  detailsBloc: detailsBloc,
                  table2: table2,
                  // nativeModel:
                  //     widget.nativeMenuModel,
                  isFromReschedule: false,
                  //isFromMyLearning:
                  //  false, //need implement reschedule
                )))
            .then((value) => {
          if (value) {refresh()}
        })
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
    if (isValidString(
        table2.viewprerequisitecontentstatus ?? "")) {
      print('ifdataaaaa');
      // Navigator.of(context).pop();
      String alertMessage = appBloc
          .localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage +
          "  \"" +
          appBloc
              .localstr.prerequisLabelContenttypelabel +
          "\" " +
          appBloc.localstr
              .prerequistesalerttitle5Alerttitle7;

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
                    table2
                        .viewprerequisitecontentstatus
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
      if (table2.isaddedtomylearning == 1) {
        launchCourse(table2, context);
      } else {
        launchCoursePreview(table2, context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    appBloc.add(WishlistCountEvent());
    getComponentId();
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
          moduleName: widget.nativeMenuModel.displayname));
      myLearningBloc.add(GetSortMenus("1"));
    }

    profileBloc =
        ProfileBloc(profileRepository: ProfileRepositoryBuilder.repository());
    profileBloc.add(GetProfileInfo());
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
          catalogBloc.add(GetCategoryWisecatalogEvent(
              pageIndex: pageNumber,
              categaoryID: widget.categaoryID,
              serachString: "",
              myLearningBloc: myLearningBloc));
        }
      }
    });
    print("Selected Sort ${myLearningBloc.selectedSort}");
    catalogBloc.isFirstLoadingCatalog = true;
    catalogBloc.isCatalogSearch = false;
    catalogBloc.searchCatalogString = "";
    refresh();

    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());

    if (widget.contentId != '') {
      catalogBloc.notificationCatalogCatgorylist.clear();
      catalogBloc.catalogCatgorylist.forEach((element) {
        if (element.objectid.toString() == widget.contentId) {
          catalogBloc.notificationCatalogCatgorylist.add(element);
        }
      });
    }

    /// commented for inapp Purchase
    // initStoreInfo();

    // provider = Provider.of<ProviderModel>(context, listen: false);
    // provider.initialize();

    if (widget.contentId != null) {
      print("Catalog Category List:${catalogBloc.catalogCatgorylist.length}");
      /*catalogBloc.catalogCatgorylist.forEach((element) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => ProviderModel(),
                  child: CommonDetailScreen(
                    screenType: ScreenType.Catalog,
                    contentid: widget.contentId,
                    objtypeId: element.objecttypeid,
                    detailsBloc: detailsBloc,
                    table2: element,
                    isFromReschedule: false,
                  ),
                )));
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    print("widget.categaoryID:${widget.categaoryID}");
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
          child: Scaffold(
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
                widget.categaoryName,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
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
                                categaoryID: 0,
                                categaoryName: widget.categaoryName,
                                detailsBloc: detailsBloc,
                                filterMenus: {},
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
                          appBloc.wishlistResponse != null
                              ? appBloc.wishlistcount
                              : '',
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

                //
                // InkWell(
                //     onTap: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => ChangeNotifierProvider(
                //                 create: (context) => ProviderModel(),
                //                 child: WishList(
                //                   categaoryID: widget.categaoryID,
                //                   categaoryName: widget.categaoryName,
                //                   detailsBloc: detailsBloc,
                //                 ),
                //               )));
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: Icon(Icons.favorite,
                //           color: Color(
                //             int.parse(
                //                 "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                //           )),
                //     ))
                //
              ],
              elevation: 0,
              leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                  )),
            ),
            body: Container(
              color: AppColors.getAppBGColor(),
              // color: Colors.green,
              child: BlocConsumer<CatalogBloc, CatalogState>(
                bloc: catalogBloc,
                listener: (context, state) {
                  if (state is GetCategoryWisecatalogState) {
                    if (state.status == Status.COMPLETED) {
//            print("List size ${state.list.length}");

                      setState(() {
                        isGetCatalogListEvent = true;
                        pageNumber++;
                      });
//sreekanth
                      if (addToMyLearn) {
                        Timer(Duration(seconds: 1), () {
                          _scrollController.scrollTo(
                              index: selectedIndexOfAddedMyLearning,
                              duration: Duration(seconds: 1));
                        });
                      }
                      appBloc.add(WishlistCountEvent());

                      //sreekanth - add to my learn scroll issue

                    } else if (state.status == Status.ERROR) {
//                print("listner Error ${state.message}");
                      if (state.message == "401") {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  }

                  if (state is GetPrequisiteDetailsState) {
                    if (state.status == Status.COMPLETED) {
                      print(
                          "prequisitePopupresponse size ${state.prequisitePopupresponse.prerequisteData.table.length}");
                      if (state.prequisitePopupresponse != null &&
                          state.prequisitePopupresponse.prerequisteData.table
                                  .length >
                              0) {
                        preqContentNames = "";
                        preqContentTitle = "";

                        state.prequisitePopupresponse.prerequisteData.table1
                            .forEach((element) {
                          preqContentTitle = element.pathName;
                        });
                        state.prequisitePopupresponse.prerequisteData.table
                            .forEach((element) async {
                          // print("displayname ${element.name}");
                          // print("parameterString ${element.name}");

                          preqContentNames = preqContentNames + "\n" + element.name;
                        });
                        /* state.prequisitePopupresponse.prerequisteData.table
                            .forEach((element) async {
                          print("displayname ${element.name}");
                          print("parameterString ${element.name}");
                          preqContentNames =
                              preqContentNames + "\n" + element.name;
                        });*/
                        getDetailsApiCall(state.contentId);
                      } else {
                        print("size ${dummyMyCatelogResponseTable2.sitename}");
                        catalogBloc.add(
                          AddToMyLearningEvent(
                              contentId: dummyMyCatelogResponseTable2.contentid,
                              table2: dummyMyCatelogResponseTable2),
                        );
                      }
                    } else if (state.status == Status.ERROR) {
                      if (state.message == "401") {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  }
                  if (state is GetCatalogDetailsState) {
                    if (state.status == Status.COMPLETED) {
                      if (catalogBloc.catalogRes != null) {
                        showAlertDialog(
                            context, preqContentNames, catalogBloc.catalogRes);
                      }
                    }
                  }

                  if (state is SaveInAppPurchaseState) {
                    if (state.status == Status.COMPLETED) {
                      if (isValidString(state.response) && state.response.contains('success')) {
                        addToMyLearn = true;
                        MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

                        catalogBloc.add(GetCategoryWisecatalogEvent(
                            pageIndex: pageNumber,
                            categaoryID:
                                widget.categaoryID == 0 ? 0 : widget.categaoryID,
                            serachString: "",
                            myLearningBloc: myLearningBloc));
                      }
                      else {}
                    }
                    else if (state.status == Status.ERROR) {
                      if (state.message == "401") {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  }

                  if (state is AddToWishListState ||
                      state is RemoveFromWishListState ||
                      state is AddToMyLearningState) {
                    if (state.status == Status.COMPLETED) {
                      catalogBloc.isFirstLoadingCatalog = true;
                      catalogBloc.add(GetCategoryWisecatalogEvent(
                          pageIndex: pageNumber,
                          categaoryID: widget.categaoryID,
                          serachString: catalogBloc.searchCatalogString,
                          myLearningBloc: myLearningBloc));
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
                          color: Colors.grey,
                          size: 70.h,
                        ),
                      ),
                    );
                  }
                  else if (state.status == Status.COMPLETED) {
                    return catalogBloc.catalogCatgorylist.length == 0
                        ? Column(
                            children: <Widget>[
                              getBreadcrumbWidget(),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InsSearchTextField(
                                    onTapAction: () {
                                      if (appBloc.uiSettingModel.isGlobalSearch ==
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
                                              catalogBloc.isFirstLoadingCatalog =
                                                  true;
                                              catalogBloc.isCatalogSearch = false;
                                              catalogBloc.searchCatalogString = "";
                                              setState(() {
                                                pageNumber = 1;
                                              });
                                              catalogBloc.add(
                                                  GetCategoryWisecatalogEvent(
                                                      pageIndex: pageNumber,
                                                      categaoryID:
                                                          widget.categaoryID,
                                                      serachString: "",
                                                      myLearningBloc:
                                                          myLearningBloc));
                                            },
                                            icon: Icon(
                                              Icons.close,
                                            ),
                                          )
                                        : (myLearningBloc.isFilterMenu)
                                            ? IconButton(
                                                onPressed: () async {
                                                  await Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyLearningFilter(componentId: componentId,)));

                                                  catalogBloc
                                                      .isFirstLoadingCatalog = true;
                                                  catalogBloc.add(
                                                      GetCategoryWisecatalogEvent(
                                                          pageIndex: pageNumber,
                                                          categaoryID:
                                                              widget.categaoryID,
                                                          serachString: "",
                                                          myLearningBloc:
                                                              myLearningBloc));
                                                },
                                                icon: Icon(Icons.tune,
                                                    color: AppColors.getFilterIconColor()),
                                              )
                                            : null,
                                    onSubmitAction: (value) {
                                      if (value.toString().length > 0) {
                                        catalogBloc.isFirstLoadingCatalog = true;
                                        catalogBloc.isCatalogSearch = true;
                                        catalogBloc.searchCatalogString =
                                            value.toString();
                                        setState(() {
                                          pageNumber = 1;
                                        });
                                        catalogBloc.add(GetCategoryWisecatalogEvent(
                                            pageIndex: pageNumber,
                                            categaoryID: widget.categaoryID,
                                            serachString: value.toString(),
                                            myLearningBloc: myLearningBloc));
                                      }
                                    },
                                  )

                                  // TextField(
                                  //   onTap: () {
                                  //     if (appBloc.uiSettingModel.IsGlobasearch ==
                                  //         'true') {
                                  //       _navigateToGlobalSearchScreen(context);
                                  //     }
                                  //   },
                                  //   controller: _controller,
                                  //   cursorColor: Color(int.parse(
                                  //       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                  //   style: TextStyle(
                                  //       fontSize: ScreenUtil().setSp(14),
                                  //       color: Colors.black),
                                  //   decoration: new InputDecoration(
                                  //     focusedBorder: new OutlineInputBorder(
                                  //         borderSide:
                                  //             new BorderSide(color: Colors.grey)),
                                  //     enabledBorder: new OutlineInputBorder(
                                  //         borderSide:
                                  //             new BorderSide(color: Colors.grey)),
                                  //     hintText: appBloc
                                  //         .localstr.commoncomponentLabelSearchlabel,
                                  //     suffixIcon: catalogBloc.isCatalogSearch
                                  //         ? IconButton(
                                  //             onPressed: () {
                                  //               //search logic
                                  //               catalogBloc.isFirstLoadingCatalog =
                                  //                   true;
                                  //               catalogBloc.isCatalogSearch = false;
                                  //               catalogBloc.searchCatalogString =
                                  //                   "";
                                  //               setState(() {
                                  //                 pageNumber = 1;
                                  //               });
                                  //               catalogBloc.add(
                                  //                   GetCategoryWisecatalogEvent(
                                  //                       pageIndex: pageNumber,
                                  //                       categaoryID:
                                  //                           widget.categaoryID,
                                  //                       serachString: "",
                                  //                       myLearningBloc:
                                  //                           myLearningBloc));
                                  //             },
                                  //             icon: Icon(
                                  //               Icons.close,
                                  //             ),
                                  //           )
                                  //         : (myLearningBloc.isFilterMenu)
                                  //             ? IconButton(
                                  //                 onPressed: () async {
                                  //                   await Navigator.of(context)
                                  //                       .push(MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               MyLearningFilter()));
                                  //
                                  //                   catalogBloc
                                  //                           .isFirstLoadingCatalog =
                                  //                       true;
                                  //                   catalogBloc.add(
                                  //                       GetCategoryWisecatalogEvent(
                                  //                           pageIndex: pageNumber,
                                  //                           categaoryID:
                                  //                               widget.categaoryID,
                                  //                           serachString: "",
                                  //                           myLearningBloc:
                                  //                               myLearningBloc));
                                  //                 },
                                  //                 icon: Icon(
                                  //                   Icons.tune,color: Color(
                                  //                   int.parse(
                                  //                       "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  //                 )
                                  //                 ),
                                  //               )
                                  //             : null,
                                  //   ),
                                  //   onSubmitted: (value) {
                                  //     // search logic
                                  //     if (value.toString().length > 0) {
                                  //       catalogBloc.isFirstLoadingCatalog = true;
                                  //       catalogBloc.isCatalogSearch = true;
                                  //       catalogBloc.searchCatalogString =
                                  //           value.toString();
                                  //       setState(() {
                                  //         pageNumber = 1;
                                  //       });
                                  //       catalogBloc.add(GetCategoryWisecatalogEvent(
                                  //           pageIndex: pageNumber,
                                  //           categaoryID: widget.categaoryID,
                                  //           serachString: value.toString(),
                                  //           myLearningBloc: myLearningBloc));
                                  //     }
                                  //   },
                                  // ),
                                  ),
                              Container(
                                child: Center(
                                  child: Text(
                                      appBloc
                                          .localstr.commoncomponentLabelNodatalabel,
                                      style: TextStyle(
                                          color: AppColors.getAppTextColor(),
                                          fontSize: 24)),
                                ),
                              ),
                            ],
                          )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getBreadcrumbWidget(),
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InsSearchTextField(
                                    onTapAction: () {
                                      if (appBloc.uiSettingModel.isGlobalSearch ==
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
                                              catalogBloc.isFirstLoadingCatalog =
                                                  true;
                                              catalogBloc.isCatalogSearch = false;
                                              catalogBloc.searchCatalogString = "";
                                              setState(() {
                                                pageNumber = 1;
                                              });
                                              catalogBloc.add(
                                                  GetCategoryWisecatalogEvent(
                                                      pageIndex: pageNumber,
                                                      categaoryID:
                                                          widget.categaoryID,
                                                      serachString: "",
                                                      myLearningBloc:
                                                          myLearningBloc));
                                            },
                                            icon: Icon(
                                              Icons.close,
                                            ),
                                          )
                                        : (myLearningBloc.isFilterMenu)
                                            ? IconButton(
                                                onPressed: () async {
                                                  await Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyLearningFilter(componentId: componentId,)));

                                                  catalogBloc
                                                      .isFirstLoadingCatalog = true;
                                                  catalogBloc.add(
                                                      GetCategoryWisecatalogEvent(
                                                          pageIndex: pageNumber,
                                                          categaoryID:
                                                              widget.categaoryID,
                                                          serachString: "",
                                                          myLearningBloc:
                                                              myLearningBloc));
                                                },
                                                icon: Icon(Icons.tune,
                                                    color: AppColors.getFilterIconColor()),
                                              )
                                            : null,
                                    onSubmitAction: (value) {
                                      if (value.toString().length > 0) {
                                        catalogBloc.isFirstLoadingCatalog = true;
                                        catalogBloc.isCatalogSearch = true;
                                        catalogBloc.searchCatalogString =
                                            value.toString();
                                        setState(() {
                                          pageNumber = 1;
                                        });
                                        catalogBloc.add(GetCategoryWisecatalogEvent(
                                            pageIndex: pageNumber,
                                            categaoryID: widget.categaoryID,
                                            serachString: value.toString(),
                                            myLearningBloc: myLearningBloc));
                                      }
                                    },
                                  )
                                  // TextField(
                                  //   onTap: () {
                                  //     if (appBloc.uiSettingModel.IsGlobasearch ==
                                  //         'true') {
                                  //       _navigateToGlobalSearchScreen(context);
                                  //     }
                                  //   },
                                  //   controller: _controller,
                                  //   cursorColor: Color(int.parse(
                                  //       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                  //   style: TextStyle(
                                  //       fontSize: ScreenUtil().setSp(14),
                                  //       color: Colors.black),
                                  //   decoration: new InputDecoration(
                                  //     focusedBorder: new OutlineInputBorder(
                                  //         borderSide:
                                  //             new BorderSide(color: Colors.grey)),
                                  //     enabledBorder: new OutlineInputBorder(
                                  //         borderSide:
                                  //             new BorderSide(color: Colors.grey)),
                                  //     hintText: appBloc.localstr
                                  //         .commoncomponentLabelSearchlabel,
                                  //     suffixIcon: catalogBloc.isCatalogSearch
                                  //         ? IconButton(
                                  //             onPressed: () {
                                  //               //search logic
                                  //               catalogBloc
                                  //                   .isFirstLoadingCatalog = true;
                                  //               catalogBloc.isCatalogSearch =
                                  //                   false;
                                  //               catalogBloc.searchCatalogString =
                                  //                   "";
                                  //               setState(() {
                                  //                 pageNumber = 1;
                                  //               });
                                  //               catalogBloc.add(
                                  //                   GetCategoryWisecatalogEvent(
                                  //                       pageIndex: pageNumber,
                                  //                       categaoryID:
                                  //                           widget.categaoryID,
                                  //                       serachString: "",
                                  //                       myLearningBloc:
                                  //                           myLearningBloc));
                                  //             },
                                  //             icon: Icon(
                                  //               Icons.close,
                                  //             ),
                                  //           )
                                  //         : (myLearningBloc.isFilterMenu)
                                  //             ? IconButton(
                                  //                 onPressed: () async {
                                  //                   await Navigator.of(context)
                                  //                       .push(MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               MyLearningFilter()));
                                  //
                                  //                   catalogBloc
                                  //                           .isFirstLoadingCatalog =
                                  //                       true;
                                  //                   catalogBloc.add(
                                  //                       GetCategoryWisecatalogEvent(
                                  //                           pageIndex: pageNumber,
                                  //                           categaoryID: widget
                                  //                               .categaoryID,
                                  //                           serachString: "",
                                  //                           myLearningBloc:
                                  //                               myLearningBloc));
                                  //                 },
                                  //                 icon: Icon(Icons.tune,
                                  //                     color: Color(
                                  //                       int.parse(
                                  //                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  //                     )),
                                  //               )
                                  //             : null,
                                  //   ),
                                  //   onSubmitted: (value) {
                                  //     // search logic
                                  //     if (value.toString().length > 0) {
                                  //       catalogBloc.isFirstLoadingCatalog = true;
                                  //       catalogBloc.isCatalogSearch = true;
                                  //       catalogBloc.searchCatalogString =
                                  //           value.toString();
                                  //       setState(() {
                                  //         pageNumber = 1;
                                  //       });
                                  //       catalogBloc.add(
                                  //           GetCategoryWisecatalogEvent(
                                  //               pageIndex: pageNumber,
                                  //               categaoryID: widget.categaoryID,
                                  //               serachString: value.toString(),
                                  //               myLearningBloc: myLearningBloc));
                                  //     }
                                  //   },
                                  // ),
                                  ),
                              Expanded(
                                flex: 9,
                                child: ResponsiveWidget(
                                  mobile: ScrollablePositionedList.builder(
                                    //shrinkWrap: true,
                                    itemScrollController: _scrollController,
                                    itemCount:
                                        catalogBloc.catalogCatgorylist.length,
                                    itemBuilder: (context, i) {
                                      if (catalogBloc.catalogCatgorylist.length ==
                                          0) {
                                        if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                          return _buildProgressIndicator();
                                        } else {
                                          return Container();
                                        }
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
                                    //controller: _sc,
                                  ),
                                  tab: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width / 840,
                                      ),
                                      itemCount:
                                          catalogBloc.catalogCatgorylist.length,
                                      itemBuilder: (context, i) {
                                        if (catalogBloc.catalogCatgorylist.length ==
                                            0) {
                                          if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                            return _buildProgressIndicator();
                                          } else {
                                            return Container();
                                          }
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
                                      }),
                                  web: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 0.65,
                                      ),
                                      itemCount:
                                      catalogBloc.catalogCatgorylist.length,
                                      itemBuilder: (context, i) {
                                        if (catalogBloc.catalogCatgorylist.length ==
                                            0) {
                                          if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                            return _buildProgressIndicator();
                                          } else {
                                            return Container();
                                          }
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
                                      }),
                                ),
                              ),
                            ],
                          );
                  }
                  else {
                    return noDataFound(true);
                  }
                },
              ),
            ),
          ),
        ),
      );
    }
    else {
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
          child: Scaffold(
            backgroundColor: AppColors.getAppBGColor(),
            body: Container(
              color: AppColors.getAppBGColor(),
              child: BlocConsumer<CatalogBloc, CatalogState>(
                bloc: catalogBloc,
                listener: (context, state) {
                  if (state is GetCategoryWisecatalogState) {
                    if (state.status == Status.COMPLETED) {
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
                    } else if (state.status == Status.ERROR) {
//                print("listner Error ${state.message}");
                      if (state.message == "401") {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  }
                  if (state is GetPrequisiteDetailsState) {
                    if (state.status == Status.COMPLETED) {
                      print(
                          "prequisitePopupresponse size ${state.prequisitePopupresponse.prerequisteData.table.length}");
                      preqContentNames = "";
                      preqContentTitle = "";
                      if (state.prequisitePopupresponse != null &&
                          state.prequisitePopupresponse.prerequisteData.table
                                  .length >
                              0) {
                        state.prequisitePopupresponse.prerequisteData.table
                            .forEach((element) async {
                          print("displayname ${element.name}");
                          print("parameterString ${element.name}");
                          preqContentNames = preqContentNames + "\n" + element.name;
                        });
                        getDetailsApiCall(state.contentId);
                      } else {
                        catalogBloc.add(
                          AddToMyLearningEvent(
                              contentId: state.prequisitePopupresponse
                                  .prerequisteData.table[0].contentID,
                              table2: dummyMyCatelogResponseTable2),
                        );
                      }
                    } else if (state.status == Status.ERROR) {
                      if (state.message == "401") {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  }

                  if (state is SaveInAppPurchaseState) {
                    if (state.status == Status.COMPLETED) {
                      if (isValidString(state.response) && state.response.contains('success')) {
                        addToMyLearn = true;
                        MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

                        catalogBloc.add(GetCategoryWisecatalogEvent(
                            sortBy: "",
                            pageIndex: pageNumber,
                            categaoryID:
                                widget.categaoryID == 0 ? 0 : widget.categaoryID,
                            serachString: "",
                            myLearningBloc: myLearningBloc));
                      }
                      else {}
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
                        showAlertDialog(
                            context, preqContentNames, catalogBloc.catalogRes);
                      }
                    }
                  }

                  if (state is AddToWishListState ||
                      state is RemoveFromWishListState ||
                      state is AddToMyLearningState) {
                    if (state.status == Status.COMPLETED) {
                      catalogBloc.isFirstLoadingCatalog = true;
                      catalogBloc.add(GetCategoryWisecatalogEvent(
                          pageIndex: pageNumber,
                          categaoryID: widget.categaoryID,
                          serachString: "",
                          myLearningBloc: myLearningBloc));
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

                        // _scrollController.jumpTo(
                        //     index: selectedIndexOfAddedMyLearning);
                        //
                        // Timer(Duration(seconds: 2), () {
                        //   _scrollController.scrollTo(
                        //       index: selectedIndexOfAddedMyLearning,
                        //       duration: Duration(seconds: 1));
                        // });
                        //

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
                          color: Colors.grey,
                          size: 70.h,
                        ),
                      ),
                    );
                  }
                  else if (state.status == Status.COMPLETED) {
                    return catalogBloc.catalogCatgorylist.length == 0
                        ? Column(
                            children: <Widget>[
                              getBreadcrumbWidget(),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InsSearchTextField(
                                    onTapAction: () {
                                      if (appBloc.uiSettingModel.isGlobalSearch ==
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
                                              catalogBloc.isFirstLoadingCatalog =
                                                  true;
                                              catalogBloc.isCatalogSearch = false;
                                              catalogBloc.searchCatalogString = "";
                                              setState(() {
                                                pageNumber = 1;
                                              });
                                              catalogBloc.add(
                                                  GetCategoryWisecatalogEvent(
                                                      pageIndex: pageNumber,
                                                      categaoryID:
                                                          widget.categaoryID,
                                                      serachString: "",
                                                      myLearningBloc:
                                                          myLearningBloc));
                                            },
                                            icon: Icon(
                                              Icons.close,
                                            ),
                                          )
                                        : (myLearningBloc.isFilterMenu)
                                            ? IconButton(
                                                onPressed: () async {
                                                  await Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyLearningFilter(componentId: componentId,)));

                                                  catalogBloc
                                                      .isFirstLoadingCatalog = true;
                                                  catalogBloc.add(
                                                      GetCategoryWisecatalogEvent(
                                                          pageIndex: pageNumber,
                                                          categaoryID:
                                                              widget.categaoryID,
                                                          serachString: "",
                                                          myLearningBloc:
                                                              myLearningBloc));
                                                },
                                                icon: Icon(Icons.tune,
                                                    color: AppColors.getFilterIconColor()),
                                              )
                                            : null,
                                    onSubmitAction: (value) {
                                      if (value.toString().length > 0) {
                                        catalogBloc.isFirstLoadingCatalog = true;
                                        catalogBloc.isCatalogSearch = true;
                                        catalogBloc.searchCatalogString =
                                            value.toString();
                                        setState(() {
                                          pageNumber = 1;
                                        });
                                        catalogBloc.add(GetCategoryWisecatalogEvent(
                                            pageIndex: pageNumber,
                                            categaoryID: widget.categaoryID,
                                            serachString: value.toString(),
                                            myLearningBloc: myLearningBloc));
                                      }
                                    },
                                  )
                                  // TextField(
                                  //   onTap: () {
                                  //     if (appBloc.uiSettingModel.IsGlobasearch ==
                                  //         'true') {
                                  //       _navigateToGlobalSearchScreen(context);
                                  //     }
                                  //   },
                                  //   controller: _controller,
                                  //   cursorColor: Color(int.parse(
                                  //       "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                  //   style: TextStyle(
                                  //       fontSize: ScreenUtil().setSp(14),
                                  //       color: Colors.black),
                                  //   decoration: new InputDecoration(
                                  //     focusedBorder: new OutlineInputBorder(
                                  //         borderSide:
                                  //             new BorderSide(color: Colors.grey)),
                                  //     enabledBorder: new OutlineInputBorder(
                                  //         borderSide:
                                  //             new BorderSide(color: Colors.grey)),
                                  //     hintText: appBloc
                                  //         .localstr.commoncomponentLabelSearchlabel,
                                  //     suffixIcon: catalogBloc.isCatalogSearch
                                  //         ? IconButton(
                                  //             onPressed: () {
                                  //               //search logic
                                  //               catalogBloc.isFirstLoadingCatalog =
                                  //                   true;
                                  //               catalogBloc.isCatalogSearch = false;
                                  //               catalogBloc.searchCatalogString =
                                  //                   "";
                                  //               setState(() {
                                  //                 pageNumber = 1;
                                  //               });
                                  //               catalogBloc.add(
                                  //                   GetCategoryWisecatalogEvent(
                                  //                       pageIndex: pageNumber,
                                  //                       categaoryID:
                                  //                           widget.categaoryID,
                                  //                       serachString: "",
                                  //                       myLearningBloc:
                                  //                           myLearningBloc));
                                  //             },
                                  //             icon: Icon(
                                  //               Icons.close,
                                  //             ),
                                  //           )
                                  //         : (myLearningBloc.isFilterMenu)
                                  //             ? IconButton(
                                  //                 onPressed: () async {
                                  //                   await Navigator.of(context)
                                  //                       .push(MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               MyLearningFilter()));
                                  //
                                  //                   catalogBloc
                                  //                           .isFirstLoadingCatalog =
                                  //                       true;
                                  //                   catalogBloc.add(
                                  //                       GetCategoryWisecatalogEvent(
                                  //                           pageIndex: pageNumber,
                                  //                           categaoryID:
                                  //                               widget.categaoryID,
                                  //                           serachString: "",
                                  //                           myLearningBloc:
                                  //                               myLearningBloc));
                                  //                 },
                                  //                 icon: Icon(Icons.tune,
                                  //                     color: Color(
                                  //                       int.parse(
                                  //                           "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                  //                     )),
                                  //               )
                                  //             : null,
                                  //   ),
                                  //   onSubmitted: (value) {
                                  //     // search logic
                                  //     if (value.toString().length > 0) {
                                  //       catalogBloc.isFirstLoadingCatalog = true;
                                  //       catalogBloc.isCatalogSearch = true;
                                  //       catalogBloc.searchCatalogString =
                                  //           value.toString();
                                  //       setState(() {
                                  //         pageNumber = 1;
                                  //       });
                                  //       catalogBloc.add(GetCategoryWisecatalogEvent(
                                  //           pageIndex: pageNumber,
                                  //           categaoryID: widget.categaoryID,
                                  //           serachString: value.toString(),
                                  //           myLearningBloc: myLearningBloc));
                                  //     }
                                  //   },
                                  // ),
                                  ),
                              Container(
                                child: Center(
                                  child: Text(
                                      appBloc
                                          .localstr.commoncomponentLabelNodatalabel,
                                      style: TextStyle(
                                          color: AppColors.getAppTextColor(),
                                          fontSize: 24)),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              getBreadcrumbWidget(),
                              Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: InsSearchTextField(
                                    onTapAction: () {
                                      if (appBloc.uiSettingModel.isGlobalSearch ==
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
                                              catalogBloc.isFirstLoadingCatalog =
                                                  true;
                                              catalogBloc.isCatalogSearch = false;
                                              catalogBloc.searchCatalogString = "";
                                              setState(() {
                                                pageNumber = 1;
                                              });
                                              catalogBloc.add(
                                                  GetCategoryWisecatalogEvent(
                                                      pageIndex: pageNumber,
                                                      categaoryID:
                                                          widget.categaoryID,
                                                      serachString: "",
                                                      myLearningBloc:
                                                          myLearningBloc));
                                            },
                                            icon: Icon(
                                              Icons.close,
                                            ),
                                          )
                                        : (myLearningBloc.isFilterMenu)
                                            ? IconButton(
                                                onPressed: () async {
                                                  await Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyLearningFilter(componentId: componentId,)));

                                                  catalogBloc
                                                      .isFirstLoadingCatalog = true;
                                                  catalogBloc.add(
                                                      GetCategoryWisecatalogEvent(
                                                          pageIndex: pageNumber,
                                                          categaoryID:
                                                              widget.categaoryID,
                                                          serachString: "",
                                                          myLearningBloc:
                                                              myLearningBloc));
                                                },
                                                icon: Icon(
                                                  Icons.tune,
                                                  color: AppColors.getFilterIconColor(),
                                                ),
                                              )
                                            : null,
                                    onSubmitAction: (value) {
                                      if (value.toString().length > 0) {
                                        catalogBloc.isFirstLoadingCatalog = true;
                                        catalogBloc.isCatalogSearch = true;
                                        catalogBloc.searchCatalogString =
                                            value.toString();
                                        setState(() {
                                          pageNumber = 1;
                                        });
                                        catalogBloc.add(GetCategoryWisecatalogEvent(
                                            pageIndex: pageNumber,
                                            categaoryID: widget.categaoryID,
                                            serachString: value.toString(),
                                            myLearningBloc: myLearningBloc));
                                      }
                                    },
                                  )),
                              Expanded(
                                child: ResponsiveWidget(
                                  mobile: ScrollablePositionedList.builder(
                                    //shrinkWrap: true,
                                    itemScrollController: _scrollController,
                                    itemCount: widget.contentId == '' ||
                                            widget.contentId == null
                                        ? catalogBloc.catalogCatgorylist.length
                                        : catalogBloc
                                            .notificationCatalogCatgorylist.length,
                                    itemBuilder: (context, i) {
                                      if (catalogBloc.catalogCatgorylist.length ==
                                          0) {
                                        if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                          return _buildProgressIndicator();
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            child: widget.contentId == '' ||
                                                    widget.contentId == null
                                                ? widgetMyCatalogListItems(
                                                    catalogBloc
                                                        .catalogCatgorylist[i],
                                                    false,
                                                    context,
                                                    i)
                                                : widgetMyCatalogListItems(
                                                    catalogBloc
                                                        .notificationCatalogCatgorylist[i],
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
                                          MediaQuery.of(context).size.width / 840,
                                    ),
                                    itemCount: widget.contentId == '' ||
                                            widget.contentId == null
                                        ? catalogBloc.catalogCatgorylist.length
                                        : catalogBloc
                                            .notificationCatalogCatgorylist.length,
                                    itemBuilder: (context, i) {
                                      if (catalogBloc.catalogCatgorylist.length ==
                                          0) {
                                        if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                          return _buildProgressIndicator();
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            child: widget.contentId == '' ||
                                                    widget.contentId == null
                                                ? widgetMyCatalogListItems(
                                                    catalogBloc
                                                        .catalogCatgorylist[i],
                                                    false,
                                                    context,
                                                    i)
                                                : widgetMyCatalogListItems(
                                                    catalogBloc
                                                        .notificationCatalogCatgorylist[i],
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
                                      childAspectRatio: 0.65,
                                    ),
                                    itemCount: widget.contentId == '' ||
                                        widget.contentId == null
                                        ? catalogBloc.catalogCatgorylist.length
                                        : catalogBloc
                                        .notificationCatalogCatgorylist.length,
                                    itemBuilder: (context, i) {
                                      if (catalogBloc.catalogCatgorylist.length ==
                                          0) {
                                        if (state.status == Status.LOADING) {
//                          print("gone in _buildProgressIndicator");
                                          return _buildProgressIndicator();
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                            child: widget.contentId == '' ||
                                                widget.contentId == null
                                                ? widgetMyCatalogListItems(
                                                catalogBloc
                                                    .catalogCatgorylist[i],
                                                false,
                                                context,
                                                i)
                                                : widgetMyCatalogListItems(
                                                catalogBloc
                                                    .notificationCatalogCatgorylist[i],
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
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget getBreadcrumbWidget() {
    if(widget.categaoryName.isEmpty) {
      return SizedBox();
    }

    return SizedBox(
      height: 50.h,
      width: double.maxFinite,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xffF0F0F0),
          //color: AppColors.getAppBGColor().withAlpha(200),
        ),
        alignment: Alignment.centerLeft,
        child: BreadCrumb.builder(
          itemCount: 2,
          builder: (pos) {
            if(pos == 0) {
              bool isClickable = widget.categaoryName.isNotEmpty;

              return BreadCrumbItem(
                onTap: isClickable ? () {
                  Navigator.pop(context);
                } : null,
                content: Text(
                  '${catalogBloc.catList[pos].categoryName}',
                  style: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.w600,
                    decoration: isClickable ? TextDecoration.underline : null,
                    color: Color(0xff1D293F),
                  ),
                ),
              );
            }
            else {
              return BreadCrumbItem(
                content: GestureDetector(
                    onTap: () {

                    },
                    child: Text(
                      '${widget.categaoryName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff1D293F),
                      ),
                    ),
                ),
              );
            }
          },
          divider: Icon(
            Icons.chevron_right,
            color: InsColor(appBloc).appIconColor,
          ),
        ),
      ),
    );
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
                              catalogBloc.add(GetCategoryWisecatalogEvent(
                                  pageIndex: pageNumber,
                                  categaoryID: widget.categaoryID,
                                  serachString: "",
                                  myLearningBloc: myLearningBloc));
                            },
                            icon: Icon(
                              Icons.tune,
                              color: AppColors.getFilterIconColor(),

                            ),
                          )
                        : null,
                    onSubmitAction: (value) {
                      if (value.toString().length > 0) {}
                    },
                  )),
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
        : Container();
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
      catalogBloc.add(GetCategoryWisecatalogEvent(
          pageIndex: pageNumber,
          categaoryID: widget.categaoryID,
          serachString: result,
          myLearningBloc: myLearningBloc));
    }
  }

  widgetMyCatalogListItems(DummyMyCatelogResponseTable2 table2, bool bool, BuildContext context, int i) {
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

//    print("percentcompleted: ${table2.percentcompleted}");
//    print("objecttypeid: ${table2.objecttypeid}");
//    print("name: ${table2.name}");
//    print("actualstatus: ${table2.actualstatus}");
//    print("durationenddate: ${table2.durationenddate}");
    //print("contentid: ${table2.contentid}");

    int objecttypeId = table2.objecttypeid;

    var isratingbarVissble;

    if (table2.totalratings >=
        int.parse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating)) {
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
    } else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    return Card(
      elevation: 4,
      color: InsColor(appBloc).appBGColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {},
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommonDetailScreen(
                          screenType: ScreenType.Catalog,
                          contentid: table2.contentid,
                          objtypeId: table2.objecttypeid,
                          detailsBloc: detailsBloc,
                          table2: table2,
                          isFromReschedule: false,
                        )));
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(kCellThumbHeight),
                    child: CachedNetworkImage(
                      imageUrl:
                          table2.thumbnailimagepath.trim().startsWith("http")
                              ? table2.thumbnailimagepath.trim()
                              : table2.siteurl.trim() +
                                  table2.thumbnailimagepath.trim(),

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
                Text(
                  table2.shortdescription,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                (table2.viewtype == 3 && table2.isaddedtomylearning == 0)
                    ? Row(
                  children: <Widget>[
                    // commented till offline integration done
                    Text(
                      "\$${table2.saleprice} ",
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

    dummyMyCatelogResponseTable2 = table2;
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
    // if(table2.isaddedtomylearning == 0){
    //   isAddToMyLearning = true;
    // }

    return
      menu0 ? Container(
          width: double.infinity,
          child: CommonPrimarySecondaryButton(onPressed: (){
                viewOnClick(table2,i);
             },
            text: appBloc.localstr.catalogActionsheetViewoption,isPrimary: true,))
          : menu1
          ? Container(
              width: double.infinity,
              child: CommonPrimarySecondaryButton(onPressed: (){
                addToLearningOnClick(table2,i);
              },text: appBloc.localstr.catalogActionsheetAddtomylearningoption,isPrimary: true,))
          : Container();
  }

  Widget buyOption(DummyMyCatelogResponseTable2 table2) {
    return
      // table2.siteid != 374
      //   ? Container()
      //   :
      Expanded(
        child: MaterialButton(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          child: Text(
            appBloc.localstr.detailsButtonBuybutton.toUpperCase(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              color: InsColor(appBloc).appBtnTextColor,
            ),
          ),
          onPressed: () async {
            //  buy functionlaity here
            MyPrint.printOnConsole("--------- Site id ------ ${table2.siteid}");

            dummyMyCatelogResponseTable2 = table2;
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
    dummyMyCatelogResponseTable2 = table2;
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
            isValidString(table2.eventstartdatetime())) {
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

    if (appBloc.uiSettingModel.enableWishlist == "true") {
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
                menu0
                    ? ListTile(
                        title:
                            Text(appBloc.localstr.catalogActionsheetViewoption,
                                style: TextStyle(
                                  color: InsColor(appBloc).appTextColor,
                                )),
                        leading: Icon(
                          IconDataSolid(int.parse('0xf06e')),
                          color: InsColor(appBloc).appIconColor,
                        ),
                        onTap: () {
                          //print("imageurl---${table2.imageData}");
                          if (isValidString(
                              table2.viewprerequisitecontentstatus ?? "")) {
                            print('ifdataaaaa');
                            Navigator.of(context).pop();
                            String alertMessage = appBloc
                                .localstr.prerequistesalerttitle6Alerttitle6;
                            alertMessage = alertMessage +
                                "  \"" +
                                appBloc
                                    .localstr.prerequisLabelContenttypelabel +
                                "\" " +
                                appBloc.localstr
                                    .prerequistesalerttitle5Alerttitle7;

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
                                              table2
                                                  .viewprerequisitecontentstatus
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
                            if (table2.isaddedtomylearning == 1) {
                              launchCourse(table2, context);
                            } else {
                              launchCoursePreview(table2, context);
                            }
                          }
                        },
                      )
                    : Container(),
                menu1
                    ? ListTile(
                        title: Text(
                          appBloc
                              .localstr.catalogActionsheetAddtomylearningoption,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
                        leading: Icon(
                          Icons.add_circle,
                          color: InsColor(appBloc).appIconColor,
                        ),
                        onTap: () {
                          if (table2.userid != null && table2.userid != "-1") {
                            Navigator.pop(context);
                            if (table2.isaddedtomylearning == 2) {
                              catalogBloc.add(
                                GetPrequisiteDetailsEvent(
                                    contentId: table2.contentid,
                                    userID: table2.userid),
                              );
                            } else {
                              setState(() {
                                selectedIndexOfAddedMyLearning = i;
                              });
                              (table2.objecttypeid == 70 &&
                                          table2.eventscheduletype == 1) ||
                                      (table2.objecttypeid == 70 &&
                                          table2.eventscheduletype == 2)
                                  ? Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CommonDetailScreen(
                                                screenType:
                                                    ScreenType.Catalog,
                                                contentid: table2.contentid,
                                                objtypeId:
                                                    table2.objecttypeid,
                                                detailsBloc: detailsBloc,
                                                table2: table2,
                                                // nativeModel:
                                                //     widget.nativeMenuModel,
                                                isFromReschedule: false,
                                                //isFromMyLearning:
                                                //  false, //need implement reschedule
                                              )))
                                      .then((value) => {
                                            if (value) {refresh()}
                                          })
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
                    ? ListTile(
                        title: Text(
                          appBloc.localstr.catalogActionsheetBuyoption,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
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
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
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
                                // nativeModel: widget.nativeMenuModel,
                                isFromReschedule: false,
                                //isFromMyLearning:
                                //true, //neeed implement
                              )));
                        },
                      )
                    : Container(),
                menu4
                    ? ListTile(
                        title: Text(
                          appBloc.localstr.catalogActionsheetDeleteoption,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
                        leading: Icon(
                          IconDataSolid(int.parse('0xf144')),
                          color: InsColor(appBloc).appIconColor,
                        ),
                      )
                    : Container(),
                menu5
                    ? ListTile(
                        title: Text(
                          appBloc.localstr.mylearningActionsheetDownloadoption,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
                        leading: Icon(
                          IconDataSolid(int.parse('0xf144')),
                          color: Colors.black54,
                        ),
                      )
                    : Container(),
                menu6
                    ? ListTile(
                        title: Text(
                          appBloc.localstr.catalogActionsheetWishlistoption,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
                        leading: Icon(
                          Icons.favorite_border,
                          color: InsColor(appBloc).appIconColor,
                        ),
                        onTap: () {
                          catalogBloc.add(
                              AddToWishListEvent(contentId: table2.contentid));
                          Navigator.of(context).pop();
                        },
                      )
                    : Container(),
                menu7
                    ? ListTile(
                        title: Text(
                          appBloc.localstr
                              .catalogActionsheetRemovefromwishlistoption,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
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
                          appBloc.localstr.learningtrackLabelEventviewrecording,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.apply(color: InsColor(appBloc).appTextColor),
                        ),
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
                  title: Text(
                    'Share with Connection',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.apply(color: InsColor(appBloc).appTextColor),
                  ),
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
                  title: Text(
                    "Share with People",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.apply(color: InsColor(appBloc).appTextColor),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShareMainScreen(true, false,
                            false, table2.contentid, table2.name)));
                  },
                ),
                /*: Container()
                    : Container()*/
                //sreekanth commmented
                // (table2?.ShareContentwithUser?.length ?? 0) > 0
                displaySendViaEmail(table2),
              ],
            ),
          ),
        );
      },
    );
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
    courseLaunchCatalog = GotoCourseLaunchCatalog(context, table2, false,
        appBloc.uiSettingModel, catalogBloc.catalogCatgorylist);
    String url = await courseLaunchCatalog!.getCourseUrl();
    if (url.isNotEmpty) {
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InAppWebCourseLaunch(url, table2)));
    }
  }

  bool privilegeCreateForumIdExists() {
    for (int i = 0; i < profileBloc.userprivilige.length; i++) {
      if (profileBloc.userprivilige[i].privilegeid == 1349) {
        return true;
      }
    }
    return false;
  }

  Future<void> launchCourse(
      DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    print('helllllllllloooooo');

    /// Need Some value
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

      getStatus(table2);

//      detailsBloc.add(GetContentStatus(url: url));

    }

    //sreekanth commented
    //Assignment content webview
    if (table2.objecttypeid == 694) {
      assignmenturl =
          await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}/ismobilecontentview/true';
      print('assignmenturl is : $assignmenturl');

      await Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => Assignmentcontentweb(
                    url: assignmenturl,
                    myLearningModel: table2,
                  )))
          .then((value) => {
                if (value)
                  {
                    catalogBloc.add(GetCategoryWisecatalogEvent(
                        pageIndex: pageNumber,
                        categaoryID: widget.categaoryID,
                        serachString: "",
                        myLearningBloc: myLearningBloc))
                  }
              });

      // String ss = "";
    }
    // //sreekanth commented
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

    // ApiResponse? apiResponse = await generalRepository.executeXAPICourse(url);
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

      String url =
          webApiUrl + "/MobileLMS/MobileGetContentStatus?" + paramsString;

      print('launchCourseUrl $url');

      detailsBloc.add(GetContentStatus(url: url));
    }
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

  showAlertDialog(
    BuildContext context,
    String preqContentNames,
    CatalogDetailsResponse response,
  ) {
    // Create button
    Widget viewPreButton = Container(
      width: 150,
      child: MaterialButton(
        onPressed: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => PrerequisiteScreen(
                      catalogBloc.prequisitePopupresponse,
                      widget.nativeMenuModel,
                      response)))
              .then((value) => {
                    if (value)
                      {
                        catalogBloc.add(GetCategoryWisecatalogEvent(
                            pageIndex: pageNumber,
                            categaoryID: widget.categaoryID,
                            serachString: "",
                            myLearningBloc: myLearningBloc))
                      }
                  }),
        },
        minWidth: MediaQuery.of(context).size.width,
        disabledColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
            .withOpacity(0.5),
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'View Prerequisites',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
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
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        textColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
      ),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: InsColor(appBloc).appBGColor,
      title: Text("Pre-requisite Sequence"),
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

  void refresh() {
    catalogBloc.add(GetCategoryWisecatalogEvent(
        pageIndex: pageNumber,
        categaoryID: widget.categaoryID == 0 ? 0 : widget.categaoryID,
        serachString: "",
        myLearningBloc: myLearningBloc));
  }
}
