import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class WebPageScreen extends StatefulWidget {
  final String urlString;

  WebPageScreen(this.urlString);

  @override
  _WebPageScreenState createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<WebPageScreen> {
  bool isLoading = true;

  late WebViewXController webviewController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: widget.urlString.length > 0
                ? getWebview(context)
                : Container()),
      ),
    );
  }

  Widget getWebview(BuildContext context) {
    /*InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        *//* android: AndroidInAppWebViewOptions(
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

              ),*//*

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
initialUrlRequest:
URLRequest(url: Uri.tryParse(widget.urlString)),
onLoadStop: (InAppWebViewController controller, Uri? url) {
//logger.e("....onLoadStop.....SAGAR.....$url");
setState(() {
isLoading = false;
});
},
)*/

    Size size = MediaQuery.of(context).size;

    return WebViewX(
      width: size.width,
      height: size.height,
      initialContent: widget.urlString,
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
}
