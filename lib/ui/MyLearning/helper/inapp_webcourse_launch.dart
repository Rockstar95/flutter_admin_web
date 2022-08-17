import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:flutter_admin_web/framework/common/instancy_content_type.dart';
import 'package:flutter_admin_web/framework/repository/mylearning/mylearning_repositry_public.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:webviewx/webviewx.dart';

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

  WebViewXController? webviewController;
  FlickManager? flickManager;

  //String demoUrl = "https://flutter.instancy.com/ajaxcourse/ScoID/13981/ContentTypeId/8/ContentID/0139db3d-3267-43d6-842b-d81b859a815f/AllowCourseTracking/true/trackuserid/302/ismobilecontentview/true/ContentPath/~Content~PublishFiles~586023ec-28a5-4b34-80a0-7fb191529172~start.html%3FnativeappURL=true";

  Future<void> _callPlatformSpecificJsMethod() async {
    print("_callPlatformSpecificJsMethod called");
    try {
      await webviewController?.callJsMethod('testPlatformSpecificMethod', ['Hi']);
    } catch (e) {
      showAlertDialog(
        title: e.toString(),
        context: context,
      );
    }
  }

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

    Future.delayed(const Duration(seconds: 10), () {
      _callPlatformSpecificJsMethod();
      Future.delayed(const Duration(seconds: 10), () {
        _callPlatformSpecificJsMethod();
      });
    });


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
                    ? const Center(child: CircularProgressIndicator())
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

  Widget getMainBody() {
    if(contentType.type == InstancyContentTypeEnum.Video_and_Audio && contentType.subType == InstancyContentSubTypeEnum.Video) {
      return getVideoPlayer();
    }
    else {
      return getWebview(context);
    }
  }

  Widget getVideoPlayer() {
    if(flickManager == null) {
      return const SizedBox();
    }

    return FlickVideoPlayer(
      flickManager: flickManager!,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.contain,
        controls: MyFlickPortraitControls(
          iconSize: 25,
          controllsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          progressBarSettings: FlickProgressBarSettings(
            padding: const EdgeInsets.only(bottom: 20),
          ),
        ),
      ),
      flickVideoWithControlsFullscreen: const FlickVideoWithControls(
        videoFit: BoxFit.contain,
        controls: MyFlickLandscapeControls(),
      ),
    );
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
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
          "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
          "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: "exitNewCourse",
          callBack: (dynamic argument) {
            print("exitNewCourse called:${argument}");
          },
        ),
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => print("TestDartCallback called:${msg.toString()}"),
        )
      },
      onPageStarted: (String src) {
        print("On Page Started Src:${ src}");
      },
      onPageFinished: (String src) {
        print("On Page Finished Src:${src}");
        setState(() {
          isLoading = false;
        });

        if (src.toLowerCase().contains("coursetracking/savecontenttrackeddata1") || src.toLowerCase().contains("blank.html?ioscourseclose=true")) {
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

        return NavigationDecision.navigate;
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
                      padding: const EdgeInsets.all(12),
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
      controllsPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      progressBarSettings: FlickProgressBarSettings(
        height: 5,
        padding: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}

