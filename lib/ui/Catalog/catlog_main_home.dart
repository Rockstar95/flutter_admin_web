import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/ui/Catalog/calalog_sub_category_screen.dart';
import 'package:flutter_admin_web/ui/Catalog/catalog_sub_screen.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';

class CatalogMainScreen extends StatefulWidget {
  @override
  _CatalogMainScreenState createState() => _CatalogMainScreenState();
}

class _CatalogMainScreenState extends State<CatalogMainScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  CatalogBloc get catalogBloc => BlocProvider.of<CatalogBloc>(context);
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myLearningBloc.add(ResetFilterEvent());
    myLearningBloc.add(GetFilterMenus(
        listNativeModel: appBloc.listNativeModel,
        localStr: appBloc.localstr,
        moduleName: "Catalog"));
    myLearningBloc.add(GetSortMenus("1"));
    catalogBloc.add(SetCatalogSideMenuEvent(appBloc.listNativeModel));
    catalogBloc.add(GetCategoryForBrowseEvent());
  }

  @override
  Widget build(BuildContext context) {
    //print("In Catalog Main Screen");

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(
          int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
        ),
        body: Container(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: BlocConsumer<CatalogBloc, CatalogState>(
            bloc: catalogBloc,
            listener: (context, state) {
              if (state.status == Status.ERROR) {
                print("listner Error ${state.message}");
                if (state.message == "401") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginCommonPage()),
                      (route) => false);
                }
              }
            },
            builder: (context, state) {
              print("state -----$state");
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
                /*   if(catalogBloc.na){

                }else{*/
                return catalogBloc.displayCatalogList.length == 0
                    ? noDataFound(true)
                    : ListView.builder(
                        itemCount: catalogBloc.displayCatalogList.length,
                        itemBuilder: (context, i) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                child: Text(
                                    catalogBloc
                                        .displayCatalogList[i].categoryName,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                height: ScreenUtil().setSp(172),
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: catalogBloc.displayCatalogList[i].subcategoryList.length,
                                    itemBuilder: (context, j) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            //print("In ListView Builder");
                                            myLearningBloc
                                                .add(ResetFilterEvent());
                                            print(
                                                "hasChild ---- ${catalogBloc.displayCatalogList[i].subcategoryList[j].hasChild}");

                                            if (catalogBloc
                                                .displayCatalogList[i]
                                                .subcategoryList[j]
                                                .hasChild) {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      CatalogSubCategoryScreen(
                                                          categaoryID: catalogBloc
                                                              .displayCatalogList[
                                                                  i]
                                                              .subcategoryList[
                                                                  j]
                                                              .categoryId,
                                                          categaoryName: catalogBloc
                                                              .displayCatalogList[
                                                                  i]
                                                              .subcategoryList[
                                                                  j]
                                                              .categoryName)));
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CatalogSubScreen(
                                                            categaoryID: catalogBloc
                                                                .displayCatalogList[
                                                                    i]
                                                                .subcategoryList[
                                                                    j]
                                                                .categoryId,
                                                            categaoryName: catalogBloc
                                                                .displayCatalogList[
                                                                    i]
                                                                .subcategoryList[
                                                                    j]
                                                                .categoryName,
                                                            nativeMenuModel:
                                                                NativeMenuModel(categoryStyle: "",componentId: "",conditions: "",contextTitle: "",contextmenuId: "",displayOrder: 0,displayname: "",image: "",isEnabled: "",isofflineMenu: "",landingpageType: "",menuid: "",parameterString: "",parentMenuId: "",repositoryId: "",siteId: "",siteUrl: "",webMenuId: 0),
                                                          )));
                                            }
                                          },
                                          child: Container(
                                            width: ScreenUtil().setWidth(150),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: ScreenUtil()
                                                      .setHeight(100),
                                                  width: ScreenUtil()
                                                      .setWidth(150),
                                                  child: catalogBloc
                                                              .displayCatalogList[
                                                                  i]
                                                              .subcategoryList[
                                                                  j]
                                                              .categoryIcon ==
                                                          ""
                                                      ? Image.asset(
                                                          'assets/cellimage.jpg',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: catalogBloc
                                                                  .displayCatalogList[
                                                                      i]
                                                                  .subcategoryList[
                                                                      j]
                                                                  .categoryIcon
                                                                  .startsWith(
                                                                      "http")
                                                              ? catalogBloc
                                                                  .displayCatalogList[
                                                                      i]
                                                                  .subcategoryList[
                                                                      j]
                                                                  .categoryIcon
                                                              : "${ApiEndpoints.strSiteUrl}${catalogBloc.displayCatalogList[i].subcategoryList[j].categoryIcon}",
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          //placeholder: (context, url) => CircularProgressIndicator(),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            'assets/cellimage.jpg',
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'assets/cellimage.jpg',
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        catalogBloc
                                                            .displayCatalogList[
                                                                i]
                                                            .subcategoryList[j]
                                                            .categoryName,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(12),
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          );
                        });
                /*  }*/

              }
              else if (state.status == Status.ERROR) {
                return noDataFound(true);
              }
              else {
                return Center(
                  child: AbsorbPointer(
                    child: SpinKitCircle(
                      color: Colors.grey,
                      size: 70.h,
                    ),
                  ),
                );
              }
            },
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
        : new Container();
  }
}
