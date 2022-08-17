import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

import '../../backend/instabot/instabot_controller.dart';
import '../common/app_colors.dart';
import '../common/common_widgets.dart';

class InstaBotScreen extends StatefulWidget {
  const InstaBotScreen({Key? key}) : super(key: key);

  @override
  State<InstaBotScreen> createState() => _InstaBotScreenState();
}

class _InstaBotScreenState extends State<InstaBotScreen> {
  late InstabotController instabotController;
  late Future<String> getInstabotUrlFuture;

  @override
  void initState() {
    instabotController = InstabotController();
    getInstabotUrlFuture = instabotController.getInstabotUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.getAppHeaderTextColor(),),
        title: Text(
          "InstaBot",
          style: TextStyle(
            color: AppColors.getAppTextColor(),
          ),
        ),
        backgroundColor: AppColors.getAppBGColor(),
      ),
      body: SafeArea(
        child: FutureBuilder<String>(
        future: getInstabotUrlFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Size size = MediaQuery.of(context).size;

          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data?.isNotEmpty ?? false) {
              return WebViewX(
                height: size.height,
                width: size.width,
                initialContent: snapshot.data!,
                initialSourceType: SourceType.url,
              );
            }
            else {
              return Center(
                child: Text(
                  "Error in Loading Instabot",
                  style: TextStyle(
                    color: AppColors.getAppTextColor(),
                  ),
                ),
              );
            }
          }
          else {
            return Center(child: getCommonLoading(),);
          }
        },
    ),
      ),
    );
  }
}
