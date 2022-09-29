import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/messages/chat_user_response.dart';
import 'package:flutter_admin_web/framework/common/device_config.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:webviewx/webviewx.dart';

class MessageItem extends StatefulWidget {
  MessageItem({
    Key? key,
    required this.appBloc,
    required this.showFriendImage,
    required this.toUser,
    required this.fromUserId,
    this.text = "",
    this.fileUrl = "",
    required this.msgType,
    required this.context,
    required this.date,
  }) : super(key: key);
  final AppBloc appBloc;
  final bool showFriendImage;
  final ChatUser toUser;
  final String fromUserId;
  final DateTime date;

  final String text;
  final String fileUrl;
  final MessageType msgType;
  final BuildContext context;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);

    MyPrint.printOnConsole("fromUserId:${widget.fromUserId}, toUser.userId:${widget.toUser.userId}");
    bool isMessageReceived = widget.fromUserId == widget.toUser.userId;

    Color messageColor = Colors.white;
    if(!isMessageReceived) {
      // messageColor = Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.35);
      messageColor = AppColors.getAppButtonBGColor();
    }

    double radius = 0.045;

    return Container(
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMessageReceived
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
          isMessageReceived
              ? widget.showFriendImage == true
                  ? AvatarIcon(
                      user: widget.toUser,
                      radius: radius,
                      errorWidgetColor: Colors.black,
                      placeholderColor: Colors.black,
                    )
                  : SizedBox.shrink() //SizedBox(width: deviceData.screenHeight * 0.045)
              : SizedBox.shrink(),
          isMessageReceived
              ? SizedBox(width: deviceData.screenWidth * 0.02)
              : SizedBox.shrink(),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: messageColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                  // topRight: Radius.circular(isMessageReceived ? 10 : 0,),
                  // topLeft: Radius.circular(isMessageReceived ? 0 : 10,),
                  topRight: Radius.circular(3),
                  topLeft: Radius.circular(3),
                ),
                border: isMessageReceived ? Border.all(color: Colors.grey.shade300, width: 1.5) : null,
              ),
              padding: EdgeInsets.symmetric(
                  vertical: deviceData.screenHeight * 0.009,
                  horizontal: deviceData.screenHeight * 0.009,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: isMessageReceived
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  // Text(
                  //   text,
                  //   style: TextStyle(
                  //     fontSize: deviceData.screenHeight * 0.018,
                  //     color: fromUserId == toUser.userId
                  //         ? Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                  //         : Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  //   ),
                  // ),
                  messageWidget(widget.msgType,isMessageReceived),
                  SizedBox(height: 4),
                  Text(
                    "${DateFormat.jm().format(widget.date)}",
                    style: TextStyle(
                      fontSize: deviceData.screenHeight * 0.01,
                      color: isMessageReceived ? AppColors.getAppTextColor(): Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !isMessageReceived,
            child: Padding(
              padding: EdgeInsets.only(left:10),
              child: getUserProfile(radius),
            ),
          )
        ],
      ),
    );
  }

  Widget getUserProfile(double radius){
    MyPrint.printOnConsole("image url: ${widget.appBloc.profilePic} userName : ${widget.appBloc.userName}");

    return AvatarIcon(
      user: ChatUser(
        profPic: widget.appBloc.profilePic.length == 0
              ? imgUrl
              : widget.appBloc.profilePic,
      ),
      radius: radius,
      errorWidgetColor: Colors.black,
      placeholderColor: Colors.black,
    );
  }

  String imgUrl = "https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg";

  String userName = "";

  Future<void> getUserName() async {
    // String name = await sharePrefGetString(sharedPref_LoginUserName);
    // List<String> nameinfo = name.split(" ");
    // String shortName = "";
    // if (nameinfo.length > 1) {
    //   for (int i = 0; i < nameinfo.length; i++) {
    //     shortName += nameinfo[i][0];
    //   }
    // }
    // /*print("nameinfo length:${nameinfo.length}");
    // print("nameinfo:${nameinfo}");
    // print("username:${username}");*/
    // if (nameinfo.length == 1) {
    //   shortName += name.isNotEmpty ? name[0] : "";
    // }
    // else {}
    // userName = name;
    // setState(() {});
  }

  // Widget getUserProfile(){
  Widget messageWidget(MessageType type,bool isMessageReceived) {
    DeviceData deviceData = DeviceData.init(widget.context);

    switch (type) {
      case MessageType.Text:
        return Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(
            widget.text,
            style: TextStyle(
              color: isMessageReceived? AppColors.getAppTextColor():Colors.white,
              fontSize: isMessageReceived?16:14
            ),
          ),
        );
      case MessageType.Image:
        return Container(
          //margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () {
              Navigator.of(widget.context).push(MaterialPageRoute(
                  builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
            },
            child: Container(
              width: 150,
              height: 150,
              padding: EdgeInsets.only(bottom: 8),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(deviceData.screenWidth * 0.05),
                child: Image.network(
                  widget.fileUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      case MessageType.Doc:
        return Container(
          //margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () async {
              Navigator.of(widget.context).push(MaterialPageRoute(
                  builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
              //PDFDocument doc = await PDFDocument.fromURL(fileUrl);

              // final result = await Navigator.push(
              //   context,
              //   // Create the SelectionScreen in the next step.
              //   MaterialPageRoute(
              //       builder: (context) => Scaffold(
              //             appBar: AppBar(
              //               title: Text('Example'),
              //             ),
              //             body: Center(child: PDFViewer(document: doc)),
              //           )),
              // );
              //PDFViewer(document: doc);
            },
            child: Container(
              width: 150,
              height: 150,
              //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(deviceData.screenWidth * 0.05),
                    child: AbsorbPointer(
                        /*child: InAppWebView(
                            initialUrlRequest:
                            URLRequest(url: Uri.tryParse(fileUrl))),*/
                      child: WebViewX(width: 150, height: 150, initialSourceType: SourceType.url, initialContent: widget.fileUrl),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.picture_as_pdf_sharp),
                  )
                ],
              ),
            ),
          ),
        );
      case MessageType.Video:
        final videoPlayerController = VideoPlayerController.network(widget.fileUrl);

        videoPlayerController.initialize();

        final chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            showControls: false,
            looping: true,
            overlay: Center(child: Icon(Icons.play_circle_fill_outlined)));

      /*  VideoPlayerController _controller;
        _controller = VideoPlayerController.network(
          fileUrl,
        );*/

        return Container(
          //margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () {
              //_controller.initialize();
              //PDFViewer(document: doc);

              Navigator.of(widget.context).push(MaterialPageRoute(
                  builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
            },
            child: Container(
                width: 150,
                height: 150,
                //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(deviceData.screenWidth * 0.05),
                  child: Chewie(
                    controller: chewieController,
                  ),
                )
              // Stack(
              //   children: [
              //     Image.network(
              //       fileUrl,
              //       fit: BoxFit.cover,
              //     ),
              //     Center(
              //       child: Icon(Icons.play_circle_fill_outlined),
              //     ),
              //   ],
              // ),
            ),
          ),
        );
        case MessageType.Audio:
        return Container(
          //margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () {
              //_controller.initialize();
              //PDFViewer(document: doc);

              Navigator.of(widget.context).push(MaterialPageRoute(
                  builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
            },
            child: Container(
              width: 150,
              height: 40,
              //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Center(
                child: Icon(Icons.my_library_music),
              ),
              // Stack(
              //   children: [
              //     Image.network(
              //       fileUrl,
              //       fit: BoxFit.cover,
              //     ),
              //     Center(
              //       child: Icon(Icons.play_circle_fill_outlined),
              //     ),
              //   ],
              // ),
            ),
          ),
        );
    }
  }
}

// class FileViewer extends StatefulWidget {
//   final String fileUrl;
//
//   const FileViewer({Key key, this.fileUrl}) : super(key: key);
//
//   @override
//   _FileViewerState createState() => _FileViewerState();
// }
//
// class _FileViewerState extends State<FileViewer> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           //title: Text(Uri.parse(fileUrl).path),
//           ),
//       body: Expanded(child: InAppWebView(initialUrl: widget.fileUrl)),
//     );
//   }
// }

class FileViewer extends StatelessWidget {
  const FileViewer({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          //title: Text(Uri.parse(fileUrl).path),
      ),
      body: WebViewX(width: size.width, height: size.height, initialSourceType: SourceType.url, initialContent: fileUrl),
    );
  }
}

enum ImageType { assets, network }

class AvatarIcon extends StatelessWidget {
  const AvatarIcon({
    required this.user,
    required this.radius,
    required this.placeholderColor,
    required this.errorWidgetColor,
  });

  final ChatUser user;
  final double radius;

  final Color placeholderColor;
  final Color errorWidgetColor;

  // NetworkImage(user.profPic.contains('http')
  // ? user.profPic
  //     : '${ApiEndpoints.strSiteUrl}${user.profPic}')
  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return ClipOval(
      child: ImageType.network != ImageType.network
          ? Image(
              image: Image.asset('').image,
              width: deviceData.screenHeight * radius,
              height: deviceData.screenHeight * radius,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              useOldImageOnUrlChange: true,
              fadeInDuration: const Duration(microseconds: 100),
              fadeOutDuration: const Duration(microseconds: 100),
              imageUrl: user.profPic.contains('http')
                  ? user.profPic
                  : '${ApiEndpoints.strSiteUrl}${user.profPic}',
              placeholder: (context, url) => Opacity(
                    opacity: 0.3,
                    child: Icon(
                      Icons.account_circle,
                      color: placeholderColor,
                      size: deviceData.screenHeight * radius,
                    ),
                  ),
              errorWidget: (context, url, error) => Opacity(
                    opacity: 0.3,
                    child: Icon(
                      Icons.account_circle,
                      color: errorWidgetColor,
                      size: deviceData.screenHeight * radius,
                    ),
                  ),
              width: deviceData.screenHeight * radius,
              height: deviceData.screenHeight * radius,
              fit: BoxFit.cover,
      ),
    );
  }
}
