import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

import '../../../framework/helpers/utils.dart';

class OfflineContentLauncherInAppWebview extends StatefulWidget {
  final DummyMyCatelogResponseTable2 table2;
  const OfflineContentLauncherInAppWebview({Key? key, required this.table2}) : super(key: key);

  @override
  State<OfflineContentLauncherInAppWebview> createState() => _OfflineContentLauncherInAppWebviewState();
}

class _OfflineContentLauncherInAppWebviewState extends State<OfflineContentLauncherInAppWebview> {
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      hardwareAcceleration: true,
      allowFileAccess: true,
      allowContentAccess: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late Future<bool> futureGetData;
  File? file;

  Future<bool> getData() async {
    String downloadDestFolderPath = await AppDirectory.getDocumentsDirectory() + '/.Mydownloads/Contentdownloads' + '/' + widget.table2.contentid;
    //String downloadDestFolderPath = "/storage/emulated/0/Contentdownloads/673f4b9a-331b-4a02-95e7-6959fd2d847f";
    //String downloadDestFolderPath = "/storage/emulated/0/Contentdownloads/673f4b9a-331b-4a02-95e7-6959fd2d847f";
    Directory directory = Directory(downloadDestFolderPath);
    print('Directory Exist:${directory.existsSync()}');

    File file = File(downloadDestFolderPath + '/start.html');
    //File file = File('/storage/emulated/0/Contentdownloads/673f4b9a-331b-4a02-95e7-6959fd2d847f/start.html');
    //File file = File('/storage/emulated/0/My Custom Downloads/cc75fbcc-7f84-45c1-a737-f4022dc6a242/start.html');
    print('file Exist:${file.existsSync()}');

    bool isExist = await file.exists();
    if(isExist) {
      this.file = file;
    }

    return isExist;
  }

  @override
  void initState() {
    futureGetData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: FutureBuilder<bool>(
        future: futureGetData,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data == true && file != null) {
              return getWebview(file!);
            }
            else {
              return Center(child: Text("Could't Load File"),);
            }
          }
          else {
            return SpinKitFadingCircle(color: Colors.black,);
          }
        },
      ),
    );
  }

  Widget getWebview(File file) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse('about:blank'),
      ),
      initialOptions: options,
      onWebViewCreated: (controller) async {
        webViewController = controller;

        if (!Platform.isAndroid || await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.WEB_MESSAGE_LISTENER)) {
          print("Going To Attach Listener");
          await controller.addWebMessageListener(WebMessageListener(
            jsObjectName: "MobileJSInterface",
            onPostMessage: (String? message, Uri? sourceOrigin, bool isMainFrame, JavaScriptReplyProxy replyProxy) {
              print("MobileJSInterface onMessage Called:$message");

              // do something about message, sourceOrigin and isMainFrame.
              //replyProxy.postMessage("Got it!");
            },
          ));
        }

        controller.addJavaScriptHandler(handlerName: "previousPage", callback: (List<dynamic> arguments) {
          print("previousPage handler called:$arguments");
        });

        controller.addJavaScriptHandler(handlerName: "nextPage", callback: (List<dynamic> arguments) {
          print("nextPage handler called:$arguments");
        });

        webViewController?.loadUrl(
          urlRequest: URLRequest(
            url: Uri.file(file.path),
          ),
        );
      },
      onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
        print("InApp Webview On Load Error:$message");
      },
      onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        print("InApp Webview On Console Message:${consoleMessage.message}");
      },
      onLoadResource: (InAppWebViewController controller, LoadedResource resource) {
        print("InApp Webview On Load Resource:${resource.url?.path}");

        if ((resource.url?.path.toLowerCase().contains("coursetracking/savecontenttrackeddata1") ?? false) ||
            (resource.url?.path.toLowerCase().contains("blank.html?ioscourseclose=true") ?? false)) {
          Navigator.of(context).pop(true);
        }
      },
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        print("InApp Webview On Load Start:${url?.path}");
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) {
        print("InApp Webview On Load Stop:${url?.path}");
      },
    );
  }
}
