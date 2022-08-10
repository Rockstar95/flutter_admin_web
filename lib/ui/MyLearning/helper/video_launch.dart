import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:video_player/video_player.dart';

class VideoCourseLaunch extends StatefulWidget {
  VideoCourseLaunch({
    this.url = "",
    required this.myFile,
    this.finalDownloadedFilePath = "",
    required this.pdfBytes,
    this.isOffline = false,
  });

  final String url;
  final File myFile;
  final Uint8List pdfBytes;
  final String finalDownloadedFilePath;
  final bool isOffline;
  final DummyMyCatelogResponseTable2 myLearningModel =
      DummyMyCatelogResponseTable2();

  @override
  _VideoCourseLaunchState createState() => _VideoCourseLaunchState();
}

class _VideoCourseLaunchState extends State<VideoCourseLaunch> {
  bool isLoading = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  TargetPlatform? _platform;
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  late VideoPlayerController _offline;
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState

    _offline = VideoPlayerController.file(widget.myFile);
    _chewieController = ChewieController(
      videoPlayerController: _offline,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _offline.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
          ),
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
          elevation: 0,
          title: Text(
            "widget.myLearningModel.name",
            style: TextStyle(
              fontSize: 18,
              color: Color(int.parse(
                  "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                  child: Expanded(
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
              ],
            ),
            //isLoading ? Center( child: CircularProgressIndicator()) : Container(),
          ],
        ));
  }
}
