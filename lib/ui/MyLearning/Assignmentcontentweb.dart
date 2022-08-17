import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:logger/logger.dart';
import 'package:webviewx/webviewx.dart';

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

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  WebViewXController? webviewController;

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
          body: GestureDetector(
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      child: getWebview(context),
                    ),
                  ],
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(),
              ],
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ),
    );
  }

  Widget myAppBar(DummyMyCatelogResponseTable2 myLearningModel) {
    if ([8, 9, 10].contains(myLearningModel.objecttypeid)) {
      return const SizedBox();
    }
    else {
      return AppBar(
        iconTheme: IconThemeData(
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
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (widget.url.contains('https://docs.google.com')) {
                  setState(() {
                    isLoading = true;
                  });
                  webviewController?.loadContent(widget.url, SourceType.url);
                }
              },
            ),
          )
        ],
      );
    }
  }

  Widget getWebview(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WebViewX(
      width: size.width,
      height: size.height,
      initialContent: widget.url.startsWith('www') ? 'https://${widget.url}' : widget.url,
      initialSourceType: SourceType.url,
      onWebViewCreated: (WebViewXController controller) {
        webviewController = controller;
      },
      onPageStarted: (String src) {
        print("On Page Started Src:${src}");
      },
      onPageFinished: (String src) {
        print("On Page Finished Src:${src}");
        setState(() {
          isLoading = false;
        });

        if (src.toLowerCase().contains("coursetracking/savecontenttrackeddata1") ||
            src.toLowerCase().contains("blank.html?ioscourseclose=true") ||
            src.toLowerCase().contains("userassignment/submituserassignmentresponse")
        ) {
          Navigator.of(context).pop(true);
        }
      },
      onWebResourceError: (WebResourceError error) {
        print("On Web Resource Error:${error.description}");
      },
      javascriptMode: JavascriptMode.unrestricted,
      webSpecificParams: const WebSpecificParams(
        webAllowFullscreenContent: true,
      ),
      userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
      navigationDelegate: (NavigationRequest navigation) async {
        print("navigationDelegate source Type:${navigation.content.sourceType}");
        print("navigationDelegate source:${navigation.content.source}");

        if(navigation.content.sourceType == SourceType.url && (navigation.content.source.startsWith("http://") || navigation.content.source.startsWith("https://"))) {
          return NavigationDecision.navigate;
        }
        else {
          return NavigationDecision.prevent;
        }
      },
    );
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
