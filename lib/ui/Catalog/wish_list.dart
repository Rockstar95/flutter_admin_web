import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/Catalog/direct_inapp_web_cource_launch.dart';
import 'package:flutter_admin_web/ui/Catalog/gotoCoursePreview.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/helper/gotoCourseLaunch.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/modal_progress_hud.dart';
import 'package:flutter_admin_web/utils/my_utils.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../configs/constants.dart';
import '../../framework/helpers/providermodel.dart';
import '../common/bottomsheet_drager.dart';
import '../common/bottomsheet_option_tile.dart';

class WishList extends StatefulWidget {
  final int categaoryID;
  final String categaoryName;
  final MyLearningDetailsBloc detailsBloc;
  final Map<String, String> filterMenus;

  const WishList({
    required this.categaoryID,
    required this.categaoryName,
    required this.detailsBloc,
    required this.filterMenus,
  });

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  ScrollController _sc = ScrollController();

  int pageNumber = 0;
  bool isGetCatalogListEvent = false;

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
  bool isConsolidated = false;

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

  @override
  void initState() {
    super.initState();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print("Last Postion");
        if (isGetCatalogListEvent &&
            catalogBloc.wishlistCatalogTotalCount >
                catalogBloc.catalogCatgorylist.length) {
          print("Last Postion-----Api call ");
          setState(() {
            isGetCatalogListEvent = false;
          });
          catalogBloc.add(GetWishListCatalogEvent(
              pageIndex: pageNumber, categaoryID: widget.categaoryID));
        }
      }
    });
    catalogBloc.isFirstLoadingWishCatalog = true;
    catalogBloc.add(GetWishListCatalogEvent(
        pageIndex: pageNumber, categaoryID: widget.categaoryID));

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
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: Center(
          child: AbsorbPointer(
            child: AppConstants().getLoaderWidget(iconSize: 70)
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
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
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
                  } else if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
                    if (state.message == "401") {
                      AppDirectory.sessionTimeOut(context);
                    }
                  }
                } else if (state is AddToWishListState ||
                    state is RemoveFromWishListState ||
                    state is AddToMyLearningState) {
                  if (state.status == Status.COMPLETED) {
                    catalogBloc.isFirstLoadingCatalog = true;
                    catalogBloc.add(GetWishListCatalogEvent(
                        pageIndex: pageNumber, categaoryID: widget.categaoryID));
                    if (state is AddToWishListState) {
                      flutterToast.showToast(
                        child: CommonToast(
                            displaymsg: appBloc.localstr
                                .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                        gravity: ToastGravity.BOTTOM,
                        toastDuration: const Duration(seconds: 2),
                      );
                    }
                    if (state is RemoveFromWishListState) {
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
                      appBloc.add(WishlistCountEvent());
                    }
                    if (state is SaveInAppPurchaseState) {
                      if (state.status == Status.COMPLETED) {
                        if (isValidString(state.response) && state.response.contains('success')) {
                          MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

                          catalogBloc.add(GetWishListCatalogEvent(
                              pageIndex: pageNumber,
                              categaoryID: widget.categaoryID));
                        }
                        else {}
                      }
                      else if (state.status == Status.ERROR) {
                        if (state.message == "401") {
                          AppDirectory.sessionTimeOut(context);
                        }
                      }
                    }
                  }
                } else if (state.status == Status.ERROR) {
//            print("listner Error ${state.message}");
                  if (state.message == "401") {
                    AppDirectory.sessionTimeOut(context);
                  }
                }
              },
              builder: (context, state) {
                print("state -----$state");
                if (state.status == Status.LOADING) {
                  return Center(
                    child: AbsorbPointer(
                      child: AppConstants().getLoaderWidget(iconSize: 70)
                    ),
                  );
                } else if (state.status == Status.COMPLETED) {
                  return catalogBloc.catalogCatgoryWishlist.length == 0
                      ? noDataFound(true)
                      : ResponsiveWidget(
                          mobile: ListView.builder(
                            itemCount:
                                catalogBloc.catalogCatgoryWishlist.length + 1,
                            itemBuilder: (context, i) {
                              if (i == catalogBloc.catalogCatgoryWishlist.length) {
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
                                        catalogBloc.catalogCatgoryWishlist[i],
                                        false,
                                        context,
                                        i),
                                  ),
                                );
                              }
                            },
                            controller: _sc,
                          ),
                          tab: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width / 840,
                            ),
                            shrinkWrap: true,
                            itemCount:
                                catalogBloc.catalogCatgoryWishlist.length + 1,
                            itemBuilder: (context, i) {
                              if (i == catalogBloc.catalogCatgoryWishlist.length) {
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
                                        catalogBloc.catalogCatgoryWishlist[i],
                                        false,
                                        context,
                                        i),
                                  ),
                                );
                              }
                            },
                            controller: _sc,
                          ),
                          web: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 1,
                            ),
                            shrinkWrap: true,
                            itemCount:
                            catalogBloc.catalogCatgoryWishlist.length + 1,
                            itemBuilder: (context, i) {
                              if (i == catalogBloc.catalogCatgoryWishlist.length) {
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
                                        catalogBloc.catalogCatgoryWishlist[i],
                                        false,
                                        context,
                                        i),
                                  ),
                                );
                              }
                            },
                            controller: _sc,
                          ),
                        );
                } else {
                  return noDataFound(true);
                }
              },
            ),
          ),
        ),
      ),
    );
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
        : Container();
  }

  widgetMyCatalogListItems(DummyMyCatelogResponseTable2 table2, bool bool,
      BuildContext context, int i) {
    String imgUrl =
        "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";

    print("contentid: ${table2.contentid}");

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
      color: InsColor(appBloc).appBGColor,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {},
                child: Container(
                  height: ScreenUtil().setHeight(kCellThumbHeight),
                  child: CachedNetworkImage(
                    imageUrl: MyUtils.getSecureUrl(table2.thumbnailimagepath.startsWith('https')
                        ? table2.thumbnailimagepath
                        : table2.siteurl + table2.thumbnailimagepath),
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
                          imageUrl: MyUtils.getSecureUrl(contentIconPath),
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
                              table2.name.toUpperCase(),
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
                        _settingMyCourceBottomSheet(context, table2);
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
                          ? (table2.presenter == null ? "" : table2.presenter)
                          : table2.authordisplayname,
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
                  height: ScreenUtil().setHeight(5),
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
                (table2.viewtype == 3 && table2.isaddedtomylearning == 0)
                    ? Row(
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
                          buyOption(table2),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buyOption(DummyMyCatelogResponseTable2 table2) {
    return isConsolidated && table2.siteid != 374
        ? Container()
        : Expanded(
            child: FlatButton.icon(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            icon: Icon(IconDataSolid(int.parse('0x${"f155"}')),
                color: InsColor(appBloc).appBtnTextColor),
            label: Text(
              appBloc.localstr.detailsButtonBuybutton.toUpperCase(),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: InsColor(appBloc).appBtnTextColor,
              ),
            ),
            onPressed: () async {
              //  buy functionlaity here
              _buyProduct(table2);
            },
          ));
  }

  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: const Center(
        child: const Opacity(
          opacity: 1.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _settingMyCourceBottomSheet(context, DummyMyCatelogResponseTable2 table2) {
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

      if (table2.objecttypeid.toString() == "70") {
        int relatedCount = int.parse(table2.relatedconentcount.toString());
        if (relatedCount > 0) {
          menu0 = true;
        } else {
          menu0 = false;
        }
      }
    } else {
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
      } else if (table2.viewtype == 5) {
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
        context: context,
        shape: AppConstants().bottomSheetShapeBorder(),
        builder: (BuildContext bc) {
          return AppConstants().bottomSheetContainer(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const BottomSheetDragger(),
                  menu0
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetViewoption,
                          iconData: IconDataSolid(int.parse('0xf06e')),
                          onTap: () {
                            launchCourse(table2, context);
                          },
                        )
                      : Container(),
                  menu1
                      ? isConsolidated && table2.siteid != 374
                          ? Container()
                          : BottomsheetOptionTile(
                              text: appBloc.localstr.catalogActionsheetAddtomylearningoption,
                              iconData: Icons.add_circle,
                              onTap: () {
                                catalogBloc.add(AddToMyLearningEvent(
                                    contentId: table2.contentid,
                                    table2: table2));
                                Navigator.of(context).pop();
                              },
                            )
                      : Container(),
                  menu2
                      ? isConsolidated && table2.siteid != 374
                          ? Container()
                          : BottomsheetOptionTile(
                              text: appBloc.localstr.catalogActionsheetBuyoption,
                              iconData: IconDataSolid(int.parse('0xf144')),
                              onTap: () {
                                Navigator.of(context).pop();
                                _buyProduct(table2);
                              })
                      : Container(),
                  menu3
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetDetailsoption,
                          iconData: IconDataSolid(int.parse('0xf570')),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (context) => ProviderModel(),
                                      child: CommonDetailScreen(
                                        screenType: ScreenType.Catalog,
                                        contentid: table2.contentid,
                                        objtypeId: table2.objecttypeid,
                                        detailsBloc: widget.detailsBloc,
                                        table2: table2,
                                        isFromReschedule: false,
                                        filterMenus: widget.filterMenus,
                                      ),
                                    )));
                          },
                        )
                      : Container(),
                  menu4
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetDeleteoption,
                          iconData: IconDataSolid(int.parse('0xf144')),
                        )
                      : Container(),
                  menu5
                      ? BottomsheetOptionTile(
                          text: appBloc
                                  .localstr.mylearningActionsheetDownloadoption,
                          iconData: IconDataSolid(int.parse('0xf144')),
                        )
                      : Container(),
                  menu6
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr.catalogActionsheetWishlistoption,
                          iconData: Icons.favorite_border,
                          onTap: () {
                            catalogBloc.add(AddToWishListEvent(
                                contentId: table2.contentid));
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                  menu7
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr
                                  .catalogActionsheetRemovefromwishlistoption,
                          iconData:  Icons.favorite,
                          onTap: () {
                            catalogBloc.add(RemoveFromWishListEvent(
                                contentId: table2.contentid));
                            Navigator.of(context).pop();
                          },
                        )
                      : Container(),
                  menu8
                      ? BottomsheetOptionTile(
                          text: appBloc.localstr
                                  .learningtrackLabelEventviewrecording,
                          iconData: IconDataSolid(int.parse('0xf144')),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  bool isValidString(String val) {
//    print('validstrinh $val');
    if (val == null || val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  Future<void> launchCourse(
      DummyMyCatelogResponseTable2 table2, BuildContext context) async {
    courseLaunchCatalog = GotoCourseLaunchCatalog(context, table2, false,
        appBloc.uiSettingModel, catalogBloc.catalogCatgoryWishlist);
    String url = await courseLaunchCatalog!.getCourseUrl();
    if (url.isNotEmpty) {
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdvancedWebCourseLaunch(url,table2)));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InAppWebCourseDirectLaunch(url, table2)));
    }
  }
}
