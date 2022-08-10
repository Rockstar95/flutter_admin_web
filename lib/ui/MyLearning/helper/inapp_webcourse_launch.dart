import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/instancy_content_type.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

class InAppWebCourseLaunch extends StatefulWidget {
  InAppWebCourseLaunch(this.url, this.myLearningModel);

  final String url;
  final DummyMyCatelogResponseTable2 myLearningModel;

  @override
  _InAppWebCourseLaunchState createState() => _InAppWebCourseLaunchState();
}

class _InAppWebCourseLaunchState extends State<InAppWebCourseLaunch> {
  //final _key = UniqueKey();
  bool isLoading = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  late MyLearningBloc myLearningBloc;
  late InstancyContentType contentType;

  InAppWebViewController? webView;
  FlickManager? flickManager;

  //String demoUrl = "https://flutter.instancy.com/ajaxcourse/ScoID/13981/ContentTypeId/8/ContentID/0139db3d-3267-43d6-842b-d81b859a815f/AllowCourseTracking/true/trackuserid/302/ismobilecontentview/true/ContentPath/~Content~PublishFiles~586023ec-28a5-4b34-80a0-7fb191529172~start.html%3FnativeappURL=true";

  bool isFullScreen(DummyMyCatelogResponseTable2 myLearningModel) {
    if ([8, 9, 10].contains(myLearningModel.objecttypeid)) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    print(".....i am from InAppWebCourseLaunch .........");
    print(widget.url);

    myLearningBloc = MyLearningBloc(myLearningRepository: MyLearningRepositoryPublic());
    myLearningBloc.add(UpdateCompleteStatusEvent(
      contentID: widget.myLearningModel.contentid,
      userID: widget.myLearningModel.contentid,
      scoID: widget.myLearningModel.scoid.toString(),
    ));

    contentType = InstancyContentType.getContentType(table2: widget.myLearningModel);

    if(contentType.type == InstancyContentTypeEnum.Video_and_Audio && contentType.subType == InstancyContentSubTypeEnum.Video) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
          widget.url.startsWith('www') ? 'https://${widget.url}' : widget.url,
        ),

      );
    }
    else {
      isLoading = true;
    }


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Timer(
    //       Duration(seconds: 3),
    //       () => {
    //             if (widget.url.contains('https://docs.google.com'))
    //               {webView.clearCache(), webView.loadUrl(url: widget.url)}
    //           });
    // });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return isFullScreen(widget.myLearningModel) ? false : true;
        //return true;
      },
      child: Scaffold(
          appBar: myAppBar(widget.myLearningModel),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      child: getMainBody(),
                    ),
                  ],
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
                // Positioned(
                //     top: 0,
                //     right: 8,
                //     child: RaisedButton(
                //         child: Text('Save & Exit'),
                //         onPressed: () {
                //           myLearningBloc.add(UpdateCompleteStatusEvent(
                //               contentID: widget.myLearningModel.contentid,
                //               userID: widget.myLearningModel.contentid,
                //               scoID: widget.myLearningModel.scoid.toString()));
                //           Navigator.of(context).pop(true);
                //         })),
              ],
            ),
          ),
      ),
    );
  }

  AppBar? myAppBar(DummyMyCatelogResponseTable2 myLearningModel) {
    MyPrint.printOnConsole('objecttypeid in appbar:${myLearningModel.objecttypeid}');

    if ([InstancyContentTypeEnum.Learning_Module, InstancyContentTypeEnum.Assessment, InstancyContentTypeEnum.Learning_Track].contains(contentType.type)) {
      return null;
    }
    else {
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
          child: Icon(
            Icons.arrow_back,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
          ),
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

  Widget getMainBody() {
    if(contentType.type == InstancyContentTypeEnum.Video_and_Audio && contentType.subType == InstancyContentSubTypeEnum.Video) {
      return getVideoPlayer();
    }
    else {
      return getWebView();
    }
  }

  Widget getVideoPlayer() {
    if(flickManager == null) {
      return SizedBox();
    }

    return FlickVideoPlayer(
      flickManager: flickManager!,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.contain,
        controls: MyFlickPortraitControls(
          iconSize: 25,
          controllsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          progressBarSettings: FlickProgressBarSettings(
            padding: EdgeInsets.only(bottom: 20),
          ),
        ),
      ),
      flickVideoWithControlsFullscreen: FlickVideoWithControls(
        videoFit: BoxFit.contain,
        controls: MyFlickLandscapeControls(),
      ),
    );
  }

  Widget getWebView() {
    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        ///*
        android: AndroidInAppWebViewOptions(
          //loadWithOverviewMode: true,
          //useWideViewPort: true,
          allowFileAccess: true,
          allowContentAccess: true,
          domStorageEnabled: true,
          layoutAlgorithm: AndroidLayoutAlgorithm.NORMAL,
          databaseEnabled: true,
          saveFormData: true,
          useShouldInterceptRequest: true,
        ),
        ios: IOSInAppWebViewOptions(),
        //*/
        /*
    webSettings.setJavaScriptEnabled(true);
    webSettings.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
    webSettings.setLoadWithOverviewMode(true);
    webSettings.setUseWideViewPort(true);
    webSettings.setAllowFileAccess(true);
    webSettings.setAppCacheEnabled(true);
    webSettings.setDomStorageEnabled(true);
    webSettings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);
    webSettings.getUseWideViewPort();
    webSettings.setDatabaseEnabled(true);
    webSettings.setSaveFormData(true);
    adWebView.setScrollBarStyle(WebView.SCROLLBARS_OUTSIDE_OVERLAY);
    adWebView.setScrollbarFadingEnabled(false);
    webSettings.setAllowFileAccessFromFileURLs(true);
    webSettings.setAllowUniversalAccessFromFileURLs(true);
    webSettings.setSupportZoom(true);
    webSettings.setAllowContentAccess(true);
    webSettings.setPluginState(WebSettings.PluginState.ON);
    webSettings.setRenderPriority(WebSettings.RenderPriority.HIGH);
    webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
    adWebView.setBackgroundColor(getResources().getColor(R.color.colorFaceBookSilver));
    webSettings.setMediaPlaybackRequiresUserGesture(false);
    */
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
          url: Uri.tryParse(widget.url.startsWith('www')
              ? 'https://${widget.url}'
              : widget.url),
          headers: {},
      ),
      //initialUrl: demoUrl,
      onLoadResource: (InAppWebViewController controller, LoadedResource resource) {
        //logger.e("....onLoadResource.....SAGAR.....${resource.url}");
        print("InAppWebView onLoadResource called for:${resource.url?.path}");

        /// temp method

        if (
          (resource.url?.path.toLowerCase().contains("coursetracking/savecontenttrackeddata1") ?? false) ||
          (resource.url?.path.toLowerCase().contains("blank.html?ioscourseclose=true") ?? false)
        ) {
          Navigator.of(context).pop(true);
        }
      },
      shouldOverrideUrlLoading: (InAppWebViewController controller, NavigationAction navigationAction) async {
        //logger.e("....shouldOverrideUrlLoading.....SAGAR.....${shouldOverrideUrlLoadingRequest.url}");
        // if (shouldOverrideUrlLoadingRequest.url
        //         .toLowerCase()
        //         .contains(
        //             "coursetracking/savecontenttrackeddata1") ||
        //     shouldOverrideUrlLoadingRequest.url
        //         .toLowerCase()
        //         .contains("blank.html?ioscourseclose=true")) {
        //   Navigator.of(context).pop();
        // }
        //return ShouldOverrideUrlLoadingAction.ALLOW;
        return NavigationActionPolicy.ALLOW;
      },
      // onProgressChanged: (InAppWebViewController controller,
      //     int progress) async {
      //   var urlString = await controller.getUrl();
      //   if (urlString.toLowerCase().contains(
      //           "coursetracking/savecontenttrackeddata1") ||
      //       urlString
      //           .toLowerCase()
      //           .contains("blank.html?ioscourseclose=true")) {
      //     Navigator.of(context).pop();
      //   }
      // },
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        Logger().e("....onLoadStart.....SAGAR.....${url?.path}");
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) {
        Logger().e("....onLoadStop.....SAGAR.....${url?.path}");
        setState(() {
          isLoading = false;
        });
      },
      onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
        print("InAppWebView onLoadError called for:${url?.path}, Message:$message");
      },
    );
  }
}

class MyFlickPortraitControls extends StatelessWidget {
  const MyFlickPortraitControls({
    Key? key,
    this.iconSize = 20,
    this.fontSize = 12,
    this.progressBarSettings,
    this.controllsPadding,
  })
  : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  final EdgeInsets? controllsPadding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: FlickPlayToggle(
                      size: 30,
                      color: Colors.black,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: controllsPadding ?? const EdgeInsets.all(10.0).copyWith(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlickVideoProgressBar(
                    flickProgressBarSettings: progressBarSettings,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlickPlayToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      FlickSoundToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      Row(
                        children: <Widget>[
                          FlickCurrentPosition(
                            fontSize: fontSize,
                          ),
                          FlickAutoHideChild(
                            child: Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                          ),
                          FlickTotalDuration(
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlickSubtitleToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      FlickFullScreenToggle(
                        size: iconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyFlickLandscapeControls extends StatelessWidget {
  const MyFlickLandscapeControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyFlickPortraitControls(
     /* fontSize: 14,
      iconSize: 30,*/
      iconSize: 25,
      controllsPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      progressBarSettings: FlickProgressBarSettings(
        height: 5,
        padding: EdgeInsets.only(bottom: 20),
      ),
    );
  }
}

