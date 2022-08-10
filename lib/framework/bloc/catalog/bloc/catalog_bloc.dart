import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/add_enroll_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/associatedcontentresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/catalog_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/display_catlog_list.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/event_enrollment_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/file_upload_controls.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/getCategoryForBrowseResponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/prequisitepopupresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/dataprovider/providers/rest_client.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/contract/catalog_repositry.dart';
import 'package:flutter_admin_web/generated/json/dummy_my_catelog_response_entity_helper.dart';

class CatalogBloc extends Bloc<CatalogEVent, CatalogState> {
  CatalogRepository catalogRepository;

  List<GetCategoryForBrowseResponse> mainCatalogList = [];
  List<GetCategoryForBrowseResponse> subCategoryCatalogList = [];
  List<GetCategoryForBrowseResponse> catList = [];
  List<DisplayCatalogData> displayCatalogList = [];
  EventEnrollmentResponse eventEnrollmentResponse = EventEnrollmentResponse();
  AddEnrollResponse addToMyLearningRes = AddEnrollResponse();
  List<FileUploadControls> fileUploadControlslist = [];
  DummyMyCatelogResponseTable2 table2 = DummyMyCatelogResponseTable2();
  List<DummyMyCatelogResponseTable2> catalogCatgorylist = [];
  List<DummyMyCatelogResponseTable2> notificationCatalogCatgorylist = [];
  bool isFirstLoadingCatalog = true;
  int listCatalogTotalCount = 0;
  bool isCatalogSearch = false;
  String searchCatalogString = "";
  CatalogDetailsResponse catalogRes = CatalogDetailsResponse.fromJson({});
  List<DummyMyCatelogResponseTable2> catalogCatgoryWishlist = [];
  bool isFirstLoadingWishCatalog = true;
  int wishlistCatalogTotalCount = 0;
  PrequisitePopupresponse prequisitePopupresponse =
      new PrequisitePopupresponse.fromJson({});
  AssociatedContentResponse associatedContentResponse =
      AssociatedContentResponse.fromJson({});
  List<PrerequisiteModel> prerequisiteModelArrayListRecommended = [];

  // String prerequisiteRecommended;
  List<PrerequisiteModel> prerequisiteModelArrayListRequired = [];

  // String prerequisiteRequired;
  List<PrerequisiteModel> prerequisiteModelArrayListCompletion = [];

  // String prerequisiteCompletion;
  List<String> selectedContent = [];
  var strUserID;

  CatalogBloc({
    required this.catalogRepository,
  }) : super(CatalogState.completed(null)) {
    on<SetCatalogSideMenuEvent>(onEventHandler);
    on<GetCategoryForBrowseEvent>(onEventHandler);
    on<GetCategoryWisecatalogEvent>(onEventHandler);
    on<GetWishListCatalogEvent>(onEventHandler);
    on<AddToMyLearningEvent>(onEventHandler);
    on<AddToWishListEvent>(onEventHandler);
    on<SaveInAppPurchaseEvent>(onEventHandler);
    on<RemoveFromWishListEvent>(onEventHandler);
    on<GetSubcategoryCatalogEvent>(onEventHandler);
    on<LoginSubsiteEvent>(onEventHandler);
    on<GetFileUploadControlsEvent>(onEventHandler);
    on<GetScheduleEvent>(onEventHandler);
    on<AddEnrollEvent>(onEventHandler);
    on<GetPrequisiteDetailsEvent>(onEventHandler);
    on<GetAssociatedContentEvent>(onEventHandler);
    on<GetCatalogDetails>(onEventHandler);
    on<AssociatesAddToMyLearning>(onEventHandler);
  }

  FutureOr<void> onEventHandler(CatalogEVent event, Emitter emit) async {
    print("CatalogBloc onEventHandler called for ${event.runtimeType}");
    Stream<CatalogState> stream = mapEventToState(event);

    bool isDone = false;

    StreamSubscription streamSubscription = stream.listen(
      (CatalogState authState) {
        emit(authState);
      },
      cancelOnError: true,
      onDone: () {
        isDone = true;
      },
    );

    while (!isDone) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    streamSubscription.cancel();
  }

  @override
  CatalogState get initialState => IntitialCatalogStateState.completed("data");

  @override
  Stream<CatalogState> mapEventToState(event) async* {
    try {
      strUserID = await sharePrefGetString(sharedPref_userid);
      if (event is SetCatalogSideMenuEvent) {
        event.listNativeModel.forEach((element) async {
          if (element.displayname == "Catalog") {
            await sharePrefSaveString(
                sharedPref_ComponentID, element.componentId);
            await sharePrefSaveString(
                sharedPref_RepositoryId, element.repositoryId);
            await sharePrefSaveString(
                sharedPref_landingpageType, element.landingpageType);
          }
        });
      }
      else if (event is GetCategoryForBrowseEvent) {
        yield GetCategoryForBrowseState.loading("Loading....");
        try {
          Response? response = await catalogRepository.getCategoryForBrowse();

          if (response?.statusCode == 200) {
            mainCatalogList =
                getCategoryForBrowseResponseFromJson(response?.body ?? "[]");
            print("main List ${mainCatalogList.length}");
            displayCatalogList = getDisplayList(mainCatalogList);

            print("displayCatalogList List ${displayCatalogList.length}");

            yield GetCategoryForBrowseState.completed(list: displayCatalogList);
          } else if (response?.statusCode == 401) {
            yield GetCategoryForBrowseState.error("401");
          } else {
            yield GetCategoryForBrowseState.error("Error");
          }
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is GetCategoryWisecatalogEvent) {
        try {
          yield GetCategoryWisecatalogState.loading("Loading....");
          String selectedSortName;
          String selectedGroupby;
          String selectedcategories;
          String selectedobjectTypes;
          String selectedskillCats;
          String selectedjobRoles;
          String selectedCredits;
          String selectedRating;
          String selectedinstructer;
          String selectedPriceRange;
          String learningprotals;

          if (event.myLearningBloc.selectedSortName == "") {
            // selectedSortName = "C.Name asc";
            selectedSortName =
                event.sortBy == null ? 'C.Name asc' : event.sortBy;
          } else {
            selectedSortName = event.myLearningBloc.selectedSort;
          }

          if (event.myLearningBloc.selectedlearningproviders.length != 0 &&
              event.myLearningBloc.selectedSortName == "") {
            selectedSortName = "";
          }
          selectedGroupby = event.myLearningBloc.selectedGroupby;
          selectedcategories =
              event.myLearningBloc.selectedcategories.length != 0
                  ? formatString(event.myLearningBloc.selectedcategories)
                  : "";
          selectedobjectTypes =
              event.myLearningBloc.selectedobjectTypes.length != 0
                  ? formatString(event.myLearningBloc.selectedobjectTypes)
                  : "";
          selectedskillCats = event.myLearningBloc.selectedskillCats.length != 0
              ? formatString(event.myLearningBloc.selectedskillCats)
              : "";
          selectedjobRoles = event.myLearningBloc.selectedjobRoles.length != 0
              ? formatString(event.myLearningBloc.selectedjobRoles)
              : "";
          selectedCredits = event.myLearningBloc.selectedCredits;
          selectedRating = event.myLearningBloc.selectedRating;
          selectedPriceRange = event.myLearningBloc.selectedPriceRange;
          selectedinstructer =
              event.myLearningBloc.selectedinstructer.length != 0
                  ? formatString(event.myLearningBloc.selectedinstructer)
                  : "";
          learningprotals =
              event.myLearningBloc.selectedlearningproviders.length != 0
                  ? formatString(event.myLearningBloc.selectedlearningproviders)
                  : "";

          Response? response =
              await catalogRepository.getMobileMyCatalogObjectsData(
                  event.pageIndex,
                  event.categaoryID,
                  event.serachString,
                  false,
                  selectedSortName,
                  selectedGroupby,
                  selectedcategories,
                  selectedobjectTypes,
                  selectedskillCats,
                  selectedjobRoles,
                  selectedCredits,
                  selectedinstructer,
                  selectedRating,
                  learningprotals.replaceAll(" ", ""),
                  "",
                  selectedPriceRange,
                  '',
                  '');

          print("CatalogList category  statusCode ${response?.statusCode}");
          print("CatalogList category  Response ${response?.body}");

          if (response?.statusCode == 200) {
            DummyMyCatelogResponseEntity myCatelogResponseEntity =
                new DummyMyCatelogResponseEntity();
            Map valueMap = json.decode(response?.body ?? "{}");
            myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(
                myCatelogResponseEntity, Map.castFrom(valueMap));
            // print("Catalog  totalrecordscount ${myCatelogResponseEntity.table[0].totalrecordscount}");
            print("Catalog size ${myCatelogResponseEntity.table2}");

            if (myCatelogResponseEntity.table != null) {
              if (myCatelogResponseEntity.table.isNotEmpty) {
                listCatalogTotalCount =
                    myCatelogResponseEntity.table[0].totalrecordscount;
                catalogCatgorylist = myCatelogResponseEntity.table2;
              }
            }

            yield GetCategoryWisecatalogState.completed(
                list: catalogCatgorylist);
          } else if (response?.statusCode == 401) {
            yield GetCategoryWisecatalogState.error("401");
          } else {
            yield GetCategoryWisecatalogState.error("Error");
          }
        } catch (e, s) {
          print("Error:$e");
          print(s);
        }
      }
      else if (event is GetWishListCatalogEvent) {
        try {
          yield GetWishListCatalogState.loading("Loading....");
          Response? response =
              await catalogRepository.getMobileMyCatalogObjectsData(
                  event.pageIndex,
                  event.categaoryID,
                  "",
                  true,
                  "c.name",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  event.type,
                  "",
                  event.compid.toString(),
                  event.compinsid.toString());

          print(" wise statusCode ${response?.statusCode}");
          print(" wise Response ${response?.body}");

          DummyMyCatelogResponseEntity myCatelogResponseEntity =
              new DummyMyCatelogResponseEntity();
          Map valueMap = json.decode(response?.body ?? "{}");
          myCatelogResponseEntity = dummyMyCatelogResponseEntityFromJson(
              myCatelogResponseEntity, Map.castFrom(valueMap));

          if (response?.statusCode == 200) {
            print(
                "wise totalrecordscount ${myCatelogResponseEntity.table[0].totalrecordscount}");
            print(
                "wise catalogCatgoryWishlist size ${myCatelogResponseEntity.table2.length}");
            wishlistCatalogTotalCount =
                myCatelogResponseEntity.table[0].totalrecordscount;
            catalogCatgoryWishlist = myCatelogResponseEntity.table2;

            yield GetWishListCatalogState.completed(
                list: catalogCatgoryWishlist);
          } else if (response?.statusCode == 401) {
            yield GetWishListCatalogState.error("401");
          } else {
            yield GetWishListCatalogState.error("Error");
          }
        } catch (e, s) {
          print("Error:$e");
          print(s);
        }
      }
      else if (event is AddToMyLearningEvent) {
        try {
          yield AddToMyLearningState.loading('Please wait...');

          // var strUserID = await sharePref_getString(sharedPref_userid);
          // var strSiteID = await sharePref_getString(sharedPref_siteid);
          var strSiteUrl = ApiEndpoints.strSiteUrl;
          String urlStr =
              "${ApiEndpoints.addToMyLearning(event.contentId, event.table2.userid.toString(), '${event.table2.siteid.toString()}', strSiteUrl, '')}";

          print('AddToMyLearningEvent $urlStr');

          Response? response = await RestClient.getPostData(urlStr);

          print('Catalog Bloc AddToMyLearningEvent Response Status:${response?.statusCode}, Body:${response?.body}');
          if (response?.statusCode == 200) {
            if ((response?.body ?? "") == 'true') {
              table2 = event.table2;
              yield AddToMyLearningState.completed(
                  isScusses: true, table2: event.table2);
            }
            else {
              yield AddToMyLearningState.error("Error");
            }
          }
          else if (response?.statusCode == 401) {
            yield AddToMyLearningState.error("401");
          }
          else {
            yield AddToMyLearningState.error("Error");
          }
        } catch (e, s) {
          print("log $e");
          print(s);
          yield AddToMyLearningState.error("Error  $e");
        }
      }
      else if (event is AddToWishListEvent) {
        yield AddToWishListState.loading("Loading....");
        try {
          Response? response = await catalogRepository.addToWishList(event.contentId);

          if (response?.statusCode == 200) {
            yield AddToWishListState.completed(isScusses: true, contentId: event.contentId);
          }
          else if (response?.statusCode == 401) {
            yield AddToWishListState.error("401");
          }
          else {
            yield AddToWishListState.error("Error");
          }
        }
        catch (e, s) {
          print(s);
        }
      }
      else if (event is RemoveFromWishListEvent) {
        yield RemoveFromWishListState.loading("Loading....");
        try {
          Response? response =
              await catalogRepository.removeFromWishList(event.contentId);

          if (response?.statusCode == 200) {
            yield RemoveFromWishListState.completed(isScusses: true);
          } else if (response?.statusCode == 401) {
            yield RemoveFromWishListState.error("401");
          } else {
            yield RemoveFromWishListState.error("Error");
          }
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is GetSubcategoryCatalogEvent) {
        yield GetSubcategoryCatalogState.loading("Loading....");
        subCategoryCatalogList.clear();
        GetCategoryForBrowseResponse pojo =
            new GetCategoryForBrowseResponse.fromJson({});
        pojo.categoryName = event.categaoryName;
        pojo.categoryId = event.categaoryID;
        catList.add(pojo);

        bool isAdded = true;
        List<GetCategoryForBrowseResponse> temp = [];

        catList.forEach((element) {
          if (isAdded) {
            temp.add(element);
          }
          if (event.categaoryName == element.categoryName) {
            isAdded = false;
          }
        });
        catList.clear();

        temp.forEach((element) {
          catList.add(element);
        });

        mainCatalogList.forEach((element) {
          if (event.categaoryID == element.parentId) {
            subCategoryCatalogList.add(element);
          }
        });
        yield GetSubcategoryCatalogState.completed(
            subCategoryCatalogList: subCategoryCatalogList);
      }
      else if (event is LoginSubsiteEvent) {
        yield SubSignInState.loading('Loading...please wait');

        Response? response = await catalogRepository.doSubSiteLogin(event.email,
            event.password, event.subSiteUrl, 'true', event.subSiteId);

        if (response?.statusCode == 200) {
          print(response?.body);

          // SubsiteLoginResponse subsiteLoginResponse =
          //     loginResponseFromJson(response.toString());
          yield SubSignInState.completed(
              response: response?.body ?? "", table2: event.table2);
        } else if (response?.statusCode == 401) {
          yield SubSignInState.error("401");
        } else {
          yield SubSignInState.error("Error");
        }

        // if (loggedIn) {
        //   yield SubSignInState.completed(isLoggedin: loggedIn);
        // } else {
        //   yield SubSignInState.error(
        //       event.localStr.loginAlerttitleSigninfailed);
        // }

      }
      else if (event is GetFileUploadControlsEvent) {
        yield GetFileUploadControlsState.loading('loading');
        try {
          Response? response = await catalogRepository.getFileUploadControls(
              event.siteId, event.localeId, event.compInsId);

          if (response?.statusCode == 200) {
            var jsonArray =
                new List<dynamic>.from(jsonDecode(response?.body ?? "[]"));

            fileUploadControlslist = jsonArray
                .map((e) => new FileUploadControls.fromJson(e))
                .toList();

            print("main List ${mainCatalogList.length}");

            print("displayCatalogList List ${fileUploadControlslist.length}");

            yield GetFileUploadControlsState.completed(
                fileUploadControlslist: fileUploadControlslist);
          } else if (response?.statusCode == 401) {
            yield GetFileUploadControlsState.error("401");
          } else {
            yield GetFileUploadControlsState.error("Error");
          }
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is GetPrequisiteDetailsEvent) {
        yield GetPrequisiteDetailsState.loading("Loading...");
        try {
          Response? response = await catalogRepository.getPrerequisiteDetails(
              event.contentId, event.userID);
          if (response?.statusCode == 200) {
            Map valueMap = json.decode(response?.body ?? "{}");

            prequisitePopupresponse =
                PrequisitePopupresponse.fromJson(Map.castFrom(valueMap));

            yield GetPrequisiteDetailsState.completed(prequisitePopupresponse: prequisitePopupresponse, contentId: event.contentId);
          } else if (response?.statusCode == 401) {
            yield GetPrequisiteDetailsState.error("401");
          } else {
            yield GetPrequisiteDetailsState.error("Error");
          }
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is GetAssociatedContentEvent) {
        yield GetAssociatedContentState.loading("Loading...");
        try {
          Response? response = await catalogRepository.getAssociatedContent(
            event.contentID,
            event.componentID,
            event.componentInstanceID,
            event.instancedata,
            event.preRequisiteSequncePathID,
          );
          log("GetAssociatedContent Response Status:${response?.statusCode}, Body:${response?.body}");
          if (response?.statusCode == 200) {
            Map valueMap = json.decode(response?.body ?? "{}");

            associatedContentResponse =
                AssociatedContentResponse.fromJson(Map.castFrom(valueMap));
            prerequisiteModelArrayListRecommended.clear();
            prerequisiteModelArrayListRequired.clear();
            prerequisiteModelArrayListCompletion.clear();
            associatedContentResponse.courseList.forEach((element) {
              if (element.prerequisites == 1) {
                // prerequisiteRecommended = event
                //     .localStr.prerequistes_recommendedtitle_recommendedtitlelbl;
                prerequisiteModelArrayListRecommended.add(element);
              } else if (element.prerequisites == 2) {
                // prerequisiteRequired =
                //     LocalStr().prerequisHeaderlabelHeadertitle;
                prerequisiteModelArrayListRequired.add(element);
              } else if (element.prerequisites == 3) {
                // prerequisiteCompletion =
                //     LocalStr().prerequisHeaderlabelHeadertitle;
                prerequisiteModelArrayListCompletion.add(element);
              }
            });

            yield GetAssociatedContentState.completed(
                associatedContentResponse: associatedContentResponse);
          } else if (response?.statusCode == 401) {
            yield GetAssociatedContentState.error("401");
          } else {
            yield GetAssociatedContentState.error("Error");
          }
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is GetScheduleEvent) {
        yield GetScheduleDataState.loading('loading....');
        try {
          Response? response = await catalogRepository.getScheduleData(
              eventID: event.eventID,
              multiInstanceEventEnroll: event.multiInstanceEventEnroll,
              multiLocation: event.multiLocation);

          if (response?.statusCode == 200) {
            eventEnrollmentResponse = eventEnrollmentResponseFromJson(response?.body ?? "{}");
            yield GetScheduleDataState.completed(
                eventEnrollmentResponse: EventEnrollmentResponse());
          }
          else if (response?.statusCode == 401) {
            yield GetScheduleDataState.error('401');
          }
          else {
            yield GetScheduleDataState.error('Something went wrong');
          }
          log('GetScheduleEvent response Status:${response?.statusCode}, Body:${response?.body}');
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is AddEnrollEvent) {
        yield AddEnrollState.loading('loading....');
        try {
          Response? apiResponse = await catalogRepository.addToEnrollContent(
              selectedContent: event.selectedContent,
              componentID: event.componentID,
              componentInsID: event.componentInsID,
              additionalParams: event.additionalParams,
              targetDate: event.targetDate,
              rescheduleEnroll: event.rescheduleenroll);
          if (apiResponse?.statusCode == 200) {
            addToMyLearningRes = addEnrollResponseFromJson(apiResponse?.body ?? "{}");
            yield AddEnrollState.completed();
          }
          else if (apiResponse?.statusCode == 401) {
            yield AddEnrollState.error('401');
          }
          else {
            yield AddEnrollState.error('Something went wrong');
          }
          print('reponse ${apiResponse?.body}');
        } catch (e, s) {
          print(s);
        }
      }
      else if (event is GetCatalogDetails) {
        yield GetCatalogDetailsState.loading('Please wait');

        Response? apiResponse = await catalogRepository
            .getCatalogDetails(event.myLearningDetailsRequest);
        if (apiResponse?.statusCode == 200) {
          catalogRes =
              catalogDetailsResponseFromJson(apiResponse?.body ?? "{}");
          //setDetailsData(response);
          yield GetCatalogDetailsState.completed(data: catalogRes);
        } else if (apiResponse?.statusCode == 401) {
          yield GetCatalogDetailsState.error('401');
        } else {
          yield GetCatalogDetailsState.error('Something went wrong');
        }
        print('apiresposne ${apiResponse?.body}');
      }
      else if (event is SaveInAppPurchaseEvent) {
        yield SaveInAppPurchaseState.loading("Loading....");
        try {
          Response? response = await catalogRepository.saveInAppPurchaseDetails(
              event.userId,
              event.siteURl,
              event.contentID,
              event.orderId,
              event.purchaseToken,
              event.productId,
              event.purchaseTime,
              event.deviceType);
          print("saveInAppPurchaseDetails response status:${response?.statusCode}, Body:${response?.body}");

          if (response?.statusCode == 200) {
            /*var jsonenccodedat = json.encode(response.data);

            mainCatalogList = getCategoryForBrowseResponseFromJson(jsonenccodedat.toString());
            print("main List ${mainCatalogList.length}");
            displayCatalogList = getDisplayList(mainCatalogList);

            print("displayCatalogList List ${displayCatalogList.length}");*/

            yield SaveInAppPurchaseState.completed(response: response?.body ?? "{}");
          }
          else if (response?.statusCode == 401) {
            yield SaveInAppPurchaseState.error("401");
          }
          else {
            yield SaveInAppPurchaseState.error("Error");
          }
        }
        catch (e, s) {
          print(s);
          yield SaveInAppPurchaseState.error("Error");
        }
      }
      else if (event is AssociatesAddToMyLearning) {
        yield AssociatedAddToMyLearning.loading("Loading....");

        Response? response = await catalogRepository.associatedAddToMyLearning(
            selectedContent: event.selectedContent,
            componentID: event.componentID,
            componentInsID: event.componentInsID,
            additionalParams: event.additionalParams,
            addLearnerPreRequisiteContent: event.addLearnerPreRequisiteContent,
            addMultiInstancesWithPrice: event.addMultiinstanceswithprice,
            addWaitListContentIDs: event.addWaitlistContentIDs,
            multiInstanceEventEnroll: event.multiInstanceEventEnroll);

        if (response?.statusCode == 200) {
          // var jsonenccodedat = json.encode(response.data);
          //
          // mainCatalogList =
          //     getCategoryForBrowseResponseFromJson(jsonenccodedat.toString());
          // print("main List ${mainCatalogList.length}");
          // displayCatalogList = getDisplayList(mainCatalogList);
          //
          // print("displayCatalogList List ${displayCatalogList.length}");

          yield AssociatedAddToMyLearning.completed(data: response?.body ?? "");
        } else if (response?.statusCode == 401) {
          yield AssociatedAddToMyLearning.error("401");
        } else {
          yield AssociatedAddToMyLearning.error("Error");
        }
      }
    } catch (e, s) {
      print("Error in CatalogBloc.mapEventToState():$e");
      print(s);

      yield SubSignInState.error(e.toString());
    }
  }

  List<DisplayCatalogData> getDisplayList(
      List<GetCategoryForBrowseResponse> mainCatalogList) {
    List<DisplayCatalogData> displaylist = [];

    for (int i = 0; i < mainCatalogList.length; i++) {
      if (mainCatalogList[i].parentId == 0 && mainCatalogList[i].hasChild) {
        DisplayCatalogData data = new DisplayCatalogData();
        data.parentId = mainCatalogList[i].parentId;
        data.categoryName = mainCatalogList[i].categoryName;
        data.categoryId = mainCatalogList[i].categoryId;
        data.categoryIcon = mainCatalogList[i].categoryIcon;
        data.hasChild = mainCatalogList[i].hasChild;
        data.isChecked = mainCatalogList[i].isChecked;

        List<GetCategoryForBrowseResponse> subcategoryList1 = [];
        for (int j = 0; j < mainCatalogList.length; j++) {
          if (mainCatalogList[i].categoryId == mainCatalogList[j].parentId) {
            subcategoryList1.add(mainCatalogList[j]);
          }
        }

        data.subcategoryList = subcategoryList1;
        displaylist.add(data);
      }
    }
    return displaylist;
  }

  String formatString(List x) {
    String formatted = '';
    for (var i in x) {
      //formatted += '$i\u0024';
      formatted += '$i, ';
    }
    return formatted.replaceRange(formatted.length - 2, formatted.length, '');
  }

  String formatMainString(List x) {
    String formatted = '';
    for (var i in x) {
      //formatted += '$i\u0024';
      formatted += '$i\$';
    }
    return formatted.replaceRange(formatted.length - 1, formatted.length, '');
  }
}
