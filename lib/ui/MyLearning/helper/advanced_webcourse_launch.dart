import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdvancedWebCourseLaunch extends StatefulWidget {
  AdvancedWebCourseLaunch(this.url, this.myLearningModel);

  final String url;
  final String myLearningModel;

  @override
  _AdvancedWebCourseLaunchState createState() =>
      _AdvancedWebCourseLaunchState();
}

class _AdvancedWebCourseLaunchState extends State<AdvancedWebCourseLaunch> {
  final _key = UniqueKey();
  bool isLoading = false;

  Logger logger = Logger();

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late WebViewController myCon;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    print(".....i am from web view .........${widget.url}");
    print(widget.url);
    isLoading = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    timer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("IsLoading:$isLoading");

    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Container(
        color: Color(int.parse("0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        child: SafeArea(
          child: Scaffold(
              appBar: myAppBar(widget.myLearningModel),
              body: Stack(
                children: <Widget>[
                  Column(
                    children: [
                      Expanded(
                        child: getWebview(),
                      ),
                    ],
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                ],
              )),
        ),
      ),
    );
  }

  Widget getWebview() {
    return WebView(
      key: _key,
      gestureNavigationEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      //initialUrl: "about:blank",
      //initialUrl: "https://www.google.com/",
      initialUrl: widget.url,
      onWebViewCreated: (WebViewController webViewController) {
        myCon = webViewController;
        _controller.complete(webViewController);
        //myCon.loadUrl(widget.url);

        //checkUrl(myCon);
      },
      userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
      navigationDelegate: (NavigationRequest request) {
        print("Url For navigationDelegate:${request.url}");
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to ${request.url}}');
          return NavigationDecision.prevent;
        }
        /*else if(request.url.startsWith("intent://")) {
          myCon.loadRequest(WebViewRequest(uri: Uri.parse(widget.url), method: WebViewRequestMethod.get));
          return NavigationDecision.prevent;
        }*/
        else {
          print('.........allowing navigation to..... ${request.url}');
          return NavigationDecision.navigate;
        }
      },
      debuggingEnabled: true,
      onPageFinished: (url) {
        print("onPageFinished:$url");
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  void checkUrl(WebViewController myCon) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      print("....hello timer....");
      String url = (await myCon.currentUrl()) ?? "";
      print("Current Url:$url");

      //logger.e("......SAGAR..myCon.currentUrl().......$url");
    });
  }

  AppBar myAppBar(String myLearningModel) {
    //
    //    if (myLearningModel.objecttypeid == 8 || myLearningModel.objecttypeid == 9 || myLearningModel.objecttypeid == 10) {
    //      return null;
    //    }
    //    else
    //      {

    return AppBar(
      backgroundColor: Color(int.parse(
          "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
      elevation: 0,
      title: Text(
        myLearningModel,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[],
    );
  }

//  }
}
