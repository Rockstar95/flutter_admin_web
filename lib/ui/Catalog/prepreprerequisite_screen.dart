import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/Splash/bloc/splash_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/catalog_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/associatedcontentresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/catalog_details_response.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/prequisitepopupresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/catalog_state.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/catalog_repositry_builder.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_builder.dart';
import 'package:flutter_admin_web/ui/Catalog/prerequisite_detail_screen.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class PrerequisiteScreen extends StatefulWidget {
  final PrequisitePopupresponse prequisitePopupresponse;
  final NativeMenuModel nativeMenuModel;
  final CatalogDetailsResponse catalogDetailsResponse;

  const PrerequisiteScreen(
    this.prequisitePopupresponse,
    this.nativeMenuModel,
    this.catalogDetailsResponse,
  );

  @override
  State<PrerequisiteScreen> createState() => _PrerequisiteScreenState();
}

class _PrerequisiteScreenState extends State<PrerequisiteScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  AssociatedContentResponse? associatedContentResponse;

  late MyLearningDetailsBloc myLearningBloc;
  late CatalogBloc catalogBloc;
  SplashBloc? splashBloc;

  late FToast flutterToast;
  bool _isChecked = false;

  bool isPopScreen = false;

  @override
  void initState() {
    super.initState();
    myLearningBloc = MyLearningDetailsBloc(
        myLearningRepository: MyLearningRepositoryBuilder.repository());
    catalogBloc =
        CatalogBloc(catalogRepository: CatalogRepositoryBuilder.repository());

    getAssociatedResponse();
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    return Scaffold(
        backgroundColor: Color(
          int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
        ),
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            ' ${widget.prequisitePopupresponse.prerequisteData.table2.isNotEmpty ? widget.prequisitePopupresponse.prerequisteData.table2[0].name : ""}',
            style: TextStyle(
                color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
          backgroundColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back, color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(child: preRequisiteWidget()),
        ),
        bottomNavigationBar: BlocConsumer<CatalogBloc, CatalogState>(
          bloc: catalogBloc,
          listener: (context, state) {
            if (state is AddEnrollState) {
              if (state.status == Status.COMPLETED) {
                if(isPopScreen) Navigator.of(context).pop(true);
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
            return new Container(
              child: Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child: MaterialButton(
                  disabledColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                      .withOpacity(0.5),
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: Text(
                      appBloc.localstr.catalogActionsheetAddtomylearningoption,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                  onPressed: () => {
                    if (catalogBloc.associatedContentResponse.parentcontent.ischecked){
                        catalogBloc.selectedContent.add(catalogBloc.associatedContentResponse.parentcontent.contentID)
                      }
                    else {
                        catalogBloc.selectedContent.remove(catalogBloc.associatedContentResponse.parentcontent.contentID)
                    },
                    if (catalogBloc.associatedContentResponse.parentcontent.ischecked &&
                        (catalogBloc.prerequisiteModelArrayListRecommended.isEmpty || catalogBloc.prerequisiteModelArrayListRecommended[0].ischecked) &&
                        (catalogBloc.prerequisiteModelArrayListCompletion.isEmpty || catalogBloc.prerequisiteModelArrayListCompletion[0].ischecked) &&
                        (catalogBloc.prerequisiteModelArrayListRequired.isEmpty || catalogBloc.prerequisiteModelArrayListRequired[0].ischecked)){
                      isPopScreen = true,
                      catalogBloc.add(AddEnrollEvent(
                          selectedContent: catalogBloc.formatString(catalogBloc.selectedContent),
                          componentID: int.parse(widget.nativeMenuModel.componentId),
                          componentInsID: int.parse(widget.nativeMenuModel.repositoryId),
                          additionalParams: '',
                          targetDate: ''))
                    }
                    else {
                      flutterToast.showToast(
                          child: CommonToast(displaymsg: 'Please select content item(s) to add'),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: Duration(seconds: 2))
                    }
                  },
                ),
              ),
            );
          },
        ));
  }

  Widget preRequisiteWidget() {
    return BlocConsumer<CatalogBloc, CatalogState>(
        bloc: catalogBloc,
        listener: (context, state) {
          if (state is GetAssociatedContentState) {
            if (state.status == Status.COMPLETED) {
              catalogBloc.associatedContentResponse.parentcontent.ischecked =
                  true;
            }
          }
          else if (state is AddEnrollState) {
            if (state.status == Status.COMPLETED) {
              flutterToast.showToast(
                  child: CommonToast(
                      displaymsg:
                          'The subscribed item has been added to your My Learning. Please click on My Learning, and then click on View to launch the content.'),
                  gravity: ToastGravity.BOTTOM,
                  toastDuration: Duration(seconds: 2));
              getAssociatedResponse();
            }
          }
          else if (state is AssociatedAddToMyLearning) {
            if (state.status == Status.COMPLETED) {
              Navigator.of(context).pop(true);
            }
          }
        },
        builder: (context, state) {
          if (state.status == Status.LOADING) {
            return Center(
              child: AbsorbPointer(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 70.0,
                ),
              ),
            );
          }
          else {
            return Column(
              children: [
                new Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        border: Border.all(color: Colors.grey.shade400)),
                    child: Text(
                      'Pre-requisite Sequence -' +
                          widget.prequisitePopupresponse.prerequisteData
                              .table[0].pathName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    )),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                      elevation: 4,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: <Widget>[
                              Container(
                                height: ScreenUtil().setHeight(120),
                                child: CachedNetworkImage(
                                  imageUrl: ApiEndpoints.strSiteUrl +
                                      catalogBloc.associatedContentResponse
                                          .parentcontent.thumbnailImagePath
                                          .trim(),
                                  width: MediaQuery.of(context).size.width,
                                  //placeholder: (context, url) => CircularProgressIndicator(),
                                  placeholder: (context, url) => Image.asset(
                                    'assets/cellimage.jpg',
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/cellimage.jpg',
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                  child: Align(
                                alignment: Alignment.topLeft,
                                child: Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    child: Checkbox(
                                        checkColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                        value: catalogBloc
                                            .associatedContentResponse
                                            .parentcontent
                                            .ischecked,
                                        onChanged: (val) {
                                          setState(() {
                                            catalogBloc
                                                .associatedContentResponse
                                                .parentcontent
                                                .ischecked = val ?? false;
                                          });
                                        })),
                              )),
                            ]),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                                child: Text(
                                  catalogBloc.associatedContentResponse.parentcontent.title,
                                  //catalogBloc.associatedContentResponse.parentcontent.title,
                                  style: TextStyle(
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                )),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Author: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                    Text(
                                      catalogBloc.associatedContentResponse.parentcontent.authorDisplayName,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Created on: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                  Text(
                                    catalogBloc.associatedContentResponse
                                        .parentcontent.createdOn,
                                    style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Content Type: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                    Text(
                                      catalogBloc.associatedContentResponse
                                          .parentcontent.contentType,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  ],
                                )),
                            catalogBloc.associatedContentResponse.parentcontent.isLearnerContent
                                ? Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Already in your 'My Learning' ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: MaterialButton(
                                        onPressed: () => {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PrerequisiteDetailScreen(
                                                        contentid: catalogBloc
                                                            .associatedContentResponse
                                                            .parentcontent
                                                            .contentID,
                                                        detailsBloc:
                                                            myLearningBloc,
                                                        table2: widget
                                                            .catalogDetailsResponse,
                                                        nativeModel: widget
                                                            .nativeMenuModel,
                                                        isFromNotification:
                                                            false,
                                                      )))
                                        },
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        disabledColor: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                            .withOpacity(0.5),
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Details',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                            ),
                                          ],
                                        ),
                                        textColor: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: catalogBloc
                                              .associatedContentResponse
                                              .parentcontent
                                              .isLearnerContent
                                          ? false
                                          : true,
                                      child: Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: MaterialButton(
                                          onPressed: () => {
                                            if (catalogBloc
                                                .associatedContentResponse
                                                .parentcontent
                                                .ischecked)
                                              {
                                                catalogBloc.selectedContent.add(
                                                    catalogBloc
                                                        .associatedContentResponse
                                                        .parentcontent
                                                        .contentID)
                                              }
                                            else
                                              {
                                                catalogBloc.selectedContent
                                                    .remove(catalogBloc
                                                        .associatedContentResponse
                                                        .parentcontent
                                                        .contentID)
                                              },
                                            if (catalogBloc
                                                    .associatedContentResponse
                                                    .parentcontent
                                                    .ischecked &&
                                                catalogBloc
                                                    .prerequisiteModelArrayListRecommended[
                                                        0]
                                                    .ischecked &&
                                                catalogBloc
                                                    .prerequisiteModelArrayListCompletion[
                                                        0]
                                                    .ischecked &&
                                                catalogBloc
                                                    .prerequisiteModelArrayListRequired[
                                                        0]
                                                    .ischecked)
                                              {
                                                catalogBloc.add(AssociatesAddToMyLearning(
                                                    selectedContent: catalogBloc
                                                        .formatMainString(
                                                            catalogBloc
                                                                .selectedContent),
                                                    componentID: widget
                                                        .nativeMenuModel
                                                        .componentId,
                                                    componentInsID: widget
                                                        .nativeMenuModel
                                                        .repositoryId,
                                                    additionalParams: '',
                                                    addLearnerPreRequisiteContent:
                                                        '',
                                                    addMultiinstanceswithprice:
                                                        '',
                                                    addWaitlistContentIDs: '',
                                                    multiInstanceEventEnroll:
                                                        ''))
                                              }
                                            else
                                              {
                                                flutterToast.showToast(
                                                    child: CommonToast(
                                                        displaymsg:
                                                            'Please select content item(s) to add'),
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    toastDuration:
                                                        Duration(seconds: 2))
                                              }
                                          },
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          disabledColor: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Add to my learning',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                            ],
                                          ),
                                          textColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      )))
                                ],
                              ),
                            )
                          ]),
                    ),
                ),
                new Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        border: Border.all(color: Colors.grey.shade400)),
                    child: Text(
                      'Recommended Pre-requisites',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                    )),
                catalogBloc.prerequisiteModelArrayListRecommended.length != 0
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: catalogBloc
                            .prerequisiteModelArrayListRecommended.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Card(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                elevation: 4,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(120),
                                          child: CachedNetworkImage(
                                            imageUrl: ApiEndpoints.strSiteUrl +
                                                catalogBloc
                                                    .prerequisiteModelArrayListRecommended[
                                                        index]
                                                    .thumbnailImagePath
                                                    .trim(),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            //placeholder: (context, url) => CircularProgressIndicator(),
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/cellimage.jpg',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/cellimage.jpg',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor: Color(
                                                      int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              child: Checkbox(
                                                  value: catalogBloc
                                                      .prerequisiteModelArrayListRecommended[
                                                          index]
                                                      .ischecked,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      catalogBloc
                                                          .prerequisiteModelArrayListRecommended[
                                                              index]
                                                          .ischecked = val ?? false;
                                                      if (val ?? false) {
                                                        catalogBloc
                                                            .selectedContent
                                                            .add(catalogBloc
                                                                .prerequisiteModelArrayListRecommended[
                                                                    index]
                                                                .contentID);
                                                      } else {
                                                        catalogBloc
                                                            .selectedContent
                                                            .remove(catalogBloc
                                                                .prerequisiteModelArrayListRecommended[
                                                                    index]
                                                                .contentID);
                                                      }
                                                    });
                                                  })),
                                        )),
                                      ]),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Text(
                                            catalogBloc
                                                .prerequisiteModelArrayListRecommended[
                                                    index]
                                                .title,
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Author: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListRecommended[
                                                          index]
                                                      .authorDisplayName,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Created on: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListRecommended[
                                                          index]
                                                      .createdOn,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Content Type: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListRecommended[
                                                          index]
                                                      .contentType,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      catalogBloc
                                              .prerequisiteModelArrayListRecommended[
                                                  index]
                                              .isLearnerContent
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "Already in your 'My Learning' ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                            )
                                          : Container(),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: MaterialButton(
                                                  onPressed: () => {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PrerequisiteDetailScreen(
                                                                  contentid: catalogBloc
                                                                      .prerequisiteModelArrayListRecommended[
                                                                          index]
                                                                      .contentID,
                                                                  detailsBloc:
                                                                      myLearningBloc,
                                                                  table2: widget
                                                                      .catalogDetailsResponse,
                                                                  nativeModel:
                                                                      widget
                                                                          .nativeMenuModel,
                                                                  isFromNotification:
                                                                      false,
                                                                )))
                                                  },
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  disabledColor: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                      .withOpacity(0.5),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Details',
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
                                              ),
                                            ),
                                            Visibility(
                                                visible: catalogBloc
                                                        .prerequisiteModelArrayListRecommended[
                                                            index]
                                                        .isLearnerContent
                                                    ? false
                                                    : true,
                                                child: Expanded(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: MaterialButton(
                                                    onPressed: () => {
                                                      isPopScreen = false,
                                                      catalogBloc.add(AddEnrollEvent(
                                                          selectedContent:
                                                              catalogBloc
                                                                  .prerequisiteModelArrayListRecommended[
                                                                      index]
                                                                  .contentID,
                                                          componentID:
                                                              int.parse(widget
                                                                  .nativeMenuModel
                                                                  .componentId),
                                                          componentInsID:
                                                              int.parse(widget
                                                                  .nativeMenuModel
                                                                  .repositoryId),
                                                          additionalParams: '',
                                                          targetDate: ''))
                                                    },
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    disabledColor: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.5),
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Add to my learning',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 14.0),
                                                        ),
                                                      ],
                                                    ),
                                                    textColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                  ),
                                                )))
                                          ],
                                        ),
                                      )
                                    ]),
                              ));
                        })
                    : Container(),
                new Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        border: Border.all(
                          color: Colors.grey.shade400,
                        )),
                    child: Text('Required Pre-requisites',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))),
                catalogBloc.prerequisiteModelArrayListRequired.length != 0
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: catalogBloc
                            .prerequisiteModelArrayListRequired.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Card(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                elevation: 4,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(120),
                                          child: CachedNetworkImage(
                                            imageUrl: ApiEndpoints.strSiteUrl +
                                                catalogBloc
                                                    .prerequisiteModelArrayListRequired[
                                                        index]
                                                    .thumbnailImagePath
                                                    .trim(),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            //placeholder: (context, url) => CircularProgressIndicator(),
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/cellimage.jpg',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/cellimage.jpg',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor: Color(
                                                      int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              child: Checkbox(
                                                  value: catalogBloc
                                                      .prerequisiteModelArrayListRequired[
                                                          index]
                                                      .ischecked,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      catalogBloc
                                                          .prerequisiteModelArrayListRequired[
                                                              index]
                                                          .ischecked = val ?? false;
                                                      if (val ?? false) {
                                                        catalogBloc
                                                            .selectedContent
                                                            .add(catalogBloc
                                                                .prerequisiteModelArrayListRequired[
                                                                    index]
                                                                .contentID);
                                                      } else {
                                                        catalogBloc
                                                            .selectedContent
                                                            .remove(catalogBloc
                                                                .prerequisiteModelArrayListRequired[
                                                                    index]
                                                                .contentID);
                                                      }
                                                    });
                                                  })),
                                        )),
                                      ]),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Text(
                                            catalogBloc
                                                .prerequisiteModelArrayListRequired[
                                                    index]
                                                .title,
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Author: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListRequired[
                                                          index]
                                                      .authorDisplayName,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Created on: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListRequired[
                                                          index]
                                                      .createdOn,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Content Type: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListRequired[
                                                          index]
                                                      .contentType,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      catalogBloc
                                              .prerequisiteModelArrayListRequired[
                                                  index]
                                              .isLearnerContent
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "Already in your 'My Learning' ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                            )
                                          : Container(),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: MaterialButton(
                                                  onPressed: () => {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PrerequisiteDetailScreen(
                                                                  contentid: catalogBloc
                                                                      .prerequisiteModelArrayListRequired[
                                                                          index]
                                                                      .contentID,
                                                                  detailsBloc:
                                                                      myLearningBloc,
                                                                  table2: widget
                                                                      .catalogDetailsResponse,
                                                                  nativeModel:
                                                                      widget
                                                                          .nativeMenuModel,
                                                                  isFromNotification:
                                                                      false,
                                                                )))
                                                  },
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  disabledColor: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                      .withOpacity(0.5),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Details',
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
                                              ),
                                            ),
                                            Visibility(
                                                visible: catalogBloc
                                                        .prerequisiteModelArrayListRequired[
                                                            index]
                                                        .isLearnerContent
                                                    ? false
                                                    : true,
                                                child: Expanded(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: MaterialButton(
                                                    onPressed: () => {
                                                      isPopScreen = false,
                                                      catalogBloc.add(AddEnrollEvent(
                                                          selectedContent:
                                                              catalogBloc
                                                                  .prerequisiteModelArrayListRequired[
                                                                      index]
                                                                  .contentID,
                                                          componentID:
                                                              int.parse(widget
                                                                  .nativeMenuModel
                                                                  .componentId),
                                                          componentInsID:
                                                              int.parse(widget
                                                                  .nativeMenuModel
                                                                  .repositoryId),
                                                          additionalParams: '',
                                                          targetDate: ''))
                                                    },
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    disabledColor: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.5),
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Add to my learning',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 14.0),
                                                        ),
                                                      ],
                                                    ),
                                                    textColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                  ),
                                                )))
                                          ],
                                        ),
                                      )
                                    ]),
                              ));
                        })
                    : Container(),
                new Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        border: Border.all(
                          color: Colors.grey.shade400,
                        )),
                    child: Text('Completion Pre-requisites',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(
                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))))),
                catalogBloc.prerequisiteModelArrayListCompletion.length != 0
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: catalogBloc
                            .prerequisiteModelArrayListCompletion.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Card(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                                elevation: 4,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(children: <Widget>[
                                        Container(
                                          height: ScreenUtil().setHeight(120),
                                          child: CachedNetworkImage(
                                            imageUrl: ApiEndpoints.strSiteUrl +
                                                catalogBloc
                                                    .prerequisiteModelArrayListCompletion[
                                                        index]
                                                    .thumbnailImagePath
                                                    .trim(),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            //placeholder: (context, url) => CircularProgressIndicator(),
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/cellimage.jpg',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/cellimage.jpg',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor: Color(
                                                      int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              child: Checkbox(
                                                  value: catalogBloc
                                                      .prerequisiteModelArrayListCompletion[
                                                          index]
                                                      .ischecked,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      catalogBloc
                                                          .prerequisiteModelArrayListCompletion[
                                                              index]
                                                          .ischecked = val ?? false;
                                                      if (val ?? false) {
                                                        catalogBloc
                                                            .selectedContent
                                                            .add(catalogBloc
                                                                .prerequisiteModelArrayListCompletion[
                                                                    index]
                                                                .contentID);
                                                      } else {
                                                        catalogBloc
                                                            .selectedContent
                                                            .remove(catalogBloc
                                                                .prerequisiteModelArrayListCompletion[
                                                                    index]
                                                                .contentID);
                                                      }
                                                    });
                                                  })),
                                        )),
                                      ]),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Text(
                                            catalogBloc
                                                .prerequisiteModelArrayListCompletion[
                                                    index]
                                                .title,
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, top: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Author: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListCompletion[
                                                          index]
                                                      .authorDisplayName,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Created on: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListCompletion[
                                                          index]
                                                      .createdOn,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: [
                                              Text('Content Type: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                              Text(
                                                  catalogBloc
                                                      .prerequisiteModelArrayListCompletion[
                                                          index]
                                                      .contentType,
                                                  style: TextStyle(
                                                      color: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                            ],
                                          )),
                                      catalogBloc
                                              .prerequisiteModelArrayListCompletion[
                                                  index]
                                              .isLearnerContent
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "Already in your 'My Learning' ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                              ),
                                            )
                                          : Container(),
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: MaterialButton(
                                                  onPressed: () => {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PrerequisiteDetailScreen(
                                                                  contentid: catalogBloc
                                                                      .prerequisiteModelArrayListCompletion[
                                                                          index]
                                                                      .contentID,
                                                                  detailsBloc:
                                                                      myLearningBloc,
                                                                  table2: widget
                                                                      .catalogDetailsResponse,
                                                                  nativeModel:
                                                                      widget
                                                                          .nativeMenuModel,
                                                                  isFromNotification:
                                                                      false,
                                                                )))
                                                  },
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  disabledColor: Color(int.parse(
                                                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                      .withOpacity(0.5),
                                                  color: Color(int.parse(
                                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Details',
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
                                              ),
                                            ),
                                            Visibility(
                                                visible: catalogBloc
                                                        .prerequisiteModelArrayListCompletion[
                                                            index]
                                                        .isLearnerContent
                                                    ? false
                                                    : true,
                                                child: Expanded(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: MaterialButton(
                                                    onPressed: () => {
                                                      isPopScreen = false,
                                                      catalogBloc.add(AddEnrollEvent(
                                                          selectedContent:
                                                              catalogBloc
                                                                  .prerequisiteModelArrayListCompletion[
                                                                      index]
                                                                  .contentID,
                                                          componentID:
                                                              int.parse(widget
                                                                  .nativeMenuModel
                                                                  .componentId),
                                                          componentInsID:
                                                              int.parse(widget
                                                                  .nativeMenuModel
                                                                  .repositoryId),
                                                          additionalParams: '',
                                                          targetDate: ''))
                                                    },
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    disabledColor: Color(int.parse(
                                                            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                                        .withOpacity(0.5),
                                                    color: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Add to my learning',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  int.parse(
                                                                      "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                              fontSize: 14.0),
                                                        ),
                                                      ],
                                                    ),
                                                    textColor: Color(int.parse(
                                                        "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")),
                                                  ),
                                                )))
                                          ],
                                        ),
                                      )
                                    ]),
                              ));
                        })
                    : Container()
              ],
            );
          }
        });
  }

  void getAssociatedResponse() {
    catalogBloc.add(GetAssociatedContentEvent(
      componentID: '1',
      componentInstanceID: '3131',
      //contentID: widget.catalogDetailsResponse.contentId,
      contentID: widget.catalogDetailsResponse.contentId,
      instancedata: "",
      preRequisiteSequncePathID: widget.prequisitePopupresponse.prerequisteData
          .table[0].preRequisiteSequnceID
          .toString(),
      localStr: LocalStr.fromJson({}),
    ));
  }
}
