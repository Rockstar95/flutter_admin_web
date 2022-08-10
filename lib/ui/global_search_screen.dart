import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/discussion/model/discussion_main_home_response.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/bloc/event_module_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/event/event_module_event.dart';
import 'package:flutter_admin_web/framework/bloc/event_module/state/event_module_state.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/global_search_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/global_search_event.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/global_search_state.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/model/search_component_response.dart';
import 'package:flutter_admin_web/framework/bloc/globalSearch/model/search_result_response.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/providermodel.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/catalog_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/event_module/provider/event_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/globalSearch/globalSearch_repository_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Discussions/discussion_main_home.dart';
import 'package:flutter_admin_web/ui/MyLearning/my_learning_home.dart';
import 'package:flutter_admin_web/ui/myConnections/connection_index_screen.dart';
import 'package:flutter_admin_web/ui/profile/profile_page.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'Catalog/catalog_refresh.dart';
import 'Catalog/wish_list.dart';
import 'Discussions/discussion_forum_topic.dart';
import 'Events/event_main_page.dart';
import 'Events/event_wishlist.dart';
import 'MyLearning/common_detail_screen.dart';
import 'MyLearning/share_mainscreen.dart';
import 'MyLearning/wait_list.dart';
import 'askTheExpert/user_questions_list.dart';
import 'common/bottomsheet_drager.dart';
import 'common/common_toast.dart';
import 'common/outline_button.dart';

class GlobalSearchScreen extends StatefulWidget {
  final bool isAutomaticSearch;
  final String fType;
  final String fValue;
  final int menuId;

  const GlobalSearchScreen(
      {Key? key,
      this.isAutomaticSearch = false,
      this.fType = '',
      this.fValue = '',
      this.menuId = 0})
      : super(key: key);

  @override
  _GlobalSearchScreenState createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  late CatalogBloc
      catalogBloc; //get catalogBloc => BlocProvider.of<CatalogBloc>(context);
  late EvntModuleBloc eventModuleBloc;

  late MyLearningDetailsBloc myLearningDetailsBloc;

  // GlobalSearchBloc get globalSearchBloc =>
  //     BlocProvider.of<GlobalSearchBloc>(context);

  late GlobalSearchBloc globalSearchBloc;
  TextEditingController _controller = TextEditingController();

  String fType = '';
  String fValue = '';
  int componentID = 0;
  int componentInstanceID = 0;
  int pageIndex = 1;
  bool showFilterView = true;
  bool _seeAll = true;
  bool _currentPageKey = true;
  late FToast flutterToast;

  Map<String, String> filterMenus = {};
  bool isConsolidated = false;

  @override
  void initState() {
    globalSearchBloc = GlobalSearchBloc(
        globalSearchRepository: GlobalSearchRepositoryBuilder.repository());

    myLearningDetailsBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());

    eventModuleBloc = EvntModuleBloc(
        eventModuleRepository: EventRepositoryBuilder.repository());

    catalogBloc =
        CatalogBloc(catalogRepository: CatalogRepositoryBuilder.repository());

    _controller = TextEditingController();
    globalSearchBloc.isFirstLoading = true;
    globalSearchBloc.add(GetSearchComponentListEvent());
    showFilterView = !widget.isAutomaticSearch;

    filterMenus = getConditionsValue();
    super.initState();
  }

  //TODO: Height calculation for search component by group
  int componentHeight(int compCount) {
    switch (compCount) {
      case 1:
        return 100;
      case 2:
        return 140;
      case 3:
        return 190;
      default:
        return compCount * 58;
    }
  }

  Map<String, String> getConditionsValue() {
    var strConditions;
    appBloc.listNativeModel.forEach((element) {
      if (element.contextTitle == "Catalog") {
        strConditions = element.conditions;
      }
    });
    print("--- strConditions ---- $strConditions");

    if (strConditions != null && strConditions != "") {
      if (strConditions.contains("#@#")) {
        var conditionsArray = strConditions.split("#@#");
        int conditionCount = conditionsArray.length;
        if (conditionCount > 0) {
          filterMenus = generateHashMap(conditionsArray);
        }
      }
    }

    ///Check Consolidated from menu
    if (filterMenus != null && filterMenus.containsKey("Type")) {
      String consolidatedType = filterMenus["Type"] ?? "";
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

    return filterMenus;
  }

  Map<String, String> generateHashMap(List<String> conditionsArray) {
    Map<String, String> map = new Map();
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

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    print("showFilterView:$showFilterView");

    return Scaffold(
      backgroundColor: InsColor(appBloc).appBGColor,
      /*
      appBar: AppBar(
        iconTheme: new IconThemeData(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        elevation: 0,
      ),
      */
      body: SafeArea(
        child: Container(
          color: InsColor(appBloc).appBGColor,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: InsColor(appBloc).appIconColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextField(
                        controller: _controller,
                        cursorColor: InsColor(appBloc).appTextColor,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.apply(color: InsColor(appBloc).appTextColor),
                        decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8),
                            focusedBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: InsColor(appBloc).appTextColor)),
                            enabledBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: InsColor(appBloc).appTextColor)),
                            hintText: appBloc
                                .localstr.commoncomponentLabelSearchlabel,
                            hintStyle: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                            suffixIcon: Visibility(
                              visible:
                                  (globalSearchBloc.searchString.length) > 0,
                              child: IconButton(
                                onPressed: () {
                                  _controller.clear();
                                  //this.searchAction('');
                                  setState(() {
                                    globalSearchBloc.searchResultList = [];
                                    showFilterView = false;
                                    globalSearchBloc.clearSearchResult = true;
                                    globalSearchBloc.searchString = '';
                                  });
                                },
                                color: InsColor(appBloc).appTextColor,
                                icon: Icon(
                                  Icons.close,
                                  color: InsColor(appBloc).appIconColor,
                                ),
                              ),
                            )),
                        onSubmitted: (value) {
                          if (value.toString().length > 0) {
                            //connectionsBloc.isArchiveFirstLoading = true;
                            this.searchAction(value.toString());
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.tune),
                    color: InsColor(appBloc).appTextColor,
                    onPressed: () {
                      setState(() {
                        showFilterView = !showFilterView;
                      });
                    },
                  )
                ],
              ),
              if (showFilterView)
                BlocConsumer<GlobalSearchBloc, GlobalSearchState>(
                  bloc: globalSearchBloc,
                  listener: (context, state) {
                    if (state.status == Status.ERROR) {
                      if (state.message == "401") {
                        AppDirectory.sessionTimeOut(context);
                      }
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      child: Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(children: [
                                Checkbox(
                                  value: _seeAll,
                                  onChanged: (val) {
                                    setState(() {
                                      _seeAll = val ?? false;
                                      _seeAllValueAction();
                                    });
                                  },
                                ),
                                Text(
                                  'All',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.apply(
                                          color:
                                              InsColor(appBloc).appTextColor),
                                )
                              ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(children: [
                                Checkbox(
                                  value: _currentPageKey,
                                  onChanged: (val) {
                                    setState(() {
                                      _currentPageKey = val ?? false;
                                      _currentPageValueAction();
                                    });
                                  },
                                ),
                                Text(_currentScreenName(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.apply(
                                            color:
                                                InsColor(appBloc).appTextColor))
                              ]),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    globalSearchBloc.searchComponents.length,
                                itemBuilder: (context, index) {
                                  var component =
                                      globalSearchBloc.searchComponents;
                                  return Container(
                                      padding: EdgeInsets.all(8),
                                      height: componentHeight(component.values
                                              .toList()[index]
                                              .length)
                                          .toDouble(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: Text(
                                              component.keys.toList()[index],
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: component.values
                                                  .toList()[index]
                                                  .length,
                                              itemBuilder: (context, i) {
                                                var value = component.values
                                                    .toList()[index][i];
                                                return Row(children: [
                                                  Checkbox(
                                                    value: value.check,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        value.check =
                                                            val ?? false;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    value.displayName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        ?.apply(
                                                            color: InsColor(
                                                                    appBloc)
                                                                .appTextColor),
                                                  )
                                                ]);
                                              },
                                            ),
                                          )
                                        ],
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              else
                BlocConsumer<GlobalSearchBloc, GlobalSearchState>(
                    bloc: globalSearchBloc,
                    listener: (context, state) {
                      if (state.status == Status.ERROR) {
                        if (state.message == "401") {
                          AppDirectory.sessionTimeOut(context);
                        }
                      }

                      if (state.status == Status.COMPLETED &&
                          state is GetSearchComponentState) {
                        if (widget.isAutomaticSearch) {
                          fType = widget.fType;
                          fValue = widget.fValue;
                          searchAction('');
                        }
                      }
                    },
                    builder: (context, state) {
                      print("isFirstLoading:${globalSearchBloc.isFirstLoading}");
                      print("GlobalBloc state:${state.runtimeType}, Status:${state.status}");

                      if (globalSearchBloc.isFirstLoading || state.status == Status.LOADING) {
                        return Expanded(
                          child: Center(
                            child: AbsorbPointer(
                              child: SpinKitCircle(
                                color: Colors.grey,
                                size: 70,
                              ),
                            ),
                          ),
                        );
                      }
                      else if (globalSearchBloc.searchResultList.length == 0) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/empty_data.svg',
                                    width: 220.w, height: 220.h),
                                SizedBox(height: 8),
                                Text('No Result found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.apply(
                                            color:
                                                InsColor(appBloc).appTextColor))
                              ],
                            ),
                          ),
                        );
                      }

                      return Container(
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: globalSearchBloc.searchResultList.length,
                            itemBuilder: (context, index) {
                              var searchResult = globalSearchBloc.searchResultList[index];

                              return Container(
                                  padding: EdgeInsets.all(8),
                                  height: (searchResult.courseList.length * 106.0) + 120,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Text(
                                          "${searchResult.searchComponent.displayName} - ${searchResult.searchComponent.siteName}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              ?.apply(color: Colors.orange),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: searchResult.courseList.length,
                                          itemBuilder: (context, i) {
                                            CourseList value = searchResult.courseList[i];
                                            //print("Description:${value.title}, View Type: ${value.viewType}");

                                            return Container(
                                              height: 100,
                                              padding: EdgeInsets.all(4),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: InsColor(appBloc)
                                                    .appBGColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                    bottomRight:
                                                        Radius.circular(8.0),
                                                    topRight:
                                                        Radius.circular(8.0)),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      offset: Offset(1.1, 1.1),
                                                      blurRadius: 2.0),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 3,
                                                      child: Center(
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              Color(0xffFDCF09),
                                                          child: CircleAvatar(
                                                            radius: 30,
                                                            backgroundImage: NetworkImage(value
                                                                    .thumbnailImagePath
                                                                    .contains(
                                                                        'http')
                                                                ? '${value.thumbnailImagePath}'
                                                                : '${ApiEndpoints.strSiteUrl}${value.thumbnailImagePath}'),
                                                            backgroundColor:
                                                                Color(int.parse(
                                                                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"))
                                                                    .withAlpha(
                                                                        1000),
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                                _contentValue(
                                                                    searchResult
                                                                        .searchComponent,
                                                                    value)[0],
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline2
                                                                    ?.apply(
                                                                        color:
                                                                            InsColor(appBloc).appTextColor)),
                                                          ),
                                                          SizedBox(height: 8),
                                                          Text(
                                                              _contentValue(
                                                                  searchResult
                                                                      .searchComponent,
                                                                  value)[1],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  ?.apply(
                                                                      color: InsColor(appBloc)
                                                                          .appTextColor
                                                                          .withAlpha(900))),
                                                          Text(
                                                              _contentValue(
                                                                  searchResult
                                                                      .searchComponent,
                                                                  value)[2],
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  ?.apply(
                                                                      color:
                                                                          InsColor(appBloc).appTextColor)),
                                                        ],
                                                      ),
                                                      //color: Colors.red,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons
                                                              .more_vert_rounded,
                                                          color: InsColor(
                                                                  appBloc)
                                                              .appIconColor),
                                                      onPressed: () {
                                                        _showOptions(
                                                            value,
                                                            searchResult
                                                                .searchComponent);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Center(
                                          // width: MediaQuery.of(context)
                                          //         .size
                                          //         .width -
                                          //     16,
                                          child: OutlineButton(
                                            border: Border.all(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                            //color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                            child: Text('See All',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                            onPressed: () async {
                                              _viewAllAction(
                                                  searchResult, context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        ),
                      );
                    })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _viewAllAction(SearchResultModel searchResult, BuildContext context) async {
    Widget? selectedWidget;

    print("Menu Id:${searchResult.searchComponent.menuId}");

    switch (searchResult.searchComponent.menuId) {
      case 3219:
        selectedWidget = ChangeNotifierProvider(
            create: (context) => ProviderModel(), child: EventMainPage(enableSearching: false, searchString: globalSearchBloc.searchString,));
        break;
      case 50014:
        appBloc.listNativeModel.forEach((element) async {
          if (element.contextmenuId == '4') {
            await sharePrefSaveString(
                sharedPref_ComponentID, element.componentId);
            await sharePrefSaveString(
                sharedPref_RepositoryId, element.repositoryId);
          }
        });
        selectedWidget = DiscussionMain(
          searchString: globalSearchBloc.searchString,
          enableSearching: false,
        );
        break;
      case 3093:
        selectedWidget = ActMyLearning(
          nativeModel: NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0),
          contentId: "",
        );
        break;
      case 3185:
        selectedWidget = ConnectionIndexScreen(
          searchString: globalSearchBloc.searchString,
        );
        break;
      case 50005: //Documents
        NativeMenuModel nativeMenuModel = NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0);
        appBloc.listNativeModel.forEach((element) async {
          if (element.displayname == searchResult.searchComponent.displayName) {
            nativeMenuModel = element;
            await sharePrefSaveString(
                sharedPref_ComponentID, element.componentId);
            await sharePrefSaveString(
                sharedPref_RepositoryId, element.repositoryId);
          }
        });
        // selectedWidget = CatalogRefreshScreen(
        //     categaoryID: 0,
        //     categaoryName: '',
        //     nativeMenuModel: nativeMenuModel);

        selectedWidget = ChangeNotifierProvider(
          create: (context) => ProviderModel(),
          child: CatalogRefreshScreen(
            categaoryID: 0,
            categaoryName: "",
            nativeMenuModel: nativeMenuModel,
            searchString: globalSearchBloc.searchString,
          ),
        );
        break;
      case 4018:
        NativeMenuModel nativeMenuModel = NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0);
        appBloc.listNativeModel.forEach((element) async {
          if (element.displayname == searchResult.searchComponent.displayName) {
            nativeMenuModel = element;
            await sharePrefSaveString(
                sharedPref_ComponentID, element.componentId);
            await sharePrefSaveString(
                sharedPref_RepositoryId, element.repositoryId);
          }
        });
        // selectedWidget = CatalogRefreshScreen(
        //     categaoryID: 0,
        //     categaoryName: '',
        //     nativeMenuModel: nativeMenuModel);
        selectedWidget = ChangeNotifierProvider(
          create: (context) => ProviderModel(),
          child: CatalogRefreshScreen(
            categaoryID: 0,
            categaoryName: "",
            nativeMenuModel: nativeMenuModel,
            searchString: globalSearchBloc.searchString,
          ),
        );
        break;
      case 3091:
        NativeMenuModel nativeMenuModel = NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0);
        appBloc.listNativeModel.forEach((element) async {
          if (element.contextTitle ==
              searchResult.searchComponent.contextTitle) {
            nativeMenuModel = element;
            await sharePrefSaveString(
                sharedPref_ComponentID, element.componentId);
            await sharePrefSaveString(
                sharedPref_RepositoryId, element.repositoryId);
          }
        });
        selectedWidget = ChangeNotifierProvider(
          create: (context) => ProviderModel(),
          child: CatalogRefreshScreen(
              categaoryID: 0,
              categaoryName: "",
              nativeMenuModel: nativeMenuModel,
            searchString: globalSearchBloc.searchString,
          ),
        );
        break;
      case 3219:
        selectedWidget = EventWishListScreen();
        break;
      case 50007:
        // Navigator.of(context).push(
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             DiscussionMain()));
        break;
      case 3231:
        selectedWidget = UserQuestionsList();
        break;
      default:
        break;
    }

    if (selectedWidget == null) {
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Container(
          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
          child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    iconTheme: new IconThemeData(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                    ),
                    backgroundColor: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
                    elevation: 0,
                    title: Text(
                      searchResult.searchComponent.displayName,
                      style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                      ),
                    ),
                    actions: <Widget>[
                      searchResult.searchComponent.menuId == 1
                          ? Icon(
                              Icons.notifications,
                              color: InsColor(appBloc).appIconColor,
                            )
                          : Container(),
                      searchResult.searchComponent.menuId == 1
                          ? SizedBox(
                              width: ScreenUtil().setWidth(20),
                            )
                          : Container(),
                      searchResult.searchComponent.menuId == 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WaitListScreen()));
                              },
                              child: Icon(
                                Icons.featured_play_list,
                                color: InsColor(appBloc).appIconColor,
                              ))
                          : Container(),
                      searchResult.searchComponent.menuId == 1
                          ? SizedBox(
                              width: ScreenUtil().setWidth(20),
                            )
                          : Container(),
                      /* (selectedmenu == '4')? new DropdownButtonHideUnderline(
                    child:  DropdownButton(
                      icon: Icon(Icons.filter_list),
                      items: arrFilter.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                         setState(() {
                           FilterInterface().clickFilter(value);
                         });
                      },
                    )
                  ) : Container(),
                  selectedmenu == "4"
                      ? SizedBox(
                    width: ScreenUtil().setWidth(20),
                  )
                      : Container(),*/
                      searchResult.searchComponent.menuId == 5
                          ? Container()
                          // new DropdownButtonHideUnderline(
                          //     child: DropdownButton(
                          //         icon: Padding(
                          //             padding: EdgeInsets.only(right: 8.0),
                          //             child: Icon(Icons.filter_list)),
                          //         items: arrFilter.map((String value) {
                          //           return new DropdownMenuItem<String>(
                          //             value: value,
                          //             child: new Text(value),
                          //           );
                          //         }).toList(),
                          //         onChanged: (String value) {
                          //           setState(() {
                          //             appBloc.filterValue = value;
                          //           });
                          //         }))
                          : Container(),
                      searchResult.searchComponent.menuId == 4
                          ? SizedBox(
                              width: ScreenUtil().setWidth(20),
                            )
                          : Container(),
                      (searchResult.searchComponent.menuId == 2 &&
                              searchResult.searchComponent.menuId == 0)
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                          create: (context) => ProviderModel(),
                                          child: WishList(
                                            categaoryID: 0,
                                            categaoryName: "",
                                            detailsBloc: myLearningDetailsBloc,
                                            filterMenus: {},
                                          ),
                                        )));
                              },
                              child: Icon(
                                Icons.favorite,
                                color: InsColor(appBloc).appIconColor,
                              ))
                          : Container(),
                      (searchResult.searchComponent.menuId == 8)
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EventWishListScreen()));
                              },
                              child: Icon(
                                Icons.favorite,
                                color: InsColor(appBloc).appIconColor,
                              ))
                          : Container(),
                      (searchResult.searchComponent.menuId == 2 &&
                                  searchResult.searchComponent.menuId == 0) ||
                              searchResult.searchComponent.menuId == 8
                          ? SizedBox(
                              width: ScreenUtil().setWidth(20),
                            )
                          : Container(),
                    ],
                  ),
                  body: Container(
                    color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),),
                    child: selectedWidget,
                  ),
                ),
              ),
        )));
  }

  _showOptions(CourseList result, SearchComponent component) {
    List<ResultMoreOptionModel> listArray = [];

    switch (component.nativeCompId.toString()) {
      // Icon(
      //   IconDataSolid(int.parse('0xf06e')),
      //   color: Colors.grey,
      // )
      case "1": //My Learning
        if (!isConsolidated && result.siteId == 374) {
          listArray.add(ResultMoreOptionModel(
              title: appBloc.localstr.catalogActionsheetAddtomylearningoption,
              icon: Icon(Icons.add_circle, color: InsColor(appBloc).appIconColor),
              screen: null));
        }

        break;
      case "2": //Documents, Catalog & Wiki
        if (result.addLink.length > 0) {
          if (!isConsolidated && result.siteId == 374) {
            listArray.add(ResultMoreOptionModel(
                title: appBloc.localstr.catalogActionsheetAddtomylearningoption,
                icon: Icon(Icons.add_circle, color: InsColor(appBloc).appIconColor),
                screen: null)); // Add to My Learning
          }
        }
        listArray.add(initCatelogDetailOption(result));
        break;
      case "4": //Discussion Forum
        if (result.contentTypeId == 652) {
          listArray.add(initGoToForumOption(result)); // go to forum
        }
        if (result.contentTypeId == 17) {
          listArray.add(initGoToTopicOption(result)); // go to topic
        }
        break;
      case "5": //Ask the Expert
        if (result.contentTypeId == 653) {
          listArray.add(initGoToQuestionsOption(result)); // go to question
        }
        if (result.contentTypeId == 654) {
          listArray.add(initGoToResponseOption(result)); // go to response
        }
        break;
      case "8": //Training Events & Training Events
        if (result.addLink.length > 0) {
          var menu = initEventEnrollOption(result);
          menu.nativeCompId = component.nativeCompId;
          listArray.add(menu);
        } else {
          listArray.add(initEventCancelOption(result));
        }
        if (result.detailsLink.length > 0) {
          listArray.add(initEventDetailOption(result));
        }
        break;
      case "10": //My Connections
        listArray.add(initViewProfileOption(result));
        break;
      case "13": //My Achievements
        break;
      default:
        listArray.add(initEventDetailOption(result));
    }

    // switch (component.nativeCompId.toString()) {
    //   case '153': //Course
    //     if (result.detailsLink.length > 0) {
    //       listArray.add(initEventDetailOption(result));
    //     }
    //     break;
    //   case '1': //catalog
    //     if (result.detailsLink.length > 0) {
    //       listArray.add(initEventDetailOption(result));
    //     }
    //     break;
    //   case '181': //Events
    //     if (result.detailsLink.length > 0) {
    //       listArray.add(initEventDetailOption(result));
    //     }
    //     break;
    //   case '156': //Discussion Forum
    //     listArray.add(initGoToTopicOption(result));
    //     break;
    //   case '10002': //Documents
    //     listArray.add(initCatelogDetailOption(result));
    //     break;
    //   case '10001': //Wiki
    //     listArray.add(initCatelogDetailOption(result));
    //     break;
    // }

    if (result.addLink.length > 0) {
      //myLearningDetailsBloc.add(
      //  SetCompleteEvent(contentId: result.contentId, scoId: result.scoid));
      // listArray.add(
      //     ResultMoreOptionModel(title: 'Add to My Learning', screen: null));
    }

    if (result.sharelink.length > 0) {
      List<String> subStr = result.sharelink.split('/');
      var params = subStr.getRange(subStr.length - 4, subStr.length);
      print('subStr \n ' + subStr.toString());
      print(subStr.getRange(subStr.length - 4, subStr.length));

      listArray.add(initShareToPeople(result));
    }
    return (showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          height: (listArray.length * 90.0) + 35,
          child: Column(
            children: [
              BottomSheetDragger(),
              BlocConsumer(
                  bloc: catalogBloc,
                  listener: (context, state) {
                    if (state is AddToMyLearningState) {
                      if (state.status == Status.COMPLETED) {
                        Navigator.pop(context);
                        Future.delayed(Duration(seconds: 1), () {
                          // 5s over, navigate to a new page
                          flutterToast.showToast(
                            child: CommonToast(
                                displaymsg: appBloc.localstr
                                    .catalogAlertsubtitleThiscontentitemhasbeenaddedto),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 2),
                          );
                          searchAction(_controller.text);
                        });

                        // print(
                        //     'availableseatsss_before ${widget.table2.availableseats}');
                        // setState(() {
                        //   state.table2.isaddedtomylearning = 1;
                        //   widget.table2.availableseats = availableSeats - 1;
                        //
                        //   checkReportEnabled();
                        //   setTag1();
                        //   availableSeat = checkAvailableSeats(widget.table2);
                        // });
                        //
                        // print(
                        //     'availableseatsss_after ${widget.table2.availableseats}');
                        //
                        // if (widget.isWishlisted != null) {
                        //   Navigator.of(context).pop();
                        // }
                      }
                    }
                  },
                  builder: (context, state) => Container(
                        height: (listArray.length * 90.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (var i in listArray)
                                InkWell(
                                  onTap: () {
                                    if ((component.nativeCompId == "8" ||
                                            component.nativeCompId == "1" ||
                                            component.nativeCompId == "0" ||
                                            component.nativeCompId == "2") &&
                                        i.screen == null) {
                                      DummyMyCatelogResponseTable2
                                          myCatelogResponseTable2 =
                                          DummyMyCatelogResponseTable2();

                                      myCatelogResponseTable2.userid =
                                          result.siteUserId;
                                      myCatelogResponseTable2.siteid =
                                          result.siteId;
                                      myCatelogResponseTable2.siteurl =
                                          result.siteUrl ??
                                              ApiEndpoints.mainSiteURL;
                                      // myCatelogResponseTable2.availableseats =
                                      //     int.parse(result.availableSeats);
                                      // myCatelogResponseTable2.waitlistenrolls =
                                      //     int.parse(result.waitListEnrolls);
                                      // myCatelogResponseTable2.isaddedtomylearning =
                                      //     int.parse(result.isaddtomylearninglogo);
                                      myCatelogResponseTable2
                                              .eventstartdatetime =
                                          result.eventStartDateTime;
                                      myCatelogResponseTable2.eventenddatetime =
                                          result.eventEndDateTime;
                                      myCatelogResponseTable2.viewtype =
                                          result.viewType;
                                      myCatelogResponseTable2
                                              .eventscheduletype =
                                          result.eventScheduleType;
                                      myCatelogResponseTable2.eventrecording =
                                          result.eventRecording;
                                      myCatelogResponseTable2.tagname =
                                          result.tags;
                                      myCatelogResponseTable2.name =
                                          result.siteName;
                                      myCatelogResponseTable2.shortdescription =
                                          result.shortDescription;
                                      myCatelogResponseTable2.locationname =
                                          result.locationName ?? "";
                                      myCatelogResponseTable2.ratingid =
                                          double.parse(result.ratingId);
                                      myCatelogResponseTable2.contentid =
                                          result.contentId;
                                      myCatelogResponseTable2.actionwaitlist =
                                          result.waitListLink;
                                      if (result.addLink.length > 0) {
                                        print('passing');
                                        addToEnroll(myCatelogResponseTable2);
                                        //Navigator.pop(context);
                                      } else if (component.nativeCompId ==
                                          "8") {
                                        showCancelEnrollDialog(
                                            myCatelogResponseTable2, 'Success');
                                      }
                                    } else if (component.nativeCompId == "10") {
                                      if (i.screen is ShareMainScreen) {
                                        var screen =
                                            i.screen as ShareMainScreen;

                                        var msgString =
                                            "I thought you might be interested in seeing this. Make sure you take a look at my comments and the New Video that is on your YouTube site! \n\nContent Name: ${screen.contentName}. \n\n Content Link: ${ApiEndpoints.mainSiteURL}/InviteURLID/contentId/${screen.contententId}/ComponentId/1.";

                                        Navigator.pop(context);
                                        Share.share(msgString,
                                            subject: screen.contentName);
                                      } else {
                                        Navigator.pop(context);
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => i.screen))
                                            .then((value) => {
                                                  if (value == true)
                                                    {
                                                      this.searchAction(
                                                          _controller.text)
                                                    }
                                                });
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => i.screen))
                                          .then((value) => {
                                                if (value == true)
                                                  {
                                                    this.searchAction(
                                                        _controller.text)
                                                  }
                                              });
                                    }
                                  },
                                  child: ListTile(
                                    title: Text(
                                      i.title,
                                      style: TextStyle(
                                          color:
                                              InsColor(appBloc).appTextColor),
                                    ),
                                    leading: i.icon,
                                  ),
                                  // Column(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     Padding(
                                  //       padding:
                                  //           const EdgeInsets.only(left: 16),
                                  //       child: Text(i.title,
                                  //           style: Theme.of(context)
                                  //               .textTheme
                                  //               .headline2
                                  //               .apply(
                                  //                   color: InsColor(appBloc)
                                  //                       .appTextColor)),
                                  //     ),
                                  //     SizedBox(height: 8),
                                  //     Divider()
                                  //   ],
                                  // ),
                                ),
                            ],
                          ),
                        ),
                      )),
              BlocConsumer<EvntModuleBloc, EvntModuleState>(
                  bloc: eventModuleBloc,
                  listener: (context, state) {
                    //if (state is CancelEnrollmentState) {

                    if (state.status == Status.COMPLETED) {
                      if (state.isSuccess == true) {
                        Navigator.pop(context);
                        Future.delayed(Duration(seconds: 1), () {
                          // 5s over, navigate to a new page
                          flutterToast.showToast(
                            child: CommonToast(
                                displaymsg:
                                    'Your enrollment for the course has been successfully canceled'),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: 1),
                          );
                        });
                        Navigator.pop(context);
                        searchAction(_controller.text);
                      } else {
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
                  },
                  //},
                  builder: (context, state) => Container()),
            ],
          ),
        );
      },
    ));
  }

  ResultMoreOptionModel initShareToPeople(CourseList result) {
    return ResultMoreOptionModel(
        title: 'Share',
        icon: Icon(
          IconDataSolid(int.parse('0xf1e0')),
          color: InsColor(appBloc).appIconColor,
        ),
        screen: ShareMainScreen(
            true, false, false, result.contentId, result.title));
  }

  ResultMoreOptionModel initEventDetailOption(CourseList result) {
    DummyMyCatelogResponseTable2 myCatelogResponseTable2 = DummyMyCatelogResponseTable2();

    myCatelogResponseTable2.userid = result.siteUserId;
    myCatelogResponseTable2.siteid = result.siteId;
    myCatelogResponseTable2.siteurl = result.siteUrl.toString();
    myCatelogResponseTable2.availableseats = result.availableSeats == "" ? 0 : int.parse(result.availableSeats);
    myCatelogResponseTable2.waitlistenrolls = result.waitListEnrolls == "" ? 0 : int.parse(result.waitListEnrolls);
    myCatelogResponseTable2.isaddedtomylearning = result.addLink.length > 0 ? 0 : 1;
    myCatelogResponseTable2.eventstartdatetime = result.eventStartDateTime;
    myCatelogResponseTable2.eventenddatetime = result.eventEndDateTime;
    myCatelogResponseTable2.viewtype = result.viewType;
    myCatelogResponseTable2.eventscheduletype = result.eventScheduleType;
    myCatelogResponseTable2.eventrecording = result.eventRecording;
    myCatelogResponseTable2.tagname = result.tags;
    myCatelogResponseTable2.name = result.siteName;
    myCatelogResponseTable2.shortdescription = result.shortDescription;
    myCatelogResponseTable2.locationname = result.locationName;
    myCatelogResponseTable2.ratingid = double.parse(result.ratingId);
    myCatelogResponseTable2.startpage = result.startPage;
    myCatelogResponseTable2.contentid = result.contentId;
    myCatelogResponseTable2.objecttypeid = result.contentTypeId;
    myCatelogResponseTable2.relatedconentcount = result.isRelatedcontent == 'true' ? 1 : 0;
    myCatelogResponseTable2.eventtype = result.eventType;
    myCatelogResponseTable2.bit5 = true;
    myCatelogResponseTable2.thumbnailimagepath = result.thumbnailImagePath;

    return ResultMoreOptionModel(
        title: 'Details',
        icon: Icon(
          IconDataSolid(int.parse('0xf570')),
          color: InsColor(appBloc).appIconColor,
        ),
        screen: ChangeNotifierProvider(
          create: (context) => ProviderModel(),
          child: CommonDetailScreen(
              screenType: ScreenType.Events,
              contentid: result.contentId,
              objtypeId: result.contentTypeId,
              detailsBloc: myLearningDetailsBloc,
              table2: myCatelogResponseTable2,
              isShowShedule: true,
              isFromReschedule: false,
              filterMenus: filterMenus),
        ),
    );
  }

  ResultMoreOptionModel initEventEnrollOption(CourseList result) {
    DummyMyCatelogResponseTable2 myCatelogResponseTable2 =
        DummyMyCatelogResponseTable2();

    myCatelogResponseTable2.userid = result.siteUserId;
    myCatelogResponseTable2.siteid = result.siteId;
    myCatelogResponseTable2.siteurl = result.siteUrl.toString();
    myCatelogResponseTable2.availableseats = int.parse(result.availableSeats);
    myCatelogResponseTable2.waitlistenrolls = int.parse(result.waitListEnrolls);
    myCatelogResponseTable2.isaddedtomylearning =
        int.parse(result.isaddtomylearninglogo);
    myCatelogResponseTable2.eventstartdatetime = result.eventStartDateTime;
    myCatelogResponseTable2.eventenddatetime = result.eventEndDateTime;
    myCatelogResponseTable2.viewtype = result.viewType;
    myCatelogResponseTable2.eventscheduletype = result.eventScheduleType;
    myCatelogResponseTable2.eventrecording = result.eventRecording;
    myCatelogResponseTable2.tagname = result.tags;
    myCatelogResponseTable2.name = result.siteName;
    myCatelogResponseTable2.shortdescription = result.shortDescription;
    myCatelogResponseTable2.locationname = result.locationName;
    myCatelogResponseTable2.ratingid = double.parse(result.ratingId);

    return ResultMoreOptionModel(
        title: 'Enroll',
        icon: Icon(
          Icons.add_circle,
          color: InsColor(appBloc).appIconColor,
        ),
        screen: null);
  }

  ResultMoreOptionModel initEventCancelOption(CourseList result) {
    DummyMyCatelogResponseTable2 myCatelogResponseTable2 =
        DummyMyCatelogResponseTable2();

    myCatelogResponseTable2.userid = result.siteUserId;
    myCatelogResponseTable2.siteid = result.siteId;
    myCatelogResponseTable2.siteurl = result.siteUrl.toString();
    myCatelogResponseTable2.availableseats = int.parse(result.availableSeats);
    myCatelogResponseTable2.waitlistenrolls = int.parse(result.waitListEnrolls);
    myCatelogResponseTable2.isaddedtomylearning =
        int.parse(result.isaddtomylearninglogo);
    myCatelogResponseTable2.eventstartdatetime = result.eventStartDateTime;
    myCatelogResponseTable2.eventenddatetime = result.eventEndDateTime;
    myCatelogResponseTable2.viewtype = result.viewType;
    myCatelogResponseTable2.eventscheduletype = result.eventScheduleType;
    myCatelogResponseTable2.eventrecording = result.eventRecording;
    myCatelogResponseTable2.tagname = result.tags;
    myCatelogResponseTable2.name = result.siteName;
    myCatelogResponseTable2.shortdescription = result.shortDescription;
    myCatelogResponseTable2.locationname = result.locationName;
    myCatelogResponseTable2.ratingid = double.parse(result.ratingId);

    return ResultMoreOptionModel(
        title: 'Cancel',
        screen: null,
        icon: Icon(
          Icons.delete,
          color: InsColor(appBloc).appIconColor,
        ));
  }

  ResultMoreOptionModel initViewProfileOption(CourseList result) {
    DummyMyCatelogResponseTable2 myCatelogResponseTable2 =
        DummyMyCatelogResponseTable2();

    myCatelogResponseTable2.userid = result.siteUserId;
    myCatelogResponseTable2.siteid = result.siteId;
    myCatelogResponseTable2.siteurl = result.siteUrl.toString();
    // myCatelogResponseTable2.availableseats = int.parse(result.availableSeats);
    // myCatelogResponseTable2.waitlistenrolls = int.parse(result.waitListEnrolls);
    //myCatelogResponseTable2.isaddedtomylearning =
    //  int.parse(result.isaddtomylearninglogo);
    myCatelogResponseTable2.eventstartdatetime = result.eventStartDateTime;
    myCatelogResponseTable2.eventenddatetime = result.eventEndDateTime;
    myCatelogResponseTable2.viewtype = result.viewType;
    myCatelogResponseTable2.eventscheduletype = result.eventScheduleType;
    myCatelogResponseTable2.eventrecording = result.eventRecording;
    myCatelogResponseTable2.tagname = result.tags;
    myCatelogResponseTable2.name = result.siteName;
    myCatelogResponseTable2.shortdescription = result.shortDescription;
    myCatelogResponseTable2.locationname = result.locationName ?? "";
    //myCatelogResponseTable2.ratingid = double.parse(result.ratingId);

    var proUserId = result.viewProfileLink.split('profileuserid/').last;
    proUserId = proUserId.split('/').first;
    return ResultMoreOptionModel(
        title: 'View Profile',
        icon: Icon(
          Icons.account_circle_rounded,
          color: InsColor(appBloc).appIconColor,
        ),
        screen: Profile(
          isFromProfile: false,
          connectionUserId: proUserId,
        ));
  }

  ResultMoreOptionModel initCatelogDetailOption(CourseList result) {
    DummyMyCatelogResponseTable2 myCatelogResponseTable2 = DummyMyCatelogResponseTable2();

    myCatelogResponseTable2.userid = result.siteUserId;
    myCatelogResponseTable2.siteid = result.siteId;
    myCatelogResponseTable2.siteurl = result.siteUrl.toString();
    // myCatelogResponseTable2.availableseats = int.parse(result.availableSeats);
    myCatelogResponseTable2.sitename = result.siteName;
    myCatelogResponseTable2.contenttype = result.contentType;
    //myCatelogResponseTable2.objecttypeid = result.contentTypeId;
    //myCatelogResponseTable2.medianame = 'PDF';
    //myCatelogResponseTable2.iconpath = 'pdf.gif';
    //myCatelogResponseTable2.contenttypethumbnail = 'contenttypethumbnail';
    //myCatelogResponseTable2.contentid = '80aa5688-569c-4d5d-9fee-15482055f092';
    myCatelogResponseTable2.isaddedtomylearning = result.addLink.length > 0 ? 0 : 1;
    myCatelogResponseTable2.contentid = result.contentId;
    myCatelogResponseTable2.iscontent = true; //result.isContentEnrolled == 'true';
    myCatelogResponseTable2.eventstartdatetime = result.eventStartDateTime;
    myCatelogResponseTable2.eventenddatetime = result.eventEndDateTime;
    myCatelogResponseTable2.viewtype = 1; //result.viewType;
    myCatelogResponseTable2.eventscheduletype = result.eventScheduleType;
    myCatelogResponseTable2.eventrecording = result.eventRecording;
    myCatelogResponseTable2.tagname = result.tags;
    myCatelogResponseTable2.name = result.siteName;
    myCatelogResponseTable2.shortdescription = result.shortDescription;
    myCatelogResponseTable2.locationname = result.locationName ?? "";
    myCatelogResponseTable2.ratingid = double.parse(result.ratingId);
    myCatelogResponseTable2.startpage = result.startPage;
    myCatelogResponseTable2.objecttypeid = result.contentTypeId;
    myCatelogResponseTable2.relatedconentcount = result.isRelatedcontent == 'true' ? 1 : 0;
    myCatelogResponseTable2.bit5 = true;

    return ResultMoreOptionModel(
        title: 'Details',
        icon: Icon(
          IconDataSolid(int.parse('0xf570')),
          color: InsColor(appBloc).appIconColor,
        ),
        screen: ChangeNotifierProvider(
          create: (context) => ProviderModel(),
          child: CommonDetailScreen(
              screenType: ScreenType.Catalog,
              contentid: result.contentId,
              objtypeId: result.contentTypeId,
              detailsBloc: myLearningDetailsBloc,
              table2: myCatelogResponseTable2,
              isShowShedule: true,
              isFromReschedule: false,
              filterMenus: filterMenus),
        ));
  }

  ResultMoreOptionModel initGoToTopicOption(CourseList result) {
    ForumList forumList = ForumList.fromJson({});

    forumList.name = result.title;
    forumList.createdDate = result.createdOn ?? "";
    forumList.totalLikes = []; //totalRatings;
    forumList.description = result.shortDescription;
    forumList.dFProfileImage = result.thumbnailImagePath;
    //forumList.noOfTopics = result.to;
    forumList.forumID = 0; //result.contentTypeId;
    forumList.forumThumbnailPath = result.thumbnailImagePath;

    return ResultMoreOptionModel(
        title: 'Go to this topic',
        icon: Icon(
          Icons.message_outlined,
          color: InsColor(appBloc).appIconColor,
        ),
        screen: DiscussionForumTopic(
          forumList: forumList,
          contentID: '',
        ));
  }

  ResultMoreOptionModel initGoToForumOption(CourseList result) {
    ForumList forumList = ForumList.fromJson({});

    forumList.name = result.title;
    forumList.createdDate = result.createdOn;
    forumList.totalLikes = []; //totalRatings;
    forumList.description = result.shortDescription;
    forumList.dFProfileImage = result.thumbnailImagePath;
    //forumList.noOfTopics = result.to;
    forumList.forumID = 0; //result.contentTypeId;
    forumList.forumThumbnailPath = result.thumbnailImagePath;

    return ResultMoreOptionModel(
        title: 'Go to this forum',
        icon: Icon(
          Icons.message_outlined,
          color: InsColor(appBloc).appIconColor,
        ),
        screen: DiscussionForumTopic(
          forumList: forumList,
          contentID: '',
        ));
  }

  ResultMoreOptionModel initGoToQuestionsOption(CourseList result) {
    ForumList forumList = ForumList.fromJson({});

    forumList.name = result.title;
    forumList.createdDate = result.createdOn;
    forumList.totalLikes = []; //totalRatings;
    forumList.description = result.shortDescription;
    forumList.dFProfileImage = result.thumbnailImagePath;
    //forumList.noOfTopics = result.to;
    forumList.forumID = 0; //result.contentTypeId;
    forumList.forumThumbnailPath = result.thumbnailImagePath;

    return ResultMoreOptionModel(
        title: 'Go to this questions',
        icon: Icon(
          Icons.question_answer_outlined,
          color: InsColor(appBloc).appIconColor,
        ),
        screen: DiscussionForumTopic(
          forumList: forumList,
          contentID: '',
        ));
  }

  ResultMoreOptionModel initGoToResponseOption(CourseList result) {
    ForumList forumList = ForumList.fromJson({});

    forumList.name = result.title;
    forumList.createdDate = result.createdOn;
    forumList.totalLikes = []; //totalRatings;
    forumList.description = result.shortDescription;
    forumList.dFProfileImage = result.thumbnailImagePath;
    //forumList.noOfTopics = result.to;
    forumList.forumID = 0; //result.contentTypeId;
    forumList.forumThumbnailPath = result.thumbnailImagePath;

    return ResultMoreOptionModel(
        title: 'Go to this response',
        icon: Icon(
          Icons.restore_page_outlined,
          color: InsColor(appBloc).appIconColor,
        ),
        screen: DiscussionForumTopic(
          forumList: forumList,
          contentID: '',
        ));
  }

  List _contentValue(SearchComponent component, CourseList courseList) {
    //print('Menu ID for content' + component.menuId.toString());
    //print('Menu Title' + courseList.title.toString());
    switch (component.menuId) {
      case 50005:
        return [courseList.title, courseList.authorName, ''];
      case 3219:
        return [courseList.title, courseList.authorName, ''];
      case 4018:
        return [courseList.title, courseList.authorName, ''];
      default:
        return [courseList.title, courseList.authorName, ''];
    }
  }

  void searchAction(String searchStr) {
    //widget.menuId ==
    setState(() {
      globalSearchBloc.searchResultList = [];
      showFilterView = false;
      globalSearchBloc.clearSearchResult = true;
    });

    List<SearchComponent> selectedElements = [];
    globalSearchBloc.searchComponents.values.toList().forEach((element) {
      element.map((e) => e).forEach((element) {
        if (element.check) {
          selectedElements.add(element);
        }
      });
    });
    var currentPageElements = selectedElements
        .where((element) => element.menuId == widget.menuId)
        .length;
    var otherPageElements = selectedElements
        .where((element) => element.menuId != widget.menuId)
        .length;

    if (!(otherPageElements > 0) && currentPageElements > 0) {
      print('selected plan ');
      Navigator.of(context).pop(searchStr); //.pop(context, searchStr);
      return;
    } else {
      print('otherPageElements plan ');
    }

    globalSearchBloc.searchString = searchStr;
    for (var element in selectedElements) {
      globalSearchBloc.add(GetGlobalSearchResultsEvent(
          componentID: int.parse(element.componentId),
          componentInsID: element.componentInstanceId,
          pageIndex: pageIndex,
          searchStr: globalSearchBloc.searchString,
          fType: fType,
          fValue: fValue,
          objComponentList: int.parse(element.componentId),
          searchComponent: element));
    }
  }

  void _seeAllValueAction() {
    setState(() {
      _currentPageKey = _seeAll;
      globalSearchBloc.searchComponents.values.toList().forEach((element) {
        element.map((e) => e).forEach((element) {
          element.check = _seeAll;
        });
      });
    });
  }

  void _currentPageValueAction() {
    setState(() {
      //_currentPageKey = _seeAll;
      globalSearchBloc.searchComponents.values.toList().forEach((element) {
        element.map((e) => e).forEach((element) {
          if (!_currentPageKey) {
            element.check = _seeAll;
            _seeAll = false;
          } else {
            element.check = (element.menuId == widget.menuId);
          }

          // if (element.menuId == widget.menuId) {
          //   element.check = true;
          // } else {
          //
          // }
        });
      });
    });
  }

  //MARK: Events Action
  void addToEnroll(DummyMyCatelogResponseTable2 table2) {
    print('waitaction ${table2.actionwaitlist} ${table2.availableseats}');
    if (appBloc.uiSettingModel.allowExpiredEventsSubscription == 'true' && returnEventCompleted(table2.eventenddatetime)) {
      try {
        addExpiryEvents(table2, 0);
      } catch (e) {
        e.toString();
      }
    }
    else {
      MyPrint.printOnConsole("In Else");
      int avaliableSeats = 0;
      avaliableSeats = table2.availableseats ?? 0;
      MyPrint.printOnConsole("Available Seats:$avaliableSeats");
      MyPrint.printOnConsole("table2.viewtype:${table2.viewtype}");

      if (avaliableSeats > 0) {
        catalogBloc.add(AddToMyLearningEvent(contentId: table2.contentid, table2: table2));
      }
      else if (table2.viewtype == 1 || table2.viewtype == 2) {
        if (true) {
        //if (isValidString(table2.eventenddatetime ?? "") && !returnEventCompleted(table2.eventenddatetime ?? "")) {
          MyPrint.printOnConsole("Hello1");
          if (isValidString(table2.actionwaitlist) && table2.actionwaitlist == "true") {
            String alertMessage = appBloc.localstr.eventdetailsenrollementAlertsubtitleEventenrollmentlimit;
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        appBloc.localstr.eventsActionsheetEnrolloption,
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                      content: Text(
                        alertMessage,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.apply(color: InsColor(appBloc).appTextColor),
                      ),
                      backgroundColor: InsColor(appBloc).appBGColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5)),
                      actions: <Widget>[
                        new FlatButton(
                          child: Text(appBloc
                              .localstr.mylearningAlertbuttonCancelbutton),
                          textColor: InsColor(appBloc).appTextColor,
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
          } else {
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
    //Navigator.of(context).pop();
    //Navigator.pop(context);
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

  void addExpiryEvents(DummyMyCatelogResponseTable2 table2, int position) {
    eventModuleBloc
        .add(AddExpiryEvent(table2: table2, strContentID: table2.contentid));
  }

  void addToWaitList(DummyMyCatelogResponseTable2 catalogModel) {
    eventModuleBloc.add(WaitingListEvent(
        strContentID: catalogModel.contentid, table2: catalogModel));
  }

  bool isValidString(String val) {
//    print('validstrinh $val' ;
    if (val == null || val.isEmpty || val == 'null') {
      return false;
    } else {
      return true;
    }
  }

  String _currentScreenName() {
    // ignore: unnecessary_statements
    var items = [
      {"MenuID": 4180, "DisplayName": "My Learning"},
      {"MenuID": 3231, "DisplayName": "Ask the Expert"},
      {"MenuID": 3219, "DisplayName": "Training Events"},
      {"MenuID": 3091, "DisplayName": "Catalog"},
      {"MenuID": 50014, "DisplayName": "Discussions"},
      {"MenuID": 3185, "DisplayName": "My Connections"},
    ];
    var selectedScreen = '';
    items.forEach((element) {
      print(element['MenuID']);
      print(widget.menuId);
      if (element['MenuID'] == widget.menuId) {
        print('Passing');
        print(element['DisplayName']);
        selectedScreen = element['DisplayName']?.toString() ?? "";
      }
    });
    return selectedScreen;
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
                    .headline1
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
                  borderRadius: new BorderRadius.circular(5)),
              actions: <Widget>[
                new FlatButton(
                  child: Text(appBloc.localstr.catalogAlertbuttonCancelbutton),
                  textColor: InsColor(appBloc).appTextColor,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: Text(appBloc.localstr.eventsAlertbuttonOkbutton),
                  textColor: Colors.blue,
                  onPressed: () async {
                    //Navigator.of(context).pop();
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
}

class ResultMoreOptionModel {
  String title;
  Icon icon;
  dynamic screen;
  String nativeCompId;

  ResultMoreOptionModel(
      {this.title = "",
      required this.icon,
      this.screen,
      this.nativeCompId = ""});
}
