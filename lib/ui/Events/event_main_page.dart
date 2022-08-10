import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/events/app_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/providermodel.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/people_listing_tab.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/MyLearning/common_detail_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/mylearning_filter.dart';
import 'package:flutter_admin_web/ui/MyLearning/review_screen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_mainscreen.dart';
import 'package:flutter_admin_web/ui/MyLearning/share_with_connections.dart';
import 'package:flutter_admin_web/ui/TrackList/event_track_list.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../framework/common/pref_manger.dart';
import '../common/app_colors.dart';
import '../common/bottomsheet_drager.dart';
import '../global_search_screen.dart';

class EventMainPage extends StatefulWidget {
  final String searchString;
  final bool enableSearching;

  const EventMainPage({
    this.searchString = "",
    this.enableSearching = true,
  });

  @override
  State<EventMainPage> createState() => _EventMainPageState();
}

class _EventMainPageState extends State<EventMainPage> {
  bool isFirst = true;

  int selectedIndex = 0;
  String tabValue = 'upcoming';
  late EvntModuleBloc eventModuleBloc;
  ScrollController _sc = new ScrollController();

  List<String> bottomList = ["Upcoming", "Past", "Today"];

  late FToast flutterToast;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  MyLearningDetailsBloc get myLearningDetailsBloc => BlocProvider.of<MyLearningDetailsBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);

  final _controller = ScrollController();

  late MyLearningDetailsBloc detailsBloc;
  String componentId = "";

  bool menu0 = false,
      menu1 = false,
      menu2 = false,
      menu3 = false,
      menu4 = false,
      menu5 = false,
      menu6 = false,
      menu7 = false;

  int pageNumber = 1;
  bool isGetListEvent = false;

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

  @override
  void initState() {
    super.initState();
    getComponentId();
    myLearningBloc.add(ResetFilterEvent());
    myLearningBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: "Training Events"));
    myLearningBloc.add(GetSortMenus("153"));

    eventModuleBloc = EvntModuleBloc(
        eventModuleRepository: EventRepositoryBuilder.repository());
    eventModuleBloc.add(GetPeopleListingTab());
    eventModuleBloc.searchEventString = widget.searchString;

    detailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        print("Last Postion");
        if (isGetListEvent && eventModuleBloc.listTotalCount > eventModuleBloc.list.length) {
          setState(() {
            isGetListEvent = false;
          });
          eventModuleBloc.add(GetTabContent(
              tabVal: tabValue,
              searchString: eventModuleBloc.searchEventString,
              myLearningBloc: myLearningBloc,
              pageIndex: pageNumber));
        }
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(isFirst) {
      isFirst = false;
      flutterToast = FToast();
      flutterToast.init(context);
    }

    return BlocConsumer<CatalogBloc, CatalogState>(
      bloc: catalogBloc,
      listener: (context, state) {
        //print("Status:${state.status}, State:${state.runtimeType}");

        if (state is AddToWishListState || state is RemoveFromWishListState) {
          if (state.status == Status.COMPLETED) {
            //evntModuleBloc.isFirstLoading = true;

            //(state as AddToWishListState).contentId
            eventModuleBloc.add(GetTabContent(
                tabVal: tabValue,
                searchString: eventModuleBloc.searchEventString,
                myLearningBloc: myLearningBloc,
                pageIndex: 1));
            if (state is AddToWishListState) {
              try {
                flutterToast = FToast();
                flutterToast.init(context);
                flutterToast.showToast(
                  child: CommonToast(
                      displaymsg: appBloc.localstr
                          .catalogAlertsubtitleItemaddedtowishlistsuccesfully),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 2),
                );
              }
              catch(e, s) {
                print("Error in Showing Toast:$e");
                print(s);
              }
              appBloc.add(WishlistCountEvent());
            }
            if (state is RemoveFromWishListState) {
              try {
                flutterToast = FToast();
                flutterToast.init(context);
                flutterToast.showToast(
                  child: CommonToast(
                      displaymsg: appBloc
                          .localstr.catalogActionsheetRemovefromwishlistoption),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 2),
                );
              }
              catch(e, s) {
                print("Error in Showing Toast:$e");
                print(s);
              }
              appBloc.add(WishlistCountEvent());
            }
          }
        }
        else if (state is AddToMyLearningState) {
          if (state.status == Status.COMPLETED) {
            try {
              flutterToast = FToast();
              flutterToast.init(context);
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
            }
            catch(e, s) {
              print("Error in Showing Toast:$e");
              print(s);
            }

            setState(() {
              state.table2.isaddedtomylearning = 1;
              state.table2.availableseats = state.table2.availableseats - 1;
            });

            //evntModuleBloc.isFirstLoading = true;
            eventModuleBloc.add(GetTabContent(
                tabVal: tabValue,
                searchString: eventModuleBloc.searchEventString,
                myLearningBloc: myLearningBloc,
                pageIndex: 1,
            ));
          }
        }
        else if(state is SaveInAppPurchaseState) {
          if (isValidString(state.response) && state.response.contains('success')) {
            MyToast.showToast(context, appBloc.localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto);

            eventModuleBloc.add(GetTabContent(
                tabVal: tabValue,
                searchString: eventModuleBloc.searchEventString,
                myLearningBloc: myLearningBloc,
                pageIndex: 1));
          }
        }
      },
      builder: (context, state) {
        return Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: Stack(
            children: <Widget>[
              BlocConsumer<EvntModuleBloc, EvntModuleState>(
                bloc: eventModuleBloc,
                listener: (context, state) {
                  print("Event Module State:${state.runtimeType}, Status:${state.status}");

                  if (state is GetPeopleListingTabState) {
                    if (state.status == Status.COMPLETED) {
                      if (eventModuleBloc.tabList.isNotEmpty) {
                        setState(() {
                          tabValue = getTabValue(eventModuleBloc.tabList[0].tabId);
                        });
                        eventModuleBloc.tabList[0].selectedIndex = true;
                      }

                      eventModuleBloc.add(GetTabContent(
                          tabVal: tabValue,
                          searchString: eventModuleBloc.searchEventString,
                          myLearningBloc: myLearningBloc,
                          pageIndex: pageNumber,
                      ));
                    }
                    else if (state.status == Status.ERROR) {
                      if (state.message == '401') {
                        AppDirectory.sessionTimeOut(context);
                      } else {
                        flutterToast.showToast(
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                            child: CommonToast(
                                displaymsg: 'Something went wrong'));
                      }
                    }
                  }
                  else if (state is GetTabContentState) {
                    if (state.status == Status.COMPLETED) {
                      setState(() {
                        isGetListEvent = true;
                        pageNumber++;
                      });
                    }
                    if (state.status == Status.ERROR) {
                      if (state.message == '401') {
                        AppDirectory.sessionTimeOut(context);
                      } else {
                        flutterToast.showToast(
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                            child: CommonToast(
                                displaymsg: 'Something went wrong'));
                      }
                    }
                  }
                  else if (state is CancelEnrollmentState) {
                    if (state.status == Status.COMPLETED) {
                      if (state.isSucces == '"true"') {
                        Future.delayed(Duration(seconds: 1), () {
                          // 5s over, navigate to a new page

                          try {
                            flutterToast = FToast();
                            flutterToast.init(context);
                            flutterToast.showToast(
                              child: CommonToast(
                                  displaymsg:
                                  'Your enrollment for the course has been successfully canceled'),
                              gravity: ToastGravity.BOTTOM,
                              toastDuration: Duration(seconds: 1),
                            );
                          }
                          catch(e, s) {
                            print("Error in Showing Toast:$e");
                            print(s);
                          }
                        });

                        setState(() {
                          state.table2.isaddedtomylearning = 0;
                          state.table2.availableseats =
                              state.table2.availableseats + 1;
                        });
                      }
                      else {
                        try {
                          flutterToast = FToast();
                          flutterToast.init(context);
                          flutterToast.showToast(
                            child:
                            CommonToast(displaymsg: 'Something went wrong'),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        }
                        catch(e, s) {
                          print("Error in Showing Toast:$e");
                          print(s);
                        }
                      }
                    }
                    else if (state.status == Status.ERROR) {
                      if (state.message == '401') {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  }
                  else if (state is BadCancelEnrollmentState) {
                    if (state.status == Status.COMPLETED) {
                      showCancelEnrollDialog(state.table2, state.isSucces);
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

                        eventModuleBloc.isFirstLoading = true;
                        eventModuleBloc.add(GetTabContent(
                            tabVal: tabValue,
                            searchString: eventModuleBloc.searchEventString,
                            myLearningBloc: myLearningBloc,
                            pageIndex: 1));
                      } else {
                        print("else  ${state.isSucces}");
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
                  }
                  else if (state is WaitingListState) {
                    if (state.status == Status.COMPLETED) {
                      if (state.waitingListResponse.isSuccess) {
                        Future.delayed(Duration(seconds: 1), () {
                          // 5s over, navigate to a new page
                          flutterToast.showToast(
                            child: CommonToast(
                                displaymsg: state.waitingListResponse.message),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        });

                        setState(() {
                          state.table2.waitlistenrolls =
                              state.table2.waitlistenrolls + 1;
                          state.table2.actionwaitlist = '';
                        });
                      } else {
                        Future.delayed(Duration(seconds: 1), () {
                          // 5s over, navigate to a new page
                          flutterToast.showToast(
                            child: CommonToast(
                                displaymsg: state.waitingListResponse.message),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                        });
                      }
                    } else if (state.status == Status.ERROR) {
                      if (state.message == '401') {
                        AppDirectory.sessionTimeOut(context);
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
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        getMainPage(state),
                        getTabBarWidget(),
                        (state.status == Status.LOADING && eventModuleBloc.list.length == 0) ? getLoadingWidget() : SizedBox(),
                      ],
                    ),
                  );
                },
              ),
              (state.status == Status.LOADING || isLoading) ? getLoadingWidget() : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget getLoadingWidget() {
    return Center(
                      child: AbsorbPointer(
                        child: SpinKitCircle(
                          color: Colors.grey,
                          size: 70.h,
                        ),
                      ),
                    );
  }

  Widget getTabBarWidget() {
    if(eventModuleBloc.tabList.isNotEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 43.h,
          child: Container(
            color: AppColors.getAppBGColor(),
            child: eventModuleBloc.tabList.length <= 3
                ? ListView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: eventModuleBloc.tabList.length,
                    itemBuilder: (context, i) {
                      bool isTabSelected = (selectedIndex == i && eventModuleBloc.tabList[i].selectedIndex);
                      double indicatorHeight = 2;

                      return Container(
                        width: MediaQuery.of(context).size.width / eventModuleBloc.tabList.length + 1,
                        child: InkWell(
                          onTap: () => onItemTapped(eventModuleBloc.tabList[i].mobileDisplayName.toLowerCase(), eventModuleBloc.tabList[i], i),
                          child: Container(
                            //color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: indicatorHeight,),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      eventModuleBloc.tabList[i].mobileDisplayName,
                                      maxLines: 1,
                                      style: isTabSelected
                                          ? TextStyle(
                                              color: AppColors.getAppTextColor(),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.h,
                                            )
                                          : TextStyle(
                                              color: AppColors.getAppTextColor(),
                                              fontSize: 14.h,
                                            ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: indicatorHeight,
                                  color: isTabSelected ? AppColors.getAppTextColor() : AppColors.getAppBGColor(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : ListView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: eventModuleBloc.tabList.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () => onItemTapped(eventModuleBloc.tabList[i].mobileDisplayName.toLowerCase(), eventModuleBloc.tabList[i], i),
                              child: Text(
                                eventModuleBloc.tabList[i].mobileDisplayName,
                                maxLines: 1,
                                style: (selectedIndex == i && eventModuleBloc.tabList[i].selectedIndex)
                                    ? TextStyle(
                                        color: AppColors.getAppButtonBGColor(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.h,
                                      )
                                    : TextStyle(
                                        color: AppColors.getAppTextColor(),
                                        fontSize: 14.h,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ),
      );
    }
    else {
      return SizedBox();
    }
  }

  Widget getMainPage(EvntModuleState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
      child: Stack(
        children: <Widget>[
          tabValue == "calendar"
              ? ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      color: AppColors.getAppHeaderColor(),
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: 250.h,
                            child: SfCalendar(
                              backgroundColor: InsColor(appBloc).appBGColor,
                              view: CalendarView.month,
                              cellBorderColor: Colors.transparent,
                              dataSource: MeetingDataSource(_getDataSource()),
                              monthViewSettings: MonthViewSettings(
                                monthCellStyle: MonthCellStyle(
                                  textStyle: Theme.of(context).textTheme.bodyText1?.apply(color: InsColor(appBloc).appTextColor),
                                  leadingDatesTextStyle: Theme.of(context).textTheme.bodyText2?.apply(color: InsColor(appBloc).appTextColor.withOpacity(0.5)),
                                  trailingDatesTextStyle: Theme.of(context).textTheme.bodyText2?.apply(color: InsColor(appBloc).appTextColor.withOpacity(0.5)),

                                  // backgroundColor:
                                  //     Color(int.parse(
                                  //         "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                ),
                                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                              ),
                              onTap: (value) {
                                eventModuleBloc.add(GetCalanderFilterListContent(startDate: value.date.toString().split(" ")[0]));
                              },
                              onViewChanged: (ViewChangedDetails ee) {
                                String startdate = "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-01";
                                String enddate = "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-30";
                                print("$startdate ~ $enddate");

                                if (eventModuleBloc.calenderSelecteddates == "" || eventModuleBloc.calenderSelecteddates != "$startdate ~ $enddate") {
                                  eventModuleBloc.calenderSelecteddates = "$startdate ~ $enddate";
                                  eventModuleBloc.list.clear();
                                  eventModuleBloc.add(GetTabContent(
                                    tabVal: tabValue,
                                    searchString: eventModuleBloc.searchEventString,
                                    myLearningBloc: myLearningBloc,
                                    pageIndex: 1,
                                  ));
                                }
                              },
                              headerStyle: CalendarHeaderStyle(
                                  textStyle: Theme.of(
                                          context)
                                      .textTheme
                                      .headline1
                                      ?.apply(
                                          color: InsColor(
                                                  appBloc)
                                              .appTextColor),
                                  textAlign:
                                      TextAlign.center,
                                  backgroundColor:
                                      InsColor(appBloc)
                                          .appBGColor),
                            ),
                          ),
                      ),
                    ),
                    eventModuleBloc.list.length > 0
                        ? displayEventContent(state)
                        : Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                  appBloc.localstr.commoncomponentLabelNodatalabel,
                                  style: TextStyle(
                                    color: AppColors.getAppTextColor(),
                                    fontSize: 24,
                                  ),
                              ),
                            ),
                          ),
                  ],
                )
              : Container(
                  child: displayEventContent(state),
                ),
        ],
      ),
    );
  }

  _navigateToGlobalSearchScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => GlobalSearchScreen(menuId: 3219)),
    );

    print(result);

    if (result != null) {
      eventModuleBloc.isFirstLoading = true;
      eventModuleBloc.isEventSearch = true;
      eventModuleBloc.searchEventString = result.toString();
      eventModuleBloc.add(GetTabContent(
          tabVal: tabValue,
          searchString: eventModuleBloc.searchEventString,
          myLearningBloc: myLearningBloc,
          pageIndex: 1));
    }
  }

  void onItemTapped(String label, GetPeopleTabListResponse res, int index) {
    myLearningBloc.add(ResetFilterEvent());
    eventModuleBloc.isEventSearch = false;
    if(widget.searchString.isEmpty) eventModuleBloc.searchEventString = "";
    eventModuleBloc.isFirstLoading = true;
    eventModuleBloc.list.clear();
    setState(() {
      selectedIndex = index;
      tabValue = getTabValue(eventModuleBloc.tabList[index].tabId);
      res.selectedIndex = true;
      pageNumber = 1;
      eventModuleBloc.add(GetTabContent(
          tabVal: tabValue,
          searchString: eventModuleBloc.searchEventString,
          myLearningBloc: myLearningBloc,
          pageIndex: pageNumber,
      ));
      _controller.animateTo(MediaQuery.of(context).size.width * index, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  Widget widgetMyEventItems(DummyMyCatelogResponseTable2 table2) {
    //https://stackoverflow.com/questions/49838021/how-do-i-stack-widgets-overlapping-each-other-in-flutter
    String imgUrl = "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
    //print("Id:${table2.contentid}, isWishlist:${table2.iswishlistcontent}");

    bool isratingbarVissble = false;
    bool isReviewVissble = false;

    double ratingRequired = 0;
    String availableSeat = '';

    availableSeat = checkAvailableSeats(table2);

    try {
      ratingRequired = double.parse(appBloc.uiSettingModel.minimumRatingRequiredToShowRating);
    }
    catch (e) {
      ratingRequired = 0;
    }

    if (table2.totalratings >= int.parse(appBloc.uiSettingModel.numberOfRatingsRequiredToShowRating) && table2.ratingid >= ratingRequired) {
      isReviewVissble = false;
      isratingbarVissble = true;
    }

    DateTime startTempDate = DateTime.now();

    try {
      //print("Date:${table2.eventstartdatedisplay}");
      if((table2.eventstartdatedisplay?.toString() ?? "").isNotEmpty) startTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventstartdatedisplay);
    }
    catch(e, s) {
      print("Error in Date Format Parsing:$e");
      print(s);
    }

    DateTime endTempDate = DateTime.now();

    try {
      //print("Date:${table2.eventenddatedisplay}");
      if((table2.eventenddatedisplay?.toString() ?? "").isNotEmpty) endTempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(table2.eventenddatedisplay);
    }
    catch(e, s) {
      print("Error in Date Format Parsing:$e");
      print(s);
    }

    String startDate = DateFormat("MM/dd/yyyy hh:mm:ss a").format(startTempDate);
    String endDate = DateFormat("MM/dd/yyyy hh:mm:ss a").format(endTempDate);

    String thumbnailPath = table2.thumbnailimagepath.startsWith("http")
        ? table2.thumbnailimagepath.trim()
        : table2.siteurl + table2.thumbnailimagepath.trim();

    String contentIconPath = table2.iconpath;

    if (isValidString(appBloc.uiSettingModel.azureRootPath)) {
      contentIconPath = contentIconPath.startsWith('http')
          ? table2.iconpath
          : appBloc.uiSettingModel.azureRootPath + table2.iconpath;

      contentIconPath = contentIconPath.toLowerCase().trim();
    } else {
      contentIconPath = table2.siteurl + contentIconPath;
    }

    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      child: Card(
        color: InsColor(appBloc).appBGColor,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(kCellThumbHeight),
                  child: InkWell(
                    onTap: () {
                      if (menu0) {
                        checkRelatedContent(table2);
                      } else if (menu3) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ProviderModel(),
                                  child: CommonDetailScreen(
                                    screenType: ScreenType.Events,
                                    contentid: table2.contentid,
                                    objtypeId: table2.objecttypeid,
                                    detailsBloc: detailsBloc,
                                    table2: table2,
                                    isFromReschedule: false,
                                  ),
                                )));
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
                      )),
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
                          _settingMyEventBottomSheet(context, table2);
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
                      Text(availableSeat,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                                .withOpacity(0.5),
                          ))
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
                  ),
                  isValidString(table2.shortdescription)
                      ? SizedBox(
                          height: ScreenUtil().setHeight(10),
                        )
                      : Container(),
                  Text(
                    table2.shortdescription,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                        color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                            .withOpacity(0.5)),
                  ),
                  isValidString(table2.shortdescription)
                      ? SizedBox(
                          height: ScreenUtil().setHeight(10),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Start Date :  ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
                        ),
                        Text(
                          startDate.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "End Date :    ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
                        ),
                        Text(
                          endDate.toUpperCase(),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Time Zone : ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
                        ),
                        Text(
                          table2.timezone ?? "",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Location :     ",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: InsColor(appBloc)
                                  .appTextColor
                                  .withOpacity(0.8)),
                        ),
                        Text(
                          table2.locationname,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(13),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
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
      ),
    );
  }

  Widget buyOption(DummyMyCatelogResponseTable2 table2) {
    return Expanded(
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

  Widget displayEventContent(EvntModuleState state) {
    switch (tabValue) {
      case 'upcoming':
        return displayUpcoming(state);
      case 'past':
        return displayUpcoming(state);
      case 'calendar':
        return displayUpcoming(state);
      case 'schedule':
        return displayUpcoming(state);
      case 'myevents':
        return displayUpcoming(state);
      default:
        return displayUpcoming(state);
    }
  }

  Widget displayUpcoming(EvntModuleState state) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    TextEditingController _controller;
    if (eventModuleBloc.isEventSearch || widget.searchString.isNotEmpty) {
      _controller =
          TextEditingController(text: eventModuleBloc.searchEventString);
    }
    else {
      _controller = TextEditingController();
    }

    return tabValue == "calendar"
        ? ResponsiveWidget(
            mobile: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventModuleBloc.list.length,
                itemBuilder: (context, i) {
                  return widgetMyEventItems(eventModuleBloc.list[i]);
                }),
            tab: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width / 960,
                ),
                scrollDirection: Axis.vertical,
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventModuleBloc.list.length,
                itemBuilder: (context, i) {
                  return widgetMyEventItems(eventModuleBloc.list[i]);
                }),
            web: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.6,
                ),
                scrollDirection: Axis.vertical,
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventModuleBloc.list.length,
                itemBuilder: (context, i) {
                  return widgetMyEventItems(eventModuleBloc.list[i]);
                }),
          )
        : (eventModuleBloc.list.length > 0)
            ? Column(
                children: [
                  Visibility(
                    visible: widget.enableSearching,
                    child: Padding(
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
                          suffixIcon: eventModuleBloc.isEventSearch
                              ? IconButton(
                                  onPressed: () {
                                    //search logic
                                    eventModuleBloc.isFirstLoading = true;
                                    eventModuleBloc.isEventSearch = false;
                                    eventModuleBloc.searchEventString = "";

                                    eventModuleBloc.add(GetTabContent(
                                        tabVal: tabValue,
                                        searchString: eventModuleBloc.searchEventString,
                                        myLearningBloc: myLearningBloc,
                                        pageIndex: 1));
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: AppColors.getFilterIconColor(),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyLearningFilter(componentId: componentId,)));

                                    eventModuleBloc.isFirstLoading = true;
                                    eventModuleBloc.add(GetTabContent(
                                        tabVal: tabValue,
                                        searchString: eventModuleBloc.searchEventString,
                                        myLearningBloc: myLearningBloc,
                                        pageIndex: 1));
                                  },
                                  icon: Icon(
                                    Icons.tune,
                                    color: AppColors.getFilterIconColor(),
                                  ),
                                ),
                          onSubmitAction: (value) {
                            if (value.toString().length > 0) {
                              eventModuleBloc.isFirstLoading = true;
                              eventModuleBloc.isEventSearch = true;
                              eventModuleBloc.searchEventString = value.toString();
                              eventModuleBloc.add(GetTabContent(
                                  tabVal: tabValue,
                                  searchString: eventModuleBloc.searchEventString,
                                  myLearningBloc: myLearningBloc,
                                  pageIndex: 1));
                            }
                          },
                        )),
                  ),
                  Expanded(
                    flex: 9,
                    child: ResponsiveWidget(
                      mobile: ListView.builder(
                          controller: _sc,
                          scrollDirection: Axis.vertical,
                          itemCount: eventModuleBloc.list.length,
                          itemBuilder: (context, i) {
                            if (eventModuleBloc.list.length == 0) {
                              if (state.status == Status.LOADING && state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Opacity(
                                      opacity: 1.0,
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              }
                              else {
                                return Container();
                              }
                            }
                            else {
                              return widgetMyEventItems(eventModuleBloc.list[i]);
                            }
                          }),
                      tab: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width / 960,
                          ),
                          controller: _sc,
                          scrollDirection: Axis.vertical,
                          itemCount: eventModuleBloc.list.length,
                          itemBuilder: (context, i) {
                            if (eventModuleBloc.list.length == 0) {
                              if (state.status == Status.LOADING &&
                                  state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Opacity(
                                      opacity: 1.0,
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return widgetMyEventItems(eventModuleBloc.list[i]);
                            }
                          }),
                      web: GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 0.6,
                          ),
                          controller: _sc,
                          scrollDirection: Axis.vertical,
                          itemCount: eventModuleBloc.list.length,
                          itemBuilder: (context, i) {
                            if (eventModuleBloc.list.length == 0) {
                              if (state.status == Status.LOADING &&
                                  state is GetTabContentState) {
//                        print("gone in _buildProgressIndicator");
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Center(
                                    child: new Opacity(
                                      opacity: 1.0,
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return widgetMyEventItems(eventModuleBloc.list[i]);
                            }
                          }),
                    ),
                  ),
                ],
              )
            : (state.status == Status.COMPLETED)
                ? Column(
                    children: <Widget>[
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
                            suffixIcon: eventModuleBloc.isEventSearch
                                ? IconButton(
                                    onPressed: () {
                                      //search logic
                                      eventModuleBloc.isFirstLoading = true;
                                      eventModuleBloc.isEventSearch = false;
                                      eventModuleBloc.searchEventString = "";

                                      eventModuleBloc.add(GetTabContent(
                                          tabVal: tabValue,
                                          searchString: eventModuleBloc.searchEventString,
                                          myLearningBloc: myLearningBloc,
                                          pageIndex: 1));
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.getFilterIconColor(),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyLearningFilter(componentId: componentId,)));

                                      eventModuleBloc.isFirstLoading = true;
                                      eventModuleBloc.add(GetTabContent(
                                          tabVal: tabValue,
                                          searchString: eventModuleBloc.searchEventString,
                                          myLearningBloc: myLearningBloc,
                                          pageIndex: 1));
                                    },
                                    icon: Icon(
                                      Icons.tune,
                                      color: AppColors.getFilterIconColor(),
                                    ),
                                  ),
                            onSubmitAction: (value) {
                              if (value.toString().length > 0) {
                                eventModuleBloc.isFirstLoading = true;
                                eventModuleBloc.isEventSearch = true;
                                eventModuleBloc.searchEventString = value.toString();
                                eventModuleBloc.add(GetTabContent(
                                    tabVal: tabValue,
                                    searchString: eventModuleBloc.searchEventString,
                                    myLearningBloc: myLearningBloc,
                                    pageIndex: 1));
                              }
                            },
                          )),
                      Container(
                        child: Center(
                          child: Text(
                              appBloc.localstr.commoncomponentLabelNodatalabel,
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

  Widget displayPast() {
    return Container(
      child: Center(
        child: Text('past'),
      ),
    );
  }

  Widget displayCalendar() {
    TextEditingController _controller;
    if (eventModuleBloc.isEventSearch) {
      _controller =
          TextEditingController(text: eventModuleBloc.searchEventString);
    } else {
      _controller = TextEditingController();
    }
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 250.h,
              child: SfCalendar(
                backgroundColor: InsColor(appBloc).appBGColor,
                view: CalendarView.month,
                cellBorderColor: Colors.transparent,
                //dataSource: MeetingDataSource(_getDataSource()),
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
                onTap: (value) {
                  print("value ${value.date.toString()}");
                },
                onViewChanged: (ViewChangedDetails ee) {
                  String startdate =
                      "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-01";
                  String enddate =
                      "${ee.visibleDates[10].year}-${ee.visibleDates[10].month}-30";
                  print("$startdate ~ $enddate");

                  myLearningBloc.selectedDuration = "$startdate ~ $enddate";
                },
              ),
            ),
          ),
          eventModuleBloc.list.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: eventModuleBloc.list.length,
                  itemBuilder: (context, i) {
                    return widgetMyEventItems(eventModuleBloc.list[i]);
                  })
              : Container()
        ],
      ),
    );
  }

  Widget displayMyEvents() {
    return Container(
      child: Center(
        child: Text('my-events'),
      ),
    );
  }

  Widget displayOthers() {
    return Container(
      child: Center(
        child: Text('other'),
      ),
    );
  }

  void _settingMyEventBottomSheet(
      BuildContext context, DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.viewtype}');

    menu0 = false;
    menu1 = false;
    menu2 = false;
    menu3 = false;
    menu4 = false;
    menu5 = false;
    menu6 = false;
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
        menu2 = true;

        // if (!returnEventCompleted(table2.eventenddatetime) &&
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
          return Container(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  BottomSheetDragger(),
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
                              appBloc.localstr.eventsActionsheetBuynowoption,
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
                            Navigator.of(context).pop();
                            _buyProduct(table2);
                          },
                        )
                      : Container(),
                  menu3
                      ? ListTile(
                          title: Text(
                              appBloc.localstr.eventsActionsheetDetailsoption,
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
                                builder: (context) => ChangeNotifierProvider(
                                      create: (context) => ProviderModel(),
                                      child: CommonDetailScreen(
                                        screenType: ScreenType.Events,
                                        contentid: table2.contentid,
                                        objtypeId: table2.objecttypeid,
                                        detailsBloc: detailsBloc,
                                        table2: table2,
                                        isFromReschedule: false,
                                      ),
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
                              appBloc.localstr.catalogActionsheetWishlistoption,
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
                      ? ListTile(
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
                    title: new Text('Share with Connection',
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
                  ),
                  /*: Container()
                      : Container()*/
                  /*table2.suggestwithfriendlink != null
                      ? (table2.suggestwithfriendlink.isNotEmpty)*/
                  /*?*/ ListTile(
                    leading: Icon(
                      IconDataSolid(int.parse('0xf079')),
                      color: InsColor(appBloc).appIconColor,
                    ),
                    title: new Text("Share with People",
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

  void showCancelEnrollDialog(
      DummyMyCatelogResponseTable2 table2, String isSuccess) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
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
                      ?.apply(color: InsColor(appBloc).appTextColor)),
              backgroundColor: InsColor(appBloc).appBGColor,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              actions: <Widget>[
                new FlatButton(
                  child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
                  textColor: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
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

    /*print("currentdate ${currentdate}");
    print("strDate ${strDate}");*/
    if (currentdate.isAfter(strDate)) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }

    return isCompleted;
  }

  void cancelEnrollment(DummyMyCatelogResponseTable2 table2, String bool) {
    eventModuleBloc.add(TrackCancelEnrollment(
        isBadCancel: bool, strContentID: table2.contentid, table2: table2));
  }

  Widget noDataFound() {
    return Column(
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
    );
  }

  void badCancelEnrollmentMethod(DummyMyCatelogResponseTable2 table2) {
    eventModuleBloc
        .add(BadCancelEnrollment(contentid: table2.contentid, table2: table2));
  }

  List<Meeting> _getDataSource() {
    List<Meeting> meetings = <Meeting>[];

    eventModuleBloc.calanderFilterList.forEach((element) {
      final DateTime today = DateTime.now();

      DateTime startTime = DateTime.now();

      try {
        //print("Date:${element.eventstartdatedisplay}");
        if((element.eventstartdatedisplay?.toString() ?? "").isNotEmpty) startTime = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(element.eventstartdatedisplay);
      }
      catch(e, s) {
        print("Error in Date Format Parsing:$e");
        print(s);
      }

      final DateTime endTime = startTime.add(Duration(hours: 2));
      meetings.add(Meeting(
          "${element.name}",
          startTime,
          startTime,
          Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          false));
    });
    return meetings;
  }

  void addExpiryEvets(DummyMyCatelogResponseTable2 table2, int position) {
    eventModuleBloc
        .add(AddExpiryEvent(table2: table2, strContentID: table2.contentid));
  }

  void addToEnroll(DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.availableseats}');
    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == 'true' && returnEventCompleted(table2.eventenddatetime ?? "")) {
      print("in If");

      try {
        addExpiryEvets(table2, 0);
      } catch (e) {
        e.toString();
      }
    }
    else {
      print("in Else");

      int avaliableSeats = 0;
      avaliableSeats = table2.availableseats ?? 0;

      if (avaliableSeats > 0) {
        catalogBloc.add(
            AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
      else if (table2.viewtype == 1 || table2.viewtype == 2) {
        if (isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
          if (isValidString(table2.actionwaitlist) && table2.actionwaitlist == "true") {
            String alertMessage = appBloc.localstr
                .eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
            showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                      title: Text(
                        appBloc.localstr.eventsActionsheetEnrolloption,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),),
                      ),
                      content: Text(alertMessage,style: TextStyle(color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),)),
                      backgroundColor: InsColor(appBloc).appBGColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5)),
                      actions: <Widget>[
                        new FlatButton(
                          child: Text(appBloc
                              .localstr.mylearningAlertbuttonCancelbutton),
                          textColor: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
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
          }
          else {
            catalogBloc.add(AddToMyLearningEvent(
                contentId: table2.contentid, table2: table2));
          }
        }
//        (isValidString(table2.actionwaitlist) &&
//            table2.actionwaitlist == "true")

      }
      else {
        catalogBloc.add(
            AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
    }
  }

  void addToWaitList(DummyMyCatelogResponseTable2 catalogModel) {
    eventModuleBloc.add(WaitingListEvent(
        strContentID: catalogModel.contentid, table2: catalogModel));
  }

  String getTabValue(String tabId) {
    String tabValue = 'upcoming';

    switch (tabId) {
      case "Upcoming-Courses":
      case "Calendar-Schedule":
        tabValue = "upcoming";

        break;
      case "Calendar-View":
        tabValue = "calendar";

        break;
      case "Past-Courses":
        tabValue = "past";
        break;
      case "My-Events":
        tabValue = "myevents";
        break;
      case "Additional-Program-Details":
        tabValue = "upcoming";
        break;
    }

    return tabValue;
  }

  void checkRelatedContent(DummyMyCatelogResponseTable2 table2) {
    if (isValidString(table2.viewprerequisitecontentstatus ?? "")) {
      String alertMessage = appBloc.localstr.prerequistesalerttitle6Alerttitle6;
      alertMessage = alertMessage +
          " \"" +
          table2.viewprerequisitecontentstatus +
          "\" " +
          appBloc.localstr.prerequistesalerttitle5Alerttitle7;

      showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
                title: Text(
                  appBloc.localstr.detailsAlerttitleStringalert,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(alertMessage),
                backgroundColor: InsColor(appBloc).appBGColor,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5)),
                actions: <Widget>[
                  new FlatButton(
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
            (table2.waitlistlimit ?? 0) - (table2.waitlistenrolls);

        if (waitlistSeatsLeftout > 0) {
          seatVal = 'Full | Waitlist seats $waitlistSeatsLeftout';
        }
      }
    }

    return seatVal;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments?[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments?[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments?[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments?[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments?[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
