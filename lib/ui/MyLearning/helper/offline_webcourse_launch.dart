import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OfflineWebCourseLaunch extends StatefulWidget {
  OfflineWebCourseLaunch(this.url, this.myFile, this.finalDownloadedFilePath);

  final String url;
  final File myFile;
  final String finalDownloadedFilePath;

  @override
  _OfflineWebCourseLaunchState createState() => _OfflineWebCourseLaunchState();
}

class _OfflineWebCourseLaunchState extends State<OfflineWebCourseLaunch> {
  final _key = UniqueKey();
  bool isLoading = false;

  String extraUrl =
      "?nativeappURL=true&cid=13981&stid=302&lloc=1&lstatus=incomplete&susdata=%23pgvs_start%231;%23pgvs_end%23&quesdata=&sname=sagar%20instancy&IsInstancyContent=true";

  WebViewController? _controller;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  @override
  void initState() {
    super.initState();
    print(".....i am from web view url.........");
    print(widget.url);
    print("........finalDownloadedFilePath......");
    print(
        "........finalDownloadedFilePath......${widget.finalDownloadedFilePath}");
    //isLoading=true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          elevation: 0,
          title: Text(
            "Launch",
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
                Container(
                  child: Expanded(
                    child: SizedBox(),
/*
                      child: WebView(
                        key: _key,
                        javascriptMode: JavascriptMode.unrestricted,
                       // initialUrl: widget.url,
                        onWebViewCreated: (WebViewController webViewController) {
                          _controller=webViewController;
                          loadHtmlFromAssets();
                        },
                      )
*/
                    /*child: WebViewPlus(
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) {
                      _controller=controller;
                      loadHtmlFromAssets();
                   },
                  ),*/

                    /* child: WebView(
                      onWebViewCreated: (WebViewController controller) {
                        controller.loadLocalHtmlFile(widget.finalDownloadedFilePath);
                      },
                      javascriptMode: JavascriptMode.unrestricted,

                    ),
*/
                  ),
                ),
              ],
            ),
            //isLoading ? Center( child: CircularProgressIndicator()) : Container(),
          ],
        ));
  }

  loadHtmlFromAssets() async {
    String fileText = "";

    try {
      // read the file
      fileText = await widget.myFile.readAsString();
      print("......fileText......$fileText");
    } catch (e) {
      print(e);
    }

    _controller?.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html',
            parameters: {'charset': 'utf-8'},
            encoding: Encoding.getByName('utf-8'))
        .toString());

    //_controller.loadString(fileText);
  }
}
