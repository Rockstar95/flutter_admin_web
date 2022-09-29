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

import '../../framework/repository/event_module/model/event_recording_resonse.dart';
import '../../framework/repository/event_module/model/session_event_response.dart';
import '../../framework/repository/event_module/model/waiting_list_response.dart';
import '../../models/api_response_model.dart';

class ClassroomEventsController extends ChangeNotifier {
  ClassroomEventsRepository eventModuleRepository;
  Map<String, DummyMyCatelogResponseTable2> mainMapOfEvents = {};

  ClassroomEventsController({
    this.eventModuleRepository = const ClassroomEventsRepository(),
    String searchString = "",
    required this.mainMapOfEvents,
  });

  List<GetPeopleTabListResponse> tabList = [];
  Map<String, ClassroomEventsController> childControllers = <String, ClassroomEventsController>{};

  List<String> mainEventsList = [], listOfEventsToShow = [];
  List<DummyMyCatelogResponseTable2> eventWishlist = [];
  bool isFirstLoading = false, isLoadingTabs = false, isLoadingEvents = false, isLoading = false, hasMoreEvents = false;
  String searchEventString = "", calenderSelecteddates = "";
  int pageIndex = 1;
  AppErrorModel? appErrorModel;

  //To Get Tabs List
  Future<void> getPeopleListingTab({bool isGetFromCache = false}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called wit Event GetPeopleListingTabEvent");

    if(isGetFromCache && tabList.isNotEmpty) {
      return;
    }

    isFirstLoading = true;
    isLoadingTabs = true;
    notifyListeners();

    ApiResponseModel<List<GetPeopleTabListResponse>> response = await eventModuleRepository.getPeopleTabList();

    if(response.data != null) {
      isFirstLoading = false;
      isLoadingTabs = false;
      tabList = response.data!;

      childControllers = {};
      tabList.forEach((element) {
        childControllers[element.tabId] = ClassroomEventsController(mainMapOfEvents: mainMapOfEvents);
      });
    }
    else if(response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return;
      }

      appErrorModel = response.appErrorModel;
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

  //To Get View Link For Recording
  Future<String> viewRecording({required String contentId}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called wit Event viewRecordingEventHandler with contentId:$contentId");

    ApiResponseModel<EventRecordingResponse> response = await eventModuleRepository.viewRecording(contentId: contentId);
    if (response.data != null) {
      EventRecordingResponse recordingResponse = response.data!;

      return recordingResponse.viewLink;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return "";
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in viewRecording:${response.appErrorModel!.stackTrace}");
        return "";
      }
    }
    else {
      return "";
    }
  }

  //To Get Events List for Particular Tab
  Future<void> getTabContent({String tabVal = "", String searchString = "", required MyLearningBloc myLearningBloc, bool isRefresh = true,
    String callenderSelectedDates = "", bool isNotify = true,
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

    ApiResponseModel<DummyMyCatelogResponseEntity> response = await eventModuleRepository.getTabContent(
      pageIndex: pageIndex,
      calenderSelecteddates: calenderSelecteddates,
      searchString: searchEventString,
      myLearningBloc: myLearningBloc,
      tabVal: tabVal,
    );

    if(response.data != null) {
      List<DummyMyCatelogResponseTable2> table2 = response.data!.table2;

      MyPrint.printOnConsole("Got ${table2.length} Events");
      table2.forEach((DummyMyCatelogResponseTable2 element) {
        print("In Bloc Id:${element.contentid}, isWishlist:${element.iswishlistcontent}");
        mainMapOfEvents[element.contentid] = element;
      });
      setImageData(table2);

      List<String> newList = List.from(listOfEventsToShow);
      newList = (newList..addAll(table2.map((e) => e.contentid).toSet())).toSet().toList();
      MyPrint.printOnConsole("Total Events:${newList.length}");

      isFirstLoading = false;
      isLoadingEvents = false;

      //Currently Disabling Pagination Because this api doen't support this
      hasMoreEvents = false;
      //hasMoreEvents = response.table2.isNotEmpty;

      pageIndex++;
      listOfEventsToShow..clear()..addAll(newList);

      MyPrint.printOnConsole("New Page Index:$pageIndex");
    }
    else if(response.appErrorModel != null) {
      appErrorModel = response.appErrorModel;
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

    if(response.appErrorModel?.code == AppApiStatusCodes.TOKEN_EXPIRED) {
      NavigationController().sessionTimeOut();
    }
  }

  //To Mark Event as Download Completed
  Future<bool> downloadComplete({required String contentId, required int scoID}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called wit Event downloadCompleteEventHandler with contentId:$contentId and scoID:$scoID");

    ApiResponseModel<bool> response = await eventModuleRepository.downloadComplete(contentId: contentId, scoID: scoID);
    if (response.data != null) {
      return response.data!;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return false;
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in downloadComplete:${response.appErrorModel!.stackTrace}");
        return false;
      }
    }
    else {
      return false;
    }
  }

  //To Get Event Wishlist Content
  Future<List<DummyMyCatelogResponseTable2>> getEventwishlistContent({String tabVal = "",}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called for getEventwishlistContent with tabVal:$tabVal");

    eventWishlist.clear();

    ApiResponseModel<DummyMyCatelogResponseEntity> response = await eventModuleRepository.getWishlistContent(tabVal: tabVal,);

    if(response.data != null) {
      List<DummyMyCatelogResponseTable2> table2 = response.data!.table2;

      MyPrint.printOnConsole("Got ${table2.length} Events");
      table2.forEach((DummyMyCatelogResponseTable2 element) {
        print("In Bloc Id:${element.contentid}, isWishlist:${element.iswishlistcontent}");
      });
      setImageData(table2);

      eventWishlist = table2;
    }
    else if(response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return [];
      }
      else {
        MyPrint.printOnConsole("Error in Getting Wishlist Content:${response.appErrorModel!.stackTrace}");
      }
    }

    return eventWishlist;
  }

  //To Get Event Session Courses List
  Future<List<CourseList>> getEventSessionCoursesList({required String contentId}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called for getEventSessionCoursesList with contentId:$contentId");

    ApiResponseModel<List<CourseList>> response = await eventModuleRepository.getEventSessionCoursesList(contentId: contentId);

    if (response.data != null) {
      return response.data!;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return [];
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in getEventSessionCoursesList:${response.appErrorModel!.stackTrace}");
        return [];
      }
    }
    else {
      return [];
    }
  }

  //To Cancel Enrollment in events
  Future<bool> cancelEventEnrollment({required String contentId}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called for cancelEventEnrollment with contentId:$contentId");

    isLoading = true;
    notifyListeners();

    ApiResponseModel<bool> response = await eventModuleRepository.cancelEventEnrollment(contentId: contentId);

    isLoading = false;
    notifyListeners();

    if (response.data != null) {
      return response.data!;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return false;
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in cancelEventEnrollment:${response.appErrorModel!.stackTrace}");
        return false;
      }
    }
    else {
      return false;
    }
  }

  //To Cancel Enrollment in Track events
  Future<bool> cancelTrackEventEnrollment({required String contentId, required String isBadCancel}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called for cancelTrackEventEnrollment with contentId:$contentId");

    isLoading = true;
    notifyListeners();

    ApiResponseModel<bool> response = await eventModuleRepository.cancelTrackEventEnrollment(contentId: contentId, isBadCancel: isBadCancel);

    isLoading = false;
    notifyListeners();

    if (response.data != null) {
      return response.data!;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return false;
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in cancelTrackEventEnrollment:${response.appErrorModel!.stackTrace}");
        return false;
      }
    }
    else {
      return false;
    }
  }

  //To Buy Event
  Future<void> buyClassroomEventEventHandler({required BuildContext context, required DummyMyCatelogResponseTable2 product,}) async {
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

  //To Apply Filter on Events by Date
  void applyFilterOnEventsByDate({required String startDate}) {
    MyPrint.printOnConsole("applyFilterOnEventsByDate called with startDate:$startDate");

    listOfEventsToShow.clear();
    print("select date $startDate");
    mainEventsList.forEach((element) {
      DummyMyCatelogResponseTable2? event = mainMapOfEvents[element];
      if(event != null) {
        print("select date ${event.eventstartdatedisplay.toString().split("T")[0]}");
        if (startDate == event.eventstartdatedisplay.toString().split("T")[0]) {
          listOfEventsToShow.add(event.contentid);
        }
      }
    });
    notifyListeners();
  }

  //To Add Expiry on Event
  Future<bool> addExpiryEvents({required String contentId}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called for addExpiryEvents with contentId:$contentId");

    isLoading = true;
    notifyListeners();

    ApiResponseModel<bool> response = await eventModuleRepository.addExpiryEvents(strContentID: contentId);

    isLoading = false;
    notifyListeners();

    if (response.data != null) {
      return response.data!;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
        return false;
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in expiryEvents:${response.appErrorModel!.stackTrace}");
        return false;
      }
    }
    else {
      return false;
    }
  }

  //To Add Event in Waiting List
  Future<WaitingListResponse?> waitingList({required String contentId}) async {
    MyPrint.printOnConsole("ClassroomEventsBloc called for waitingList with contentId:$contentId");

    isLoading = true;
    notifyListeners();

    ApiResponseModel<WaitingListResponse> response = await eventModuleRepository.waitingList(strContentID: contentId);

    isLoading = false;
    notifyListeners();

    if (response.data != null) {
      return response.data!;
    }
    else if (response.appErrorModel != null) {
      if(response.appErrorModel!.code == AppApiStatusCodes.TOKEN_EXPIRED) {
        NavigationController().sessionTimeOut();
      }
      else {
        MyPrint.printOnConsole("Some Error Occurred in waitingList:${response.appErrorModel!.stackTrace}");
      }
    }
  }


  void setImageData(List<DummyMyCatelogResponseTable2> list) {
    for (DummyMyCatelogResponseTable2 table2 in list) {
      table2.imageData = ApiEndpoints.strSiteUrl + table2.thumbnailimagepath;
    }
  }

  static String getTabValue(String tabId) {
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

  void clearControllersData() {
    mainMapOfEvents = {};

    tabList = [];
    mainEventsList = [];
    listOfEventsToShow = [];
    eventWishlist = [];
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