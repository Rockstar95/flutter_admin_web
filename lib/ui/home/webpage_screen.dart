import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPageScreen extends StatefulWidget {
  final String urlString;

  WebPageScreen(this.urlString);

  @override
  _WebPageScreenState createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<WebPageScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: widget.urlString.length > 0
                ? InAppWebView(
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
                    initialUrlRequest:
                        URLRequest(url: Uri.tryParse(widget.urlString)),
                    onLoadStop: (InAppWebViewController controller, Uri? url) {
                      //logger.e("....onLoadStop.....SAGAR.....$url");
                      setState(() {
                        isLoading = false;
                      });
                    },
                  )
                : Container()),
      ),
    );
  }
}
