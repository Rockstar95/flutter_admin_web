import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Assignmentcontentweb extends StatefulWidget {
  Assignmentcontentweb({required this.url, required this.myLearningModel});

  final String url;
  final DummyMyCatelogResponseTable2 myLearningModel;

  Assignmentcontent createState() => Assignmentcontent();
}

class Assignmentcontent extends State<Assignmentcontentweb> {
  final _key = UniqueKey();
  bool isLoading = false;

  Logger logger = Logger();

  MyLearningBloc get myLearningBloc => BlocProvider.of<MyLearningBloc>(context);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  InAppWebViewController? webView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(".....i am from web view .........");
    print(widget.url);
    isLoading = true;
    // myLearningBloc.add(UpdateCompleteStatusEvent(
    //     contentID: widget.myLearningModel.contentid,
    //     userID: widget.myLearningModel.contentid,
    //     scoID: widget.myLearningModel.scoid.toString()));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          // appBar: myAppBar(widget.myLearningModel),
          body: new GestureDetector(
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      child: InAppWebView(
                        initialOptions: InAppWebViewGroupOptions(
                          ///*
                          android: AndroidInAppWebViewOptions(
                            allowFileAccess: true,
                          ),
                          ios: IOSInAppWebViewOptions(),
                          crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                            useOnLoadResource: true,
                          ),
                        ),
                        initialUrlRequest: URLRequest(
                            url: Uri.tryParse(widget.url.startsWith('www')
                                ? 'https://${widget.url}'
                                : widget.url),
                            headers: {}),
                        onLoadResource: (InAppWebViewController controller,
                            LoadedResource resource) {
                          //logger.e("....onLoadResource.....SAGAR.....${resource.url}");

                          /// temp method

                          if ((resource.url?.path.toLowerCase() ?? "").contains(
                                  "coursetracking/savecontenttrackeddata1") ||
                              (resource.url?.path.toLowerCase() ?? "")
                                  .contains("blank.html?ioscourseclose=true") ||
                              (resource.url?.path.toLowerCase() ?? "").contains(
                                  "userassignment/submituserassignmentresponse")) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        shouldOverrideUrlLoading:
                            (InAppWebViewController controller,
                                NavigationAction navigationAction) async {
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
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          ),
        ),
      ),
    );
  }

  Widget myAppBar(DummyMyCatelogResponseTable2 myLearningModel) {
    if (myLearningModel.objecttypeid == 8 ||
        myLearningModel.objecttypeid == 9 ||
        myLearningModel.objecttypeid == 10) {
      return SizedBox();
    } else {
      return AppBar(
        iconTheme: new IconThemeData(
          color: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
        ),
        backgroundColor: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
        elevation: 0,
        title: Text(
          widget.myLearningModel.name,
          style: TextStyle(
            fontSize: 18,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(true),
          child: Icon(Icons.arrow_back,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
        ),
        actions: [
          Visibility(
            visible: widget.myLearningModel.mediatypeid != 13,
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                if (widget.url.contains('https://docs.google.com')) {
                  setState(() {
                    isLoading = true;
                  });
                  webView?.loadUrl(
                      urlRequest: URLRequest(url: Uri.tryParse(widget.url)));
                }
              },
            ),
          )
        ],
      );
    }
  }

  bool isFullScreen(DummyMyCatelogResponseTable2 myLearningModel) {
    if (FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).unfocus();
    }
    if (myLearningModel.objecttypeid == 8 ||
        myLearningModel.objecttypeid == 9 ||
        myLearningModel.objecttypeid == 10) {
      return true;
    } else {
      return false;
    }
  }
}
