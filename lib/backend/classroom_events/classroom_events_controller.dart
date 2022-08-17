import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_admin_web/backend/classroom_events/classroom_events_repository.dart';
import 'package:flutter_admin_web/configs/app_status_codes.dart';
import 'package:flutter_admin_web/configs/app_strings.dart';
import 'package:flutter_admin_web/controllers/navigation_controller.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/catalog_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/event_module/model/people_listing_tab.dart';
import 'package:flutter_admin_web/in_app_purchase_controller.dart';
import 'package:flutter_admin_web/models/app_error_model.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/mytoast.dart';
import 'package:intl/intl.dart';

class ClassroomEventsController extends ChangeNotifier {
  ClassroomEventsRepository eventModuleRepository;

  ClassroomEventsController({
    this.eventModuleRepository = const ClassroomEventsRepository(),
    String searchString = "",
  });

  List<GetPeopleTabListResponse> tabList = [];
  List<DummyMyCatelogResponseTable2> mainEventsList = [], listOfEventsToShow = [];
  bool isFirstLoading = false, isLoadingTabs = false, isLoadingEvents = false, isLoading = false, hasMoreEvents = false;
  String searchEventString = "", calenderSelecteddates = "";
  int pageIndex = 1;
  AppErrorModel? appErrorModel;
  Map<String, ClassroomEventsController> childControllers = <String, ClassroomEventsController>{};

  Future<void> getPeopleListingTabEventHandler({bool isGetFromCache = false}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called wit Event GetPeopleListingTabEvent");

    if(isGetFromCache && tabList.isNotEmpty) {
      return;
    }

    isFirstLoading = true;
    isLoadingTabs = true;
    notifyListeners();

    dynamic response = await eventModuleRepository.getPeopleTabList();

    if(response is List<GetPeopleTabListResponse>) {
      isFirstLoading = false;
      isLoadingTabs = false;
      tabList = response;

      childControllers = {};
      tabList.forEach((element) {
        childControllers[element.tabId] = ClassroomEventsController();
      });
    }
    else if(response is AppErrorModel) {
      if(response.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return;
      }

      appErrorModel = response;
      isFirstLoading = false;
      isLoadingTabs = false;
      tabList = [];
    }
    else {
      appErrorModel = AppErrorModel(
        message: AppStrings.error_in_api_call,
      );
      isFirstLoading = false;
      isLoadingTabs = false;
      tabList = [];
    }
    notifyListeners();
  }

  Future<void> getTabContentEventHandler({
    String tabVal = "",
    String searchString = "",
    required MyLearningBloc myLearningBloc,
    bool isRefresh = true,
    String callenderSelectedDates = "",
    bool isNotify = true,
  }) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called wit Event GetTabContentEvent");

    if (isRefresh) {
      MyPrint.printOnConsole("Refresh");
      isFirstLoading = true;
      isLoadingEvents = false; // track if venues fetching
      hasMoreEvents = true; // flag for more products available or not
      pageIndex = 1;
      listOfEventsToShow = [];

      if (isNotify) notifyListeners();
    }

    if (!hasMoreEvents || isLoadingEvents) return;

    isLoadingEvents = true;
    searchEventString = searchString;
    calenderSelecteddates = callenderSelectedDates;
    if(isNotify) notifyListeners();

    MyPrint.printOnConsole("Current Page Index:$pageIndex");

    dynamic response = await eventModuleRepository.getTabContent(
      pageIndex: pageIndex,
      calenderSelecteddates: calenderSelecteddates,
      searchString: searchEventString,
      myLearningBloc: myLearningBloc,
      tabVal: tabVal,
    );

    if(response is DummyMyCatelogResponseEntity) {
      MyPrint.printOnConsole("Got ${response.table2.length} Events");
      response.table2.forEach((DummyMyCatelogResponseTable2 element) {
        print("In Bloc Id:${element.contentid}, isWishlist:${element.iswishlistcontent}");
      });
      setImageData(response.table2);

      List<DummyMyCatelogResponseTable2> newList = listOfEventsToShow.toList();
      newList.addAll(response.table2);
      MyPrint.printOnConsole("Total Events:${newList.length}");

      isFirstLoading = false;
      isLoadingEvents = false;

      //Currently Disabling Pagination Because this api doen't support this
      hasMoreEvents = false;
      //hasMoreEvents = response.table2.isNotEmpty;

      pageIndex++;
      mainEventsList..clear()..addAll(newList);
      listOfEventsToShow..clear()..addAll(newList);

      /*mainEventsList..clear()..addAll([]);
      listOfEventsToShow..clear()..addAll([]);*/

      MyPrint.printOnConsole("New Page Index:$pageIndex");
    }
    else if(response is AppErrorModel) {
      appErrorModel = response;
      isFirstLoading = false;
      isLoadingEvents = false;
      hasMoreEvents = false;
      pageIndex = 1;
      listOfEventsToShow = [];
      searchEventString = "";
    }
    else {
      appErrorModel = AppErrorModel(
          message: AppStrings.error_in_api_call,
        );
      isFirstLoading = false;
      isLoadingEvents = false;
      hasMoreEvents = false;
      pageIndex = 1;
      listOfEventsToShow = [];
      searchEventString = "";
    }
    notifyListeners();
  }

  Future<void> buyClassroomEventEventHandler({
    required BuildContext context,
    required DummyMyCatelogResponseTable2 product,
  }) async {
    isLoading = true;
    notifyListeners();

    print("Content Id:${product.contentid}");

    String productId = "";

    if(!kIsWeb) {
      if(Platform.isAndroid) {
        productId = product.googleproductid?.toString() ?? "";
      }
      else if(Platform.isIOS) {
        productId = product.itunesproductid?.toString() ?? "";
      }
    }

    String toastMessage = "";
    if(productId.isNotEmpty) {
      print("Product Id:$productId");
      Map<String, ProductDetails> map = await InAppPurchaseController().getProductDetails([productId]);
      print("Product Details Map:$map");

      if(map[productId] != null) {
        ProductDetails productDetails = map[productId]!;

        PurchaseDetails? purchaseDetails = await InAppPurchaseController().buyProduct(productDetails);

        if(purchaseDetails == null) {
          toastMessage = "Purchase Failed";
        }
        else {
          if (purchaseDetails.status == PurchaseStatus.pending) {
            toastMessage = "Purchase Pending";
          }
          else if (purchaseDetails.status == PurchaseStatus.error) {
            if(purchaseDetails.error != null) {
              toastMessage = "Error in Buying Content : '${purchaseDetails.error!.message}'";
            }
            else {
              toastMessage = "Error in Buying Content";
            }
          }
          else if (purchaseDetails.status == PurchaseStatus.purchased) {
            var deviceType = Platform.isAndroid ? "Android" : "IOS";

            String formatted = "";
            try {
              DateTime now = DateTime.now();
              DateFormat formatter = DateFormat("yyyy-MM-dd hh:mm:ss");
              formatted = formatter.format(now);
            }
            catch(e, s) {
              MyPrint.printOnConsole("Error :$e");
              MyPrint.printOnConsole(s);
            }

            CatalogBloc catalogBloc = CatalogBloc(catalogRepository: CatalogRepositoryBuilder.repository());
            catalogBloc.add(SaveInAppPurchaseEvent(
              siteURl: product.siteurl,
              contentID: product.contentid,
              orderId: purchaseDetails.purchaseID ?? "",
              purchaseToken: purchaseDetails.productID,
              // purchaseToken: purchaseDetails.billingClientPurchase.purchaseToken ?? "",
              productId: purchaseDetails.productID,
              purchaseTime: formatted,
              deviceType: deviceType,
            ));

            SaveInAppPurchaseState? saveInAppPurchaseState;

            await for(CatalogState state in catalogBloc.stream) {
              if(state is SaveInAppPurchaseState && [Status.COMPLETED, Status.ERROR].contains(state.status)) {
                saveInAppPurchaseState = state;
                break;
              }
            }

            if(saveInAppPurchaseState != null && AppDirectory.isValidString(saveInAppPurchaseState.response) && saveInAppPurchaseState.response.contains('success')) {
              toastMessage = BlocProvider.of<AppBloc>(context).localstr.catalogAlertsubtitleThiscontentitemhasbeenaddedto;
            }
            else {
              toastMessage = "Product Couldn't Buy";
            }
          }
          else {
            toastMessage = "Product Couldn't Buy";
          }
        }
      }
      else {
        toastMessage = "Product Details Not Available";
      }
    }
    else {
      toastMessage = "Product Id Not Available";
    }

    isLoading = false;
    notifyListeners();

    if(toastMessage.isNotEmpty) {
      MyToast.showToast(context, toastMessage);
    }
  }

  void applyFilterOnEventsByDate({required String startDate}) {
    MyPrint.printOnConsole("applyFilterOnEventsByDate called with startDate:$startDate");

    listOfEventsToShow.clear();
    print("select date ${startDate}");
    mainEventsList.forEach((element) {
      print("select date ${element.eventstartdatedisplay.toString().split("T")[0]}");
      if (startDate == element.eventstartdatedisplay.toString().split("T")[0]) {
        listOfEventsToShow.add(element);
      }
    });
    notifyListeners();
  }

  void setImageData(List<DummyMyCatelogResponseTable2> list) {
    for (DummyMyCatelogResponseTable2 table2 in list) {
      table2.imageData = ApiEndpoints.strSiteUrl + table2.thumbnailimagepath;
    }
  }

  void clearControllersData() {
    tabList = [];
    listOfEventsToShow = [];
    isFirstLoading = false;
    isLoadingTabs = false;
    isLoadingEvents = false;
    isLoading = false;
    hasMoreEvents = false;
    searchEventString = "";
    calenderSelecteddates = "";
    pageIndex = 1;
    appErrorModel = null;
  }
}