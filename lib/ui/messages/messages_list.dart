import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/messages/chat_message_response.dart';
import 'package:flutter_admin_web/framework/bloc/messages/chat_user_response.dart';
import 'package:flutter_admin_web/framework/bloc/messages/messages_bloc.dart';
import 'package:flutter_admin_web/framework/common/constants.dart';
import 'package:flutter_admin_web/framework/common/device_config.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/common/pref_manger.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/messages/messages_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/messages/send_icon.dart';
import 'package:flutter_admin_web/ui/myConnections/connections_screen.dart';

import 'message_input.dart';
import 'message_item.dart';

class MessagesList extends StatefulWidget {
  final ChatUser toUser;

  MessagesList({
    required this.toUser,
  });

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late TextEditingController _textController;
  List<Message> messages = [];
  ScrollController _scrollController = ScrollController();
  bool noMoreMessages = false;
  late MessagesBloc messagesBloc;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);
  var chatRoom = '';
  final LoadingDialog _loadingOverlay = LoadingDialog();

  Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection(kAppFlavour).snapshots();

  @override
  void initState() {
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollListener());

    _getFireStoreStreams();
    messagesBloc = MessagesBloc(
        messagesRepository: MessagesRepositoryBuilder.repository());
    messagesBloc.add(
        GetChatHistoryEvent(toUserId: widget.toUser.userId, markAsRead: true));
    super.initState();
  }

  _getFireStoreStreams() async {
    var fromUserID = await sharePrefGetString(sharedPref_userid);

    var snapTo = await FirebaseFirestore.instance
        .collection(kAppFlavour)
        .doc('messages')
        .collection('${widget.toUser.userId}-$fromUserID')
        .limit(1)
        .get()
        .whenComplete(() => {});

    if (snapTo.size > 0) {
      chatRoom = '${widget.toUser.userId}-$fromUserID';
    }

    if (chatRoom == '') {
      var snapFrom = await FirebaseFirestore.instance
          .collection(kAppFlavour)
          .doc('messages')
          .collection('$fromUserID-${widget.toUser.userId}')
          .limit(1)
          .get()
          .whenComplete(() => {});

      if (snapFrom.size > 0) {
        chatRoom = '$fromUserID-${widget.toUser.userId}';
      }
    }

    ///Creating dummy collection if chat room is not created
    if (chatRoom == '') {
      chatRoom = '$fromUserID-${widget.toUser.userId}';
    }

    setState(() {
      _usersStream = FirebaseFirestore.instance
          .collection(kAppFlavour)
          .doc('messages')
          .collection(chatRoom)
          .snapshots();
    });

    print('chatRoom $chatRoom');
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !noMoreMessages) {
      messagesBloc.add(MoreMessagesFetched(
          _scrollController.position.pixels, messages.length));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);
    return Container(
      color: Color(int.parse('0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse('0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}')),
          appBar: getAppBar(),
          body: BlocConsumer<MessagesBloc, MessagesState>(
              bloc: messagesBloc,
              listener: (context, state) {
                // if (messagesBloc.isFirstLoading == true &&
                //     !messagesBloc.isFirstLoading) {
                //   _loadingOverlay.show(context);
                // } else {
                //   _loadingOverlay.hide();
                // }

                if (messagesBloc.isAttachmentUploading) {
                  _loadingOverlay.show(context);
                } else {
                  _loadingOverlay.hide();
                }
                if (state.status == Status.ERROR) {
                  if (state.message == "401") {
                    AppDirectory.sessionTimeOut(context);
                  }
                }
              },
              builder: (context, state) {
                return StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      messages = snapshot.data?.docs.map((i) => Message.fromJson(i.data() as Map<String, dynamic>)).toList() ?? [];

                      messages.sort((a, b) {
                        if (a.date != null && b.date != null) {
                          return b.date!.compareTo(a.date!);
                        }
                        else {
                          return 0;
                        }
                      });

                      //Code To Update Last Message in Chat
                      /*if(messages.isNotEmpty && messages.first.date != null && widget.toUser.sendDateTime != null && !(widget.toUser.sendDateTime!.isAtSameMomentAs(messages.first.date!))) {
                        Message lastMessage = messages.first;
                        MyPrint.logOnConsole("Last message:${lastMessage.message}");
                        widget.toUser.latestMessage = lastMessage.message;
                      }*/

                      //print(messages.map((e) => e.message));
                      return Container(
                        color: InsColor(appBloc).appBGColor,
                        child: Column(
                          children: [
                            Expanded(child: getMessagesListVIew(messages, deviceData),),
                            getMessageTextField(deviceData),
                          ],
                        ),
                      );
                    }
                    else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          color: InsColor(appBloc).appBGColor,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    else {
                      return Container(
                        color: InsColor(appBloc).appBGColor,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.warning),
                            ),
                            Text('Error in loading data')
                          ],
                        ),
                      );
                    }
                  },
                );
              },
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: AppColors.getAppHeaderColor(),
      elevation: 2,
      title: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: widget.toUser.profPic.contains('http')
                  ? '${widget.toUser.profPic}'
                  : '${ApiEndpoints.mainSiteURL}${widget.toUser.profPic}',
              width: 32.h,
              height: 32.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => ClipOval(
                child: CircleAvatar(
                  radius: 25.h,
                  child: Text(
                    widget.toUser.fullName[0],
                    style: TextStyle(
                        fontSize: 20.h, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
              errorWidget: (context, url, error) => ClipOval(
                child: CircleAvatar(
                  radius: 25.h,
                  child: Text(
                    widget.toUser.fullName[0],
                    style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                        fontSize: 30.h,
                        fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Text(
            widget.toUser.fullName,
            style: TextStyle(
                color: InsColor(appBloc).appTextColor, fontSize: 18),
          ),
        ],
      ),
      iconTheme: new IconThemeData(
        color: Color(int.parse(
            "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
      ),
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Icon(Icons.arrow_back,
            color: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}"))),
      ),
    );
  }

  Widget getMessagesListVIew(List<Message> messages, DeviceData deviceData) {
    if(messages.isEmpty) {
      return Center(
        child: Text(
          "No messages yet ",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: deviceData.screenHeight * 0.019,
            color: InsColor(appBloc).appTextColor,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: EdgeInsets.only(bottom: deviceData.screenHeight * 0.01),
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final message = messages[index];
        return MessageItem(
          appBloc: appBloc,
          showFriendImage: false,
          toUser: widget.toUser,
          text: message.message,
          fileUrl: message.fileUrl,
          fromUserId: message.fromUserId,
          msgType: message.msgType,
          date: message.date ?? DateTime.now(),
          context: context,
        );
      },
    );
  }

  Widget getMessageTextField(DeviceData deviceData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1),
            color: Colors.grey.shade300,
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AttachmentIcon(
              controller: _textController,
              toUserId: widget.toUser.userId,
              messageBloc: messagesBloc,
              appBloc: appBloc,
              chatRoom: chatRoom),
          MessageInput(
            controller: _textController,
            appBloc: appBloc,
          ),
          SizedBox(width: 8),
          SendIcon(
            controller: _textController,
            toUserId: widget.toUser.userId.toString(),
            messageBloc: messagesBloc,
            appBloc: appBloc,
            chatRoom: chatRoom,
          ),
        ],
      ),
    );
  }

  bool _showFriendImage(Message message, int index) {
    if (message.fromUserId == widget.toUser.userId) {
      if (index == 0) {
        return true;
      } else if (index > 0) {
        String nextSender = messages[index - 1].toUserId.toString();
        if (nextSender == widget.toUser.userId.toString()) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }
}
