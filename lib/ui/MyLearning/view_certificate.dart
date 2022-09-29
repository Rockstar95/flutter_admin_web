import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/mylearning_details_state.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/downloader/file_course_downloader.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../configs/constants.dart';

class ViewCertificate extends StatefulWidget {
  final MyLearningDetailsBloc detailsBloc;

  const ViewCertificate({Key? key, required this.detailsBloc}) : super(key: key);

  @override
  _ViewCertificateState createState() => _ViewCertificateState();
}

class _ViewCertificateState extends State<ViewCertificate> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  String imageUrl = '';
  late FToast flutterToast;

  Completer<WebViewController> _controller = Completer<WebViewController>();
  final CookieManager cookieManager = CookieManager();

  //var  imageUrl="https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg";
  bool downloading=true;
  String downloadingStr="No data";
  double download=0.0;
  late File f;
  late FileCourseDownloader fileCourseDownloader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterToast = FToast();
    flutterToast.init(context);

    widget.detailsBloc.add(GetCerificateEvent(
      contentId: widget.detailsBloc.myLearningDetailsModel.contentID,
      certificatePage:
          widget.detailsBloc.myLearningDetailsModel.certificatePage,
      certificateId: widget.detailsBloc.myLearningDetailsModel.certificateId,
    ));
    CookieManager().clearCookies();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // _onClearCookies(context);
  }

  @override
  Widget build(BuildContext context) {
    basicDeviceHeightWidth(context,
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    // TODO: implement build
    return BlocConsumer<MyLearningDetailsBloc,MyLearningDetailsState>(
      bloc: widget.detailsBloc,
      listener: (context, state) {
        if (state is GetCertificateState) if (state.status ==
            Status.COMPLETED) {
          setState(() {
            imageUrl = ApiEndpoints.strSiteUrl + state.isCompleted;
          });

          print('imageurl $imageUrl');
        }
        if (state.status == Status.ERROR) {
          flutterToast.showToast(
            child: CommonToast(displaymsg: 'Something went wrong'),
            gravity: ToastGravity.BOTTOM,
            toastDuration: Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Certificate",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
              elevation: 2,
              backgroundColor: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                (state.status == Status.COMPLETED)
                    ? Builder(builder: (BuildContext context) {
                        return Container(
                          child: WebView(
                            debuggingEnabled: false,
                            initialUrl:
                                ('https://docs.google.com/gview?embedded=true&url=$imageUrl'),
                            javascriptMode: JavascriptMode.unrestricted,
                            gestureNavigationEnabled: false,
                          ),
                        );
                      })
                    : Container(),
                (state.status == Status.LOADING)
                    ? Container(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                        child: Center(
                            child: AbsorbPointer(
                          child: AppConstants().getLoaderWidget(iconSize: 70)
                        )),
                      )
                    : Container()
              ],
            ),
            bottomNavigationBar: Container(
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  disabledColor: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                      .withOpacity(0.5),
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                  child: Text("Download",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(int.parse(
                              "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
         onPressed: () async {
                            try {
                              PermissionStatus permission =
                                  await Permission.storage.status;

                              if (permission != PermissionStatus.granted) {
                                await Permission.storage.request();
                                PermissionStatus permission =
                                    await Permission.storage.status;
                                if (permission == PermissionStatus.granted) {
                                  /// Permission Granted
                                  ///
                                  ///
                                  downloadPdf(imageUrl, 0);
                                } else {
                                  /// Notify User

                                }
                              } else {
                                downloadPdf(imageUrl, 0);
                              }
                            } on Exception {
                              print('Could not get the downloads directory');
                            }
                          },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
String pathSeparator = "";String downloadResPath = '';String urlpath = "";
  void downloadPdf(String refItem, int position) async {
    if (pathSeparator == null || pathSeparator.trim().isEmpty) {
      pathSeparator = Platform.pathSeparator;
    }
    String dirloc = "";

    if (Platform.isAndroid) {
      downloadResPath = (await getExternalStorageDirectories(type: StorageDirectory.downloads))!.first.path + pathSeparator+ refItem;
      //'/sdcard/download/'+ refItem; //for android belwo 11 version i.e 10 it's is worked
      ////(await getExternalStorageDirectories(type: StorageDirectory.downloads)).first.path + refItem; => For android 11 and above used external storage Directories.
    } else {
      downloadResPath = (await getApplicationDocumentsDirectory()).path +
          pathSeparator +
          refItem;
    }

    final savedDir = Directory(downloadResPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create(recursive: true);
    }

    String extensionStr = refItem.split('/').last;

    //print('extensionString $urlpath');

    if (refItem == 'url') {
      urlpath = refItem;
    } else {
     urlpath = refItem;

      if (urlpath.toLowerCase().contains(".ppt") ||
          urlpath.toLowerCase().contains(".pptx") ||
        //  urlpath.toLowerCase().contains(".pdf") ||
          urlpath.toLowerCase().contains(".doc") ||
          urlpath.toLowerCase().contains(".docx") ||
          urlpath.toLowerCase().contains(".xls") ||
          urlpath.toLowerCase().contains(".xlsx")) {
        urlpath = urlpath.replaceAll("file://", "");
        urlpath = "https://docs.google.com/gview?embedded=true&url=" + urlpath;
      } else if (urlpath.toLowerCase().contains(".pdf")) {
        if (appBloc.uiSettingModel.isCloudStorageEnabled.toLowerCase() ==
            'true') {
          urlpath = urlpath + "?fromnativeapp=true";
        } else {
          urlpath = urlpath + "?fromNativeapp=true";
        }
      } else {
        urlpath = urlpath;
      }
    }

    fileCourseDownloader =
        FileCourseDownloader(urlpath, (CallbackParam callbackParam) {
      if (callbackParam != null) {
        _downloaderCallBack(callbackParam, context, position, refItem);
      }
    }, downloadResPath, pathSeparator, extensionStr);

    initialiseModelDownloadAll();
  }

  int _downloadProgress = 0;bool _downloaded = false;

  Future<void> _downloaderCallBack(CallbackParam callbackParam,
      BuildContext context, int position, String refItem) async {
    try {
      setState(() {
        _downloadProgress = callbackParam.progress;
      });
      _downloaded = callbackParam.status == DownloadTaskStatus.complete;

//

      if (_downloadProgress == -1) {
        //nextScreenNav(context, false);
        print("PDF download have error ........");
        // setState(() {
        //   refItem.isDownloaded = false;
        //   refItem.isDownloading = false;
        // });

        flutterToast.showToast(
          child: CommonToast(displaymsg: 'Error while downloading'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
      } else if (_downloadProgress == 100) {
        // setState(() {
        //   refItem.isDownloaded = true;
        //   refItem.isDownloading = false;
        // });

        flutterToast.showToast(
          child: CommonToast(displaymsg: 'Successfully downloaded'),
          gravity: ToastGravity.BOTTOM,
          toastDuration: Duration(seconds: 2),
        );
      } else {
        // setState(() {
        //   refItem.isDownloaded = false;
        //   refItem.isDownloading = true;
        // });
      }
    } catch (e) {
      // setState(() {
      //   refItem.isDownloaded = false;
      //   refItem.isDownloading = true;
      // });
    }
  }

   void initialiseModelDownloadAll() async {
    fileCourseDownloader.startDownload();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
