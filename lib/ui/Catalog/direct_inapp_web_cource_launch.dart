import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebCourseDirectLaunch extends StatefulWidget {
  InAppWebCourseDirectLaunch(this.url, this.myLearningModel);

  final String url;
  final DummyMyCatelogResponseTable2 myLearningModel;

  @override
  _InAppWebCourseDirectLaunchState createState() =>
      _InAppWebCourseDirectLaunchState();
}

class _InAppWebCourseDirectLaunchState
    extends State<InAppWebCourseDirectLaunch> {
  final _key = UniqueKey();
  bool isLoading = false;

  Logger logger = Logger();

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late InAppWebViewController webView;

  String demoUrl =
      "https://flutter.instancy.com/ajaxcourse/ScoID/13981/ContentTypeId/8/ContentID/0139db3d-3267-43d6-842b-d81b859a815f/AllowCourseTracking/true/trackuserid/302/ismobilecontentview/true/ContentPath/~Content~PublishFiles~586023ec-28a5-4b34-80a0-7fb191529172~start.html%3FnativeappURL=true";

  @override
  void initState() {
    super.initState();
    print(".....i am from web view .........");
    print(widget.url);
    isLoading = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(
            int.parse(
                "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}"),
          ),
          appBar: AppBar(
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
            elevation: 0,
            title: Text(
              widget.myLearningModel.name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      initialOptions: InAppWebViewGroupOptions(
                        /* android: AndroidInAppWebViewOptions(
                            allowFileAccess: true,
                            allowFileAccessFromFileURLs: true,
                            allowUniversalAccessFromFileURLs: true,
                            loadWithOverviewMode: true,
                            useWideViewPort: true,
                            domStorageEnabled: true,
                            //layoutAlgorithm: WebVie
                            databaseEnabled: true,
                            saveFormData: true,
                            useShouldInterceptRequest: true,


                          ),

                            ios: IOSInAppWebViewOptions(

                            ),*/

                        crossPlatform: InAppWebViewOptions(
                          javaScriptEnabled: true,
                          //useShouldOverrideUrlLoading: true,
                          useOnLoadResource: true,
                          //cacheEnabled: true,
                          //javaScriptCanOpenWindowsAutomatically: true,
                          //mediaPlaybackRequiresUserGesture: true,
                          //supportZoom: true,
                          //useShouldInterceptAjaxRequest: true,
                          //useShouldInterceptFetchRequest: true,
                        ),
                      ),
                      initialUrlRequest: URLRequest(
                          url: Uri.tryParse(widget.url), headers: {}),
                      //initialUrl: demoUrl,
                      onLoadResource: (InAppWebViewController controller,
                          LoadedResource resource) {
                        //logger.e("....onLoadResource.....SAGAR.....${resource.url}");

                        /// temp method

                        /*if(resource.url.contains("https://flutterapi.instancy.com/api/CourseTracking/SaveContentTrackedData1"))
                        {
                          Navigator.of(context).pop();
                        }*/
                      },
                      shouldOverrideUrlLoading:
                          (InAppWebViewController controller,
                              NavigationAction navigationAction) async {
                        //logger.e("....shouldOverrideUrlLoading.....SAGAR.....${shouldOverrideUrlLoadingRequest.url}");
                        //return ShouldOverrideUrlLoadingAction.ALLOW;
                        return NavigationActionPolicy.ALLOW;
                      },
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      onLoadStart:
                          (InAppWebViewController controller, Uri? url) {
                        //logger.e("....onLoadStart.....SAGAR.....$url");
                      },
                      onLoadStop:
                          (InAppWebViewController controller, Uri? url) {
                        //logger.e("....onLoadStop.....SAGAR.....$url");
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
            ],
          )),
    );
  }

  Widget myAppBar(DummyMyCatelogResponseTable2 myLearningModel) {
    if (myLearningModel.objecttypeid == 8 ||
        myLearningModel.objecttypeid == 9 ||
        myLearningModel.objecttypeid == 10) {
      return SizedBox();
    } else {
      return AppBar(
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
        elevation: 0,
        title: Text(
          widget.myLearningModel.name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  bool isFullScreen(DummyMyCatelogResponseTable2 myLearningModel) {
    if (myLearningModel.objecttypeid == 8 ||
        myLearningModel.objecttypeid == 9 ||
        myLearningModel.objecttypeid == 10) {
      return true;
    } else {
      return false;
    }
  }
}
