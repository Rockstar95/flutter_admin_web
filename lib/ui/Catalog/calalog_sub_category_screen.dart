import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/getCategoryForBrowseResponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/ResponsiveWidget.dart';
import 'package:flutter_admin_web/framework/helpers/providermodel.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/Catalog/catalog_sub_screen.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:provider/provider.dart';

import 'catalog_refresh.dart';

class CatalogSubCategoryScreen extends StatefulWidget {
  final int categaoryID;
  final String categaoryName;
  final NativeMenuModel? nativeMenuModel;

  const CatalogSubCategoryScreen(
      {required this.categaoryID,
      required this.categaoryName,
      this.nativeMenuModel});

  @override
  State<CatalogSubCategoryScreen> createState() =>
      _CatalogSubCategoryScreenState();
}

class _CatalogSubCategoryScreenState extends State<CatalogSubCategoryScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);
  NativeMenuModel? nativeMenuModel;

  @override
  void initState() {
    super.initState();
    if (widget.nativeMenuModel == null) {
      nativeMenuModel = NativeMenuModel(categoryStyle: "",
          componentId: "",
          conditions: "",
          contextTitle: "",
          contextmenuId: "",
          displayOrder: 0,
          displayname: "",
          image: "",
          isEnabled: "",
          isofflineMenu: "",
          landingpageType: "",
          menuid: "",
          parameterString: "",
          parentMenuId: "",
          repositoryId: "",
          siteId: "",
          siteUrl: "",
          webMenuId: 0);
    } else {
      nativeMenuModel = widget.nativeMenuModel;
    }

    if (widget.categaoryID == 0) {
      myLearningBloc.add(ResetFilterEvent());
      myLearningBloc.add(GetFilterMenus(
          listNativeModel: appBloc.listNativeModel,
          localStr: appBloc.localstr,
          moduleName: nativeMenuModel!.displayname));
      myLearningBloc.add(GetSortMenus("1"));
      catalogBloc.add(SetCatalogSideMenuEvent(appBloc.listNativeModel));
      catalogBloc.add(GetCategoryForBrowseEvent());
      catalogBloc.catList.clear();
    } else {
      GetCategoryForBrowseResponse pojo2 =
          new GetCategoryForBrowseResponse.fromJson({});
      pojo2.categoryName = widget.categaoryName;
      pojo2.categoryId = widget.categaoryID;
      catalogBloc.catList.add(pojo2);

      catalogBloc.add(GetSubcategoryCatalogEvent(
          categaoryID: widget.categaoryID,
          categaoryName: widget.categaoryName));
    }
  }

  @override
  Widget build(BuildContext context) {
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;

    return Scaffold(
      backgroundColor: Color(
        int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
      ),
      appBar: widget.categaoryID == 0
          ? null
          : AppBar(
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
        child: BlocConsumer<CatalogBloc, CatalogState>(
          bloc: catalogBloc,
          listener: (context, state) {
            if (state is GetCategoryForBrowseState) {
              if (state.status == Status.COMPLETED) {
                catalogBloc.add(GetSubcategoryCatalogEvent(
                    categaoryID: widget.categaoryID, categaoryName: "All"));
              }
            }
          },
          builder: (context, state) {
            if (state.status == Status.ERROR) {
              return Container(
                child: Center(
                  child: Text(appBloc.localstr.commoncomponentLabelNodatalabel,
                      style: TextStyle(
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                          fontSize: 24)),
                ),
              );
            }
            else if (state.status == Status.LOADING) {
              return Center(
                child: AbsorbPointer(
                  child: SpinKitCircle(
                    color: Colors.grey,
                    size: 70,
                  ),
                ),
              );
            }
            else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (catalogBloc.catList.isNotEmpty)
                          ? SizedBox(
                              height: 40.h,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                                  child: BreadCrumb.builder(
                                    itemCount: catalogBloc.catList.length,
                                    builder: (pos) {
                                      return BreadCrumbItem(
                                          content: GestureDetector(
                                              onTap: () {
                                                catalogBloc.add(
                                                    GetSubcategoryCatalogEvent(
                                                        categaoryID: catalogBloc
                                                            .catList[pos]
                                                            .categoryId,
                                                        categaoryName: catalogBloc
                                                            .catList[pos]
                                                            .categoryName));
                                              },
                                              child: Text(
                                                '${catalogBloc.catList[pos].categoryName}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.getAppButtonBGColor(),
                                                ),
                                              )));
                                    },
                                    divider: Icon(
                                      Icons.chevron_right,
                                      color: InsColor(appBloc).appIconColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      catalogBloc.catList.length == 1
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (context) => ProviderModel(),
                                      child: CatalogRefreshScreen(
                                        categaoryID: 0,
                                        categaoryName: "true",
                                        nativeMenuModel:
                                            nativeMenuModel ??
                                                NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  child: Text(
                                    'Go to list',
                                    style: TextStyle(
                                        color: Color(
                                          int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"),
                                        ),
                                        fontSize: 16),
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  catalogBloc.subCategoryCatalogList.length == 0
                      ? Container(
                          child: Center(
                            child: Text(
                                appBloc
                                    .localstr.commoncomponentLabelNodatalabel,
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                    fontSize: 24)),
                          ),
                        )
                      : Expanded(
                          child: ResponsiveWidget(
                            mobile: ListView.builder(
                                itemCount:
                                    catalogBloc.subCategoryCatalogList.length,
                                itemBuilder: (context, i) {
                                  //print("ListView Builder Called");
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      color: Color(
                                        int.parse(
                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            myLearningBloc
                                                    .selectedMainCategoryId =
                                                catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryId
                                                    .toString();
                                            print(
                                                "catalogBloc.subCategoryCatalogList[i].hasChild:${catalogBloc.subCategoryCatalogList[i].hasChild}");
                                            if (catalogBloc
                                                .subCategoryCatalogList[i]
                                                .hasChild) {
                                              catalogBloc.add(
                                                  GetSubcategoryCatalogEvent(
                                                categaoryID: catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryId,
                                                categaoryName: catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryName,
                                              ));
                                            } else {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                  create: (context) =>
                                                      ProviderModel(),
                                                  child: CatalogSubScreen(
                                                    categaoryID: catalogBloc
                                                        .subCategoryCatalogList[
                                                            i]
                                                        .categoryId,
                                                    categaoryName: catalogBloc
                                                        .subCategoryCatalogList[
                                                            i]
                                                        .categoryName,
                                                    nativeMenuModel: widget
                                                            .nativeMenuModel ??
                                                        NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0),
                                                  ),
                                                ),
                                              ));
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 200,
                                                child: catalogBloc
                                                            .subCategoryCatalogList[
                                                                i]
                                                            .categoryIcon ==
                                                        ""
                                                    ? Image.asset(
                                                        'assets/cellimage.jpg',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: catalogBloc
                                                                .subCategoryCatalogList[
                                                                    i]
                                                                .categoryIcon
                                                                .startsWith(
                                                                    'http')
                                                            ? catalogBloc
                                                                .subCategoryCatalogList[
                                                                    i]
                                                                .categoryIcon
                                                            : "${ApiEndpoints.strSiteUrl}${catalogBloc.subCategoryCatalogList[i].categoryIcon}",
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        //placeholder: (context, url) => CircularProgressIndicator(),
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          'assets/cellimage.jpg',
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/cellimage.jpg',
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    catalogBloc
                                                        .subCategoryCatalogList[
                                                            i]
                                                        .categoryName,
                                                    style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(15),
                                                      color: Color(
                                                        int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            tab: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / 660,
                                ),
                                itemCount:
                                    catalogBloc.subCategoryCatalogList.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      color: Color(
                                        int.parse(
                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            myLearningBloc
                                                    .selectedMainCategoryId =
                                                catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryId
                                                    .toString();
                                            if (catalogBloc
                                                .subCategoryCatalogList[i]
                                                .hasChild) {
                                              catalogBloc.add(
                                                  GetSubcategoryCatalogEvent(
                                                categaoryID: catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryId,
                                                categaoryName: catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryName,
                                              ));
                                            } else {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                  create: (context) =>
                                                      ProviderModel(),
                                                  child: CatalogSubScreen(
                                                    categaoryID: catalogBloc
                                                        .subCategoryCatalogList[
                                                            i]
                                                        .categoryId,
                                                    categaoryName: catalogBloc
                                                        .subCategoryCatalogList[
                                                            i]
                                                        .categoryName,
                                                    nativeMenuModel:
                                                        nativeMenuModel!,
                                                  ),
                                                ),
                                              ));
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height:
                                                    useMobileLayout ? 200 : 140,
                                                child: catalogBloc
                                                            .subCategoryCatalogList[
                                                                i]
                                                            .categoryIcon ==
                                                        ""
                                                    ? Image.asset(
                                                        'assets/cellimage.jpg',
                                                        fit: BoxFit.cover,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: catalogBloc
                                                                .subCategoryCatalogList[
                                                                    i]
                                                                .categoryIcon
                                                                .startsWith(
                                                                    'http')
                                                            ? catalogBloc
                                                                .subCategoryCatalogList[
                                                                    i]
                                                                .categoryIcon
                                                            : "${ApiEndpoints.strSiteUrl}${catalogBloc.subCategoryCatalogList[i].categoryIcon}",
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        //placeholder: (context, url) => CircularProgressIndicator(),
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          'assets/cellimage.jpg',
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/cellimage.jpg',
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    catalogBloc
                                                        .subCategoryCatalogList[
                                                            i]
                                                        .categoryName,
                                                    style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(15),
                                                      color: Color(
                                                        int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            web: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: catalogBloc.subCategoryCatalogList.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      color: Color(
                                        int.parse(
                                            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}"),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            myLearningBloc
                                                .selectedMainCategoryId =
                                                catalogBloc
                                                    .subCategoryCatalogList[i]
                                                    .categoryId
                                                    .toString();
                                            if (catalogBloc
                                                .subCategoryCatalogList[i]
                                                .hasChild) {
                                              catalogBloc.add(
                                                  GetSubcategoryCatalogEvent(
                                                    categaoryID: catalogBloc
                                                        .subCategoryCatalogList[i]
                                                        .categoryId,
                                                    categaoryName: catalogBloc
                                                        .subCategoryCatalogList[i]
                                                        .categoryName,
                                                  ));
                                            } else {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeNotifierProvider(
                                                      create: (context) =>
                                                          ProviderModel(),
                                                      child: CatalogSubScreen(
                                                        categaoryID: catalogBloc
                                                            .subCategoryCatalogList[
                                                        i]
                                                            .categoryId,
                                                        categaoryName: catalogBloc
                                                            .subCategoryCatalogList[
                                                        i]
                                                            .categoryName,
                                                        nativeMenuModel:
                                                        nativeMenuModel!,
                                                      ),
                                                    ),
                                              ));
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height:
                                                useMobileLayout ? 200 : 140,
                                                child: catalogBloc
                                                    .subCategoryCatalogList[
                                                i]
                                                    .categoryIcon ==
                                                    ""
                                                    ? Image.asset(
                                                  'assets/cellimage.jpg',
                                                  fit: BoxFit.cover,
                                                )
                                                    : CachedNetworkImage(
                                                  imageUrl: catalogBloc
                                                      .subCategoryCatalogList[
                                                  i]
                                                      .categoryIcon
                                                      .startsWith(
                                                      'http')
                                                      ? catalogBloc
                                                      .subCategoryCatalogList[
                                                  i]
                                                      .categoryIcon
                                                      : "${ApiEndpoints.strSiteUrl}${catalogBloc.subCategoryCatalogList[i].categoryIcon}",
                                                  width: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .width,
                                                  //placeholder: (context, url) => CircularProgressIndicator(),
                                                  placeholder:
                                                      (context, url) =>
                                                      Image.asset(
                                                        'assets/cellimage.jpg',
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                  errorWidget: (context,
                                                      url, error) =>
                                                      Image.asset(
                                                        'assets/cellimage.jpg',
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                    catalogBloc
                                                        .subCategoryCatalogList[
                                                    i]
                                                        .categoryName,
                                                    style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(15),
                                                      color: Color(
                                                        int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            key: Key(""),
                          ),
                        )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
