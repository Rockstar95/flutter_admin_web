import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/bloc/wikiupload_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/event/wikiupload_event.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/model/wiki_categoryresponse.dart';
import 'package:flutter_admin_web/framework/bloc/catalog/state/wikiupload_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/repository/Catalog/wikiuploadrepo/wikiupload_repositry_builder.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

import '../common/outline_button.dart';
import 'wiki_categoriesscreen.dart';

class WikiUploadScreen extends StatefulWidget {
  // String urlString;
  final String titleString;
  final FileType _pickingType;

  // WikiCategoryModel wikiCategoryModel;

  const WikiUploadScreen(this.titleString, this._pickingType);

  @override
  State<WikiUploadScreen> createState() => _WikiUploadScreenState();
}

class _WikiUploadScreenState extends State<WikiUploadScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  List<WikiCategoryModel> wikiCategorieslistLocal = [];

  late WikiUploadBloc wikiUploadBloc;

  TextEditingController urlController = new TextEditingController();

  TextEditingController urlTController = new TextEditingController();

  TextEditingController dController = new TextEditingController();

  TextEditingController contentTController = new TextEditingController();

  late FToast flutterToast;

  var titleSelectCategory = 'Select Category';

  @override
  void initState() {
    super.initState();

    wikiUploadBloc = WikiUploadBloc(
        wikiUploadRepository: WikiUploadRepositoryBuilder.repository());

    // getWikiCategories();
  }

  @override
  void didUpdateWidget(covariant WikiUploadScreen oldWidget) {
    setState(() {
      contentTController.text = wikiUploadBloc.fileName;
      // dController.text = wikiUploadBloc.filePath;
      print('wikiUploadBloc.fileName: ${wikiUploadBloc.fileName}');
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    flutterToast = FToast();
    flutterToast.init(context);

    print("widget.titleString:${widget.titleString}");

    return Container(
      color: Color(
        int.parse(
            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(
            int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
          ),
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Add ${widget.titleString}',
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
            ),
//              contextList.isNotEmpty ?,
//                  :Container(),
          ),
          body: BlocConsumer<WikiUploadBloc, WikiUploadState>(
            bloc: wikiUploadBloc,
            listener: (context, state) {},
            builder: (context, state) {
              print("wikiUploadBloc Status:${state.status}");

              if (state is PostWikiUploadState && state.status == Status.LOADING/* && wikiUploadBloc.isFirstLoading == true*/) {
                return Center(
                  //heightFactor: ScreenUtil().setWidth(10),
                  //widthFactor: ScreenUtil().setWidth(10),
                  child: AbsorbPointer(
                    child: SpinKitCircle(
                      color: Colors.grey,
                      size: 70,
                    ),
                  ),
                );
              }
              else if (state is PostWikiUploadState && state.status == Status.COMPLETED) {
                // Navigator.pop(context);
                Navigator.pop(context, true);

                Future.delayed(Duration.zero, () async {
                  flutterToast.showToast(
                    child: CommonToast(displaymsg: '${contentTController.text} Submitted Successfully'),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                });
              }
              if (state is OpenFileExplorerState) {
                if (contentTController.text.isEmpty)
                  contentTController.text = wikiUploadBloc.fileName;

                // dController.text = wikiUploadBloc.filePath;
              }
              return SingleChildScrollView(
                reverse: true,
                child: widget.titleString != 'Url'
                    ? Column(
                        children: [
                          wikiUploadBloc.filePath.isEmpty
                              ? Container(
                            color: Color(
                              int.parse(
                                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                              ),
                              elevation: 12.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Add ${widget.titleString}",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(
                                            int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: MaterialButton(
                                        onPressed: () => {
                                          print('choose file '),
                                          wikiUploadBloc.add(OpenFileExplorerEvent(widget._pickingType)),
                                        },
                                        disabledColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.5),
                                        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                        child: Text('Choose file'),
                                        textColor: Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                                ),
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    wikiUploadBloc.fileName.length > 0
                                        ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "Attachment",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        wikiUploadBloc.fileName,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),),
                                          /*fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,*/
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 6.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Title",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: TextField(
                                        controller: contentTController,
                                        decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.grey)),
                                            hintText: 'Title',
                                            hintStyle:
                                            TextStyle(color: Colors.grey)),
                                        style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 6.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Short Description ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: TextField(
                                        controller: dController,
                                        cursorHeight: 25.0,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.grey)),
                                            hintText: 'Enter Short description',
                                            hintStyle:
                                            TextStyle(color: Colors.grey)),
                                        style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 0.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Categories",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //     padding: const EdgeInsets.all(12.0),
                                    //     child: OutlineButton(
                                    //       borderSide: BorderSide(
                                    //           color: Color(int.parse(
                                    //               "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                    //       child: SizedBox(
                                    //         child: Text(
                                    //           titleSelectCategory,
                                    //           style: TextStyle(
                                    //               color: Color(int.parse(
                                    //                   "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                                    //         ),
                                    //         width: MediaQuery.of(context)
                                    //             .size
                                    //             .width,
                                    //       ),
                                    //       onPressed: () {
                                    //         movetoWikiCategories();
                                    //       },
                                    //     )),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 1.0,
                                            bottom: 5.0,
                                            left: 12.0,
                                            right: 12.0),
                                        child: OutlineButton(
                                          border: Border.all(
                                              color: Colors.grey.shade500),
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                      titleSelectCategory,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.grey.shade600),
                                                    )),
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.grey.shade600,
                                                )
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          onPressed: () {
                                            movetoWikiCategories();
                                          },
                                        )),
                                    wikiUploadBloc.filePath.isNotEmpty
                                        ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MaterialButton(
                                          onPressed: () => {
                                            wikiUploadBloc.filePath =
                                            '',
                                            wikiUploadBloc.fileName =
                                            '',
                                            contentTController.text =
                                            '',
                                            dController.text = '',
                                            wikiCategorieslistLocal =
                                            [],
                                            updateInformation(
                                                'Select Category'),
                                          },
                                          disabledColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                          child: Text('Delete'),
                                          textColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                    )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: MaterialButton(
                                          onPressed: () => {
                                            validateUploadData(false),
                                          },
                                          minWidth:
                                          MediaQuery.of(context).size.width,
                                          disabledColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                          child: Text('Upload'),
                                          textColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                              color: Color(
                                int.parse(
                                    "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                color: Color(
                                  int.parse(
                                      "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
                                ),
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 6.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Website URL",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: TextField(
                                        style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                        controller: urlController,
                                        decoration: InputDecoration(
                                            hintText: 'www.instancy.com',
                                            hintStyle:
                                            TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 6.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Website Title",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: TextField(
                                        style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                        controller: urlTController,
                                        decoration: InputDecoration(
                                            hintText: 'Instancy',
                                            hintStyle:
                                            TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 6.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Description (Optional)",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 16.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: TextField(
                                        style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"),
                                            )),
                                        controller: dController,
                                        cursorHeight: 25.0,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.grey)),
                                            hintText: 'Enter description',
                                            hintStyle:
                                            TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0,
                                          bottom: 6.0,
                                          left: 16.0,
                                          right: 16.0),
                                      child: Text(
                                        "Add Categories",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: OutlineButton(
                                          border: Border.all(
                                              color: Color(int.parse(
                                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))),
                                          child: SizedBox(
                                            child: Text(
                                              titleSelectCategory,
                                              style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          onPressed: () {
                                            movetoWikiCategories();
                                          },
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: MaterialButton(
                                          onPressed: () => {
                                            if (urlController.text.isEmpty)
                                              {
                                                flutterToast.showToast(
                                                  child: CommonToast(
                                                      displaymsg:
                                                      'Invalid  Url'),
                                                  gravity:
                                                  ToastGravity.BOTTOM,
                                                  toastDuration:
                                                  Duration(seconds: 2),
                                                )
                                              }
                                            else if (urlTController
                                                .text.isEmpty)
                                              {
                                                flutterToast.showToast(
                                                  child: CommonToast(
                                                      displaymsg:
                                                      'Enter title'),
                                                  gravity:
                                                  ToastGravity.BOTTOM,
                                                  toastDuration:
                                                  Duration(seconds: 2),
                                                )
                                              }
                                            else
                                              {
                                                validateUploadData(true),
                                              },
                                          },
                                          minWidth:
                                          MediaQuery.of(context).size.width,
                                          disabledColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                              .withOpacity(0.5),
                                          color: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                                          child: Text('Add'),
                                          textColor: Color(int.parse(
                                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}"))),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  void validateUploadData(bool isWebsite) {
    var objectTypeID = 0;
    var mediaTypeID = 0;

    switch (widget._pickingType) {
      case FileType.image:
        objectTypeID = 11;
        mediaTypeID = 1;
        break;
      case FileType.audio:
        objectTypeID = 11;
        mediaTypeID = 4;
        break;
      case FileType.video:
        objectTypeID = 11;
        mediaTypeID = 3;
        break;
      case FileType.custom:
        objectTypeID = 14;
        mediaTypeID = 0;
        break;
      default:
        if (isWebsite) {
          objectTypeID = 28;
          mediaTypeID = 13;
        } else {
          objectTypeID = 14;
          mediaTypeID = 0;
        }
        break;
    }

    var filepath = wikiUploadBloc.filePath;
    var descriptionVar = dController.text;
    var titleNameVar = contentTController.text;

    if (isWebsite) {
      titleNameVar = urlTController.text;
      descriptionVar = dController.text;
      filepath = urlController.text;
    }

    if (!isWebsite && filepath.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Choose file'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    } else if (titleNameVar.isEmpty) {
      flutterToast.showToast(
        child: CommonToast(displaymsg: 'Enter file name'),
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 4),
      );
      return;
    }

    var categoryIDs = printTheData();

    wikiUploadBloc.add(PostWikiUploadEvent(
      isUrl: isWebsite,
      filepath: filepath,
      mediaTypeID: mediaTypeID,
      objectTypeID: objectTypeID,
      title: titleNameVar,
      shortDesc: descriptionVar,
      userID: 0,
      siteID: int.parse(ApiEndpoints.siteID),
      localeID: '',
      componentID: 1,
      cMSGroupId: 1,
      keywords: '',
      orgUnitID: int.parse(ApiEndpoints.siteID),
      eventCategoryID: '',
      categoryId: categoryIDs,
    ));
  }

  void getWikiCategories() {
    wikiUploadBloc.add(GetWikiCategoriesEvent(
      intUserID: 1,
      intSiteID: 2,
      intComponentID: 2,
      locale: '2',
      strType: 'cat',
    ));
  }

  void movetoWikiCategories() async {
    wikiCategorieslistLocal = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WikiCategoryScreen(
                      wikiCategorieslistLocal: wikiCategorieslistLocal,
                    ))) ??
        [];

    updateCategoryTitle();
  }

  String formatString(List x) {
    if (x.length == 0) {
      return 'Select Category';
    }
    String formatted = '';
    for (var i in x) {
      formatted += '$i,';
    }
    return formatted.replaceRange(formatted.length - 1, formatted.length, '');
  }

  String printTheData() {
    List<String> selectedCategoryID = [];

    wikiCategorieslistLocal.length > 0
        ? wikiCategorieslistLocal.forEach((element) {
            selectedCategoryID.add('${element.categoryID}');
          })
        : selectedCategoryID.clear();
    print('selectedCategoryID ${formatString(selectedCategoryID)}');

    // updateInformation(formatString(selectedCategoryID));

    return formatString(selectedCategoryID);
  }

  String updateCategoryTitle() {
    List<String> selectedCategoryID = [];

    wikiCategorieslistLocal.length > 0
        ? wikiCategorieslistLocal.forEach((element) {
            selectedCategoryID.add('${element.name}');
          })
        : selectedCategoryID.clear();
    print('selectedCategoryID ${formatString(selectedCategoryID)}');

    updateInformation(formatString(selectedCategoryID));

    return formatString(selectedCategoryID);
  }

  void updateInformation(String information) {
    setState(() => titleSelectCategory = information);
  }
}
